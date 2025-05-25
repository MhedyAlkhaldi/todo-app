from flask import Flask, render_template, redirect, url_for, flash, request, session, jsonify, send_file
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from flask_wtf.csrf import CSRFProtect
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, date, timedelta
import secrets
import os
from urllib.parse import quote_plus
from flask_wtf.csrf import generate_csrf
import re
import pandas as pd
import io
from sqlalchemy import text, or_, and_
from flask import request, send_file
import itertools

# ------------------------------
# إعداد التطبيق
# ------------------------------
app = Flask(__name__)
app.config['SECRET_KEY'] = secrets.token_hex(32)  # ضروري لحماية الجلسات
csrf = CSRFProtect(app)


@app.context_processor
def inject_csrf_token():
    return dict(csrf_token=generate_csrf)

# ------------------------------
# إعداد قاعدة البيانات
# ------------------------------
def get_database_uri():
    uri = os.getenv('DATABASE_URL')
    if not uri and 'railway' in os.getenv('PYTHON_VERSION', ''):
        uri = "postgresql://postgres:gZAqNHnNEHRbrRDZQLoQqrGFLNKjWEHF@hopper.proxy.rlwy.net:10727/railway"
    if uri and uri.startswith("postgres://"):
        uri = uri.replace("postgres://", "postgresql://", 1)
    if uri and ('railway' in uri or 'supabase' in uri):
        uri += "?sslmode=require" if '?' not in uri else "&sslmode=require"
    return uri or 'sqlite:///local.db'

app.config['SQLALCHEMY_DATABASE_URI'] = get_database_uri()
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# ------------------------------
# تهيئة المكونات الأساسية
# ------------------------------
db = SQLAlchemy(app)
migrate = Migrate(app, db)
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# ------------------------------
# نماذج قاعدة البيانات
# ------------------------------
class Department(db.Model):
    __tablename__ = 'department'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

    employees = db.relationship('Employee', back_populates='department', foreign_keys='Employee.department_id')
    tasks = db.relationship('Task', back_populates='department', foreign_keys='Task.department_id')
    archived_tasks = db.relationship('ArchivedTask', back_populates='department', foreign_keys='ArchivedTask.department_id')


class Employee(UserMixin, db.Model):
    __tablename__ = 'employee'
    def get_role(self):
        return self.role
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)

    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=False)
    department = db.relationship('Department', back_populates='employees', foreign_keys=[department_id])

    phone = db.Column(db.String(20))
    job_title = db.Column(db.String(100))
    email = db.Column(db.String(120), unique=True)
    role = db.Column(db.String(50), default='employee')

    manager_id = db.Column(db.Integer, db.ForeignKey('employee.id'), nullable=True)
    manager = db.relationship('Employee', remote_side=[id], backref='subordinates', foreign_keys=[manager_id])

    country = db.Column(db.String(100))
    profile_image = db.Column(db.String(255))

    tasks = db.relationship('Task', back_populates='employee', foreign_keys='Task.employee_id')
    archived_tasks = db.relationship('ArchivedTask', back_populates='employee', foreign_keys='ArchivedTask.employee_id')
    
    # العلاقة مع المهام التي تم وضع تاغ للموظف فيها
    tagged_tasks = db.relationship('TaskTag', back_populates='employee')
    
    is_manager = db.Column(db.Boolean, default=False)  # إضافة هذا الحقل
    is_ceo = db.Column(db.Boolean, default=False)     # إضافة هذا الحقل
    is_hr = db.Column(db.Boolean, default=False)  # إضافة هذا الحقل


# جدول العلاقة بين المهام والموظفين المشار إليهم (تاغ)
class TaskTag(db.Model):
    __tablename__ = 'task_tag'
    
    id = db.Column(db.Integer, primary_key=True)
    task_id = db.Column(db.Integer, db.ForeignKey('task.id'), nullable=False)
    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # العلاقات
    task = db.relationship('Task', back_populates='tagged_employees')
    employee = db.relationship('Employee', back_populates='tagged_tasks')


class Task(db.Model):
    __tablename__ = 'task'

    id = db.Column(db.Integer, primary_key=True)
    task_name = db.Column(db.String(200), nullable=False)

    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=False)
    department = db.relationship('Department', back_populates='tasks', foreign_keys=[department_id])

    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'), nullable=False)
    employee = db.relationship('Employee', back_populates='tasks', foreign_keys=[employee_id])

    status = db.Column(db.String(50), nullable=False)
    date = db.Column(db.Date, nullable=False)
    description = db.Column(db.Text, nullable=True)
    
    # العلاقة مع الموظفين المشار إليهم (تاغ)
    tagged_employees = db.relationship('TaskTag', back_populates='task', cascade='all, delete-orphan')

    @property
    def is_overdue(self):
        return self.date < date.today() and self.status != 'مكتمل'
        
    @property
    def is_important(self):
        # تحديد ما إذا كانت المهمة مهمة بناءً على معايير معينة
        # مثال: المهام التي تأخرت أكثر من 3 أيام أو المهام التي لها أولوية عالية
        today = date.today()
        days_overdue = (today - self.date).days if self.date < today else 0
        return days_overdue > 3 or 'مهم' in self.task_name.lower() or 'عاجل' in self.task_name.lower()


class ArchivedTask(db.Model):
    __tablename__ = 'archived_task'

    id = db.Column(db.Integer, primary_key=True)
    original_task_id = db.Column(db.Integer)

    task_name = db.Column(db.String(200))

    department_id = db.Column(db.Integer, db.ForeignKey('department.id'))
    department = db.relationship('Department', back_populates='archived_tasks', foreign_keys=[department_id])

    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'))
    employee = db.relationship('Employee', back_populates='archived_tasks', foreign_keys=[employee_id])

    status = db.Column(db.String(50))
    date = db.Column(db.Date)
    description = db.Column(db.Text)
    
    archived_at = db.Column(db.DateTime, default=datetime.utcnow)  # مهم لتسجيل وقت الأرشفة
    
    
class Notification(db.Model):
    __tablename__ = 'notification'
    
    id = db.Column(db.Integer, primary_key=True)
    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'))
    task_id = db.Column(db.Integer, db.ForeignKey('task.id'))
    message = db.Column(db.String(500))
    is_read = db.Column(db.Boolean, default=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    
    # العلاقات
    employee = db.relationship('Employee', backref='notifications', foreign_keys=[employee_id])
    task = db.relationship('Task', backref='notifications', foreign_keys=[task_id])



# ------------------------------
# تهيئة المستخدم
# ------------------------------
@login_manager.user_loader
def load_user(user_id):
    return Employee.query.get(int(user_id))


# ------------------------------
# وظائف مساعدة
# ------------------------------
def is_admin():
    return current_user.is_authenticated and current_user.get_role() == 'admin'


def can_edit_task(task):
    if current_user.is_hr:
        return False  # HR لا يمكنه التعديل
    return is_admin() or task.employee_id == current_user.id


def archive_completed_tasks():
    today = date.today()
    tasks_to_archive = Task.query.filter(Task.status == 'مكتمل', Task.date < today).all()
    for task in tasks_to_archive:
        archived = ArchivedTask(
            original_task_id=task.id,
            task_name=task.task_name,
            employee_id=task.employee_id,
            department_id=task.department_id,
            status=task.status,
            date=task.date,
            description=task.description
        )
        db.session.add(archived)
        db.session.delete(task)
    db.session.commit()


def get_tasks_for_user(user):
    if user.role == 'admin':
        return Task.query.all()
    elif user.role == 'manager':
        return Task.query.filter(Task.employee_id.in_([sub.id for sub in user.subordinates])).all()
    else:
        return Task.query.filter_by(employee_id=user.id).all()


# إضافة الدوال المساعدة إلى سياق القالب
@app.context_processor
def utility_processor():
    return dict(
        is_admin=is_admin,
        can_edit_task=can_edit_task
    )


# ------------------------------
# المسارات (Routes)
# ------------------------------

@app.route('/')
def index():
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))


@app.route('/home')
@login_required
def home():
    if is_admin():
        return "مرحبًا مدير النظام! لديك كامل الصلاحيات."
    return f"مرحبًا {current_user.name}! لديك صلاحيات محدودة."


@app.route('/admin')
@login_required
def admin():
    if not is_admin():
        flash("لا يمكنك الوصول لهذه الصفحة، فقط المدير لديه صلاحيات الوصول.", 'danger')
        return redirect(url_for('dashboard'))
    total_employees = Employee.query.count()
    total_tasks = Task.query.count()
    archive_completed_tasks()
    return render_template('dashboard.html', total_employees=total_employees, total_tasks=total_tasks)


@app.route('/login', methods=['GET', 'POST'])
def login():
    # إذا كان المستخدم مسجلًا بالفعل
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
    
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '').strip()
        
        # التحقق من الحقول الفارغة
        if not username or not password:
            flash("يرجى إدخال اسم المستخدم وكلمة المرور", "danger")
            return redirect(url_for('login'))
        
        # البحث عن المستخدم
        user = Employee.query.filter_by(username=username).first()
        
        if user and user.password == password:

            # تسجيل الدخول الناجح
            login_user(user)
            session['user_id'] = user.id  # الأفضل استخدام user_id بدلاً من username
            session['role'] = user.role
            session.permanent = True  # جعل الجلسة دائمة
            
            # رسالة الترحيب
            welcome_msg = f"تم التسجيل كمدير {user.name}" if user.role == 'admin' else f"تم التسجيل كموظف {user.name}"
            flash(welcome_msg, "success")
            
            # التوجيه للصفحة المقصودة أو dashboard
            next_page = request.args.get('next') or url_for('dashboard')
            return redirect(next_page)
        else:
            # فشل تسجيل الدخول
            flash("اسم المستخدم أو كلمة المرور غير صحيحة", "danger")
            return redirect(url_for('login'))
    
    # طلب GET - عرض صفحة التسجيل
    return render_template('login.html')


@app.route('/logout')
@login_required
def logout():
    logout_user()
    session.clear()
    flash("تم تسجيل الخروج بنجاح", 'success')
    return redirect(url_for('login'))


@app.route('/dashboard')
@login_required
def dashboard():
    # جلب البيانات الأساسية
    all_departments = Department.query.all()
    all_employees = Employee.query.options(db.joinedload(Employee.department)).all() if (is_admin() or current_user.is_hr) else []

    # معالجة الفلاتر من الطلب
    filters = {
        'date': request.args.get('date_filter'),
        'status': request.args.get('status_filter'),
        'employee': request.args.get('employee_filter'),
        'department': request.args.get('department_filter'),
        'week': request.args.get('week')
    }

    # بناء الاستعلام الأساسي مع العلاقات
    query = Task.query.options(
        db.joinedload(Task.employee),
        db.joinedload(Task.department)
    )

    # تطبيق فلتر الصلاحيات (مرة واحدة فقط)
    if current_user.is_hr:
        # HR يرى جميع المهام بدون فلتر أساسي
        pass
    elif is_admin():
        if filters['employee'] and filters['employee'].isdigit():
            query = query.filter(Task.employee_id == int(filters['employee']))
    else:
        managed_ids = [emp.id for emp in Employee.query.filter_by(manager_id=current_user.id).all()]
        query = query.filter(db.or_(
            Task.employee_id.in_(managed_ids),
            Task.employee_id == current_user.id
        ))

    # تطبيق الفلاتر المشتركة
    if filters['department'] and filters['department'].isdigit():
        query = query.filter(Task.department_id == int(filters['department']))

    if filters['date']:
        try:
            parsed_date = datetime.strptime(filters['date'], "%Y-%m-%d").date()
            query = query.filter(Task.date == parsed_date)
        except ValueError:
            pass

    if filters['week']:
        week_match = re.match(r"(\d{4})-W(\d{2})", filters['week'])
        if week_match:
            year, week = int(week_match.group(1)), int(week_match.group(2))
            try:
                monday = datetime.strptime(f"{year}-W{week}-1", "%G-W%V-%u").date()
                start = monday - timedelta(days=2)
                end = start + timedelta(days=6)
                query = query.filter(Task.date.between(start, end))
            except ValueError:
                pass

    if filters['status']:
        query = query.filter(Task.status == filters['status'])

    # جلب النتائج النهائية
    tasks = query.order_by(Task.date.desc()).all()

    # معالجة المهام المتأخرة
    today = date.today()
    overdue_tasks = Task.query.filter(
        Task.status != 'مكتمل',
        Task.date < today
    ).options(db.joinedload(Task.employee)).all()

    # إنشاء إشعارات المهام المتأخرة
    for task in overdue_tasks:
        if not Notification.query.filter_by(
            task_id=task.id,
            employee_id=task.employee_id,
            message=f"المهمة '{task.task_name}' متأخرة"
        ).first():
            db.session.add(Notification(
                employee_id=task.employee_id,
                task_id=task.id,
                message=f"المهمة '{task.task_name}' متأخرة"
            ))
    db.session.commit()

    # تجهيز الإشعارات للعرض
    notifications = Notification.query.filter(
        Notification.employee_id == current_user.id,
        db.or_(
            Notification.message.like('%متأخرة%'),
            Notification.message.like('%تمت الإشارة إليك%')
        )
    ).options(db.joinedload(Notification.task)).all()

    notifications = sorted([
        {
            **n.__dict__,
            'notification_type': 'overdue' if 'متأخرة' in n.message else 'tag'
        }
        for n in notifications
        if not n.task or n.task.employee_id != current_user.id
    ], key=lambda x: x['timestamp'], reverse=True)[:10]

    # تجهيز تحذيرات المهام المتأخرة المهمة
    overdue_task_alerts = [
        task for task in overdue_tasks
        if task.is_important and (current_user.is_hr or task.employee_id == current_user.id)
    ]

    return render_template(
        'dashboard.html',
        tasks=tasks,
        all_departments=all_departments,
        all_employees=all_employees,
        department_filter=filters['department'],
        employee_filter=filters['employee'],
        status_filter=filters['status'],
        week_filter=filters['week'],
        notifications=notifications,
        overdue_task_alerts=overdue_task_alerts
    )


@app.route('/mark_notification_read/<int:notification_id>', methods=['POST'])
@login_required
def mark_notification_read(notification_id):
    notification = Notification.query.get_or_404(notification_id)
    if notification.employee_id == current_user.id:
        notification.is_read = True
        db.session.commit()
    return '', 204  # No content response


@app.route('/notifications')
@login_required
def notifications():
    # جلب جميع الإشعارات للمستخدم الحالي
    all_notifications = Notification.query.filter_by(
        employee_id=current_user.id
    ).order_by(
        Notification.timestamp.desc()
    ).all()
    
    return render_template('notifications.html', notifications=all_notifications)


@app.route('/add_task', methods=['GET', 'POST'])
@login_required
def add_task():
    if request.method == 'POST':
        task_name = request.form.get('task_name')
        department_id = request.form.get('department_id')
        employee_id = request.form.get('employee_id')
        status = request.form.get('status')
        date_str = request.form.get('date')
        description = request.form.get('description')
        
        # الحصول على قائمة الموظفين المشار إليهم (تاغ)
        tagged_employee_ids = request.form.getlist('tagged_employees')
        
        # التحقق من البيانات
        if not task_name or not department_id or not employee_id or not status or not date_str:
            flash('يرجى ملء جميع الحقول المطلوبة', 'danger')
            return redirect(url_for('add_task'))
        
        try:
            task_date = datetime.strptime(date_str, '%Y-%m-%d').date()
        except ValueError:
            flash('تنسيق التاريخ غير صحيح', 'danger')
            return redirect(url_for('add_task'))
        
        # إنشاء المهمة الجديدة
        new_task = Task(
            task_name=task_name,
            department_id=department_id,
            employee_id=employee_id,
            status=status,
            date=task_date,
            description=description
        )
        
        db.session.add(new_task)
        db.session.flush()  # للحصول على معرف المهمة الجديدة
        
        # إضافة العلاقات مع الموظفين المشار إليهم (تاغ)
        for emp_id in tagged_employee_ids:
            if emp_id.isdigit():
                emp_id_int = int(emp_id)
                
                # إنشاء علاقة تاغ
                tag = TaskTag(
                    task_id=new_task.id,
                    employee_id=emp_id_int
                )
                db.session.add(tag)
                
                # إنشاء إشعار للموظف المشار إليه
                notification = Notification(
                    employee_id=emp_id_int,
                    task_id=new_task.id,
                    message=f"تمت الإشارة إليك في المهمة '{task_name}' بواسطة {current_user.name}"
                )
                db.session.add(notification)
        
        try:
            db.session.commit()
            flash('تمت إضافة المهمة بنجاح', 'success')
            return redirect(url_for('dashboard'))
        except Exception as e:
            db.session.rollback()
            flash('حدث خطأ أثناء حفظ المهمة', 'danger')
            return redirect(url_for('add_task'))
    
    # الحصول على قائمة الأقسام والموظفين
    departments = Department.query.all()
    
    # تحديد الموظفين المتاحين بناءً على دور المستخدم
    if is_admin():
        employees = Employee.query.all()
    else:
        # المدير يمكنه إضافة مهام لنفسه أو للموظفين التابعين له
        employees = [current_user] + Employee.query.filter_by(manager_id=current_user.id).all()
    
    # الحصول على قائمة الموظفين للاختيار منهم للتاغ
    tag_employees = Employee.query.filter(Employee.id != current_user.id).all()
    
    
    
    return render_template(
        'add_task.html',
        departments=departments,
        employees=employees,
        tag_employees=tag_employees,
        employee_name=current_user.name,
        department_name=current_user.department.name,
        current_week=datetime.now().strftime("%Y-W%W")
    )


@app.route('/edit_task/<int:task_id>', methods=['GET', 'POST'])
@login_required
def edit_task(task_id):
    task = Task.query.options(
        db.joinedload(Task.tagged_employees)
    ).get_or_404(task_id)
    
    if not can_edit_task(task):
        flash('ليس لديك صلاحية لتعديل هذه المهمة', 'danger')
        return redirect(url_for('dashboard'))
    
    if request.method == 'POST':
        task.task_name = request.form.get('task_name')
        task.department_id = request.form.get('department_id')
        task.employee_id = request.form.get('employee_id')
        task.status = request.form.get('status')
        date_str = request.form.get('date')
        task.description = request.form.get('description')
        
        # الحصول على قائمة الموظفين المشار إليهم (تاغ)
        tagged_employee_ids = request.form.getlist('tagged_employees')
        
        try:
            task.date = datetime.strptime(date_str, '%Y-%m-%d').date()
        except ValueError:
            flash('تنسيق التاريخ غير صحيح', 'danger')
            return redirect(url_for('edit_task', task_id=task_id))
        
        # حذف العلاقات القديمة مع الموظفين المشار إليهم
        TaskTag.query.filter_by(task_id=task.id).delete()
        
        # إضافة العلاقات الجديدة مع الموظفين المشار إليهم
        for emp_id in tagged_employee_ids:
            if emp_id.isdigit():
                emp_id_int = int(emp_id)
                
                # إنشاء علاقة تاغ
                tag = TaskTag(
                    task_id=task.id,
                    employee_id=emp_id_int
                )
                db.session.add(tag)
                
                # التحقق من عدم وجود إشعار سابق لنفس الموظف ونفس المهمة
                existing_notif = Notification.query.filter_by(
                    task_id=task.id,
                    employee_id=emp_id_int,
                    message=f"تمت الإشارة إليك في المهمة '{task.task_name}' بواسطة {current_user.name}"
                ).first()
                
                if not existing_notif:
                    # إنشاء إشعار للموظف المشار إليه
                    notification = Notification(
                        employee_id=emp_id_int,
                        task_id=task.id,
                        message=f"تمت الإشارة إليك في المهمة '{task.task_name}' بواسطة {current_user.name}"
                    )
                    db.session.add(notification)
        
        try:
            db.session.commit()
            flash('تم تحديث المهمة بنجاح', 'success')
            return redirect(url_for('dashboard'))
        except Exception as e:
            db.session.rollback()
            flash('حدث خطأ أثناء تحديث المهمة', 'danger')
            return redirect(url_for('edit_task', task_id=task_id))
    
    # الحصول على قائمة الأقسام والموظفين
    departments = Department.query.all()
    
    # تحديد الموظفين المتاحين بناءً على دور المستخدم
    if is_admin():
        employees = Employee.query.all()
    else:
        # المدير يمكنه تعديل مهام نفسه أو الموظفين التابعين له
        employees = [current_user] + Employee.query.filter_by(manager_id=current_user.id).all()
    
    # الحصول على قائمة الموظفين للاختيار منهم للتاغ
    tag_employees = Employee.query.filter(Employee.id != current_user.id).all()
    
    # الحصول على قائمة معرفات الموظفين المشار إليهم حالياً
    current_tagged_ids = [tag.employee_id for tag in task.tagged_employees]
    
    return render_template(
        'edit_task.html',
        task=task,
        departments=departments,
        employees=employees,
        tag_employees=tag_employees,
        current_tagged_ids=current_tagged_ids
    )


@app.route('/get_tagged_employees/<int:task_id>')
@login_required
def get_tagged_employees(task_id):
    task = Task.query.get_or_404(task_id)
    tagged_employees = []
    
    for tag in task.tagged_employees:
        employee = Employee.query.get(tag.employee_id)
        if employee:
            tagged_employees.append({
                'id': employee.id,
                'name': employee.name
            })
    
    return jsonify(tagged_employees)


@app.route('/task_details/<int:task_id>')
@login_required
def task_details(task_id):
    task = Task.query.options(
        db.joinedload(Task.employee),
        db.joinedload(Task.department),
        db.joinedload(Task.tagged_employees).joinedload(TaskTag.employee)
    ).get_or_404(task_id)
    
    # الحصول على قائمة الموظفين المشار إليهم
    tagged_employees = []
    for tag in task.tagged_employees:
        if tag.employee:
            tagged_employees.append(tag.employee)
    
    return render_template('task_details.html', task=task, tagged_employees=tagged_employees)


@app.route('/update_status/<int:task_id>', methods=['POST'])
@login_required
def update_status(task_id):
    task = Task.query.get_or_404(task_id)
    
    if not can_edit_task(task):
        flash('ليس لديك صلاحية لتعديل هذه المهمة', 'danger')
        return redirect(url_for('dashboard'))
    
    new_status = request.form.get('status')
    
    if new_status:
        task.status = new_status
        
        if new_status == 'مكتمل':
            try:
                archived_task = ArchivedTask(
                    task_name=task.task_name,
                    description=task.description,
                    date=task.date,
                    status=new_status,  # استخدم الحالة الجديدة
                    employee_id=task.employee_id,
                    department_id=task.department_id,
                    # archived_at سيتم تعبئته تلقائياً
                )
                
                db.session.add(archived_task)
                db.session.delete(task)
                db.session.commit()
                flash('تم تحديث حالة المهمة ونقلها إلى الأرشيف بنجاح', 'success')
            except Exception as e:
                db.session.rollback()
                flash(f'حدث خطأ أثناء أرشفة المهمة: {str(e)}', 'danger')
        else:
            db.session.commit()
            flash('تم تحديث حالة المهمة بنجاح', 'success')
    
    return redirect(url_for('dashboard'))


@app.route('/delete_task/<int:task_id>', methods=['POST'])
@login_required
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)
    
    if not can_edit_task(task):
        flash('ليس لديك صلاحية لحذف هذه المهمة', 'danger')
        return redirect(url_for('dashboard'))
    
    # حذف الإشعارات المرتبطة بالمهمة
    Notification.query.filter_by(task_id=task.id).delete()
    
    # حذف المهمة
    db.session.delete(task)
    db.session.commit()
    
    flash('تم حذف المهمة بنجاح', 'success')
    return redirect(url_for('dashboard'))


@app.route('/archived_tasks')
@login_required
def archived_tasks():
    # جلب البيانات الأساسية للفلاتر
    departments = Department.query.all() if (is_admin() or current_user.is_hr) else []
    employees = Employee.query.all() if (is_admin() or current_user.is_hr) else []
    
    # معالجة الفلاتر من الطلب
    department_filter = request.args.get('department')
    employee_filter = request.args.get('employee')
    week_filter = request.args.get('week')
    date_filter = request.args.get('date_filter')
    
    # بناء الاستعلام الأساسي مع العلاقات
    query = ArchivedTask.query.options(
        db.joinedload(ArchivedTask.employee),
        db.joinedload(ArchivedTask.department)
    )
    
    # تطبيق فلتر الصلاحيات
    if not (is_admin() or current_user.is_hr):
        query = query.filter(ArchivedTask.employee_id == current_user.id)
    
    # تطبيق الفلاتر المشتركة
    if department_filter and department_filter.isdigit():
        query = query.filter(ArchivedTask.department_id == int(department_filter))
    
    if employee_filter and employee_filter.isdigit() and (is_admin() or current_user.is_hr):
        query = query.filter(ArchivedTask.employee_id == int(employee_filter))
    
    if date_filter:
        try:
            parsed_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
            query = query.filter(ArchivedTask.date == parsed_date)
        except ValueError:
            pass
    
    if week_filter:
        week_match = re.match(r"(\d{4})-W(\d{2})", week_filter)
        if week_match:
            year, week = int(week_match.group(1)), int(week_match.group(2))
            try:
                monday = datetime.strptime(f"{year}-W{week}-1", "%G-W%V-%u").date()
                start = monday - timedelta(days=2)
                end = start + timedelta(days=6)
                query = query.filter(ArchivedTask.date.between(start, end))
            except ValueError:
                pass
    
    # جلب النتائج النهائية
    tasks = query.order_by(ArchivedTask.archived_at.desc()).all()
    
    # تجهيز الإشعارات للعرض (نفس الكود من dashboard)
    notifications = Notification.query.filter(
        Notification.employee_id == current_user.id,
        db.or_(
            Notification.message.like('%متأخرة%'),
            Notification.message.like('%تمت الإشارة إليك%')
        )
    ).options(db.joinedload(Notification.task)).all()
    
    notifications = sorted([
        {
            **n.__dict__,
            'notification_type': 'overdue' if 'متأخرة' in n.message else 'tag'
        }
        for n in notifications
        if not n.task or n.task.employee_id != current_user.id
    ], key=lambda x: x['timestamp'], reverse=True)[:10]
    
    return render_template(
        'archived_tasks.html',
        tasks=tasks,
        departments=departments,
        employees=employees,
        notifications=notifications
    )

@app.route('/export_tasks')
@login_required
def export_tasks():
    # معالجة الفلاتر
    date_filter = request.args.get('date_filter')
    status_filter = request.args.get('status_filter')
    employee_filter = request.args.get('employee_filter')
    department_filter = request.args.get('department_filter')
    week_filter = request.args.get('week')
    
    # بناء الاستعلام الأساسي
    query = Task.query.options(
        db.joinedload(Task.employee),
        db.joinedload(Task.department)
    )
    
    # تطبيق الفلاتر
    if is_admin():
        if employee_filter and employee_filter.isdigit():
            query = query.filter(Task.employee_id == int(employee_filter))
    else:
        query = query.filter_by(employee_id=current_user.id)
    
    if department_filter and department_filter.isdigit():
        query = query.filter(Task.department_id == int(department_filter))
    
    if date_filter:
        try:
            parsed_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
            query = query.filter(Task.date == parsed_date)
        except ValueError:
            pass
    
    # فلترة حسب الأسبوع
    if week_filter:
        match = re.match(r"(\d{4})-W(\d{2})", week_filter)
        if match:
            year, week = int(match.group(1)), int(match.group(2))
            try:
                monday = datetime.strptime(f"{year}-W{week}-1", "%G-W%V-%u").date()
                start_of_week = monday - timedelta(days=2)  # السبت بدلاً من الإثنين
                end_of_week = start_of_week + timedelta(days=6)
                query = query.filter(Task.date.between(start_of_week, end_of_week))
            except ValueError:
                pass
    
    if status_filter:
        query = query.filter(Task.status == status_filter)
    
    # جلب المهام المصفاة
    tasks = query.order_by(Task.date.desc()).all()
    
    # إنشاء DataFrame
    data = []
    for task in tasks:
        data.append({
            'اسم المهمة': task.task_name,
            'القسم': task.department.name,
            'الموظف': task.employee.name,
            'الحالة': task.status,
            'التاريخ': task.date.strftime('%Y-%m-%d'),
            'الوصف': task.description or ''
        })
    
    df = pd.DataFrame(data)
    
    # إنشاء ملف Excel في الذاكرة
    output = io.BytesIO()
    with pd.ExcelWriter(output, engine='xlsxwriter') as writer:
        df.to_excel(writer, index=False, sheet_name='المهام')
        worksheet = writer.sheets['المهام']
        for i, col in enumerate(df.columns):
            # تعديل عرض الأعمدة ليناسب المحتوى
            max_len = max(df[col].astype(str).map(len).max(), len(col)) + 2
            worksheet.set_column(i, i, max_len)
    
    output.seek(0)
    
    # إرسال الملف للتنزيل
    return send_file(
        output,
        as_attachment=True,
        download_name=f"tasks_export_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx",
        mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )


@app.route('/org_chart')
@login_required
def org_chart():
    # جلب المدير التنفيذي
    ceo = Employee.query.filter_by(is_ceo=True).first()
    
    # جلب الأقسام مع موظفيها
    departments = Department.query.options(
        db.joinedload(Department.employees)
    ).all()
    
    for dept in departments:
        # تحديد مدير القسم (الموظف مع is_manager=True)
        dept.manager = next((emp for emp in dept.employees if emp.is_manager), None)
        
        # إذا لم يكن هناك مدير، نستخدم أول موظف
        if not dept.manager and dept.employees:
            dept.manager = dept.employees[0]
        
        # الموظفون العاديون (غير المدير)
        dept.other_employees = [
            emp for emp in dept.employees 
            if emp.id != getattr(dept.manager, 'id', None)
        ]
    
    return render_template('org_chart.html',
                         ceo=ceo,
                         departments=departments)


@app.route('/employee/<int:employee_id>/details')
@login_required
def employee_details(employee_id):
    employee = Employee.query.options(
        db.joinedload(Employee.department)
    ).get_or_404(employee_id)
    
    return jsonify({
        'name': employee.name,
        'job_title': employee.job_title,
        'profile_image': employee.profile_image,
        'department': employee.department.name if employee.department else None,
        'email': employee.email,
        'phone': employee.phone,
        'is_manager': employee.is_manager,
        'is_ceo': employee.is_ceo
    })



def get_tasks_for_user(user):
    if user.is_hr:
        return Task.query.all()  # HR يرى كل المهام
    elif user.role == 'admin':
        return Task.query.all()
    elif user.role == 'manager':
        return Task.query.filter(Task.employee_id.in_([sub.id for sub in user.subordinates])).all()
    else:
        return Task.query.filter_by(employee_id=user.id).all()




def is_hr(user):
    return hasattr(user, 'is_hr') and user.is_hr

def cycle(values):
    iterator = itertools.cycle(values)
    return lambda: next(iterator)

@app.context_processor
def utility_processor():
    return dict(cycle=cycle(['#f8d7da', '#d1ecf1', '#d4edda', '#fff3cd', '#e2e3e5', '#cce5ff']))


if __name__ == '__main__':
    app.run(debug=True)

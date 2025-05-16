from flask_wtf.csrf import CSRFProtect
from flask import Flask, render_template, request, redirect, url_for, jsonify, flash, session
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, date
from flask_migrate import Migrate
import secrets
import os
import urllib.parse
from urllib.parse import quote_plus
from flask_login import current_user





# تهيئة التطبيق
app = Flask(__name__)

# إعدادات الأمان
app.config['SECRET_KEY'] = secrets.token_hex(32)
csrf = CSRFProtect(app)

# إعداد الاتصال بقاعدة البيانات
import os
from urllib.parse import quote_plus

def get_database_uri():
    uri = os.getenv('DATABASE_URL')  # استخدام متغير البيئة إذا موجود
    if uri:
        # التأكد من أن الرابط في الصيغة الصحيحة
        if uri.startswith("postgres://"):
            uri = uri.replace("postgres://", "postgresql://", 1)
        
        # إذا كنت تستخدم Railway أو Supabase، تأكد من إضافة SSL
        if "railway" in uri or "supabase" in uri:
            if '?' in uri:
                uri += "&sslmode=require"
            else:
                uri += "?sslmode=require"
    else:
        # إذا لم يوجد متغير البيئة، استخدم الرابط المحلي
        password = "gZAqNHnNEHRbrRDZQLoQqrGFLNKjWEHF"  # كلمة المرور الخاصة بك من Railway
        encoded_password = quote_plus(password)
        uri = f"postgresql://postgres:{encoded_password}@hopper.proxy.rlwy.net:10727/railway?sslmode=require"
    
    return uri


# إعدادات قاعدة البيانات
app.config['SQLALCHEMY_DATABASE_URI'] = get_database_uri()
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# تهيئة SQLAlchemy و Migrate
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# تهيئة LoginManager
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# الآن يمكنك استيراد نماذج قاعدة البيانات والقيام بمزيد من التهيئة هنا


    
    
   

# موديلات قاعدة البيانات
class Department(db.Model):
    __tablename__ = 'department'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)

class Employee(UserMixin, db.Model):
    __tablename__ = 'employee'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(50), nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=False)
    department = db.relationship('Department', backref=db.backref('employees', lazy=True))
    phone = db.Column(db.String(20))
    job_title = db.Column(db.String(100))
    email = db.Column(db.String(120), unique=True)
    role = db.Column(db.String(50), default='employee')
    manager_id = db.Column(db.Integer, db.ForeignKey('employee.id'), nullable=True)

    # علاقات
    manager = db.relationship('Employee', remote_side=[id], backref='subordinates')

    def get_role(self):
        return self.role

@app.route('/teams')
@login_required
def teams():
    departments = Department.query.options(
        db.joinedload(Department.manager),
        db.joinedload(Department.employees)
    ).all()
    return render_template('teams.html', departments=departments)

class Task(db.Model):
    __tablename__ = 'task'
    id = db.Column(db.Integer, primary_key=True)
    task_name = db.Column(db.String(200), nullable=False)
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)
    date = db.Column(db.Date, nullable=False)
    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'), nullable=False)
    department = db.relationship('Department', backref=db.backref('tasks', lazy=True))
    employee = db.relationship('Employee', backref=db.backref('tasks', lazy=True))
    description = db.Column(db.Text, nullable=True)

class ArchivedTask(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    original_task_id = db.Column(db.Integer)
    task_name = db.Column(db.String(100))
    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'))
    employee = db.relationship('Employee', backref='archived_tasks')  # 👈 هذا السطر الجديد
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'))
    department = db.relationship('Department', backref='archived_tasks')
    status = db.Column(db.String(20))
    date = db.Column(db.Date)
    description = db.Column(db.Text)
    
    
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
        # إذا كان المستخدم هو "admin"، يعرض جميع المهام
        tasks = Task.query.all()
    elif user.role == 'manager':
        # إذا كان المستخدم هو "manager"، يعرض المهام فقط للموظفين التابعين له
        tasks = Task.query.filter(Task.employee_id.in_([subordinate.id for subordinate in user.subordinates])).all()
    else:
        # إذا كان المستخدم هو "employee"، يعرض فقط المهام الخاصة به
        tasks = Task.query.filter(Task.employee_id == user.id).all()
    return tasks



@login_manager.user_loader
def load_user(user_id):
    return Employee.query.get(int(user_id))

def is_admin():
    return current_user.is_authenticated and current_user.get_role() == 'admin'

def can_edit_task(task):
    return is_admin() or task.employee_id == current_user.id

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
    tasks = Task.query.all()
    return render_template('dashboard.html', total_employees=total_employees, total_tasks=total_tasks)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = Employee.query.filter_by(username=username).first()

        if user and user.password == password:
            login_user(user)

            # 🟢 هون أضفنا تخزين الاسم والصلاحية بالسشن
            session['username'] = user.username
            session['role'] = user.role

            if user.role == 'admin':
                flash(f"تم التسجيل كمدير {user.name}", "success")
            else:
                flash(f"تم التسجيل كموظف {user.name}", "success")
            return redirect(url_for('dashboard'))
        else:
            flash("اسم المستخدم أو كلمة المرور غير صحيحة", "danger")
    
    return render_template('login.html')



@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("تم تسجيل الخروج بنجاح", 'success')
    return redirect(url_for('login'))

@app.route('/dashboard')
@login_required
def dashboard():
    # جلب جميع الأقسام (مطلوب للفلتر الجديد)
    all_departments = Department.query.all()
    
    if is_admin():
        all_employees = Employee.query.options(db.joinedload(Employee.department)).all()
    else:
        all_employees = []

    # جلب جميع معايير الفلترة
    date_filter = request.args.get('date_filter')
    status_filter = request.args.get('status_filter')
    employee_filter = request.args.get('employee_filter')
    department_filter = request.args.get('department_filter')  # الفلتر الجديد

    # استعلام المهام الأساسي
    query = Task.query.options(
        db.joinedload(Task.employee),
        db.joinedload(Task.department)
    )

    # تطبيق فلتر الصلاحيات (يبقى كما هو)
    if is_admin():
        if employee_filter and employee_filter.isdigit():
            query = query.filter(Task.employee_id == int(employee_filter))
    else:
        managed_employees = Employee.query.filter_by(manager_id=current_user.id).all()
        managed_ids = [emp.id for emp in managed_employees]
        query = query.filter(
            db.or_(
                Task.employee_id.in_(managed_ids),
                Task.employee_id == current_user.id
            )
        )

    # 1. فلتر الأقسام الجديد (يضاف قبل الفلاتر الأخرى)
    if department_filter and department_filter.isdigit():
        query = query.filter(Task.department_id == int(department_filter))

    # 2. فلتر التاريخ (يبقى كما هو)
    if date_filter:
        try:
            parsed_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
            query = query.filter(Task.date == parsed_date)
        except ValueError:
            pass

    # 3. فلتر الحالة (يبقى كما هو)
    if status_filter:
        query = query.filter(Task.status == status_filter)

    # تنفيذ الاستعلام
    tasks = query.order_by(Task.date.desc()).all()

    # التعامل مع طلبات AJAX (يبقى كما هو)
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return jsonify({
            'tasks': [{
                'id': task.id,
                'task_name': task.task_name,
                'employee': {'name': task.employee.name},
                'department': {'name': task.department.name},
                'status': task.status,
                'date': task.date.strftime('%Y-%m-%d')
            } for task in tasks]
        })

    return render_template('dashboard.html',
                         tasks=tasks,
                         all_employees=all_employees,
                         all_departments=all_departments,  # ← تمرير الأقسام للقالب
                         is_admin=is_admin(),
                         employee_filter=employee_filter,
                         department_filter=department_filter,  # ← الفلتر الجديد
                         date_filter=date_filter,
                         status_filter=status_filter)



@app.route('/add_task', methods=['GET', 'POST'])
@login_required
def add_task():
    if request.method == 'POST':
        task_name = request.form.get('task_name', '').strip()
        status = request.form.get('status', '').strip()
        week_str = request.form.get('week', '')  # تغيير من date إلى week

        try:
            # تحويل قيمة الأسبوع (YYYY-WW) إلى تاريخ
            year, week = map(int, week_str.split('-W'))
            # الحصول على أول يوم في الأسبوع (الاثنين)
            date = datetime.strptime(f'{year}-{week}-1', "%Y-%W-%w").date()
        except (ValueError, AttributeError):
            flash('صيغة الأسبوع غير صحيحة. يرجى اختيار أسبوع صحيح.', 'danger')
            return redirect(url_for('add_task'))

        new_task = Task(
            task_name=task_name,
            department_id=current_user.department_id,
            status=status,
            date=date,  # سيتم تخزين تاريخ أول يوم في الأسبوع
            employee_id=current_user.id
        )

        db.session.add(new_task)
        db.session.commit()
        flash('تمت إضافة المهمة بنجاح', 'success')
        return redirect(url_for('dashboard'))

    return render_template('add_task.html', 
                         employee_name=current_user.name, 
                         department_name=current_user.department.name,
                         current_week=datetime.now().strftime("%Y-W%W"))  # إضافة الأسبوع الحالي كقيمة افتراضية

@app.route('/update_status/<int:task_id>', methods=['POST'])
@login_required
def update_status(task_id):
    task = Task.query.get_or_404(task_id)

    if not can_edit_task(task):
        flash("ليس لديك صلاحية لتعديل هذه المهمة", "danger")
        return redirect(url_for('dashboard'))

    task.status = request.form['status']
    db.session.commit()
    flash("تم تحديث الحالة بنجاح.", "success")
    return redirect(url_for('dashboard'))

@app.route('/delete_task/<int:task_id>', methods=['POST'])
@login_required
def delete_task(task_id):
    task = Task.query.get_or_404(task_id)

    # السماح بالحذف فقط للمسؤول أو المدير أو منشئ المهمة
    if current_user.role not in ['admin', 'manager'] and task.user_id != current_user.id:
        flash('ليس لديك صلاحية لحذف هذه المهمة', 'danger')
        return redirect(url_for('dashboard'))

    db.session.delete(task)
    db.session.commit()
    flash('تم حذف المهمة بنجاح', 'success')
    return redirect(url_for('dashboard'))


@app.route('/task/<int:task_id>')
@login_required
def task_details(task_id):
    task = Task.query.get_or_404(task_id)

    if not is_admin() and task.employee_id != current_user.id:
        flash("ليس لديك صلاحية لعرض هذه المهمة", "danger")
        return redirect(url_for('dashboard'))

    return render_template('task_details.html', task=task)

@app.route('/edit_task/<int:task_id>', methods=['GET', 'POST'])
@login_required
def edit_task(task_id):
    task = Task.query.get_or_404(task_id)

    # تحقق من صلاحيات التعديل
    if not can_edit_task(task):
        flash("ليس لديك صلاحية للتعديل", "danger")
        return redirect(url_for('dashboard'))

    if request.method == 'POST':
        # تحديث الحقول
        task.task_name = request.form.get('task_name')
        task.status = request.form.get('status')
        task.description = request.form.get('description')

        # إذا بدك تعدل التاريخ كمان:
        if request.form.get('date'):
            try:
                task.date = datetime.strptime(request.form.get('date'), '%Y-%m-%d').date()
            except ValueError:
                flash("تنسيق التاريخ غير صحيح", "danger")
                return redirect(request.url)

        db.session.commit()
        flash("تم التعديل بنجاح", "success")
        return redirect(url_for('task_details', task_id=task.id))

    return render_template('edit_task.html', task=task)

@app.route('/run_archive')
def run_archive():
    archive_completed_tasks()
    flash("تم أرشفة المهام المكتملة بنجاح", "success")
    return redirect(url_for('dashboard'))  # أو أي صفحة بدك ترجع إلها


@app.route('/archived_tasks', methods=['GET', 'POST'])
@login_required
def archived_tasks():
    # جلب جميع الأقسام إذا كان مديراً
    departments = Department.query.all() if is_admin() else None
    employees = Employee.query.all() if is_admin() else None

    selected_department = request.args.get('department')
    selected_employee = request.args.get('employee')
    selected_week = request.args.get('week')  # بصيغة YYYY-WW

    query = ArchivedTask.query

    # فلترة حسب الصلاحيات
    if not is_admin():
        query = query.filter_by(employee_id=current_user.id)

    if selected_department:
        query = query.filter_by(department_id=selected_department)
    if selected_employee:
        query = query.filter_by(employee_id=selected_employee)
    if selected_week:
        try:
            year, week = map(int, selected_week.split("-W"))
            start_date = date.fromisocalendar(year, week, 1)
            end_date = date.fromisocalendar(year, week, 7)
            query = query.filter(ArchivedTask.date >= start_date, ArchivedTask.date <= end_date)
        except ValueError:
            flash("صيغة الأسبوع غير صحيحة", "danger")

    tasks = query.order_by(ArchivedTask.date.desc()).all()

    return render_template('archived_tasks.html', 
                         tasks=tasks, 
                         departments=departments, 
                         employees=employees,
                         is_admin=is_admin())


if __name__ == '__main__':
    app.run(debug=True)

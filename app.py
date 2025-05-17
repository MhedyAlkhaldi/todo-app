from flask import Flask, render_template, request, redirect, url_for, jsonify, flash, session
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from flask_wtf.csrf import CSRFProtect
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, date
import secrets
import os
from urllib.parse import quote_plus
from sqlalchemy import text
from flask_wtf.csrf import generate_csrf
from sqlalchemy import text



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
    all_departments = Department.query.all()
    if is_admin():
        all_employees = Employee.query.options(db.joinedload(Employee.department)).all()
    else:
        all_employees = []

    # الفلاتر
    date_filter = request.args.get('date_filter')
    status_filter = request.args.get('status_filter')
    employee_filter = request.args.get('employee_filter')
    department_filter = request.args.get('department_filter')

    query = Task.query.options(db.joinedload(Task.employee), db.joinedload(Task.department))

    if is_admin():
        if employee_filter and employee_filter.isdigit():
            query = query.filter(Task.employee_id == int(employee_filter))
    else:
        managed_ids = [emp.id for emp in Employee.query.filter_by(manager_id=current_user.id).all()]
        query = query.filter(db.or_(Task.employee_id.in_(managed_ids), Task.employee_id == current_user.id))

    if department_filter and department_filter.isdigit():
        query = query.filter(Task.department_id == int(department_filter))

    if date_filter:
        try:
            parsed_date = datetime.strptime(date_filter, "%Y-%m-%d").date()
            query = query.filter(Task.date == parsed_date)
        except ValueError:
            pass

    if status_filter:
        query = query.filter(Task.status == status_filter)

    tasks = query.order_by(Task.date.desc()).all()

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
                           all_departments=all_departments,
                           is_admin=is_admin(),
                           employee_filter=employee_filter,
                           department_filter=department_filter,
                           date_filter=date_filter,
                           status_filter=status_filter)


@app.route('/add_task', methods=['GET', 'POST'])
@login_required
def add_task():
    if request.method == 'POST':
        task_name = request.form.get('task_name', '').strip()
        description = request.form.get('description', '').strip()  # ✅ تم إضافته
        status = request.form.get('status', '').strip()
        week_str = request.form.get('week', '')

        try:
            year, week = map(int, week_str.split('-W'))
            date_val = datetime.strptime(f'{year}-{week}-1', "%Y-%W-%w").date()
        except (ValueError, AttributeError):
            flash('صيغة الأسبوع غير صحيحة. يرجى اختيار أسبوع صحيح.', 'danger')
            return redirect(url_for('add_task'))

        new_task = Task(
            task_name=task_name,
            description=description,  # ✅ تم إضافته هنا
            department_id=current_user.department_id,
            status=status,
            date=date_val,
            employee_id=current_user.id
        )
        db.session.add(new_task)
        db.session.commit()
        flash('تمت إضافة المهمة بنجاح', 'success')
        return redirect(url_for('dashboard'))

    return render_template(
        'add_task.html',
        employee_name=current_user.name,
        department_name=current_user.department.name,
        current_week=datetime.now().strftime("%Y-W%W")
    )



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
    try:
        task = Task.query.get_or_404(task_id)
        if not (current_user.role in ['admin', 'manager'] or task.employee_id == current_user.id):
            flash('ليس لديك صلاحية لحذف هذه المهمة', 'danger')
            return redirect(url_for('dashboard'))
        db.session.delete(task)
        db.session.commit()
        flash('تم حذف المهمة بنجاح', 'success')
        return redirect(url_for('dashboard'))
    except Exception as e:
        db.session.rollback()
        flash(f'حدث خطأ أثناء الحذف: {str(e)}', 'danger')
        return redirect(url_for('dashboard'))


@app.route('/task/<int:task_id>')
@login_required
def task_details(task_id):
    task = Task.query.get_or_404(task_id)
    return render_template('task_details.html', task=task)



@app.route('/edit_task/<int:task_id>', methods=['GET', 'POST'])
@login_required
def edit_task(task_id):
    task = Task.query.get_or_404(task_id)
    if not can_edit_task(task):
        flash("ليس لديك صلاحية للتعديل", "danger")
        return redirect(url_for('dashboard'))
    if request.method == 'POST':
        task.task_name = request.form.get('task_name')
        task.status = request.form.get('status')
        task.description = request.form.get('description')
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
    return redirect(url_for('dashboard'))


@app.route('/archived_tasks', methods=['GET', 'POST'])
@login_required
def archived_tasks():
    departments = Department.query.all() if is_admin() else None
    employees = Employee.query.all() if is_admin() else None

    selected_department = request.args.get('department')
    selected_employee = request.args.get('employee')
    selected_week = request.args.get('week')

    query = ArchivedTask.query
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


@app.route('/teams')
@login_required
def teams():
    departments = Department.query.options(
        db.joinedload(Department.manager),
        db.joinedload(Department.employees)
    ).all()
    return render_template('teams.html', departments=departments)

@app.route('/org_chart')
@login_required
def org_chart():
    ceo = Employee.query.filter_by(manager_id=None).first()  # المدير التنفيذي ما عنده مدير
    
    departments = Department.query.options(db.subqueryload(Department.employees)).all()

    for dept in departments:
        # نبحث عن الموظف في القسم اللي هو مدير (يظهر كـ manager_id لكثير موظفين من نفس القسم)
        managers_in_dept = set(emp.manager_id for emp in dept.employees if emp.manager_id)
        # مدير القسم هو الموظف الذي رقمه موجود في مجموعة المديرين وفي نفس الوقت هو موظف في القسم نفسه
        dept.manager = next((emp for emp in dept.employees if emp.id in managers_in_dept), None)

    return render_template('org_chart.html', ceo=ceo, departments=departments)


from flask import jsonify

@app.route('/employee/<int:employee_id>/details')
def employee_details(employee_id):
    query = text("""
        SELECT e.id, e.name, e.job_title, d.name AS department, e.country, e.phone, e.email, e.profile_image
        FROM employee e
        LEFT JOIN department d ON e.department_id = d.id
        WHERE e.id = :id
    """)

    employee = db.session.execute(query, {"id": employee_id}).fetchone()

    if not employee:
        return jsonify({"error": "الموظف غير موجود"}), 404

    data = {
        "id": employee.id,
        "name": employee.name,
        "job_title": employee.job_title,
        "department": employee.department,  # هنا اسم القسم بدل الرقم
        "country": employee.country,
        "phone": employee.phone,
        "email": employee.email,
        "profile_image": employee.profile_image or "default-profile.png"
    }

    return jsonify(data)


    
    
    
# ------------------------------
# إنشاء الجداول
# ------------------------------
with app.app_context():
    db.create_all()


try:
    with app.app_context():
        db.create_all()
        # اختبار الاتصال بقاعدة البيانات
        db.session.execute(text('SELECT 1'))
        print("✅ تم الاتصال بنجاح مع قاعدة البيانات")
except Exception as e:
    print(f"❌ فشل الاتصال: {e}")
    raise

if __name__ == '__main__':
    app.run(debug=True)
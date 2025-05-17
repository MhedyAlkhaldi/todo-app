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
from sqlalchemy import text  # Import needed for raw SQL queries

# تهيئة التطبيق
app = Flask(__name__)

# إعدادات الأمان
app.config['SECRET_KEY'] = secrets.token_hex(32)
csrf = CSRFProtect(app)

# إعداد الاتصال بقاعدة البيانات
def get_database_uri():
    # 1. الأولوية لمتغير البيئة
    uri = os.getenv('DATABASE_URL')
    
    # 2. إذا كان الاتصال عبر Railway
    if not uri and 'railway' in os.getenv('PYTHON_VERSION', ''):
        uri = "postgresql://postgres:gZAqNHnNEHRbrRDZQLoQqrGFLNKjWEHF@hopper.proxy.rlwy.net:10727/railway"
    
    # 3. إصلاح صيغة الرابط
    if uri and uri.startswith("postgres://"):
        uri = uri.replace("postgres://", "postgresql://", 1)
    
    # 4. إضافة SSL
    if uri and ('railway' in uri or 'supabase' in uri):
        uri += "?sslmode=require" if '?' not in uri else "&sslmode=require"
    
    return uri or 'sqlite:///local.db'  # Fallback للتنمية المحلية

# إعدادات قاعدة البيانات
app.config['SQLALCHEMY_DATABASE_URI'] = get_database_uri()
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# تهيئة SQLAlchemy و Migrate
db = SQLAlchemy(app)
migrate = Migrate(app, db)

# تهيئة LoginManager
login_manager = LoginManager(app)
login_manager.login_view = 'login'

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
    password = db.Column(db.String(255), nullable=False)  # Changed to 255 for hashed passwords
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

    def set_password(self, password):
        self.password = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password, password)

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
    employee = db.relationship('Employee', backref='archived_tasks')
    department_id = db.Column(db.Integer, db.ForeignKey('department.id'))
    department = db.relationship('Department', backref='archived_tasks')
    status = db.Column(db.String(20))
    date = db.Column(db.Date)
    description = db.Column(db.Text)

@login_manager.user_loader
def load_user(user_id):
    return Employee.query.get(int(user_id))

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
        tasks = Task.query.all()
    elif user.role == 'manager':
        tasks = Task.query.filter(Task.employee_id.in_([subordinate.id for subordinate in user.subordinates])).all()
    else:
        tasks = Task.query.filter(Task.employee_id == user.id).all()
    return tasks

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
    if current_user.is_authenticated:
        return redirect(url_for('dashboard'))
        
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        if not username or not password:
            flash("يرجى إدخال اسم المستخدم وكلمة المرور", "danger")
            return redirect(url_for('login'))
            
        user = Employee.query.filter_by(username=username).first()

        if user and user.check_password(password):
            login_user(user)
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

    date_filter = request.args.get('date_filter')
    status_filter = request.args.get('status_filter')
    employee_filter = request.args.get('employee_filter')
    department_filter = request.args.get('department_filter')

    query = Task.query.options(
        db.joinedload(Task.employee),
        db.joinedload(Task.department)
    )

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
        status = request.form.get('status', '').strip()
        week_str = request.form.get('week', '')

        try:
            year, week = map(int, week_str.split('-W'))
            date = datetime.strptime(f'{year}-{week}-1', "%Y-%W-%w").date()
        except (ValueError, AttributeError):
            flash('صيغة الأسبوع غير صحيحة. يرجى اختيار أسبوع صحيح.', 'danger')
            return redirect(url_for('add_task'))

        new_task = Task(
            task_name=task_name,
            department_id=current_user.department_id,
            status=status,
            date=date,
            employee_id=current_user.id
        )

        db.session.add(new_task)
        db.session.commit()
        flash('تمت إضافة المهمة بنجاح', 'success')
        return redirect(url_for('dashboard'))

    return render_template('add_task.html', 
                         employee_name=current_user.name, 
                         department_name=current_user.department.name,
                         current_week=datetime.now().strftime("%Y-W%W"))

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

    if not is_admin() and task.employee_id != current_user.id:
        flash("ليس لديك صلاحية لعرض هذه المهمة", "danger")
        return redirect(url_for('dashboard'))

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

# إنشاء جداول قاعدة البيانات عند التشغيل لأول مرة
@app.before_first_request
def create_tables():
    db.create_all()

with app.app_context():
    try:
        # استخدام text() للاستعلامات النصية المباشرة
        db.session.execute(text('SELECT 1'))
        print("✅ تم الاتصال بنجاح مع قاعدة البيانات")
    except Exception as e:
        print(f"❌ فشل الاتصال: {e}")
        raise

if __name__ == '__main__':
    app.run(debug=True)
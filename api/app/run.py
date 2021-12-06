import config as config
import hashlib, binascii, os
import re
import math
from flask import Flask, render_template, request, Response, redirect, url_for,Markup
from flask_login import LoginManager, UserMixin, login_required, login_user, logout_user, current_user
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from slugify import slugify
from flask_mail import Mail

#from config import SQLALCHEMY_DATABASE_URI

app = Flask(__name__)
app.secret_key = config.SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = config.SQLALCHEMY_DATABASE_URI
app.config['UPLOAD_FOLDER'] = config.UPLOAD_FOLDER
app.config.update(
	MAIL_SERVER = 'smtp.gmail.com',
	MAIL_PORT = '465',
	MAIL_USE_SSL = True,
	MAIL_USERNAME = config.GMAIL_USERNAME,
	MAIL_PASSWORD = config.GMAIL_PASSWORD
)
db = SQLAlchemy(app)
mail = Mail(app)

# flask-login
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"


class Users(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=True)
    name = db.Column(db.String(80), nullable=False)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(10), nullable=False)
    message = db.Column(db.String(120), nullable=False)
    created_at = db.Column(db.DateTime(), nullable=False, default=datetime.now())

class Posts(db.Model):
    id = db.Column(db.Integer, primary_key=True, nullable=True)
    title = db.Column(db.String(225), nullable=False)
    description = db.Column(db.Text(), nullable=True)
    slug = db.Column(db.String(25), nullable=True)
    banner_image = db.Column(db.String(255), nullable=True)
    status = db.Column(db.Boolean, nullable=False, default = False)
    created_at = db.Column(db.DateTime(), nullable=False, default=datetime.now())

class Admins(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255))
    email = db.Column(db.String(100), unique=True)
    password = db.Column(db.String(100))
    created_at = db.Column(db.DateTime(), nullable=False, default=datetime.now())

@app.route('/')
def home():
    count_post = Posts.query.filter_by(status=True).count()
    page = request.args.get('page')

    if page == None: 
    	page = 1
    limit = config.FRONT_RECORDS_PER_PAGE
    last = math.ceil(count_post/limit);
    page = int(page)
    if page == 1:
        prev = '#'
        next = '?page=' + str(page + 1) 
    elif page == last:
        prev = '?page=' + str(page - 1)
        next = '#'
    else:
        prev = '?page=' + str(page - 1)
        next = '?page=' + str(page + 1)

    if last == 1:
        next = "#"

    posts = Posts.query.filter_by(status=True).order_by(Posts.id.desc()).paginate(page, limit, error_out=False)

    return render_template("index.html", web_setting = config, page_title='Home Page', posts = posts, prev=prev, next = next);

@app.route('/about')
def about():
	return render_template("about.html", web_setting = config, page_title='About Us');

@app.route('/contact', methods=["GET","POST"])
def contact():
	errors = {};
	success = '';
	posted_data = {};
	email_regex = '^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$'

	phone_regex = re.compile("(0/91)?[7-9][0-9]{9}") 
	if request.method == "POST":
		name = request.form.get('name')
		email = request.form.get('email')
		phone = request.form.get('phone')
		message = request.form.get('message')
		posted_data = request.form
		if name == "":
			errors['name'] = "Name is required"
		if email == "":
			errors['email'] = "Email is required"
		if (re.search(email_regex, email) == None):
			errors['email'] = "Email is invalid"
		if phone == "":
			errors['phone'] = "Phone is required"
		if phone_regex.match(phone) == None:
			errors['phone'] = "Invalid Phone number"
		if message == "":
			errors['message'] = "Message is required"
		if len (errors) == 0:
			me = Users(name=name,email=email,phone=phone, message= message)
			db.session.add(me)
			db.session.commit()
			mail.send_message(subject='Ashish Kb Blogs:- New Contact Information',
				html='Dear Admin,<br/>'
				+ name + ' has been submitted following information:-<br/>'
				+ '<b>Name : </b>' + name+ '<br/>'
				+ '<b>Email : </b>' + email+ '<br/>'
				+ '<b>Phone : </b>' + phone+ '<br/>'
				+ '<b>Message : </b>' + message+ '<br/><br/><br/>'
				+ 'Thanks & Regards<br/>'
				+ 'Ashish KB Blogs',
				sender = email,
				recipients = [ config.ADMIN_EMAIL ])
			success = "Your information submit successfully"
			posted_data = {'name':'','email':'','phone':'','message':''};


	return render_template("contact.html", errors=errors, posted_data = posted_data, success=success, web_setting = config, page_title='Contact Us');

@app.route('/post/<string:slug>')
def post_details(slug):
	post_details = Posts.query.filter_by(slug=slug).first()
	if post_details is not None:
		return render_template("details.html", web_setting = config, post=post_details,page_title=post_details.title, Markup = Markup);
	else:
		return redirect(url_for('home'))

@app.route('/login', methods=["GET","POST"])
def login():
	errors = {};
	posted_data = {}
	email_regex = '^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$'
	if request.method == "POST":
			posted_data = request.form
			email = posted_data.get('email')
			password = posted_data.get('password')
			if email == "":
				errors['email'] = "Email is required"
			if (re.search(email_regex, email) == None and email != ""):
				errors['email'] = "Email is invalid"
			if password == "":
				errors['password'] = "Password is required"
			if len (errors) == 0:
				admin_details = Admins.query.filter_by(email=email).first()
				if admin_details == None:
					errors['invalid'] = "Invalid email or password"
				else:
					password_match = verify_password(admin_details.password, password)
					if password_match == "not matched":
						errors['invalid'] = "Invalid email or password"
					else:
						login_user(admin_details)
						return redirect(url_for('dashboard'))

	return render_template("login.html", web_setting = config, page_title='Admin Login', posted_data = posted_data, errors = errors);

def verify_password(stored_password, provided_password):
    """Verify a stored password against one provided by user"""
    salt = stored_password[:64]
    stored_password = stored_password[64:]
    pwdhash = hashlib.pbkdf2_hmac('sha512', 
                                  provided_password.encode('utf-8'), 
                                  salt.encode('ascii'), 
                                  100000)
    pwdhash = binascii.hexlify(pwdhash).decode('ascii')
    if pwdhash == stored_password:
    	return 'matched'
    return 'not matched'

def hash_password(password):
    """Hash a password for storing."""
    salt = hashlib.sha256(os.urandom(60)).hexdigest().encode('ascii')
    pwdhash = hashlib.pbkdf2_hmac('sha512', password.encode('utf-8'), 
                                salt, 100000)
    pwdhash = binascii.hexlify(pwdhash)
    return (salt + pwdhash).decode('ascii')


# callback to reload the user object        
@login_manager.user_loader
def load_user(id):
    return Admins.query.get(id)

# somewhere to logout
@app.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route("/admin/dashboard")
@login_required
def dashboard():
    posts = Posts.query.order_by(Posts.id.desc()).limit(5).all()
    queries = Users.query.order_by(Users.id.desc()).limit(5).all()
    return render_template("admin/dashboard.html", page_title='Dashboard:- '+config.SITE_NAME, admin = current_user, posts = posts, queries = queries);

@app.route("/admin")
@login_required
def admin():
    return redirect(url_for('dashboard'))

@app.route("/admin/posts")
@login_required
def admin_posts():
    count_post = Posts.query.count()
    limit = config.ADMIN_RECORDS_PER_PAGE
    last = math.ceil(count_post/limit)
    page = request.args.get('page')
    if page is None:
    	page = 1
    page = int(page)
    if page == 1 :
    	prev = "#"
    	next = "?page="+str(page+1)
    elif page == last:
    	prev = "?page="+str(page-1)
    	next = "#"
    else:
    	prev = "?page="+str(page-1)
    	next = "?page="+str(page+1)

    if last == 1:
        next = "#"

    posts = Posts.query.order_by(Posts.id.desc()).paginate(page, limit, error_out=False)

    return render_template("admin/blogs.html", page_title='All Blogs:- '+config.SITE_NAME, admin = current_user, posts = posts, prev = prev, next = next, page = page, total_page = last, limit = limit);

@app.route("/admin/enquries")
@login_required
def admin_contacts():
    contact_count = Users.query.count()
    page = request.args.get('page')
    limit = config.ADMIN_RECORDS_PER_PAGE
    last = math.ceil(contact_count/limit)
    if page == None :
    	page = 1

    page = int(page)
    if page == 1:
    	prev = "#"
    	nxt = "?page="+str(page+1)
    elif page == last:
    	prev = "?page="+str(page-1)
    	nxt = "#"
    else:
    	prev = "?page="+str(page-1)
    	nxt = "?page="+str(page+1)

    if last == 1:
    	nxt = "#"

    #last
    #middle
    queries = Users.query.order_by(Users.id.desc()).paginate( page, limit, error_out = False)
    return render_template("admin/queries.html", page_title='All Enquries:- '+config.SITE_NAME, admin = current_user, queries = queries, limit = limit ,last = last, page = page, prev = prev, nxt =nxt, total_page = last)

@app.route("/admin/enquiry/delete/<int:id>")
@login_required
def delete_contact(id):
    enquiry = Users.query.filter_by(id=id).delete()
    db.session.commit()
    return redirect(url_for('admin_contacts'))

@app.route("/admin/post/delete/<int:id>")
@login_required
def delete_posts(id):
    enquiry = Posts.query.filter_by(id=id).delete()
    db.session.commit()
    return redirect(url_for('admin_posts'))

@app.route("/admin/enquires/<int:id>")
@login_required
def view_contact(id):
    enquiry = Users.query.filter_by(id=id).first()
    return render_template("admin/enquiry_details.html", page_title='Enqury Details:- '+config.SITE_NAME, admin = current_user, enquiry = enquiry);

@app.route("/admin/posts/<int:id>")
@login_required
def view_blog(id):
    post = Posts.query.filter_by(id=id).first()
    return render_template("admin/blog_details.html", page_title='Blog Details:- '+config.SITE_NAME, admin = current_user, post = post, Markup = Markup);

@app.route("/admin/post/add", methods=['GET', 'POST'])
@login_required
def add_blog():
    errors = {}
    success = ''
    posted_data = {}
    if request.method == 'POST':
        posted_data = request.form
        title = posted_data.get('title')
        description = posted_data.get('description')
        status = posted_data.get('status')
        f = request.files['banner_image']
        file_name = f.filename
        if title == '':
            errors['title'] = "Title is required"
        if description == '':
            errors['description'] = "Description is required"
        if file_name != '':
            if f and allowed_file(file_name):
                f.save( os.path.join(app.config['UPLOAD_FOLDER']+'/posts', file_name))
            else:
                errors['banner_image'] = "Invalid file format"
        if len (errors) == 0:
            slug = getSlug(slugify(title[:30]))
            #return slug
            post = Posts(title = title, description = description, banner_image = file_name, slug = slug, status = bool(status))
            db.session.add(post)
            db.session.commit()
            return redirect(url_for('admin_posts'))
    return render_template("admin/add_blog.html", page_title='Add Blog:- ' + config.SITE_NAME, admin = current_user, posted_data = posted_data, errors = errors, success = success);

def allowed_file(filename):
    ALLOWED_EXTENSIONS = config.ALLOWED_EXTENSIONS
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def getSlug(slug):
	post = Posts.query.filter_by(slug=slug).first()
	if post is None:
		return slug
	else:
		return getSlug(slug+'_s')

@app.route("/admin/post/edit/<int:id>", methods=['GET', 'POST'])
@login_required
def edit_blog(id):
    errors = {}
    success = ''
    posts = Posts.query.filter_by(id=id).first()
    posted_data = posts
    if request.method == "POST":
        posted_data = request.form
        title = posted_data.get('title')
        description = posted_data.get('description')
        slug = posted_data.get('slug')
        status = posted_data.get('status')
        old_banner_image = posts.banner_image
        f = request.files['banner_image']
        file_name = f.filename
        if title == '':
            errors['title'] = "Title is required"
        if description == '':
            errors['description'] = "Description is required"
        if slug == '':
            errors['slug'] = "Slug is required"
        if slug != posts.slug and slug != '':
            exist_slug = Posts.query.filter_by(slug = slug).first()
            if exist_slug is not None:
                errors['slug'] = "Slug is already registered with another blog. Please add another one"

        if file_name != '':
            if f and allowed_file(file_name):
                if os.path.isfile(app.config['UPLOAD_FOLDER']+'/posts'+ old_banner_image):
                    os.remove(os.path.join(app.config['UPLOAD_FOLDER']+'/posts', old_banner_image))
                f.save( os.path.join(app.config['UPLOAD_FOLDER']+'/posts', file_name))
            else:
                errors['banner_image'] = "Invalid file format"
        else:
            file_name = old_banner_image
        if len (errors) == 0:
            posts.title = title
            posts.description = description
            posts.slug = slug
            posts.banner_image = file_name
            posts.status = bool(status)
            db.session.commit()
            return redirect(url_for('admin_posts'))

    return render_template("admin/add_blog.html", page_title='Edit Blog:- ' + config.SITE_NAME, admin = current_user, posted_data = posted_data, errors = errors, success = success);


if __name__ == "__main__":
	app.run(debug= True, host="0.0.0.0")

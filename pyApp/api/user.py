import util.func as func

from flask import Blueprint, request
from flasgger import swag_from
from werkzeug.security import generate_password_hash

from db.User import User
from db.User import getUserByEmail

user = Blueprint('user', __name__)


@user.route('/login', methods=['POST'])
@swag_from('docs/user/login.yml')
def login():
    if 'email' or 'password' not in request.form.keys():
        return func.reply_json(403)
    email = request.form.get('email').lower()
    password = request.form.get('password')

    # return user when true
    auth_status = func.auth_user(email, password)
    if type(auth_status) != User:
        return func.reply_json(auth_status)
    else:
        u = auth_status
        token = func.genToken(email)
        u.token = token
        User.add(u)
        return func.reply_json(1, data={'token': token})


@user.route('/logout', methods=['POST'])
@func.login_required
@swag_from('docs/user/logout.yml')
def logout():
    if 'email' not in request.form.keys():
        return func.reply_json(403)
    email = request.form.get('email').lower()

    u = getUserByEmail(email)
    u.token = func.genToken(email)
    User.add(u)

    return func.reply_json(1)


@user.route('/signup', methods=['POST'])
@swag_from('docs/user/signup.yml')
def signup():
    if 'email' or 'password' or 'nickname' not in request.form.keys():
        return func.reply_json(403)
    email = request.form.get('email').lower()
    nickname = request.form.get('nickname')
    password = generate_password_hash(request.form.get('password'))

    u = User.query.filter(User.email == email).first()
    if u is None:
        return func.reply_json(-2)
    else:
        if u.code_check != 1:
            return func.reply_json(-4)
        if func.get_time_gap(u.last_code_sent) > 60 * 10:
            return func.reply_json(-6)
        if u.group != 0:
            return func.reply_json(-3)
        else:
            u.nickname = nickname
            u.password = password
            u.group = 1
            u.code_check = 0

            User.add(u)
    return func.reply_json(1)


@user.route('/send_code', methods=['POST'])
@swag_from('docs/user/send_register_code.yml')
def send_register_code():
    func.remove_temp_account()
    if 'email' not in request.form.keys():
        return func.reply_json(403)
    email = request.form.get('email').lower()

    auth_code = func.gen_auth_code()

    u = User.query.filter(User.email == email).first()
    if u is None:
        u = User(email=email, auth_code=func.gen_auth_code())
    else:
        if u.group != 0:
            return func.reply_json(-3)
        gap = func.get_time_gap(u.last_code_sent)
        # Code expired (5 minutes)
        if gap > 60 * 5:
            u.code = auth_code
            u.last_code_sent = func.get_current_time()
            # Update
            User.add(u)
        elif gap < 60:
            return func.reply_json(-5, 'Wait for 60s!')
        else:
            # Resend code
            auth_code = u.auth_code
    status = func.send_verification_code(email, auth_code)
    if status == 1:
        User.add(u)
    return func.reply_json(status)


@user.route('/check_code', methods=['POST'])
@swag_from('docs/user/check_code.yml')
def check_code():
    if 'email' or 'auth_code' not in request.form.keys():
        return func.reply_json(403)
    auth_code = request.form.get('auth_code')
    email = request.form.get('email').lower()
    u = User.query.filter(User.email == email).first()

    if u is None:
        return func.reply_json(-4)
    else:
        if func.get_time_gap(u.last_code_sent) > 60 * 5:
            return func.reply_json(-6)
        if auth_code == auth_code.upper():
            u.code_check = 1
            User.add(u)
            return func.reply_json(1)
        else:
            return func.reply_json(-4)


@user.route('/modify_password', methods=['POST'])
@func.login_required
@swag_from('docs/user/modify_password.yml')
def modify_password():
    if 'email' or 'password' or 'new_password' not in request.form.keys():
        return func.reply_json(403)
    email = request.form.get('email')
    password = request.form.get('password')
    new_password = generate_password_hash(request.form.get('new_password'))
    auth_status = func.auth_user(email, password)
    if type(auth_status) != User:
        return func.reply_json(auth_status)
    else:
        u = auth_status
        u.password = new_password
        u.code_check = 0
        u.token = func.genToken(email)
        User.add(u)
        return func.reply_json(1)


@user.route('retrieve_password', methods=['POST'])
@swag_from('docs/user/modify/retrieve_password')
def retrieve_password():
    if 'email' or 'password' not in request.form.keys():
        return func.reply_json(403)
    email = request.form.get('email')
    password = request.form.get('new_password')
    u = getUserByEmail(email)
    if u is None:
        func.reply_json(-2)
    else:
        pass


def send_reset_pw_code():
    pass

@user.route('/require_login')
def require_login():
    return func.reply_json(-1)

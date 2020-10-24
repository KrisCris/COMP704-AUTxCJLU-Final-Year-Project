import util.func as func

from flask import Blueprint, request
from werkzeug.security import generate_password_hash, check_password_hash

from db.User import User
from db.User import getUserByEmail
from extensions import auth

user = Blueprint('user', __name__)


@user.route('/')
def user_main():
    return 'welcome to user main page.'


@user.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')

    u = getUserByEmail(email)
    if u is None:
        return func.reply_json(-2)

    if check_password_hash(u.password, password):
        token = func.genToken(email)
        u.token = token
        User.add(u)
        return func.reply_json(1, data={'token': token})
    else:
        return func.reply_json(-2)


@auth.login_required
@user.route('/logout', methods=['GET'])
def logout():
    email = request.args.get('email')

    u = getUserByEmail(email)
    u.token = func.genToken(email)
    User.add(u)

    return func.reply_json(1)


@user.route('/signup', methods=['POST'])
def signup():
    email = request.form.get('email')
    nickname = request.form.get('nickname')
    password = generate_password_hash(request.form.get('password'))

    u = User.query.filter(User.email == email).first()
    if u is None:
        return func.reply_json(-2)
    else:
        u.nickname = nickname
        u.password = password
        u.group = 1

        User.add(u)
    return func.reply_json(1)


@user.route('/send_code', methods=['POST'])
def send_code():
    email = request.form.get('email')
    if email is None:
        return func.reply_json(-5)

    auth_code = func.gen_auth_code()

    u = User.query.filter(User.email == email).first()
    if u is None:
        u = User(email=email, auth_code=func.gen_auth_code())
        User.add(u)
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
            return func.reply_json(-1, 'Wait for 60s!')
        else:
            # Resend code
            auth_code = u.auth_code

    return func.reply_json(func.send_verification_code(email, auth_code))


@user.route('/check_code', methods=['POST'])
def check_code():
    auth_code = request.form.get('auth_code')
    email = request.form.get('email')
    u = User.query.filter(User.email == email).first()

    if u is None:
        pass
    else:
        if auth_code == auth_code.upper():
            return func.reply_json(1)
        else:
            return func.reply_json(-4)


@auth.verify_token
def verify_token(token):
    users = User.query.filter(User.token == token).all()
    if len(users) > 1:
        return False
    user = users[0]
    if user.token == token:
        return True
    else:
        return False

import base64
from flask import Blueprint, request
from flasgger import swag_from
from werkzeug.security import generate_password_hash

from db.PlanDetail import PlanDetail
from db.Plan import Plan
from db.User import User
import util.user as func

user = Blueprint(name='user', import_name=__name__)


@user.route('/login', methods=['POST'])
@swag_from('docs/user/login.yml')
def login():
    email = request.form.get('email').lower()
    password = request.form.get('password')

    # return user when true
    auth_status = func.auth_user(password=password, email=email)
    if type(auth_status) != User:
        return func.reply_json(auth_status)
    else:
        u = auth_status
        token = func.genToken(email)
        u.token = token
        User.add(u)
        return func.reply_json(1, data={'uid': u.id, 'token': token})


@user.route('/logout', methods=['POST'])
@func.require_login
@swag_from('docs/user/logout.yml')
def logout():
    uid = request.form.get('uid')
    u = User.getUserByID(uid)
    u.token = func.genToken(key=uid)
    User.add(u)

    return func.reply_json(1)


@user.route('/signup', methods=['POST'])
@func.require_code_check
@swag_from('docs/user/signup.yml')
def signup():
    email = request.form.get('email').lower()
    nickname = request.form.get('nickname')
    password = generate_password_hash(request.form.get('password'))

    u = User.getUserByEmail(email)
    if u is None:
        return func.reply_json(-6)
    else:
        if u.group != 0:
            return func.reply_json(-3)
        else:
            u.nickname = nickname
            u.password = password
            u.group = 1
            from util.func import get_current_time
            u.register_date = get_current_time()
            User.add(u)
    return func.reply_json(1)


@user.route('/send_register_code', methods=['POST'])
@swag_from('docs/user/send_register_code.yml')
def send_register_code():
    func.remove_temp_account()

    email = request.form.get('email').lower()
    u = User.getUserByEmail(email)

    if u is None:
        u = User(email=email, auth_code=func.gen_auth_code())
    else:
        if u.group != 0:
            return func.reply_json(-3)
        gap = func.get_time_gap(u.last_code_sent)
        # Code expired (5 minutes)
        if gap > 60 * 2:
            u.auth_code = func.gen_auth_code()
        elif gap < 60:
            return func.reply_json(-7)
        else:
            pass
    status = func.send_verification_code(email, u.auth_code)
    u.last_code_sent = func.get_current_time()
    if status == 1:
        u.code_check = 0
        User.add(u)
    return func.reply_json(status)


@user.route('/is_new_email', methods=['GET'])
@swag_from('docs/user/is_new_email.yml')
def is_new_email():
    email = request.values.get('email')
    u = User.getUserByEmail(email)
    if u is None:
        return func.reply_json(1)
    if u.group != 0:
        return func.reply_json(-3)
    else:
        return func.reply_json(1)


@user.route('/check_code', methods=['POST'])
@swag_from('docs/user/check_code.yml')
def check_code():
    auth_code = request.form.get('auth_code')
    if 'uid' in request.form.keys():
        uid = request.form.get('uid')
        u = User.getUserByID(uid)
    else:
        email = request.form.get('email').lower()
        u = User.getUserByEmail(email)

    if u is None:
        return func.reply_json(-6)
    else:
        if func.get_time_gap(u.last_code_sent) > 60 * 10:
            import time
            print(time.localtime(u.last_code_sent))
            return func.reply_json(-4)
        if u.auth_code == auth_code.upper():
            u.code_check = 1
            User.add(u)
            return func.reply_json(1)
        else:
            return func.reply_json(-2)


@user.route('/cancel_account', methods=['POST'])
@func.require_login
@func.require_code_check
@swag_from('docs/user/cancel_account.yml')
def cancel_account():
    uid = request.form.get('uid')
    password = request.form.get('password')
    auth_status = func.auth_user(password=password, uid=uid)

    if type(auth_status) != User:
        return func.reply_json(auth_status)
    else:
        u = auth_status
        User.delete(u)
        return func.reply_json(1)


@user.route('/modify_password', methods=['POST'])
@func.require_login
@func.require_code_check
@swag_from('docs/user/modify_password.yml')
def modify_password():
    uid = request.form.get('uid')
    password = request.form.get('password')
    new_password = generate_password_hash(request.form.get('new_password'))
    auth_status = func.auth_user(password=password, uid=uid)
    if type(auth_status) != User:
        return func.reply_json(auth_status)
    else:
        u = auth_status
        u.password = new_password
        u.token = func.genToken(uid)
        User.add(u)
        return func.reply_json(1)


@user.route('retrieve_password', methods=['POST'])
@func.require_code_check
@swag_from('docs/user/retrieve_password.yml')
def retrieve_password():
    email = request.form.get('email')
    password = request.form.get('new_password')
    u = User.getUserByEmail(email)
    if u is None:
        func.reply_json(-6)
    else:
        pass


@user.route('send_security_code', methods=['POST'])
@swag_from('docs/user/send_security_code.yml')
def send_security_code():
    email = request.form.get('email')
    u = User.getUserByEmail(email)

    if u is None or u.group != 1:
        return func.reply_json(-6)
    else:
        gap = func.get_time_gap(u.last_code_sent)
        # Code expired (5 minutes)
        if gap > 60 * 5:
            u.auth_code = func.gen_auth_code()
            u.last_code_sent = func.get_current_time()
        elif gap < 60:
            return func.reply_json(-7)
        else:
            pass
    status = func.send_verification_code(email, u.auth_code)
    if status == 1:
        u.code_check = 0
        User.add(u)
    return func.reply_json(status)


@user.route('get_basic_info', methods=['POST'])
@func.require_login
@swag_from('docs/user/get_basic_info.yml')
def get_basic_info():
    uid = request.form.get('uid')
    u = User.getUserByID(uid)

    # pal
    pal = None
    p = Plan.getLatest(u.id)
    if p is not None:
        sp = PlanDetail.getLatest(p.id)
        pal = sp.activityLevel

    import base64
    with open(u.avatar, "rb") as avatar_file:
        b2s_avatar = base64.b64encode(avatar_file.read()).decode('utf-8')

    data = u.toDict()
    data['avatar'] = b2s_avatar
    data['activityLevel'] = pal
    return func.reply_json(1, data=data)


@user.route('modify_basic_info', methods=['POST'])
@func.require_login
@swag_from('docs/user/modify_basic_info.yml')
def modify_basic_info():
    uid = request.form.get('uid')

    nickname = request.form.get('nickname')
    gender = request.form.get('gender')
    age = request.form.get('age')

    avatar_data = base64.b64decode(request.form.get('avatar'))

    _test = nickname.replace(' ', '')
    if _test == '':
        return func.reply_json(-9)
    u = User.getUserByID(uid)
    u.nickname = nickname
    u.gender = gender
    u.age = age

    if u.avatar == "static/user/avatar/default.png":
        u.avatar = "static/user/avatar/" + str(u.id) + ".png"
        u.add()
    with open(u.avatar, 'wb') as avatar:
        avatar.write(avatar_data)

    u.add()
    return func.reply_json(1)

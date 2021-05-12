import base64
from flask import Blueprint, request
from flasgger import swag_from
from werkzeug.security import generate_password_hash

from db.PlanDetail import PlanDetail
from db.Plan import Plan
from db.User import User
from util.Common.user import *
from util.Common.func import *

user = Blueprint(name='user', import_name=__name__)


@user.route('/login', methods=['POST'])
@attributes_receiver(required=["email", "password"])
@swag_from('docs/user/login.yml')
def login(*args, **kwargs):
    email = args[0].get("email").lower()
    password = args[0].get("password")

    # return user when true
    auth_status = auth_user(password=password, email=email)
    if type(auth_status) != User:
        return reply_json(auth_status)
    else:
        u = auth_status
        token = genToken(email)
        u.token = token
        User.add(u)
        return reply_json(1, data={'uid': u.id, 'token': token})


@user.route('/logout', methods=['POST'])
@attributes_receiver(required=["uid", "token"])
@require_login
@swag_from('docs/user/logout.yml')
def logout(*args, **kwargs):
    uid = args[0].get("uid")
    u = User.getUserByID(uid)
    u.token = genToken(key=uid)
    User.add(u)

    return reply_json(1)


@user.route('/signup', methods=['POST'])
@attributes_receiver(required=["email", "nickname", "password"], optional=["uid"])
@require_code_check
@swag_from('docs/user/signup.yml')
def signup(*args, **kwargs):
    email = args[0].get('email').lower()
    nickname = args[0].get('nickname')
    password = generate_password_hash(args[0].get("password"))

    u = User.getUserByEmail(email)
    if u is None:
        return reply_json(-6)
    else:
        if u.group != 0:
            return reply_json(-3)
        else:
            u.nickname = nickname
            u.password = password
            u.group = 1
            from util.Common.func import get_current_time
            u.register_date = get_current_time()
            User.add(u)
    return reply_json(1)


@user.route('/send_register_code', methods=['POST'])
@attributes_receiver(required=["email"])
@swag_from('docs/user/send_register_code.yml')
def send_register_code(*args, **kwargs):
    remove_temp_account()

    email = args[0].get('email').lower()
    u = User.getUserByEmail(email)

    if u is None:
        u = User(email=email, auth_code=gen_auth_code())
    else:
        if u.group != 0:
            return reply_json(-3)
        gap = get_time_gap(u.last_code_sent)
        # Code expired (5 minutes)
        if gap > 60 * 2:
            u.auth_code = gen_auth_code()
        elif gap < 60:
            return reply_json(-7)
        else:
            pass
    status = send_verification_code(email, u.auth_code)
    u.last_code_sent = get_current_time()
    if status == 1:
        u.code_check = 0
        User.add(u)
    return reply_json(status)


@user.route('/is_new_email', methods=['GET'])
@attributes_receiver(required=["email"])
@swag_from('docs/user/is_new_email.yml')
def is_new_email(*args, **kwargs):
    email = args[0].get('email')
    u = User.getUserByEmail(email)
    if u is None:
        return reply_json(1)
    if u.group != 0:
        return reply_json(-3)
    else:
        return reply_json(1)


@user.route('/check_code', methods=['POST'])
@attributes_receiver(required=["auth_code"], optional=["uid", "email"])
@swag_from('docs/user/check_code.yml')
def check_code(*args, **kwargs):
    auth_code = args[0].get('auth_code')
    if args[0].get("uid"):
        uid = args[0].get('uid')
        u = User.getUserByID(uid)
    else:
        email = args[0].get('email').lower()
        u = User.getUserByEmail(email)

    if u is None:
        return reply_json(-6)
    else:
        if get_time_gap(u.last_code_sent) > 60 * 10:
            import time
            print(time.localtime(u.last_code_sent))
            return reply_json(-4)
        if u.auth_code == auth_code.upper():
            u.code_check = 1
            User.add(u)
            return reply_json(1)
        else:
            return reply_json(-2)


@user.route('/cancel_account', methods=['POST'])
@attributes_receiver(required=["uid", "token", "password"], optional=["email"])
@require_login
@require_code_check
@swag_from('docs/user/cancel_account.yml')
def cancel_account(*args, **kwargs):
    uid = args[0].get('uid')
    password = args[0].get('password')
    auth_status = auth_user(password=password, uid=uid)

    if type(auth_status) != User:
        return reply_json(auth_status)
    else:
        u = auth_status
        User.delete(u)
        return reply_json(1)


@user.route('/modify_password', methods=['POST'])
@attributes_receiver(required=["uid", "password", "token", "new_password"], optional=["email"])
@require_login
@require_code_check
@swag_from('docs/user/modify_password.yml')
def modify_password(*args, **kwargs):
    uid = args[0].get('uid')
    password = args[0].get('password')
    new_password = generate_password_hash(args[0].get('new_password'))
    auth_status = auth_user(password=password, uid=uid)
    if type(auth_status) != User:
        return reply_json(auth_status)
    else:
        u = auth_status
        u.password = new_password
        u.token = genToken(uid)
        User.add(u)
        return reply_json(1)


@user.route('retrieve_password', methods=['POST'])
@attributes_receiver(required=["email", "new_password"], optional=["uid"])
@swag_from('docs/user/retrieve_password.yml')
def retrieve_password(*args, **kwargs):
    email = args[0].get('email')
    password = args[0].get('new_password')
    u = User.getUserByEmail(email)
    if u is None:
        return reply_json(-6)
    else:
        u.password = generate_password_hash(password)
        u.add()
        return reply_json(1)


@user.route('send_security_code', methods=['POST'])
@attributes_receiver(required=["email"])
@swag_from('docs/user/send_security_code.yml')
def send_security_code(*args, **kwargs):
    email = args[0].get('email')
    u = User.getUserByEmail(email)

    if u is None or u.group != 1:
        return reply_json(-6)
    else:
        gap = get_time_gap(u.last_code_sent)
        # Code expired (5 minutes)
        if gap > 60 * 5:
            u.auth_code = gen_auth_code()
            u.last_code_sent = get_current_time()
        elif gap < 60:
            return reply_json(-7)
        else:
            pass
    status = send_verification_code(email, u.auth_code)
    if status == 1:
        u.code_check = 0
        User.add(u)
    return reply_json(status)


@user.route('get_basic_info', methods=['POST'])
@attributes_receiver(required=["uid", "token"])
@require_login
@swag_from('docs/user/get_basic_info.yml')
def get_basic_info(*args, **kwargs):
    uid = args[0].get('uid')
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
    return reply_json(1, data=data)


@user.route('modify_basic_info', methods=['POST'])
@attributes_receiver(required=["uid", "token", "nickname", "gender", "age", "avatar"])
@require_login
@swag_from('docs/user/modify_basic_info.yml')
def modify_basic_info(*args, **kwargs):
    uid = args[0].get('uid')

    nickname = args[0].get('nickname')
    gender = args[0].get('gender')
    age = args[0].get('age')

    avatar_data = base64.b64decode(args[0].get('avatar'))

    _test = nickname.replace(' ', '')
    if _test == '':
        return reply_json(-9)
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
    return reply_json(1)


@user.route("set_meals_intake_ratio", methods=['POST'])
@attributes_receiver(required=["token", "uid", "breakfast", "launch", "dinner"])
@require_login
@swag_from('docs/user/set_meals_intake_ratio.yml')
def setMealsIntakeRatio(*args):
    u = User.getUserByID(args[0].get("uid"))

    b = args[0].get("breakfast")
    l = args[0].get("launch")
    d = args[0].get("dinner")

    if (b + l + d) != 10:
        return reply_json(-2, msg="should added up to 100")

    u.b_percent = b
    u.l_percent = l
    u.d_percent = d
    u.add()

    return reply_json(1, data=u.toDict())

import torch

import util.func as func

from flask import Blueprint, request
from flasgger import swag_from
from werkzeug.security import generate_password_hash

from db.User import User

from cv.detect import detect

user = Blueprint('user', __name__)


@user.route('/login', methods=['POST'])
@swag_from('docs/user/login.yml')
def login():
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
        return func.reply_json(1, data={'uid': u.id, 'token': token})


@user.route('/logout', methods=['POST'])
@func.require_login
@swag_from('docs/user/logout.yml')
def logout():
    email = request.form.get('email').lower()
    u = User.getUserByEmail(email)
    u.token = func.genToken(email)
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
        return func.reply_json(-2)
    else:
        # if u.code_check != 1:
        #     return func.reply_json(-4)
        # if func.get_time_gap(u.last_code_sent) > 60 * 10:
        #     return func.reply_json(-6)
        if u.group != 0:
            return func.reply_json(-3)
        else:
            u.nickname = nickname
            u.password = password
            u.group = 1
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
        if gap > 60 * 5:
            u.auth_code = func.gen_auth_code()
            u.last_code_sent = func.get_current_time()
        elif gap < 60:
            return func.reply_json(-5, msg='Wait for 60s!')
        else:
            pass
    status = func.send_verification_code(email, u.auth_code)
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
    email = request.form.get('email').lower()
    u = User.getUserByEmail(email)

    if u is None:
        return func.reply_json(-4)
    else:
        if func.get_time_gap(u.last_code_sent) > 60 * 5:
            return func.reply_json(-4)
        if u.auth_code == auth_code.upper():
            u.code_check = 1
            User.add(u)
            return func.reply_json(1)
        else:
            return func.reply_json(-4)


@user.route('/cancel_account', methods=['POST'])
@func.require_login
@func.require_code_check
@swag_from('docs/user/cancel_account.yml')
def cancel_account():
    email = request.form.get('email')
    password = request.form.get('password')
    auth_status = func.auth_user(email, password)

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
    email = request.form.get('email')
    password = request.form.get('password')
    new_password = generate_password_hash(request.form.get('new_password'))
    auth_status = func.auth_user(email, password)
    if type(auth_status) != User:
        return func.reply_json(auth_status)
    else:
        u = auth_status
        u.password = new_password
        u.token = func.genToken(email)
        User.add(u)
        return func.reply_json(1)


@user.route('retrieve_password', methods=['POST'])
@func.require_code_check
# @swag_from('docs/user/modify/retrieve_password.yml')
def retrieve_password():
    email = request.form.get('email')
    password = request.form.get('new_password')
    u = User.getUserByEmail(email)
    if u is None:
        func.reply_json(-2)
    else:
        pass


@user.route('send_security_code', methods=['POST'])
@swag_from('docs/user/send_security_code.yml')
def send_security_code():
    email = request.form.get('email')
    u = User.getUserByEmail(email)

    if u is None or u.group != 1:
        return func.reply_json(-2, msg='Wrong email')
    else:
        gap = func.get_time_gap(u.last_code_sent)
        # Code expired (5 minutes)
        if gap > 60 * 5:
            u.auth_code = func.gen_auth_code()
            u.last_code_sent = func.get_current_time()
        elif gap < 60:
            return func.reply_json(-5, msg='Wait for 60s!')
        else:
            pass
    status = func.send_verification_code(email, u.auth_code)
    if status == 1:
        u.code_check = 0
        User.add(u)
    return func.reply_json(status)


@user.route('get_basic_info', methods=['POST'])
@func.require_login
def get_basic_info():
    uid = request.form.get('uid')
    u = User.getUserByID(uid)
    import base64
    with open(u.avatar, "rb") as avatar_file:
        b2sAvatar = base64.b64encode(avatar_file.read()).decode('utf-8')
    return func.reply_json(1, data={
        'email': u.email,
        'nickname': u.nickname,
        'avatar': b2sAvatar,
        'gender': u.gender,
        'age': u.age,
    })


# test
@user.route('detect')
def d():
    with torch.no_grad():
        detect()

    return func.reply_json(1)
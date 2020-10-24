import util.func as func
import db.database as db

from flask import Blueprint, request

user = Blueprint('user', __name__)


@user.route('/')
def user_main():
    return 'welcome to user main page.'


@user.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    # TODO check account and login


@user.route('/logout', methods=['GET'])
def logout():
    username = request.args.get('username')
    return '{0} logged out!'.format(username)

    # TODO LOGOUT


@user.route('/signup', methods=['POST'])
def signup():
    username = request.form.get('username')
    password = request.form.get('password')
    # TODO db manipulation, logic
    print('in signup')
    db.add(db.User(username=username, password=password, group=0))

    return func.reply_json(1, 'signed up')


@user.route('/send_code', methods=['POST'])
def send_code():
    # TODO check if this mail has been sent a code before
    if False:
        return reply_json(-1, 'wait for 60sec')

    # actually record and send code.
    mail = request.form.get('mail')
    code = func.gen_auth_code()
    # db.add(db.User(email=mail, auth_code=code))
    func.send_verification_code(mail, code)

    return func.reply_json(1, 'mail send')


@user.route('/check_code', methods=['POST'])
def check_code():
    pass
    # TODO search the code in user table and find if code is legit.


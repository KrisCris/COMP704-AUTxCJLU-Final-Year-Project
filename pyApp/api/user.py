from flask import Blueprint, request

from db.database import db, User, DBM
from util.func import reply_json

user = Blueprint('user', __name__)


@user.route('/')
def user_main():
    return 'welcome to user main page.'


@user.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    # check account and login


@user.route('/logout', methods=['GET'])
def logout():
    username = request.args.get('username')
    return '{0} logged out!'.format(username)


# LOGOUT


@user.route('/signup', methods=['POST'])
def signup():
    username = request.form.get('username')
    password = request.form.get('password')
    # db manipulation
    print('in signup')
    DBM.add(User(username=username, password=password, group=0))


    return reply_json(1, 'signed up')


@user.route('/verify_mail', methods=['POST'])
def verify_mail():
    mail = request.form.get('POST')

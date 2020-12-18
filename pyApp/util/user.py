import functools
import random
import smtplib
import string
import uuid

from flask import request
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from werkzeug.security import check_password_hash

from util.constants import DEBUG
from util.constants import SENDER, SENDER_NAME, SENDER_PW, SMTP_PORT, SMTP_URL

from util.func import reply_json, get_time_gap,get_current_time


def require_login(func):
    @functools.wraps(func)  # 修饰内层函数，防止当前装饰器去修改被装饰函数__name__的属性
    def inner(*args, **kwargs):
        token = ''
        if request.method == 'POST':
            if 'token' not in request.form.keys():
                return reply_json(-1)
        else:
            if not request.values.has_key('token'):
                return reply_json(-1)
        token = request.form['token'] if request.method == 'POST' else request.values.get('token')
        from db.User import User
        users = User.query.filter(User.token == token).all()
        if len(users) != 1:
            return reply_json(-1)
        user = users[0]
        if user.token != token:
            return reply_json(-1)
        return func(*args, **kwargs)

    return inner


def require_code_check(func):
    @functools.wraps(func)
    def inner(*args, **kwargs):
        email = request.form['email'] if request.method == 'POST' else request.values.get('email')
        from db.User import User
        user = User.getUserByEmail(email)

        if user is None:
            return reply_json(-6)
        elif user.code_check != 1:
            return reply_json(-8)
        elif get_time_gap(user.last_code_sent) > 60 * 15:
            return reply_json(-4)
        else:
            user.code_check = 0
            User.add(user)

        return func(*args, **kwargs)

    return inner


def remove_temp_account():
    from db.User import User
    unavailable_time = get_current_time() - 3600
    users = User.query.filter(User.group == 0, User.last_code_sent < unavailable_time).all()
    for user in users:
        User.delete(user)
        print('Removed temp account: {}'.format(user.email))


def auth_user(password, uid=None, email=None):
    from db.User import User
    if password is None:
        password = ''
    if uid is None and email is None:
        return -6

    if email is None:
        u = User.getUserByID(uid)
    else:
        u = User.getUserByEmail(email)
    if u is None:
        return -6

    if check_password_hash(u.password, password):
        return u
    else:
        return -2


def gen_auth_code():
    s = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(6))
    s = s.upper()
    return s


def genToken(email):
    time_uuid = uuid.uuid1()
    return uuid.uuid5(time_uuid, email)


def __send_email(receivers: list, content: str, subject: str):
    msg = MIMEMultipart()
    msg['Subject'] = subject
    msg['From'] = SENDER_NAME
    msg['To'] = ','.join(receivers)

    text = MIMEText('''
        <html>
            <body>
                <img hidefocus="true" class="index-logo-src" src="https://i.imgur.com/hE7KCJd.png" height="96">
                <br>
                <div>
                    <p>Hi,</p>
                    <br>
                    <div>
                    {0}
                    </div>
                    <br>
                    <p>Regards</p>
                </div>
            </body>
        </html>
    '''.format(content), 'html', 'utf-8')

    msg.attach(text)

    try:
        # mail = smtplib.SMTP_SSL(SMTP_URL, SMTP_PORT)

        mail = smtplib.SMTP(SMTP_URL, SMTP_PORT)
        mail.set_debuglevel(DEBUG)
        mail.ehlo()
        mail.starttls()
        mail.ehlo()
        mail.login(SENDER, SENDER_PW)
        mail.sendmail(SENDER_NAME, receivers, msg.as_string())
        mail.close()
        return 1
    except Exception as e:
        print('[send_email] {0}'.format(str(e)))
        return -5


def send_verification_code(receiver: str, code: str):
    content = '''
            Your verification code is: {0}.
            This code will expire in 10 minutes.
    '''.format(code)
    return __send_email(receivers=[receiver], content=content, subject='DietLens verification code')
import functools
import random
import smtplib
import string
import time
import uuid

from flask import request, jsonify, redirect
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from werkzeug.security import check_password_hash

from util.constants import REPLY_CODES, DEBUG
from util.constants import SENDER, SENDER_NAME, SENDER_PW, SMTP_PORT, SMTP_URL


def reply_json(code, msg=None, data=None):
    if data is None:
        data = []
    if code in REPLY_CODES:
        return jsonify({
            'code': code,
            'msg': REPLY_CODES[code] if msg is None else msg,
            'data': data
        })
    return jsonify({
        'code': 800,
        'msg': 'Unknown code',
        'data': data
    })


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


def gen_auth_code():
    s = ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(6))
    s = s.upper()
    return s


def genToken(email):
    time_uuid = uuid.uuid1()
    return uuid.uuid5(time_uuid, email)


def get_current_time():
    return int(time.time())


def get_time_gap(old):
    return int(time.time()) - old


def login_required(func):
    """
    判断是否登陆
    :param func: 函数
    :return:
    """

    @functools.wraps(func)  # 修饰内层函数，防止当前装饰器去修改被装饰函数__name__的属性
    def inner(*args, **kwargs):
        token = ''
        if request.method == 'POST':
            if 'token' not in request.form.keys():
                return redirect('/user/require_login')
        else:
            if not request.values.has_key('token'):
                return redirect('/user/require_login')
        token = request.form['token'] if request.method == 'POST' else request.values.get('token')
        from db.User import User
        users = User.query.filter(User.token == token).all()
        if len(users) != 1:
            return redirect('/user/require_login')
        user = users[0]
        if user.token != token:
            return redirect('/user/require_login')
        return func(*args, **kwargs)

    return inner


def remove_temp_account():
    from db.User import User
    unavailable_time = get_current_time() - 3600
    users = User.query.filter(User.group == 0, User.last_code_sent < unavailable_time).all()
    for user in users:
        User.delete(user)
        print('Removed temp account: {}'.format(user.email))


def auth_user(email, password):
    from db.User import getUserByEmail
    if password is None:
        password = ''
    if email is None:
        email = ''

    u = getUserByEmail(email)
    if u is None:
        return -2

    if check_password_hash(u.password, password):
        return u
    else:
        return -2

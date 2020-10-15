import random
import smtplib
import os
import string
import time

from flask import request, jsonify, redirect
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart

from util.constants import REPLY_CODES
from util.constants import SENDER, SENDER_NAME, SENDER_PW, SMTP_PORT, SMTP_URL


def reply_json(code, data=None):
    if data is None:
        data = []
    if code in REPLY_CODES:
        return jsonify({
            'code': code,
            'msg': REPLY_CODES[code],
            'data': data
        })
    return jsonify({
        'code': -1,
        'msg': ''
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
        mail.set_debuglevel(True)
        mail.ehlo()
        mail.starttls()
        mail.ehlo()
        mail.login(SENDER, SENDER_PW)
        mail.sendmail(SENDER_NAME, receivers, msg.as_string())
        mail.close()
        return 1
    except Exception as e:
        print('[send_email] {0}'.format(str(e)))
        return 0


def send_verification_code(receiver: str, code: str):
    content = '''
            Your verification code is: {0}.
            This code will expire in 10 minutes.
    '''.format(code)
    __send_email(receivers=[receiver], content=content, subject='DietLens verification code')


def gen_auth_code():
    return ''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for _ in range(6))


def get_timestamp():
    return int(time.time())


if __name__ == '__main__':
    send_verification_code('hi.imhpc@outlook.com', 123456)
    send_verification_code('zzwyxl@163.com', 123123)

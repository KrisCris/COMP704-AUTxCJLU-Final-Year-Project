# DB
DB_USERNAME = 'rnd'
DB_PASSWORD = 'sofop#rnd'
DB_ADDRESS = 'localhost'
DB_PORT = '33060'
DATABASE = 'rnd'
DB_CHARSET = 'utf8mb4'

# EMAIL
# SENDER = 'rnd_mail@mail.connlost.online'
# SENDER_NAME = 'DietLens<rnd_mail@mail.connlost.online>'
# SMTP_URL = 'smtp.yandex.com'
# SMTP_PORT = 465
SENDER = 'twr9738@autuni.ac.nz'
SENDER_NAME = 'DietLens<twr9738@autuni.ac.nz>'
SENDER_PW = 'Genius910189033'
SMTP_URL = 'smtp.office365.com'
SMTP_PORT = 587

# FLASK
HOST = '0.0.0.0'
PORT = 5000
DEBUG = True
ENV = 'development'

# CODE
REPLY_CODES = {
    -6: 'Code expired',
    -5: 'Email sending failed',
    -4: 'Wrong verification code',
    -3: 'User already exists',
    -2: 'Wrong email or password',
    -1: 'Login required',
    1: 'Success',
    403: 'Bad request'

}

SECRET_KEY = 'twr9728@autuni.ac.nz'

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
# SENDER = 'sofop_rnd@outlook.com'
# SENDER_NAME = 'DietLens<sofop_rnd@outlook.com>'
# SENDER_PW = 'sofop#rnd'
# SMTP_URL = 'smtp.office365.com'
# SMTP_PORT = 587
SENDER = 'ZhuanPlus@163.com'
SENDER_NAME = 'DietLens<ZhuanPlus@163.com>'
SENDER_PW = 'DYABEXZWAEEYUHNH'
SMTP_URL = 'smtp.163.com'
SMTP_PORT = 587

# FLASK
HOST = '0.0.0.0'
PORT = 5000
DEBUG = True
ENV = 'development'

# CODE
REPLY_CODES = {
    -9: 'Bad Format',
    -8: 'Code Check Required',
    -7: 'Too Often',
    -6: 'Not Exist',
    -5: 'Operation Failed',
    -4: 'Expired',
    -3: 'Already Exist',
    -2: 'Wrong',
    -1: 'Login Required',
    1: 'Success',
    403: 'Bad Request',
    500: 'Error'

}

SECRET_KEY = 'twr9728@autuni.ac.nz'

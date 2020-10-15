from flask_sqlalchemy import SQLAlchemy
from util.func import get_timestamp

db = SQLAlchemy()


def initDB(app):
    with app.app_context():
        db.init_app(app)
        db.create_all()


def add(model: db.Model):
    db.session.add(model)
    db.session.commit()


class User(db.Model):
    __tablename__ = 'user'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    username = db.Column(db.VARCHAR(20), unique=True, comment='账号')
    password = db.Column(db.VARCHAR(255), comment='密码')
    group = db.Column(db.INTEGER, comment='用户组')
    token = db.Column(db.VARCHAR(40), server_default=db.text("''"))
    portrait = db.Column(db.VARCHAR(255), server_default=db.text("'/new_api/static/default.jpg'"),
                         comment='头像')
    email = db.Column(db.VARCHAR(255), nullable=False, unique=True)
    auth_code = db.Column(db.VARCHAR(6), comment='验证码')
    last_login = db.Column(db.INTEGER, nullable=False)

    def __init__(self, email, auth_code, last_login=get_timestamp(), username='', password='', group=1, ):
        self.username = username
        self.password = password
        self.group = group
        self.email = email
        self.auth_code = auth_code
        self.last_login = last_login


class Food(db.Model):
    __tablename__ = 'food'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    name = db.Column(db.VARCHAR(255), nullable=False)
    type = db.Column(db.INTEGER)
    calories = db.Column(db.INTEGER, nullable=False)

    def __init__(self, name, type, calories):
        self.name = name
        self.type = type
        self.calories = calories

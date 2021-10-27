from db.db import db
from util.Common.func import get_current_time


class User(db.Model):
    __tablename__ = 'user'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    email = db.Column(db.VARCHAR(255), nullable=False, unique=True)
    nickname = db.Column(db.VARCHAR(20))
    password = db.Column(db.VARCHAR(255))
    group = db.Column(db.INTEGER, comment='user group, 0=unactivated, 1=normal user')
    token = db.Column(db.VARCHAR(40), server_default=db.text("''"), comment='unique string that auth auto login')
    avatar = db.Column(db.VARCHAR(255), server_default=db.text("'static/user/avatar/default.png'"))
    gender = db.Column(db.INTEGER, comment='male=1, female=2, others=0')
    age = db.Column(db.INTEGER)
    weight = db.Column(db.FLOAT)
    height = db.Column(db.FLOAT)
    auth_code = db.Column(db.VARCHAR(20), comment='verification code')
    last_code_sent = db.Column(db.INTEGER, nullable=False, comment='timestamp the last time server sent a auth_code')
    code_check = db.Column(db.INTEGER, server_default=db.FetchedValue())
    guide = db.Column(db.BOOLEAN)
    register_date = db.Column(db.INTEGER)
    b_percent = db.Column(db.INTEGER)
    l_percent = db.Column(db.INTEGER)
    d_percent = db.Column(db.INTEGER)
    test_account = db.Column(db.BOOLEAN)

    def __init__(self, email, auth_code, gender=1, age=20, weight=70, height=175, last_code_sent=get_current_time(),
                 nickname='', password='',
                 group=0, token='', code_check=0, guide=1, register_date=get_current_time()):
        self.email = email
        self.nickname = nickname
        self.password = password
        self.group = group
        self.token = token
        self.auth_code = auth_code
        self.last_code_sent = last_code_sent
        self.gender = gender
        self.age = age
        self.weight = weight
        self.height = height
        self.code_check = code_check
        self.guide = guide
        self.register_date = register_date
        self.b_percent = 30
        self.l_percent = 40
        self.d_percent = 30
        self.test_account = False

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def getUserByID(id) -> 'User':
        return User.query.get(id)

    @staticmethod
    def getUserByEmail(email) -> 'User':
        return User.query.filter(User.email == email).first()

    def toDict(self):
        return {'id': self.id, 'email': self.email, 'nickname': self.nickname, 'token': self.token,
                'avatar': self.avatar, 'gender': self.gender, 'age': self.age, 'weight': self.weight,
                'height': self.height, 'register_date': self.register_date, 'needGuide': self.guide,
                'breakfast_percent': self.b_percent, 'lunch_percent': self.l_percent, 'dinner_percent': self.d_percent,
                }

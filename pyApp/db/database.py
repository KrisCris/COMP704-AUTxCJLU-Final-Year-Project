# from sqlalchemy import create_engine
# from sqlalchemy.ext.declarative import declarative_base
# from sqlalchemy.orm import sessionmaker
#
# from util.constants import USER_NAME, PASSWORD, HOST_ADDRESS, PORT, DATABASE, CHARSET
#
# engine = create_engine('mysql+mysqldb://%s:%s@%s:%s/%s?charset=%s' % (
#     USER_NAME, PASSWORD, HOST_ADDRESS, PORT, DATABASE, CHARSET),pool_recycle=3600)
# Base = declarative_base()
#
# Session = sessionmaker(bind=engine)
#
#
# def init_db():
#     import db.Model.User
#     Base.metadata.create_all(bind=engine)
#
#
# if __name__ == '__main__':
#     init_db()

from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'user'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    username = db.Column(db.VARCHAR(20), comment='账号')
    password = db.Column(db.VARCHAR(255), comment='密码')
    group = db.Column(db.INTEGER, comment='用户组')
    token = db.Column(db.VARCHAR(40), nullable=False, server_default=db.text("''"))
    portrait = db.Column(db.VARCHAR(255), nullable=False, server_default=db.text("'/new_api/static/default.jpg'"),
                         comment='头像')

    def __init__(self, username, password, group):
        self.username = username
        self.password = password
        self.group = group


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

from db.db import db


class Plan(db.Model):
    __tablename__ = 'plan'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    begin = db.Column(db.Ti)
from db.db import db


class DailyConsumption(db.Model):
    __tablename__ = 'dailyConsumption'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    pid = db.Column(db.INTEGER, db.ForeignKey('plan.id'), nullable=False)
    fid = db.Column(db.INTEGER, db.ForeignKey('food.id'), nullable=False)
    type = db.Column(db.INTEGER, nullable=False, comment='1=breakfast, 2=lunch, 3=dinner')
    day = db.Column(db.INTEGER, nullable=False, comment='relative days since the plan began')
    name = db.Column(db.VARCHAR(256), comment='easier way to query food name...')
    calories = db.Column(db.FLOAT, comment='easier way to query calories')
    protein = db.Column(db.FLOAT, comment='easier way to query protein')

    def __init__(self, uid, pid, fid, type, day, name=None, calories=None, protein=None):
        self.uid = uid
        self.pid = pid
        self.fid = fid
        self.type = type
        self.day = day
        self.name = name
        self.calories = calories
        self.protein = protein

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
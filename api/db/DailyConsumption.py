from db.db import db


class DailyConsumption(db.Model):
    __tablename__ = 'dailyConsumption'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    pid = db.Column(db.INTEGER, db.ForeignKey('plan.id'), nullable=False)
    fid = db.Column(db.INTEGER, db.ForeignKey('food.id'), nullable=False)
    type = db.Column(db.INTEGER, nullable=False, comment='1=breakfast, 2=lunch, 3=dinner')
    day = db.Column(db.INTEGER, nullable=False, comment='relative days since the plan began')

    def __init__(self, uid, pid, fid, type, day):
        self.uid = uid,
        self.pid = pid,
        self.fid = fid,
        self.type = type,
        self.day = day

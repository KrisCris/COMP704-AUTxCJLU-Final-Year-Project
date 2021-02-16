from db.db import db
from util.func import get_current_time


class DailyConsumption(db.Model):
    __tablename__ = 'dailyConsumption'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    pid = db.Column(db.INTEGER, db.ForeignKey('plan.id'), nullable=False)
    fid = db.Column(db.INTEGER, db.ForeignKey('food.id'), nullable=False)
    type = db.Column(db.INTEGER, nullable=False, comment='1=breakfast, 2=lunch, 3=dinner')
    day = db.Column(db.INTEGER, nullable=False, comment='relative days since the plan began')
    time = db.Column(db.INTEGER)
    name = db.Column(db.VARCHAR(256), comment='easier way to query food name...')
    calories = db.Column(db.FLOAT, comment='easier way to query calories')
    protein = db.Column(db.FLOAT, comment='easier way to query protein')
    img = db.Column(db.Text(16777216))

    def __init__(self, uid, pid, fid, type, day, name=None, calories=None, protein=None, time=get_current_time(),
                 img=None):
        self.uid = uid
        self.pid = pid
        self.fid = fid
        self.type = type
        self.day = day
        self.name = name
        self.calories = calories
        self.protein = protein
        self.time = time
        self.img = img

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def get_periodic_record(begin: int, end: int, uid: int):
        records = DailyConsumption.query.filter(DailyConsumption.uid == uid).filter(
            end >= DailyConsumption.time >= begin).order_by(DailyConsumption.time.asc())
        arr = []
        for record in records:
            data = {
                'id': record.id,
                'pid': record.pid,
                'fid': record.fid,
                'time': record.time,
                'type': record.type,
                'calories': record.calories,
                'protein': record.protein,
                'name': record.name,
                'img': record.img
            }
            arr.append(data)
        return arr

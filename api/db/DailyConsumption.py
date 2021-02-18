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
    weight = db.Column(db.FLOAT, comment='100g per')
    img = db.Column(db.Text(16777216))

    def __init__(self, uid, pid, fid, type, day, name=None, calories=None, protein=None, weight=None,
                 time=get_current_time(), img=None):
        self.uid = uid
        self.pid = pid
        self.fid = fid
        self.type = type
        self.day = day
        self.name = name
        self.calories = calories
        self.protein = protein
        self.time = time
        self.weight = weight
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
            DailyConsumption.time >= begin).filter(DailyConsumption.time <= end).order_by(DailyConsumption.time.asc())
        arr = []
        for record in records:
            data = record.toDict()
            arr.append(data)
        return arr

    @staticmethod
    def getConsumptionGroupByType(begin: int, end: int, uid: int):
        records = DailyConsumption.query.filter(DailyConsumption.uid == uid).filter(
            DailyConsumption.time >= begin).filter(DailyConsumption.time <= end).order_by(DailyConsumption.time.asc())
        dic = {
            'b': [],
            'l': [],
            'd': [],
            'e': []
        }
        for record in records:
            def getArr(t: int):
                m = {
                    1: dic['b'],
                    2: dic['l'],
                    3: dic['d'],
                    0: dic['e']
                }
                return m.get(t)

            data = record.toDict()
            getArr(record.type).append(data)
        return dic

    @staticmethod
    def getAccumulatedCaloriesIntake(begin: int, end: int, uid: int):
        records = DailyConsumption.query.filter(DailyConsumption.uid == uid).filter(
            DailyConsumption.time >= begin).filter(DailyConsumption.time <= end).order_by(DailyConsumption.time.asc())
        cal = 0
        for record in records:
            cal += record.calories * record.weight
        return cal

    @staticmethod
    def getListedCaloriesIntake(begin: int, end: int, uid: int):
        records = DailyConsumption.query.filter(DailyConsumption.uid == uid).filter(
            DailyConsumption.time >= begin).filter(DailyConsumption.time <= end).order_by(DailyConsumption.time.asc())
        arr = []
        for record in records:
            arr.append({
                'id': record.id,
                'time': record.time,
                'calories': record.calories * record.weight
            })
        return arr

    def toDict(self):
        return {
            'id': self.id,
            'uid': self.uid,
            'pid': self.pid,
            'fid': self.fid,
            'time': self.time,
            'type': self.type,
            'calories': self.calories,
            'protein': self.protein,
            'name': self.name,
            'img': self.img,
            'weight': self.weight,
        }

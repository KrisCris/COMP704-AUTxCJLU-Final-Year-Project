from db.db import db
from util.func import get_current_time


class PlanDetail(db.Model):
    __tablename__ = 'planDetail'
    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=True, autoincrement=True)
    pid = db.Column(db.INTEGER, db.ForeignKey('plan.id'))
    time = db.Column(db.INTEGER, nullable=True)
    weight = db.Column(db.FLOAT)
    caloriesL = db.Column(db.FLOAT, nullable=False)
    caloriesH = db.Column(db.FLOAT, nullable=False)
    proteinL = db.Column(db.FLOAT, nullable=False)
    proteinH = db.Column(db.FLOAT, nullable=False)
    activityLevel = db.Column(db.FLOAT, nullable=False)
    ext = db.Column(db.INTEGER, comment='extension')

    def __init__(self, pid, weight, caloriesL, caloriesH, proteinL, proteinH, activeLevel, ext):
        self.pid = pid
        self.time = get_current_time()
        self.weight = weight
        self.caloriesL = caloriesL
        self.caloriesH = caloriesH
        self.proteinL = proteinL
        self.proteinH = proteinH
        self.activityLevel = activeLevel
        self.ext = ext

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def getWeightChangeArray(pid):
        plans = PlanDetail.query.filter(PlanDetail.pid == pid).order_by(PlanDetail.id.desc())
        weight_arr = []
        for p in plans:
            data = {'time': p.time, 'weight': p.weight}
            weight_arr.append(data)
        return weight_arr

    @staticmethod
    def getLatest(pid) -> 'PlanDetail':
        return PlanDetail.query.filter(PlanDetail.pid == pid).order_by(PlanDetail.id.desc()).first()

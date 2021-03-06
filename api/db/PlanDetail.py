from db.db import db
from util.Common.func import get_current_time


class PlanDetail(db.Model):
    __tablename__ = 'planDetail'
    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=True, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'))
    pid = db.Column(db.INTEGER, db.ForeignKey('plan.id'))
    time = db.Column(db.INTEGER, nullable=True)
    weight = db.Column(db.FLOAT)
    caloriesL = db.Column(db.FLOAT, nullable=False)
    caloriesH = db.Column(db.FLOAT, nullable=False)
    proteinL = db.Column(db.FLOAT, nullable=False)
    proteinH = db.Column(db.FLOAT, nullable=False)
    activityLevel = db.Column(db.FLOAT, nullable=False)
    ext = db.Column(db.INTEGER, comment='extension')

    def __init__(self, pid, uid, weight, caloriesL, caloriesH, proteinL, proteinH, activeLevel, ext=None,
                 time=get_current_time()):
        self.pid = pid
        self.uid = uid
        self.time = time
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

    def toDict(self):
        return {
            'pid': self.pid, 'uid': self.uid,
            'time': self.time, 'weight': self.weight,
            'cH': self.caloriesH, 'cL': self.caloriesL,
            'pH': self.proteinH, 'pL': self.proteinL,
            'pal': self.activityLevel, 'ext': self.ext
        }

    def extend(self, ext) -> 'PlanDetail':
        ext = int(ext)
        self.ext = ext if self.ext is None else self.ext + ext
        self.add()
        return self

    @staticmethod
    def getByID(pdid) -> 'PlanDetail':
        return PlanDetail.query.filter(PlanDetail.id==pdid).first()

    @staticmethod
    def getWeightTrendInPlan(pid):
        plans = PlanDetail.query.filter(PlanDetail.pid == pid).order_by(PlanDetail.id.asc())
        weight_arr = []
        for p in plans:
            data = {'time': p.time, 'weight': p.weight}
            weight_arr.append(data)
        return weight_arr

    @staticmethod
    def getWeightTrendInPeriod(uid, begin, end):
        if end == begin:
            end = end + 24 * 3600
        subPlans = PlanDetail.query.filter(PlanDetail.uid == uid).filter(PlanDetail.time >= begin).filter(
            PlanDetail.time <= end).order_by(PlanDetail.time.asc())
        weight_arr = []
        from db.Plan import Plan
        for subPlan in subPlans:
            pType = Plan.getPlanByID(subPlan.pid).type
            data = {'time': subPlan.time, 'weight': subPlan.weight, 'type': pType}
            weight_arr.append(data)
        return weight_arr

    @staticmethod
    def getLatest(pid) -> 'PlanDetail':
        return PlanDetail.query.filter(PlanDetail.pid == pid).order_by(PlanDetail.id.desc()).first()

    @staticmethod
    def getPastRecords(begin, end, uid):
        if end == begin:
            end = end + 24 * 3600
        res = PlanDetail.query.filter(PlanDetail.uid == uid).filter(PlanDetail.time >= begin).filter(
            PlanDetail.time <= end).order_by(PlanDetail.id.asc()).all()
        return res

    def getCorrespondingConsumptionsRecords(self):
        from db.DailyConsumption import DailyConsumption
        results = DailyConsumption.query.filter(DailyConsumption.pdid == self.id).order_by(DailyConsumption.time.asc()).all()
        list = []
        for result in results:
            resdict = result.toDict()
            resdict['img'] = None
            list.append(resdict)
        return list

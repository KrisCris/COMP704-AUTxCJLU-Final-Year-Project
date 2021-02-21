from db.db import db
from util.func import get_current_time


class Plan(db.Model):
    __tablename__ = 'plan'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    begin = db.Column(db.INTEGER, nullable=False)
    end = db.Column(db.INTEGER, nullable=False)
    # type = 1, 2, 3., i.e. shed weight, maintain, build muscle
    type = db.Column(db.INTEGER, nullable=False)
    goalWeight = db.Column(db.FLOAT)
    achievedWeight = db.Column(db.FLOAT)
    realEnd = db.Column(db.INTEGER)
    completed = db.Column(db.BOOLEAN, nullable=False, default=False)

    def __init__(self, uid, begin, end, plan_type, goal_weight):
        self.uid = uid
        self.begin = begin
        self.end = end
        self.type = plan_type
        self.goalWeight = goal_weight

    @staticmethod
    def getUnfinishedPlanByUID(uid):
        return Plan.query.filter(Plan.uid == uid).filter(Plan.completed != True).order_by(Plan.id.desc())

    @staticmethod
    def getPlanByID(pid) -> 'Plan':
        return Plan.query.filter(Plan.id == pid).first()

    @staticmethod
    def getLatest(uid) -> 'Plan':
        return Plan.query.filter(Plan.uid == uid).order_by(Plan.id.desc()).first()

    # @staticmethod
    # def getMaintainPlan(uid, age, height, weight, pal, gender):
    #     plan = Plan(
    #         uid=uid,
    #         begin=get_current_time(), end=-1,
    #         plan_type=2,
    #         goal_weight=weight
    #     )
    #     return plan

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    def finish(self, weight, time=get_current_time()):
        self.realEnd = time
        self.achievedWeight = weight
        self.completed = True
        self.add()

    def toDict(self):
        return {
            'pid': self.id, 'uid': self.uid,
            'begin': self.begin, 'end': self.end,
            'type': self.type, 'goalWeight': self.goalWeight,
            'achievedWeight': self.achievedWeight, 'realEnd': self.realEnd,
            'hasCompleted': self.completed
        }


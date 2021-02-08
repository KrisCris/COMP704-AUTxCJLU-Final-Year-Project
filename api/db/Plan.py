from db.db import db


class Plan(db.Model):
    __tablename__ = 'plan'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    begin = db.Column(db.INTEGER, nullable=False)
    end = db.Column(db.INTEGER, nullable=False)
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

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def getCurrentPlanByUID(uid):
        return Plan.query.filter(Plan.uid == uid).filter(Plan.completed != True)

    @staticmethod
    def getPlanByID(id):
        return Plan.query.filter(Plan.id == id)

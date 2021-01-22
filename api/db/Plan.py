from db.db import db


class Plan(db.Model):
    __tablename__ = 'plan'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    uid = db.Column(db.INTEGER, db.ForeignKey('user.id'), nullable=False)
    begin = db.Column(db.INTEGER, nullable=False)
    end = db.Column(db.INTEGER, nullable=False)
    type = db.Column(db.INTEGER, nullable=False)
    caloriesL = db.Column(db.FLOAT, nullable=False)
    caloriesH = db.Column(db.FLOAT, nullable=False)
    proteinL = db.Column(db.FLOAT, nullable=False)
    proteinH = db.Column(db.FLOAT, nullable=False)

    def __init__(self, uid, begin, end, type, caloriesL, caloriesH, proteinL, proteinH):
        self.uid = uid
        self.begin = begin
        self.end = end
        self.type = type
        self.caloriesL = caloriesL
        self.caloriesH = caloriesH
        self.proteinL = proteinL
        self.proteinH = proteinH

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()
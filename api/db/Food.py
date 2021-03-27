from db.db import db


class Food(db.Model):
    __tablename__ = 'food'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    name = db.Column(db.VARCHAR(255), unique=True, nullable=False, comment='food name')
    cnName = db.Column(db.VARCHAR(255))
    category = db.Column(db.ForeignKey('category.id'), index=True, comment='food category, details in category table.')
    image = db.Column(db.Text(16777216), comment='image for a food')
    calories = db.Column(db.FLOAT)
    fat = db.Column(db.FLOAT)
    carbohydrate = db.Column(db.FLOAT)
    protein = db.Column(db.FLOAT)
    cellulose = db.Column(db.FLOAT)
    ratioP = db.Column(db.FLOAT)
    ratioCH = db.Column(db.FLOAT)
    ratioF = db.Column(db.FLOAT)

    def __init__(self, name, category, calories, fat, carbohydrate, protein, cellulose, image='', cnName=None):
        self.cnName = cnName
        self.name = name
        self.category = category
        self.image = image
        self.calories = calories
        self.fat = fat
        self.carbohydrate = carbohydrate
        self.protein = protein
        self.cellulose = cellulose
        accumulatedWeight = protein + carbohydrate + fat
        self.ratioP = round(protein / accumulatedWeight, 3)
        self.ratioCH = round(carbohydrate / accumulatedWeight, 3)
        self.ratioF = 1 - self.ratioP - self.ratioCH

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def getByExactName(exact_name) -> 'Food':
        return Food.query.filter(Food.name == exact_name).first()

    @staticmethod
    def getById(fid) -> 'Food':
        return Food.query.filter(Food.id == fid).first()

    @staticmethod
    def search(name: str):
        return Food.query.filter(Food.name.like('%' + name + '%')).all()

    def toDict(self):
        return {'id': self.id, 'name': self.name, 'cnName': self.cnName, 'category': self.category, 'img': self.image,
                'calories': self.calories, 'fat': self.fat, 'carbohydrate': self.carbohydrate, 'protein': self.protein,
                'cellulose': self.cellulose,
                'ratioP': self.ratioP, 'ratioCH': self.ratioCH, 'ratioF': self.ratioF
                }

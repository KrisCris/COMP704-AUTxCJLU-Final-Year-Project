from db.db import db


class Food(db.Model):
    __tablename__ = 'food'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    name = db.Column(db.VARCHAR(255), unique=True, nullable=False, comment='food name')
    category = db.Column(db.ForeignKey('category.id'), index=True, comment='food category, details in category table.')
    image = db.Column(db.Text(16777216), comment='image for a food')
    calories = db.Column(db.FLOAT)
    fat = db.Column(db.FLOAT)
    carbohydrate = db.Column(db.FLOAT)
    protein = db.Column(db.FLOAT)
    cholesterol = db.Column(db.FLOAT)
    cellulose = db.Column(db.FLOAT)

    def __init__(self, name, category, calories, fat, carbohydrate, protein, cholesterol, cellulose, image=''):
        self.name = name
        self.category = category
        self.image = image
        self.calories = calories
        self.fat = fat
        self.carbohydrate = carbohydrate
        self.protein = protein
        self.cholesterol = cholesterol
        self.cellulose = cellulose

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

    @staticmethod
    def searchByName(exact_name):
        return Food.query.filter(Food.name == exact_name).first()
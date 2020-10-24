from extensions import db


class Food(db.Model):
    __tablename__ = 'food'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    name = db.Column(db.VARCHAR(255), unique=True, nullable=False, comment='food name')
    category = db.Column(db.INTEGER, db.ForeignKey('category.id'), comment='food category, details in category table.')
    image = db.Column(db.VARCHAR(255), server_default='', comment='image for a food')
    calories = db.Column(db.INTEGER, nullable=False)

    def __init__(self, name, category, image, calories):
        self.name = name
        self.category = category
        self.image = image
        self.calories = calories

    def add(self):
        db.session.add(self)
        db.session.commit()

    def delete(self):
        db.session.delete(self)
        db.session.commit()

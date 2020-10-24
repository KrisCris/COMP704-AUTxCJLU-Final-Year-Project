from extensions import db


class Category(db.Model):
    __tablename__ = 'category'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)

from db.db import db


class Category(db.Model):
    __tablename__ = 'category'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    name = db.Column(db.VARCHAR(256), nullable=False)

    def __init__(self, name):
        self.name = name

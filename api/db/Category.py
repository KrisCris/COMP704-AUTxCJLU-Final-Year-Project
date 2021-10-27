from db.db import db


class Category(db.Model):
    __tablename__ = 'category'

    id = db.Column(db.INTEGER, primary_key=True, unique=True, nullable=False, autoincrement=True)
    name = db.Column(db.VARCHAR(256), nullable=False)
    cnName = db.Column(db.VARCHAR(256))
    desc = db.Column(db.Text(16383))
    cnDesc = db.Column(db.Text(16383))

    def __init__(self, name, cnName=None, desc=None, cnDesc=None):
        self.cnName = cnName
        self.name = name
        self.desc = desc
        self.cnDesc = cnDesc

    @staticmethod
    def getCateByID(id):
        return Category.query.filter(Category.id == id).first()

    def toDict(self):
        return {
            'id': self.id,
            'name': self.name,
            'cnName': self.cnName,
            'desc': self.desc,
            'cnDesc': self.cnDesc
        }

    @staticmethod
    def getIdList():
        idSet: list = []
        for cate in Category.query.all():
            idSet.append(cate.id)
        return idSet

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
        # we had to manually map these items to english in order to do the search since we forgot to convert the name of these to english before training.
        conversionTable = {
            '西瓜': 'watermelon',
            '香蕉': 'banana',
            '馒头': 'steamed bread',
            '草莓': 'strawberry',
            '酸奶': 'yoghourt',
            '雪碧': 'sprite',
            '葡萄': 'grape',
            '苹果': 'apple',
            '玉米': 'maize',
            '冰淇淋': 'ice cream',
            '饼干': 'cookies',
            '茶叶蛋': 'tea eggs',
            '汉堡': 'hamburger',
            '米饭': 'rice',
            '粥': 'porridge',
            '小笼包': 'xiao long bao',
            '方便面': 'instant noodles',
            '面包': 'roll bread',
            '面条': 'noodles',
            '牛奶': 'milk',
            '水饺': 'jiaozi',
            '车厘子': 'cherries',
            '橙子': 'orange',
            '蛋糕': 'cake',
            '豆浆': 'soy milk',
            '馄饨': 'huntun',
            '鸡翅': 'Deep Fried Chicken Wing',
            '荷包蛋': 'poached egg',
            '三明治': 'sandwiches',
            '果汁': 'juice',
            '咖啡': 'coffee',
            '可乐': 'cola',
            '梨': 'pear',
            '巧克力': 'chocolate',
            '薯条': 'french fries'
        }
        if exact_name in conversionTable:
            exact_name = conversionTable[exact_name]
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

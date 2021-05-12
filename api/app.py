from flask import Flask
from flasgger import Swagger
import pymysql
pymysql.install_as_MySQLdb()
from db.db import db
from util.Common.constants import HOST, PORT, DEBUG, ENV
from util.Common.constants import DB_USERNAME, DB_PASSWORD, DB_ADDRESS, DB_PORT, DATABASE
from util.Common.constants import SECRET_KEY

from api.user import user
from api.food import food
from api.plan import plan

app = Flask(__name__)

# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://%s:%s@%s:%s/%s' % (
#     DB_USERNAME, DB_PASSWORD, DB_ADDRESS, DB_PORT, DATABASE)
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# app.config['SECRET_KEY'] = SECRET_KEY
#
# app.config['ENV'] = ENV
# app.config['DEBUG'] = DEBUG
from config import DevConfig
app.config.from_object(DevConfig())


app.register_blueprint(user, url_prefix='/user')
app.register_blueprint(food, url_prefix='/food')
app.register_blueprint(plan, url_prefix='/plan')

swagger = Swagger(app)


with app.app_context():
    db.init_app(app)
    db.create_all()

# app.run(host=HOST, port=PORT, debug=DEBUG)


def calcNutritionRatio():
    with app.app_context():
        from db.Food import Food
        for food in Food.query.all():
            protein = food.protein if food.protein else 0
            carbohydrate = food.carbohydrate if food.carbohydrate else 0
            fat = food.fat if food.fat else 0

            accW = protein + carbohydrate + fat
            food.ratioP = round(protein / accW, 3) if accW != 0 else 0
            food.ratioCH = round(carbohydrate / accW, 3) if accW != 0 else 0
            food.ratioF = 0 if fat == 0 else 1 - food.ratioP - food.ratioCH
            food.add()
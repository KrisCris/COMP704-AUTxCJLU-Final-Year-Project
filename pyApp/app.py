from flask import Flask
from flasgger import Swagger

from db.db import db
from util.constants import HOST, PORT, DEBUG, ENV
from util.constants import DB_USERNAME, DB_PASSWORD, DB_ADDRESS, DB_PORT, DATABASE
from util.constants import SECRET_KEY

from api.user import user

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://%s:%s@%s:%s/%s' % (
    DB_USERNAME, DB_PASSWORD, DB_ADDRESS, DB_PORT, DATABASE)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = SECRET_KEY

app.register_blueprint(user, url_prefix='/user')

swagger = Swagger(app)

if __name__ == '__main__':
    with app.app_context():
        db.init_app(app)
        db.create_all()

    app.run(host=HOST, port=PORT, debug=DEBUG)

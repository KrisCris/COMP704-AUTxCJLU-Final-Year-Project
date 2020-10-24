from flask_sqlalchemy import SQLAlchemy
from flask_httpauth import HTTPTokenAuth

db = SQLAlchemy()
auth = HTTPTokenAuth(scheme='Token')




from flask import Blueprint, request
from flasgger import swag_from

plan = Blueprint(name='plan', import_name=__name__)

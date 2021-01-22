from flask import Blueprint, request

from db import User
from util.user import require_login
from flasgger import swag_from

plan = Blueprint(name='plan', import_name=__name__)


@plan.route('set_plan', methods=['POST'])
@require_login
def set_plan():
    uid = request.form.get('uid')
    duration = request.form.get('duration')
    height = request.form.get('height')
    weight = request.form.get('weight')
    age = request.form.get('age')
    plan = request.form.get('plan')

    # update age
    user = User.getUserByID(uid)
    user.age = age
    User.add()


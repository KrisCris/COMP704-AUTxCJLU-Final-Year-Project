from flask import Blueprint, request
from flasgger import swag_from

from db import User, Plan
from util.user import require_login
from util.func import reply_json, get_current_time, get_future_time
from util.Planer.CalsPlaner import calc_calories

plan = Blueprint(name='plan', import_name=__name__)


# type = 1, 2, 3., i.e. shed weight, maintain, build muscle


@plan.route('query_plan', methods=['GET'])
def query_plan():
    # params
    height = float(request.values.get('height'))
    weight = float(request.values.get('weight'))
    age = int(request.values.get('age'))
    # male 1, female 2
    gender = True if request.values.get('gender') == '1' else False
    plan_type = int(request.values.get('plan'))
    duration = int(request.values.get('duration'))
    goal_weight = weight if plan_type == 2 or plan_type == 3 else float(request.values.get('goal_weight'))
    physical_activity_level = float(request.values.get('pal'))

    # calculation
    result = calc_calories(
        age=age,
        height=height,
        weight=weight,
        pal=physical_activity_level,
        time=duration,
        goalWeight=goal_weight,
        gender=gender,
        type=plan_type
    )

    if result == 'unachievable':
        return reply_json(code=-2, msg='unachievable')

    return reply_json(code=1, data=result)


@plan.route('set_plan', methods=['POST'])
@require_login
def set_plan():
    # params
    uid = request.form.get('uid')

    age = int(request.form.get('age'))
    gender = int(request.form.get('gender'))
    weight = float(request.form.get('weight'))
    goal_weight = float(request.form.get('goalWeight'))
    height = float(request.form.get('height'))
    calories = int(request.form.get('calories'))
    protein = float(request.form.get('protein'))
    plan_type = int(request.form.get('type'))
    duration = int(request.form.get('duration'))

    # db
    user = User.getUserByID(uid)
    # update user data
    user.age = age
    user.gender = gender
    user.weight = weight
    user.height = height
    user.add()
    # new plan
    new_plan = Plan(
        uid=uid,
        begin=get_current_time(), end=get_future_time(duration), plan_type=plan_type,
        goal_weight=goal_weight,
        caloriesL=round(calories * 0.95), caloriesH=round(calories * 1.05),
        proteinL=protein * 0.95, proteinH=protein * 1.05
    )
    new_plan.add()

    return reply_json(1)

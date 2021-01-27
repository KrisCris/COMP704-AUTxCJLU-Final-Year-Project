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

    # calories calculation
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
    if result == 'wrong type':
        return reply_json(code=-2, msg='wrong type')


    # protein calculation
    result['protein_l'] = result['completedCal'] / 7.7 * 0.22
    result['protein_h'] = result['completedCal'] / 7.7 * 0.32

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
    maintCalories = int(request.form.get('maintCalories'))
    plan_type = int(request.form.get('type'))
    duration = int(request.form.get('duration'))

    # db
    user = User.getUserByID(uid)

    # check old plan
    old_plan = Plan.getCurrentPlanByUID(uid).first()
    if old_plan:
        if old_plan.type == 2:
            old_plan.realEnd = get_current_time()
            old_plan.achievedWeight = weight
            old_plan.completed = True
            old_plan.add()
        else:
            return reply_json(-3, data={
                'pid': old_plan.id,
                'cl': old_plan.caloriesL, 'ch': old_plan.caloriesH,
                'pl': old_plan.proteinL, 'ph': old_plan.proteinH,
                'begin': old_plan.begin, 'end': old_plan.end,
                'type': old_plan.type, 'goal': old_plan.goalWeight
            })

    # new plan
    new_plan = Plan(
        uid=uid,
        begin=get_current_time(), end=get_future_time(duration), plan_type=plan_type,
        goal_weight=goal_weight,
        caloriesL=round(calories * 0.95) if round(calories * 0.95) >= 1000 else 1000,
        caloriesH=round(calories * 1.05),
        proteinL=maintCalories / 7.7 * 0.22,
        proteinH=maintCalories / 7.7 * 0.32
    )
    new_plan.add()

    # update user data
    user.age = age
    user.gender = gender
    user.weight = weight
    user.height = height
    user.guide = False
    user.add()

    return reply_json(
        1,
        data={
            'pid': new_plan.id,
            'cl': new_plan.caloriesL, 'ch': new_plan.caloriesH,
            'pl': new_plan.proteinL, 'ph': new_plan.proteinH,
            'begin': new_plan.begin, 'end': new_plan.end,
            'type': new_plan.type, 'goal': new_plan.goalWeight
        }
    )


@plan.route('finish_plan', methods=['POST'])
@require_login
def finish_plan():
    uid = request.form.get('uid')
    weight = request.form.get('weight')
    # pid = request.form.get('pid')

    res = Plan.getCurrentPlanByUID(uid)

    if res.count() > 1:
        print('wrong plan number')

    p = res.first()
    if p:
        p.realEnd = get_current_time()
        p.achievedWeight = weight
        p.completed = True
        p.add()
    return reply_json(1)


@plan.route('get_current_plan', methods=['POST'])
@require_login
def get_current_plan():
    uid = request.form.get('uid')
    p = Plan.getCurrentPlanByUID(uid).first()
    if p:
        return reply_json(1, data={
            'pid': p.id,
            'cl': p.caloriesL, 'ch': p.caloriesH,
            'pl': p.proteinL, 'ph': p.proteinH,
            'begin': p.begin, 'end': p.end,
            'type': p.type, 'goal': p.goalWeight,
        })
    else:
        return reply_json(-6)


def get_plans():
    pass


def get_plan():
    pass

@plan.route('add_food_plan', methods=['POST'])
@require_login
def add_food_plan():
    uid = request.form.get('uid')
    pass
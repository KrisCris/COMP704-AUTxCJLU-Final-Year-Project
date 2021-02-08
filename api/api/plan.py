from flask import Blueprint, request
from flasgger import swag_from

from db import User, Plan, DailyConsumption, PlanDetail
from util.user import require_login
from util.func import reply_json, get_current_time, get_future_time, get_relative_days
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
            return reply_json(-3)

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
    newPlanDetail = PlanDetail()
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
    weight = request.form.get('weight')
    pid = request.form.get('pid')

    # no more search by uid. completely eliminate unfinished plan.
    p = Plan.getPlanByID(pid)
    if p:
        if not p.completed:
            p.finish(weight=weight)
            return reply_json(1)
        else:
            return reply_json(-3, msg='Already finished')
    else:
        return reply_json(-6)


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


@plan.route('get_plan', methods=['POST'])
@require_login
def get_plan():
    pid = request.form.get('pid')
    p = Plan.getPlanByID(pid)
    if p:
        return reply_json(1, data={
            'pid': p.id,
            'cl': p.caloriesL, 'ch': p.caloriesH,
            'pl': p.proteinL, 'ph': p.proteinH,
            'begin': p.begin, 'end': p.end,
            'type': p.type, 'goal': p.goalWeight,
            'hasFinished': False if p.realEnd is None else True
        })
    else:
        return reply_json(-6)


@plan.route('consume_foods', methods=['POST'])
@require_login
def consume_foods():
    uid = request.form.get('uid')
    pid = request.form.get('pid')
    # 1 = breakfast, 2 = lunch, 3 = dinner
    type = request.form.get('type')
    # a list that contains all the food and its corresponding info including proteins, calories, names.
    foods_info = request.form.get('foods_info')
    # TODO check the food_info's type
    p = Plan.getPlanByID(pid)

    day = get_relative_days(p.begin, get_current_time()) + 1
    for food_info in foods_info:
        f = DailyConsumption(
            uid=uid, pid=pid, type=type, fid=food_info[0], day=day,
            name=food_info[1], calories=foods_info[2], protein=foods_info[3]
        )
        f.add()
    return reply_json(1)


@plan.route('update_body_info', methods=['POST'])
@require_login
def update_body_info():
    uid = request.form.get('uid')
    height = None if 'height' in request.form.keys() else request.form.get('height')
    weight = None if 'weight' in request.form.keys() else request.form.get('weight')

    u = User.getUserByID(uid)
    u.height = height if height else u.height
    u.weight = weight if weight else u.weight

    # TODO update plan and return the future calories and protein intake

    u.add()
    return reply_json(1, data={'calories': 0, 'protein': 0})

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

    # check unfinished previous plan
    old_plan = Plan.getUnfinishedPlanByUID(uid).first()
    if old_plan:
        if old_plan.type == 2:
            old_plan.finish(weight=weight)
        else:
            return reply_json(-3)

    # new plan
    newPlan = Plan(
        uid=uid,
        begin=get_current_time(), end=get_future_time(duration),
        plan_type=plan_type,
        goal_weight=goal_weight
    )
    newPlanDetail = PlanDetail(
        pid=newPlan.id,
        weight=weight,
        caloriesL=round(calories * 0.95) if round(calories * 0.95) >= 1000 else 1000,
        caloriesH=round(calories * 1.05),
        proteinL=maintCalories / 7.7 * 0.22,
        proteinH=maintCalories / 7.7 * 0.32
    )
    from db.db import db
    db.session.add(newPlan)
    db.session.add(newPlanDetail)
    db.session.commit()

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
            'pid': newPlan.id,
            'cl': newPlanDetail.caloriesL, 'ch': newPlanDetail.caloriesH,
            'pl': newPlanDetail.proteinL, 'ph': newPlanDetail.proteinH,
            'begin': newPlan.begin, 'end': newPlan.end,
            'type': newPlan.type, 'goal': newPlan.goalWeight
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
    p: 'Plan' = Plan.getUnfinishedPlanByUID(uid).first()
    planDetail = PlanDetail.getLatest(p.id)
    if p:
        return reply_json(1, data={
            'pid': p.id,
            'cl': planDetail.caloriesL, 'ch': planDetail.caloriesH,
            'pl': planDetail.proteinL, 'ph': planDetail.proteinH,
            'ext': planDetail.ext,
            'begin': p.begin, 'end': p.end,
            'type': p.type, 'goal': p.goalWeight,
        })
    else:
        return reply_json(-6)


@plan.route('get_plan', methods=['POST'])
@require_login
def get_plan():
    pid = request.form.get('pid')
    p = Plan.getPlanByID(pid)
    planDetail = PlanDetail.getLatest(p.id)
    if p:
        return reply_json(1, data={
            'pid': p.id,
            'cl': planDetail.caloriesL, 'ch': planDetail.caloriesH,
            'pl': planDetail.proteinL, 'ph': planDetail.proteinH,
            'ext': planDetail.ext,
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
    pal = None if 'pal' in request.form.keys() else request.form.get('pal')  # physical activity level

    u = User.getUserByID(uid)
    u.height = height if height else u.height
    u.weight = weight if weight else u.weight

    # update plan and return the future calories and protein intake
    p: Plan = Plan.getUnfinishedPlanByUID(uid).first()
    remain = get_relative_days(get_current_time(), p.end)
    planDetail = PlanDetail.getLatest(p.id)

    # last extension record
    ext = planDetail.ext
    if ext:
        remain = remain + ext

    if p.type == 1:
        # 10 attempts to find a realizable diet plan, or plan would be failed.
        failed = True
        for i in range(11):
            day = 7 * i
            result = calc_calories(
                age=u.age,
                height=u.height,
                weight=u.weight,
                pal=pal,
                time=remain + day,
                goalWeight=p.goalWeight,
                gender=True if u.gender == 1 else False,
                type=p.type
            )
            # find the shortest ext
            if not (result == 'unachievable' or result.get('low')):
                failed = False
                ext = day if not ext else ext + day
                break
        if failed:
            return reply_json(-2)

        calories = result.get('goalCal')
        maintCalories = result.get('maintainCal')

        newPlanDetail = PlanDetail(
            pid=p.id,
            weight=weight,
            caloriesL=round(calories * 0.95) if round(calories * 0.95) >= 1000 else 1000,
            caloriesH=round(calories * 1.05),
            proteinL=maintCalories / 7.7 * 0.22,
            proteinH=maintCalories / 7.7 * 0.32,
            activeLevel=pal,
            ext=None if not ext else ext
        )
        newPlanDetail.add()

        planData={
            'pid': p.id,
            'cl': newPlanDetail.caloriesL, 'ch': newPlanDetail.caloriesH,
            'pl': newPlanDetail.proteinL, 'ph': newPlanDetail.proteinH,
            'begin': p.begin, 'end': p.end,
            'ext': 0 if not newPlanDetail.ext else ext,
            'type': p.type, 'goal': p.goalWeight,
        }

    elif p.type == 2:
        # calibrate weight using type.1
        result = calc_calories(
            age=u.age,
            height=u.height,
            weight=u.weight,
            pal=pal,
            time=14,
            goalWeight=p.goalWeight,
            gender=True if u.gender == 1 else False,
            type=1
        )
        calories = result.get('goalCal')
        newPlanDetail = PlanDetail(
            pid=p.id,
            weight=weight,
            caloriesL=round(calories * 0.95) if round(calories * 0.95) >= 1000 else 1000,
            caloriesH=round(calories * 1.05),
            proteinL=calories / 7.7 * 0.22,
            proteinH=calories / 7.7 * 0.32,
            activeLevel=pal,
            ext=None
        )
        newPlanDetail.add()

        if result == 'unachievable' or result.get('low'):
            return reply_json(-2)

        planData = {
            'pid': p.id,
            'cl': newPlanDetail.caloriesL, 'ch': newPlanDetail.caloriesH,
            'pl': newPlanDetail.proteinL, 'ph': newPlanDetail.proteinH,
            'begin': p.begin, 'end': p.end,
            'ext': None,
            'type': p.type, 'goal': p.goalWeight,
        }

    elif p.type == 3:
        result = calc_calories(
            age=u.age,
            height=u.height,
            weight=u.weight,
            pal=pal,
            time=0,
            goalWeight=u.weight,
            gender=True if u.gender == 1 else False,
            type=3
        )
        maintCals = result.get('maintainCal')
        newPlanDetail = PlanDetail(
            pid=p.id,
            weight=weight,
            caloriesL=round(maintCals * 0.95) if round(maintCals * 0.95) >= 1000 else 1000,
            caloriesH=round(maintCals * 1.05),
            proteinL=maintCals / 7.7 * 0.22,
            proteinH=maintCals / 7.7 * 0.32,
            activeLevel=pal,
            ext=None
        )
        newPlanDetail.add()
        planData = {
            'pid': p.id,
            'cl': newPlanDetail.caloriesL, 'ch': newPlanDetail.caloriesH,
            'pl': newPlanDetail.proteinL, 'ph': newPlanDetail.proteinH,
            'begin': p.begin, 'end': p.end,
            'ext': None,
            'type': p.type, 'goal': p.goalWeight,
        }


    u.add()
    return reply_json(1, data=planData)

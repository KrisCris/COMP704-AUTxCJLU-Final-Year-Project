from flask import Blueprint, request
from flasgger import swag_from

from db import User, Plan, DailyConsumption, PlanDetail
from util.user import require_login
from util.func import reply_json, get_current_time, get_future_time, get_relative_days, get_time_gap
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
    pal = float(request.form.get('pal'))

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
    time = get_current_time()
    newPlan = Plan(
        uid=uid,
        begin=time, end=get_future_time(now=time, days=duration),
        plan_type=plan_type,
        goal_weight=goal_weight
    )
    newPlan.add()
    newPlanDetail = PlanDetail(
        pid=newPlan.id,
        uid=uid,
        weight=weight,
        caloriesL=round(calories * 0.95) if round(calories * 0.95) >= 1000 else 1000,
        caloriesH=round(calories * 1.05),
        proteinL=maintCalories / 7.7 * 0.22,
        proteinH=maintCalories / 7.7 * 0.32,
        activeLevel=pal,
        ext=None,
        time=time
    )
    newPlanDetail.add()

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
    if p:
        planDetail = PlanDetail.getLatest(p.id)
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
    if p:
        planDetail = PlanDetail.getLatest(p.id)
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


@plan.route('update_body_info', methods=['POST'])
@require_login
def update_body_info():
    FLAG = False
    FLAG_EXT = 0
    uid = request.form.get('uid')
    height = float(request.values.get('height'))
    weight = float(request.values.get('weight'))
    pal = None if 'pal' not in request.form.keys() else request.form.get('pal')  # physical activity level

    u = User.getUserByID(uid)
    if u is None:
        return reply_json(-2)

    u.height = height if height else u.height
    u.weight = weight if weight else u.weight

    # update plan and return the future calories and protein intake
    p: Plan = Plan.getUnfinishedPlanByUID(uid).first()
    if p:
        remain = get_relative_days(get_current_time(), p.end)
        planDetail = PlanDetail.getLatest(p.id)
        if pal is None:
            pal = planDetail.activityLevel

        # last extension record
        ext = planDetail.ext
        if ext:
            remain = remain + ext

        if p.type == 1:
            # 10 attempts to find a realizable diet plan, or plan would be failed.

            result = calc_calories(
                age=u.age,
                height=u.height,
                weight=u.weight,
                pal=pal,
                time=remain,
                goalWeight=p.goalWeight,
                gender=True if u.gender == 1 else False,
                type=p.type
            )
            if result == 'unachievable' or result.get('low'):
                FLAG = True
                day = 7
                accumDay = 7
                lastAvaDay = -1
                for i in range(0, 24):
                    result = calc_calories(
                        age=u.age,
                        height=u.height,
                        weight=u.weight,
                        pal=pal,
                        time=remain + accumDay,
                        goalWeight=p.goalWeight,
                        gender=True if u.gender == 1 else False,
                        type=p.type
                    )
                    # find the shortest ext
                    if result == 'unachievable' or result.get('low'):
                        if lastAvaDay > 0:
                            FLAG_EXT = lastAvaDay
                            break
                        day *= 2
                        accumDay += day
                    else:
                        lastAvaDay = accumDay
                        accumDay = accumDay - (day / 2 if day >= 14 else day)

            if not FLAG:
                calories = result.get('goalCal')
                maintCalories = result.get('maintainCal')

                newPlanDetail = PlanDetail(
                    uid=uid,
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

                planData = {
                    'pid': p.id,
                    'cl': newPlanDetail.caloriesL, 'ch': newPlanDetail.caloriesH,
                    'pl': newPlanDetail.proteinL, 'ph': newPlanDetail.proteinH,
                    'begin': p.begin, 'end': p.end,
                    'ext': 0 if not newPlanDetail.ext else ext,
                    'type': p.type, 'goal': p.goalWeight,
                }

        elif p.type == 2:
            # calibrate weight using type.1, 14 days to lose weight.
            result = calc_calories(
                age=u.age,
                height=u.height,
                weight=u.weight,
                pal=pal,
                time=28,
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

            # if -2, means the weight gained too much... Should change the plan instead
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
            # calories calculated from current weight to support muscle gain
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
            # calories for maintain this weight
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
        if not FLAG:
            return reply_json(1, data=planData)
        else:
            return reply_json(-2, data={'hasRecommendation': True if FLAG_EXT else False, 'recommend_ext': FLAG_EXT})
    else:
        return reply_json(-6)


@plan.route('get_weight_trend', methods=['POST'])
@require_login
def get_weight_trend():
    uid = request.form.get('uid')
    begin = request.form.get('begin')
    end = request.form.get('end')

    trend = PlanDetail.getWeightTrendInPeriod(uid=uid, begin=begin, end=end)
    return reply_json(1, data={'trend': trend})


@plan.route('get_plan_weight_trend', methods=['POST'])
@require_login
def get_plan_weight_trend():
    pid = request.form.get('pid')
    trend = PlanDetail.getWeightTrendInPlan(pid)
    return reply_json(1, data={'trend': trend})


@plan.route('extend_update_plan', methods=['POST'])
@require_login
def extendAndUpdatePlan():
    # only called by type 1 for fixing the end date
    uid = request.form.get('uid')
    pid = request.form.get('pid')
    days = request.form.get('days')
    user = User.getUserByID(uid)
    subPlan = PlanDetail.getLatest(pid)
    newSubPlan = PlanDetail(
        pid=pid,
        uid=subPlan.uid,
        weight=user.weight,
        caloriesL=subPlan.caloriesL,
        caloriesH=subPlan.caloriesH,
        proteinL=subPlan.proteinL,
        proteinH=subPlan.proteinH,
        activeLevel=subPlan.activityLevel,
    )
    newSubPlan.add()
    return reply_json(1, data={'ext': newSubPlan.extend(ext=days).ext})


@plan.route('extend_plan', methods=['POST'])
@require_login
def extendPlan():
    pid = request.form.get('pid')
    days = request.form.get('days')
    return reply_json(1, data={'ext': PlanDetail.getLatest(pid).extend(ext=days).ext})


@plan.route('should_update_weight', methods=['POST'])
@require_login
def shouldUpdateWeight():
    pid = request.form.get('pid')
    subPlan = PlanDetail.getLatest(pid)
    if get_time_gap(subPlan.time) > 3600 * 24 * 7:
        return reply_json(1, data={'shouldUpdate': True})
    else:
        return reply_json(1, data={'shouldUpdate': False})


@plan.route('get_past_plans', methods=['POST'])
@require_login
def getPastDetails():
    # too many bullshit to figure out.
    pass

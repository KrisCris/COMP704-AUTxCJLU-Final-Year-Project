from flasgger import swag_from
from flask import Blueprint, request

from db import User, Plan, DailyConsumption, PlanDetail
from util.Common.func import reply_json, get_current_time, get_future_time, get_relative_days, get_time_gap, \
    attributes_receiver, echoErr
from util.Common.plan import estimateExt
from util.Common.user import require_login
from util.Planner.CalsPlanner import calc_calories

plan = Blueprint(name='plan', import_name=__name__)


# type = 1, 2, 3., i.e. shed weight, maintain, build muscle


@plan.route('query_plan', methods=['GET'])
@echoErr
@attributes_receiver(required=["height", "weight", "age", "gender", "plan", "duration", "pal"],
                     optional=["goal_weight"])
@swag_from('docs/plan/query_plan.yml')
def query_plan(*args, **kwargs):
    # params
    height = float(args[0].get('height'))
    weight = float(args[0].get('weight'))
    age = int(args[0].get('age'))
    # male 1, female 2
    gender = True if args[0].get('gender') == '1' else False
    plan_type = int(args[0].get('plan'))
    duration = int(args[0].get('duration'))
    goal_weight = weight if plan_type == 2 or plan_type == 3 else float(args[0].get('goal_weight'))
    physical_activity_level = float(args[0].get('pal'))

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
@echoErr
@attributes_receiver(
    required=["uid", "token", "age", "gender", "weight", "goalWeight", "height", "calories", "maintCalories", "type",
              "duration", "pal"])
@require_login
@swag_from('docs/plan/set_plan.yml')
def set_plan(*args, **kwargs):
    # params
    uid = args[0].get('uid')

    age = int(args[0].get('age'))
    gender = int(args[0].get('gender'))
    weight = float(args[0].get('weight'))
    goal_weight = float(args[0].get('goalWeight'))
    height = float(args[0].get('height'))
    calories = int(args[0].get('calories'))
    maintCalories = int(args[0].get('maintCalories'))
    plan_type = int(args[0].get('type'))
    duration = int(args[0].get('duration'))
    pal = float(args[0].get('pal'))

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
        begin=time, end=get_future_time(now=time, days=duration) if duration != 0 else -1,
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
@echoErr
@attributes_receiver(required=["uid", "token", "weight", "pid"])
@require_login
@swag_from('docs/plan/finish_plan.yml')
def finish_plan(*args, **kwargs):
    weight = args[0].get('weight')
    pid = args[0].get('pid')
    uid = args[0].get('uid')
    u = User.getUserByID(uid)
    # no more search by uid. completely eliminate unfinished plan.
    p = Plan.getPlanByID(pid)
    if p:
        if not p.completed:
            p.finish(weight=weight)
            u.weight = weight
            u.add()
            return reply_json(1)
        else:
            return reply_json(-2, msg='Already finished')
    else:
        return reply_json(-6)


@plan.route('get_current_plan', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token"])
@require_login
@swag_from('docs/plan/get_current_plan.yml')
def get_current_plan(*args, **kwargs):
    uid = args[0].get('uid')
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
@echoErr
@attributes_receiver(required=["uid", "pid", "token"])
@require_login
@swag_from('docs/plan/get_plan.yml')
def get_plan(*args, **kwargs):
    pid = args[0].get('pid')
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
@echoErr
@attributes_receiver(required=["token", "uid"], optional=["weight", "height", "pal"])
@require_login
@swag_from('docs/plan/update_body_info.yml')
def update_body_info(*args, **kwargs):
    FLAG = False
    FLAG_EXT = 0
    uid = args[0].get('uid')
    height = float(args[0].get('height')) if args[0].get('height') is not None else None
    weight = float(args[0].get('weight')) if args[0].get('weight') is not None else None
    pal = None if 'pal' not in request.form.keys() else args[0].get('pal')  # physical activity level

    u = User.getUserByID(uid)
    if u is None:
        return reply_json(-1)

    u.height = height if height else u.height
    u.weight = weight if weight else u.weight
    u.add()
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
            # check if already reached the target weight
            if weight <= p.goalWeight:
                p.finish(weight=u.weight)
                return reply_json(1)

            # 24 attempts to find a realizable diet plan, or plan would be failed.
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
                FLAG_EXT = estimateExt(u=u, goalWeight=p.goalWeight, pal=pal, remain=remain)

            if not FLAG:
                calories = result.get('goalCal')
                maintCalories = result.get('maintainCal')

                newPlanDetail = PlanDetail(
                    uid=uid,
                    pid=p.id,
                    weight=u.weight,
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
            # if -2, means the weight gained too much... Should change the plan instead
            if result == 'unachievable' or result.get('low'):
                return reply_json(-2)
            calories = result.get('goalCal')
            newPlanDetail = PlanDetail(
                uid=uid,
                pid=p.id,
                weight=u.weight,
                caloriesL=round(calories * 0.95) if round(calories * 0.95) >= 1000 else 1000,
                caloriesH=round(calories * 1.05),
                proteinL=calories / 7.7 * 0.22,
                proteinH=calories / 7.7 * 0.32,
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
                uid=uid,
                pid=p.id,
                weight=u.weight,
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

        if not FLAG:
            return reply_json(1, data=planData)
        else:
            return reply_json(-2, data={'hasRecommendation': True if FLAG_EXT else False, 'recommend_ext': FLAG_EXT})
    else:
        return reply_json(-6)


@plan.route('get_weight_trend', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "begin", "end"])
@require_login
@swag_from('docs/plan/get_weight_trend.yml')
def get_weight_trend(*args, **kwargs):
    uid = args[0].get('uid')
    begin = args[0].get('begin')
    end = args[0].get('end')

    trend = PlanDetail.getWeightTrendInPeriod(uid=uid, begin=begin, end=end)
    return reply_json(1, data={'trend': trend})


@plan.route('get_plan_weight_trend', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "pid"])
@require_login
@swag_from('docs/plan/get_plan_weight_trend.yml')
def get_plan_weight_trend(*args, **kwargs):
    pid = args[0].get('pid')
    trend = PlanDetail.getWeightTrendInPlan(pid)
    return reply_json(1, data={'trend': trend})


@plan.route('extend_update_plan', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "pid", "days"])
@require_login
@swag_from('docs/plan/extend_update_plan.yml')
def extendAndUpdatePlan(*args, **kwargs):
    # only called by type 1 for fixing the end date
    uid = args[0].get('uid')
    pid = args[0].get('pid')
    days = args[0].get('days')
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
@echoErr
@attributes_receiver(required=["uid", "pid", "days", "token"])
@require_login
@swag_from('docs/plan/extend_plan.yml')
def extendPlan(*args, **kwargs):
    pid = args[0].get('pid')
    days = args[0].get('days')
    return reply_json(1, data={'ext': PlanDetail.getLatest(pid).extend(ext=days).ext})


@plan.route('should_update_weight', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "pid"])
@require_login
@swag_from('docs/plan/should_update_weight.yml')
def shouldUpdateWeight(*args, **kwargs):
    pid = args[0].get('pid')
    subPlan = PlanDetail.getLatest(pid)
    if get_time_gap(subPlan.time) > 3600 * 24 * 7:
        return reply_json(1, data={'shouldUpdate': True})
    else:
        return reply_json(1, data={'shouldUpdate': False})


@plan.route('get_past_plans', methods=['POST'])
@echoErr
@attributes_receiver(required=["token", "uid", "begin", "end"])
@require_login
@swag_from('docs/plan/get_past_plans.yml')
def getPastPlans(*args, **kwargs):
    uid = args[0].get('uid')
    begin = args[0].get('begin')
    end = args[0].get('end')
    dataMap = {}
    for result in PlanDetail.getPastRecords(begin=begin, end=end, uid=uid):
        if result.pid not in dataMap.keys():
            # from db
            p = Plan.getPlanByID(result.pid)
            dcs = DailyConsumption.getRecordsByPID(result.pid)

            # processing data
            consumptionRecords = {
                'accumCalories': 0,
                'accumProtein': 0,
                'avgCalories': 0,
                'avgProtein': 0,
                'calsHigh': {
                    'days': 0,
                    'details': [],
                },
                'calsLow': {
                    'days': 0,
                    'details': [],
                },
                'proteinHigh': {
                    'days': 0,
                    'details': [],
                },
                'proteinLow': {
                    'days': 0,
                    'details': [],
                },
                # 'detailedRecords': []
            }
            counter = 0
            for dc in dcs:
                # for avg
                counter += 1
                # accumulated
                consumptionRecords['accumCalories'] += dc.calories * dc.weight / 100 if dc.calories is not None else 0
                consumptionRecords['accumProtein'] += dc.protein * dc.weight / 100 if dc.protein is not None else 0
                # calculate low and high

                # detailed
                detail = dc.toDict()
                detail.pop('img')
                # consumptionRecords['detailedRecords'].append(detail)

            if counter > 0:
                timegap = get_current_time() - p.begin
                days = timegap/3600/24 + 1 if timegap % (3600*24) else timegap/3600/24
                consumptionRecords['avgCalories'] = consumptionRecords['accumCalories'] / days
                consumptionRecords['avgProtein'] = consumptionRecords['accumProtein'] / days

            dataMap[result.pid] = {
                'planBrief': p.toDict(),
                'weeklyDetails': [],
                'exts': 0,
                'consumption': consumptionRecords
            }
        resdict = result.toDict()
        resdict["foodsConsumed"] = result.getCorrespondingConsumptionsRecords()
        dataMap[result.pid]['weeklyDetails'].append(resdict)

        if result.ext != dataMap[result.pid]['weeklyDetails'][-1]['ext']:
            dataMap[result.pid]['exts'] += 1

    return reply_json(1, data=list(dataMap.values()))


@plan.route('estimate_extension', methods=['POST'])
@echoErr
@attributes_receiver(required=["token", "uid", "pid"])
@require_login
@swag_from('docs/plan/estimate_extension.yml')
def estimateExtension(*args, **kwargs):
    uid = args[0].get('uid')
    pid = args[0].get('pid')

    u = User.getUserByID(uid)
    p = Plan.getPlanByID(pid)
    sp = PlanDetail.getLatest(p.id)
    res = estimateExt(u=u, pal=sp.activityLevel, remain=0, goalWeight=p.goalWeight)
    if res:
        return reply_json(1, data={'ext': res})
    else:
        return reply_json(-2)

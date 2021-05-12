import cv2
import random
from PIL import Image
from flask import Blueprint, request
from flasgger import swag_from

from cv.detect import detect as food_detect
from db.Plan import Plan
from db.DailyConsumption import DailyConsumption
from db.Food import Food
from db.User import User
from util.Common.img import base64_to_image, fix_flutter_img_rotation_issue, crop_image_by_coords_2, img_to_b64
from util.Common.func import reply_json, get_relative_days, get_current_time, attributes_receiver, echoErr
from util.Common.user import require_login

food = Blueprint(name='food', import_name=__name__)


@food.route('detect', methods=['POST'])
@echoErr
@attributes_receiver(required=['food_b64', 'rotation'])
@swag_from('docs/food/detect.yml')
def detect(*args, **kwargs):
    b64String = args[0].get('food_b64')
    img = base64_to_image(b64String)
    rotation = int(args[0].get('rotation'))

    # fix flutter camera :/
    img = fix_flutter_img_rotation_issue(img, rotation)

    # detect
    res = food_detect(img, False)
    if res is None:
        return reply_json(-6)
    import math
    res_dict = []
    for fr in res:
        #  search in db
        f = Food.getByExactName(fr[5])
        f_db = {}
        if f:
            f_db = f.toDict()


        # crop image based on results
        food_image = crop_image_by_coords_2(img, int(fr[0]), int(fr[1]), int(fr[2]), int(fr[3]))

        # image = Image.fromarray(cv2.cvtColor(food_image, cv2.COLOR_BGR2RGB))
        # image.show()

        # to b64
        b64_fimg = img_to_b64(food_image)
        import random
        res_dict.append({
            'basic': {'img': b64_fimg, 'name': fr[5]},
            'info': f_db
        })

    return reply_json(1, data=res_dict)


@food.route('search', methods=['GET'])
@echoErr
@attributes_receiver(required=["name"])
@swag_from('docs/food/search.yml')
def search(*args, **kwargs):
    name: str = args[0].get("name").strip()
    nameArr = name.split(' ')
    nameArr.insert(0, name)
    resMap = {}
    for n in nameArr:
        if n == '':
            continue
        else:
            res = Food.search(n)
            for r in res:
                resMap[r.name] = r.toDict()
    return reply_json(1, data=resMap)


@food.route('food_info', methods=['GET'])
@echoErr
@attributes_receiver(required=["fid"])
@swag_from('docs/food/food_info.yml')
def getFoodInfo(*args, **kwargs):
    fid = request.values.get('fid')
    f = Food.getById(fid)
    if f:
        return reply_json(1, data=f.toDict())
    else:
        return reply_json(-6)


@food.route('consume_foods', methods=['POST'])
@echoErr
@attributes_receiver(required=['uid', 'token', 'pid', 'type', 'foods_info'])
@require_login
@swag_from('docs/food/consume_foods.yml')
def consume_foods(*args, **kwargs):
    uid = args[0].get('uid')
    pid = args[0].get('pid')
    # 1 = breakfast, 2 = lunch, 3 = dinner
    type = args[0].get('type')
    # a list that contains all the food and its corresponding info including proteins, calories, names.
    foods_info = args[0].get('foods_info')
    # TODO need check the food_info's type
    p = Plan.getPlanByID(pid)
    if foods_info is None:
        return reply_json(-2)
    import json
    foods_info = json.loads(foods_info)
    time = get_current_time()
    day = get_relative_days(p.begin, get_current_time()) + 1
    for food_info in foods_info:
        f = DailyConsumption(
            uid=uid, pid=pid, type=type, day=day,
            name=food_info['name'],
            img=food_info['picture'],
            fid=food_info['id'],
            calories=food_info['calories'],
            protein=food_info['protein'],
            weight=food_info['weight'],
            time=time
        )
        f.add()
    return reply_json(1, data={'stmp': time})


@food.route('get_consume_history', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "begin", "end"])
@require_login
@swag_from('docs/food/get_consume_history.yml')
def getConsumeHistory(*args, **kwargs):
    begin = args[0].get('begin')
    end = args[0].get('end')
    uid = args[0].get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.get_periodic_record(begin=begin, end=end, uid=uid)
    )


@food.route('get_daily_consumption', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "begin", "end"])
@require_login
@swag_from('docs/food/get_daily_consumption.yml')
def getDailyConsumption(*args, **kwargs):
    begin = args[0].get('begin')
    end = args[0].get('end')
    uid = args[0].get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.getConsumptionGroupByType(begin=begin, end=end, uid=uid)
    )


@food.route('accumulated_calories_intake', methods=['POST'])
@echoErr
@attributes_receiver(required=["begin", "end", "uid", "token"])
@require_login
@swag_from('docs/food/accumulated_calories_intake.yml')
def getAccumulatedCaloriesIntake(*args, **kwargs):
    begin = args[0].get('begin')
    end = args[0].get('end')
    uid = args[0].get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.getAccumulatedCaloriesIntake(begin=begin, end=end, uid=uid)
    )


@food.route('listed_calories_intake', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "begin", "end"])
@require_login
@swag_from('docs/food/listed_calories_intake.yml')
def listedCaloriesIntake(*args, **kwargs):
    begin = args[0].get('begin')
    end = args[0].get('end')
    uid = args[0].get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.getListedCaloriesIntake(begin=begin, end=end, uid=uid)
    )


@food.route('recmd_food_in_search', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "fid", "pid"])
@require_login
@swag_from('docs/food/recmd_food_in_search.yml')
def recmdFoodInSearch(*args, **kwargs):
    plan = Plan.getPlanByID(args[0].get("pid"))
    food = Food.getById(args[0].get("fid"))
    planType = plan.type
    data = {
        "suitable": food.isSuitable(planType),
        "recmdFoods": []
    }
    foods = None
    if planType == 1:
        foods = Food.getFoodsRestricted(category=food.category, protein=0.2, fat=0.25, ch=0.5)
    elif planType == 3:
        foods = Food.getFoodsRestricted(category=food.category, protein=0.3, fat=0.6, ch=0.1)
    elif planType == 2:
        foods = food.getKNN(k=10)

    foodsList = []
    for f in foods:
        foodsList.append(f.toDict())
    listLen = len(foodsList)

    while listLen > 10:
        f = foodsList[random.randint(0, listLen - 1)]
        foodsList.remove(f)
        listLen -= 1

    data["recmdFoods"] = foodsList

    return reply_json(1, data=data)


@food.route('recmd_food', methods=['POST'])
@echoErr
@attributes_receiver(required=["uid", "token", "pid", "mealType"])
@require_login
@swag_from('docs/food/recmd_food.yml')
def recmdFood(*args, **kwargs):
    plan = Plan.getPlanByID(args[0].get("pid"))
    planType = plan.type

    def setToDict(set):
        tmpDict = {}
        for s in set:
            if s is None:
                continue
            if s.category not in tmpDict:
                tmpDict[s.category] = []
            tmpDict[s.category].append(s.toDict())
        return tmpDict

    recentConsumed = DailyConsumption.getRecentConsumedSuitableFood(pid=plan.id, mealType=args[0].get("mealType"))
    randFoodSet = Food.randSuitableFood(planType)

    similarSet = []
    for f in recentConsumed.values():
        food = f.getKNN(1, matchCate=True)[0]
        similarSet.append(food)

    data = {
        "recentConsumed": setToDict(recentConsumed.values()),
        "randFoods": setToDict(randFoodSet),
        "similarRecmd": setToDict(similarSet)
    }

    return reply_json(1, data=data)

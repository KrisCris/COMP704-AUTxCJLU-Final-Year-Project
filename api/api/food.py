import cv2
from PIL import Image
from flask import Blueprint, request
from flasgger import swag_from

from cv.detect import detect as food_detect
from db import Plan, DailyConsumption
from db.Food import Food
from util.img import base64_to_image, fix_flutter_img_rotation_issue, crop_image_by_coords_2, img_to_b64
from util.func import reply_json, get_relative_days, get_current_time
from util.user import require_login

food = Blueprint(name='food', import_name=__name__)


@food.route('detect', methods=['POST'])
def detect():
    img = base64_to_image(request.form.get('food_b64'))
    rotation = int(request.form.get('rotation'))

    # fuck flutter camera :/
    img = fix_flutter_img_rotation_issue(img, rotation)

    # detect
    res = food_detect(img, False)
    if res is None:
        return reply_json(-6)
    import math
    res_dict = []
    for fr in res:
        #  search in db
        f = Food.searchByName(fr[5])
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
def search():
    pass


@food.route('food_info', methods=['GET'])
def getFoodInfo():
    fid = request.values.get('fid')
    f = Food.getById(fid)
    if f:
        return reply_json(1, data=f.toDict())
    else:
        return reply_json(-6)


@food.route('consume_foods', methods=['POST'])
@require_login
def consume_foods():
    uid = request.form.get('uid')
    pid = request.form.get('pid')
    # 1 = breakfast, 2 = lunch, 3 = dinner
    type = request.form.get('type')
    # a list that contains all the food and its corresponding info including proteins, calories, names.
    foods_info = request.form.get('foods_info')
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
@require_login
def getConsumeHistory():
    begin = request.form.get('begin')
    end = request.form.get('end')
    uid = request.form.get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.get_periodic_record(begin=begin, end=end, uid=uid)
    )


@food.route('get_daily_consumption', methods=['POST'])
@require_login
def getDailyConsumption():
    begin = request.form.get('begin')
    end = request.form.get('end')
    uid = request.form.get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.getConsumptionGroupByType(begin=begin, end=end, uid=uid)
    )


@food.route('accumulated_calories_intake', methods=['POST'])
@require_login
def getAccumulatedCaloriesIntake():
    begin = request.form.get('begin')
    end = request.form.get('end')
    uid = request.form.get('uid')
    return reply_json(
        code=1,
        data=DailyConsumption.getPeriodicCaloriesIntake(begin=begin, end=end, uid=uid)
    )

@food.route('')

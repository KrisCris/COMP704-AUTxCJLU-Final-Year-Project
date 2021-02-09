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
            f_db['id'] = f.id
            f_db['name'] = f.name
            f_db['category'] = f.category
            f_db['img'] = f.image
            f_db['calories'] = f.calories
            f_db['fat'] = f.fat
            f_db['carbohydrate'] = f.carbohydrate
            f_db['protein'] = f.protein
            f_db['cholesterol'] = f.cholesterol
            f_db['cellulose'] = f.cellulose

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


@food.route('consume_foods', methods=['POST'])
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


@food.route('get_consume_history')
@require_login
def get_consume_history():
    pass


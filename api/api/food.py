from cv.detect import detect as food_detect
from flask import Blueprint, request
from flasgger import swag_from

food = Blueprint('food', __name__)


@food.route('detect', methods=['POST'])
def detect():
    b64 = request.form.get('food_b64')
    res = food_detect(b64)
    res_dict = []
    for fr in res:
        # TODO search in db
        res_dict.append({
            'basic': {'x': fr[0], 'y': fr[1], 'w': fr[2], 'h': fr[3], 'prob': fr[4], 'name': fr[5]},
            'info': {'calories': 0, 'protain':0, 'va': 0, 'vb':0, 'vc':0}
        })
    from util.func import reply_json
    return reply_json(1, data=res_dict)

from cv.detect import detect as food_detect
from flask import Blueprint, request
from flasgger import swag_from

food = Blueprint('food', __name__)


@food.route('detect', methods=['POST'])
def detect():
    import base64
    img_data = base64.b64decode(request.form.get('food_b64'))
    with open('cv/inference/images/image.jpg', 'wb') as f:
        f.write(img_data)
    res = food_detect()
    print(res)
    from util.func import reply_json
    return reply_json(1,data={'result':res})
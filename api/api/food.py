import cv2
from PIL import Image
from flask import Blueprint, request
from flasgger import swag_from

from cv.detect import detect as food_detect
from util.img import base64_to_image, fix_flutter_img_rotation_issue, crop_image_by_coords_2, img_to_b64
from util.func import reply_json

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

    res_dict = []
    for fr in res:
        # TODO search in db

        # crop image based on results
        food_image = crop_image_by_coords_2(img, int(fr[0]), int(fr[1]), int(fr[2]), int(fr[3]))

        # image = Image.fromarray(cv2.cvtColor(food_image, cv2.COLOR_BGR2RGB))
        # image.show()

        # to b64
        b64_fimg = img_to_b64(food_image)

        res_dict.append({
            'basic': {'img': b64_fimg, 'name': fr[5]},
            'info': {'calories': 0, 'protain': 0, 'va': 0, 'vb': 0, 'vc': 0}
        })

    return reply_json(1, data=res_dict)


@food.route('search', methods=['GET'])
def search():
    pass

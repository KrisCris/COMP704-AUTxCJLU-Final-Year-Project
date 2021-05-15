import base64

import cv2
import numpy as np


def base64_to_image(base64_code):
    img_original = base64.b64decode(base64_code)
    img_np = np.frombuffer(img_original, dtype=np.uint8)
    img = cv2.imdecode(img_np, cv2.IMREAD_UNCHANGED)

    return img


def image_to_base64_path(path):
    mat = cv2.imread(path)
    # Mat to Base64
    string = base64.b64encode(cv2.imencode('.png', mat)[1]).decode()

    return string


def img_to_b64(img):
    retval, buffer = cv2.imencode('.jpg', img)
    b64_img = base64.b64encode(buffer).decode('ascii')
    return b64_img


def fix_flutter_img_rotation_issue(img, rotation):
    # fix flutter stupidity of long lasting bullshit locked rotation issue
    if rotation == 90:
        img2 = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
    elif rotation == -90:
        img2 = cv2.rotate(img, cv2.ROTATE_90_COUNTERCLOCKWISE)
    else:
        img2 = img
    return img2


def crop_image_by_coords_2(img, y1, x1, y2, x2):
    return img[x1:x2, y1:y2].copy()

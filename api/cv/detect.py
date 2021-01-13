import argparse
import os
import shutil
import time
from pathlib import Path

import cv2
import torch
import torch.backends.cudnn as cudnn
from numpy import random
import numpy as np
import base64

from models.experimental import attempt_load
from cv.utils.datasets import LoadStreams, LoadImages
from cv.utils.general import check_img_size, non_max_suppression, scale_coords


def base64_to_image(base64_code):
    img_original = base64.b64decode(base64_code)
    img_np = np.frombuffer(img_original, dtype=np.uint8)
    img = cv2.imdecode(img_np, cv2.IMREAD_UNCHANGED)

    return img


def img_to_base64(path):
    mat = cv2.imread(path)
    # Mat to Base64
    string = base64.b64encode(cv2.imencode('.jpeg', mat)[1]).decode()

    return string


def letterbox(img, new_shape=(640, 640), color=(114, 114, 114), auto=True, scaleFill=False, scaleup=True):
    # Resize image to a 32-pixel-multiple rectangle https://github.com/ultralytics/yolov3/issues/232
    shape = img.shape[:2]  # current shape [height, width]
    if isinstance(new_shape, int):
        new_shape = (new_shape, new_shape)

    # Scale ratio (new / old)
    r = min(new_shape[0] / shape[0], new_shape[1] / shape[1])
    if not scaleup:  # only scale down, do not scale up (for better test mAP)
        r = min(r, 1.0)

    # Compute padding
    ratio = r, r  # width, height ratios
    new_unpad = int(round(shape[1] * r)), int(round(shape[0] * r))
    dw, dh = new_shape[1] - new_unpad[0], new_shape[0] - new_unpad[1]  # wh padding
    if auto:  # minimum rectangle
        dw, dh = np.mod(dw, 32), np.mod(dh, 32)  # wh padding
    elif scaleFill:  # stretch
        dw, dh = 0.0, 0.0
        new_unpad = (new_shape[1], new_shape[0])
        ratio = new_shape[1] / shape[1], new_shape[0] / shape[0]  # width, height ratios

    dw /= 2  # divide padding into 2 sides
    dh /= 2

    if shape[::-1] != new_unpad:  # resize
        img = cv2.resize(img, new_unpad, interpolation=cv2.INTER_LINEAR)
    top, bottom = int(round(dh - 0.1)), int(round(dh + 0.1))
    left, right = int(round(dw - 0.1)), int(round(dw + 0.1))
    img = cv2.copyMakeBorder(img, top, bottom, left, right, cv2.BORDER_CONSTANT, value=color)  # add border
    return img, ratio, (dw, dh)


def _img_handle(b64, img_size):
    img0 = b64

    # Padded resize
    img = letterbox(img0, new_shape=img_size)[0]

    # Convert
    img = img[:, :, ::-1].transpose(2, 0, 1)  # BGR to RGB, to 3x416x416
    img = np.ascontiguousarray(img)

    return b64, img, img0, None


def _detect(b64):
    out, source, weights, imgsz, device, augment, conf_thres, iou_thres, agnostic_nms = \
        'cv/inference/output', b64, '../cv/weights/s_v1.pt', \
        640, 'cpu', 'store_true', 0.25, 0.45, 'store_true'

    # Initialize
    device = torch.device('cpu')
    half = device.type != 'cpu'  # half precision only supported on CUDA

    # Load model
    model = attempt_load(weights, map_location=device)  # load FP32 model
    imgsz = check_img_size(imgsz, s=model.stride.max())  # check img_size
    dataset = _img_handle(source, img_size=imgsz)

    # Get names and colors
    names = model.module.names if hasattr(model, 'module') else model.names

    # Run inference
    img = torch.zeros((1, 3, imgsz, imgsz), device=device)  # init img
    _ = model(img.half() if half else img) if device.type != 'cpu' else None  # run once
    for b64, img, im0s, vid_cap in [dataset]:
        img = torch.from_numpy(img).to(device)
        img = img.half() if half else img.float()  # uint8 to fp16/32
        img /= 255.0  # 0 - 255 to 0.0 - 1.0
        if img.ndimension() == 3:
            img = img.unsqueeze(0)

        # Inference
        pred = model(img, augment=augment)[0]

        # Apply NMS
        pred = non_max_suppression(pred, conf_thres, iou_thres, classes=None, agnostic=agnostic_nms)

        result = []
        # Process detections
        for i, det in enumerate(pred):  # detections per image
            p, s, im0 = b64, '', im0s

            s += '%gx%g ' % img.shape[2:]  # print string
            if det is not None and len(det):
                # Rescale boxes from img_size to im0 size
                det[:, :4] = scale_coords(img.shape[2:], det[:, :4], im0.shape).round()

                # Print results
                for c in det[:, -1].unique():
                    n = (det[:, -1] == c).sum()  # detections per class
                    s += '%g %ss, ' % (n, names[int(c)])  # add to string (resulation, counts, name)
            for inner in det:
                inner = list(map(lambda x: x.item(), inner))
                inner[-1] = names[int(inner[-1])]
                result.append(inner)
        # print(result)
        return result


def detect(b64):
    with torch.no_grad():
        out = _detect(b64)
        print(out)


if __name__ == '__main__':
    path = 'cv/inference/images/3.jpeg'
    img64 = img_to_base64(path)
    img = base64_to_image(img64)
    # cv2.imwrite('test111.png', img)
    detect(img)

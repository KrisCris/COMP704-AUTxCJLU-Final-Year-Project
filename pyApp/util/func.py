from flask import request, jsonify, redirect

from util.constants import REPLY_CODES


def reply_json(code, data=None):
    if data is None:
        data = []
    if code in REPLY_CODES:
        return jsonify({
            'code': code,
            'msg': REPLY_CODES[code],
            'data': data
        })
    return jsonify({
        'code': -1,
        'msg': ''
    })


def sendEmail(user_mail:str, content:str):
    pass

import time
import datetime

from flask import request, jsonify

from util.constants import REPLY_CODES, DEBUG


def reply_json(code, msg=None, data=None):
    if data is None:
        data = []
    if code in REPLY_CODES:
        return jsonify({
            'code': code,
            'msg': REPLY_CODES[code] if msg is None else msg,
            'data': data
        })
    return jsonify({
        'code': 800,
        'msg': 'Unknown code',
        'data': data
    })


def get_current_time():
    return int(time.time())


def get_time_gap(old):
    return int(time.time()) - old


def get_future_time(days):
    return int(time.time()+3600*24*days)


def get_relative_days(base_day, day):
    t1 = time.localtime(base_day)
    t2 = time.localtime(day)
    d1 = datetime.datetime(t1.tm_year,t1.tm_mon, t1.tm_mday)
    d2 = datetime.datetime(t2.tm_year,t2.tm_mon, t2.tm_mday)
    interval = d2 - d1
    return interval.days

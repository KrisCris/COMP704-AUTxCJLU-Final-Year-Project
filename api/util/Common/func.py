import time
import datetime
import functools

from flask import jsonify

from util.Common.constants import REPLY_CODES


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


def get_future_time(now, days):
    return int((time.time() if now is None else now) + 3600 * 24 * days)


def get_relative_days(base_day, day):
    t1 = time.localtime(base_day)
    t2 = time.localtime(day)
    d1 = datetime.datetime(t1.tm_year, t1.tm_mon, t1.tm_mday)
    d2 = datetime.datetime(t2.tm_year, t2.tm_mon, t2.tm_mday)
    interval = d2 - d1
    return interval.days


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def echoErr(func):
    @functools.wraps(func)  # 修饰内层函数，防止当前装饰器去修改被装饰函数__name__的属性
    def inner(*args, **kwargs):
        def getInfo(f):
            idx = f.__code__.co_filename.find("api/") + 4
            func_info = f"{bcolors.OKGREEN}{f.__name__}{bcolors.ENDC} {bcolors.WARNING}@{bcolors.ENDC} {bcolors.OKGREEN}{f.__code__.co_filename[idx:]}"
            return func_info

        try:
            r = func(*args, **kwargs)
        except Exception as e:
            print(f"{bcolors.OKGREEN}[Debug]{bcolors.ENDC} {bcolors.WARNING}[{bcolors.ENDC}{getInfo(func)}{bcolors.ENDC}{bcolors.WARNING}]{bcolors.ENDC}: {bcolors.OKBLUE}{e}{bcolors.ENDC}")
            return reply_json(500, data=str(e))
        else:
            r.json.get("code") != 1
            print(f"{bcolors.OKGREEN}[Debug]{bcolors.ENDC} {bcolors.WARNING}[{bcolors.ENDC}{getInfo(func)}{bcolors.ENDC}{bcolors.WARNING}]{bcolors.ENDC}: {bcolors.OKBLUE}{str(r.json)}{bcolors.ENDC}")
            return r

    return inner


def attributes_receiver(required: list, optional: list = []):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            from flask import request
            attr_map = {}
            missing = []
            if request.method == 'POST':
                source = request.form
            else:
                source = request.values

            for attr in required:
                val = source.get(attr)
                if val is None:
                    missing.append(attr)
                else:
                    attr_map[attr] = val
            if len(missing) > 0:
                return reply_json(403, msg="Missing at least the following attribute(s): " + str(missing), data=None)
            for attr in optional:
                val = source.get(attr)
                if val is not None:
                    attr_map[attr] = val
            return func(attr_map)

        return wrapper

    return decorator

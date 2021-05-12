from db.User import User


def estimateExt(u: User, pal, remain, goalWeight):
    EXT = -1
    day = 7
    accumDay = 7
    lastAvaDay = -1
    for i in range(0, 24):
        from util.Planner.CalsPlanner import calc_calories
        result = calc_calories(
            age=u.age,
            height=u.height,
            weight=u.weight,
            pal=pal,
            time=remain + accumDay,
            goalWeight=goalWeight,
            gender=True if u.gender == 1 else False,
            type=1
        )
        # find the shortest ext
        if result == 'unachievable' or result.get('low'):
            if lastAvaDay > 0:
                EXT = lastAvaDay
                break
            day *= 2
            accumDay += day
        else:
            lastAvaDay = accumDay
            accumDay = accumDay - (day / 2 if day >= 14 else day)

    return EXT

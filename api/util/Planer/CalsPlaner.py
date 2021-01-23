# type = 1, 2, 3., i.e. shed weight, maintain, build muscle
def calc_calories(age, height, weight, pal, time, goalWeight, gender, type):
    from util.Planer.BodyModel import BodyModel
    from util.Planer.Intervention import Intervention
    from util.Planer.Baseline import Baseline

    baseline = Baseline(isMale=gender, age=age, height=height, weight=weight, pal=pal*1.05 if type == 3 else pal, bfp=True, rmr=False)
    maintainCal = round(baseline.getMaintCals())

    # calculate target weight bmi
    bmi = baseline.getNewBMI(newWeight=goalWeight if type == 1 else weight)
    if bmi > 25:
        bmi_flag = 1
    elif bmi < 18.5:
        bmi_flag = -1
    else:
        bmi_flag = 0

    # calculate shedding weight calories intake
    if type == 1:
        if goalWeight != weight:
            try:
                goalItv = Intervention.forgoal(baseline, goalWeight, time, 0, 0, 0.001)
                goalCal = round(goalItv.calories)
                goalModel = BodyModel.projectFromBaselineViaIntervention(baseline, goalItv, int(time) + 1)
                goalMaintainCal = round(goalModel.cals4balance(baseline, goalItv.getAct(baseline)))
            except Exception as e:
                return 'unachievable'
        else:
            goalCal = maintainCal
            goalMaintainCal = maintainCal

        low_eng_warn = False if goalCal >= 1000 else True

        return {
            'goalCal': goalCal, 'completedCal': goalMaintainCal, 'maintainCal': maintainCal,
            'low': low_eng_warn, 'bmi': bmi_flag
        }

    elif type == 2 or type == 3:
        return {
            'goalCal': maintainCal, 'completedCal': maintainCal, 'maintainCal': maintainCal,
            'low': False, 'bmi': bmi_flag
        }

    else:
        return 'wrong type'


if __name__ == '__main__':
    result = calc_calories(age=22, height=170, weight=70, pal=1.4, time=30, goalWeight=65, gender=True, type=1)
    print(result)
    # baseline = Baseline(male, age, height, weight, physicalActivityLevel, True, False)
    # goalIntervention = Intervention()
    # goalMaintenanceIntervention = goalIntervention
    #
    # if math.fabs(goalWeight - baseline.weight) < 0.02:
    #     goalWeight = baseline.weight
    #
    # unachievableGoal = False
    # try:
    #     goalIntervention = Intervention.forgoal(baseline, goalWeight, int(goalTime), 0, 0, 0.001)
    # except Exception:
    #     unachievableGoal = True
    #
    # ca = None
    # goalCalsField = None
    # goalMaintCals = None
    # goalbc = None
    # weightAtGoal = None
    # goalMaintCals = None
    # if goalIntervention:
    #     ca = goalIntervention.calories[0] if isinstance(goalIntervention.calories, tuple) else goalIntervention.calories
    #     goalCalsField = round(ca)
    #     goalMaintCals = goalCalsField
    #     goalbc = BodyModel.projectFromBaselineViaIntervention(baseline, goalIntervention, int(goalTime) + 1)
    #     weightAtGoal = baseline.getNewWeightFromBodyModel(goalbc)
    #     bfpAtGoal = goalbc.getFatPercent(baseline)
    #
    # if goalWeight == baseline.weight and goalMaintenanceIntervention.actchangepercent == 0:
    #     goalMaintCals = round(baseline.getMaintCals())
    # else:
    #     goalMaintCals = round(goalbc.cals4balance(baseline, goalMaintenanceIntervention.getAct(baseline)))
    #
    # print(goalCalsField if goalCalsField else "")
    # print(unachievableGoal)
    # print(goalMaintCals)

import math

from util.Planer.BodyModel import BodyModel
from util.Planer.Intervention import Intervention
from util.Planer.Baseline import Baseline


def calc_calories(age, height, weight, pal, time, goalWeight, gender):
    flag = False
    baseline = Baseline(gender, age, height, weight, pal, True, False)
    goalCal = None
    goalMaintainCal = None
    maintainCal = None
    if goalWeight != weight:
        try:
            goalItv = Intervention.forgoal(baseline, goalWeight, time, 0, 0, 0.001)
            goalCal = goalItv.calories
            goalModel = BodyModel.projectFromBaselineViaIntervention(baseline, goalItv, int(time) + 1)
            goalMaintainCal = goalModel.cals4balance(baseline, goalItv.getAct(baseline))
        except Exception as e:
            flag = True
    if flag:
        print('unachievable!')
        return
    maintainCal = round(baseline.getMaintCals())
    print('goal: ' + str(goalCal) if goalCal else None)
    print('maintain: ' + str(maintainCal))
    print('goalMaintainCal: ' + str(goalMaintainCal) if goalMaintainCal else None)


if __name__ == '__main__':

    age = 22
    height = 170
    weight = 70
    physicalActivityLevel = 1.6
    goalTime = 60
    goalWeight = 70
    male = True

    calc_calories(age, height, weight, physicalActivityLevel, goalTime, goalWeight, male)
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

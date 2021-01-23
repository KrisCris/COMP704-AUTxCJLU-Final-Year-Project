import math

from util.Planer.BodyModel import BodyModel
from util.Planer.Intervention import Intervention
from util.Planer.Baseline import Baseline

if __name__ == '__main__':
    ENERGYUNITS = 1

    age = 22
    height = 170
    weight = 70
    physicalActivityLevel = 1.6
    goalTime = 60
    goalWeight = 60
    male = True

    baseline = Baseline(male, age, height, weight, physicalActivityLevel, True, False)
    goalIntervention = Intervention()
    goalMaintenanceIntervention = goalIntervention

    if math.fabs(goalWeight - baseline.weight) < 0.02:
        goalWeight = baseline.weight

    unachievableGoal = False
    try:
        goalIntervention = Intervention.forgoal(baseline, goalWeight, int(goalTime), 0, 0, 0.001)
    except Exception:
        unachievableGoal = True
        # print(Exception.with_traceback())

    ca = goalIntervention.calories[0] if isinstance(goalIntervention.calories, tuple) else goalIntervention.calories
    goalCalsField = round(ca * ENERGYUNITS)
    goalMaintCals = goalCalsField


    goalbc = BodyModel.projectFromBaselineViaIntervention(baseline, goalIntervention, int(goalTime) + 1)
    weightAtGoal = baseline.getNewWeightFromBodyModel(goalbc)
    bfpAtGoal = goalbc.getFatPercent(baseline)

    if goalWeight == baseline.weight and goalMaintenanceIntervention.actchangepercent == 0:
        goalMaintCals = round(baseline.getMaintCals())
    else:
        goalMaintCals = round(goalbc.cals4balance(baseline, goalMaintenanceIntervention.getAct(baseline)))

    print(goalCalsField)
    print(unachievableGoal)
    print(goalMaintCals)

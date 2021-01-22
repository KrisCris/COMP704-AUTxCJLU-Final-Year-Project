import math

from util.Planer.BodyModel import BodyModel
from util.Planer.Intervention import Intervention
from util.Planer.Baseline import Baseline

if __name__ == '__main__':
    ENERGYUNITS = 1

    age = 25
    height = 170
    weight = 100
    physicalActivityLevel = 1.5
    goalTime = 360
    goalWeight = 70
    male = True

    baseline = Baseline(male, age, height, weight, physicalActivityLevel, True, False)
    goalIntervention = Intervention(None, None, None, None, None)
    goalMaintenanceIntervention = goalIntervention

    if math.fabs(goalWeight - baseline.weight) < 0.02:
        goalWeight = baseline.weight

    unachievableGoal = False
    try:
        goalIntervention = Intervention.forgoal(baseline, goalWeight, int(goalTime), 0, 0, 0.001)
    except Exception:
        unachievableGoal = True
        print(Exception)

    ca = goalIntervention.calories[0] if isinstance(goalIntervention.calories, tuple) else goalIntervention.calories
    goalCalsField = int(ca * ENERGYUNITS)
    goalMaintCals = goalCalsField

    bm = BodyModel(None, None, None, None, None)
    goalbc = bm.projectFromBaselineViaIntervention(baseline, goalIntervention, int(goalTime) + 1)
    weightAtGoal = baseline.getNewWeightFromBodyModel(goalbc)
    bfpAtGoal = goalbc.getFatPercent(baseline)

    if goalWeight == baseline.weight and goalMaintenanceIntervention.actchangepercent == 0:
        goalMaintCals = int(baseline.getMaintCals())
    else:
        goalMaintCals = int(goalbc.cals4balance(baseline, goalMaintenanceIntervention.getAct(baseline)))

    print(goalCalsField)
    print(unachievableGoal)
    print(goalMaintCals)

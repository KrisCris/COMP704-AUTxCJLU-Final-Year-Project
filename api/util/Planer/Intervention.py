import math

from util.Planer.BodyModel import BodyModel

MIN_CALORIES = 0.0,
INITIAL_CALORIES = 2200.0,
MIN_CARB_INTAKE_PCT = 0.0,
MAX_CARB_INTAKE_PCT = 100.0,
INITIAL_CARB_INTAKE_PCT = 50.0,
INITIAL_PAL = 1.6,
MIN_SODIUM = 0.0,
MAX_SODIUM = 50000.0,
INITIAL_SODIUM = 4000.0,
MIN_ACTIVITY_CHG_PCT = -100.0,
INITIAL_ACTIVITY_CHG_PCT = 0.0


class Intervention(object):
    def __init__(self, day=100, calories=INITIAL_CALORIES, carbinpercent=INITIAL_CARB_INTAKE_PCT, actchangepercent=INITIAL_ACTIVITY_CHG_PCT, sodium=INITIAL_SODIUM):
        self.calories = calories if calories and calories >= MIN_CALORIES else INITIAL_CALORIES
        self.carbinpercent = carbinpercent if carbinpercent and MAX_CARB_INTAKE_PCT >= carbinpercent >= MIN_CARB_INTAKE_PCT else INITIAL_CARB_INTAKE_PCT
        self.PAL = INITIAL_PAL
        self.sodium = sodium if sodium and MAX_SODIUM >= sodium >= MIN_SODIUM else INITIAL_SODIUM
        self.on = True
        self.rampon = False
        self.actchangepercent = actchangepercent if actchangepercent and actchangepercent >= MIN_ACTIVITY_CHG_PCT else INITIAL_ACTIVITY_CHG_PCT
        self.day = day or 100
        self.title = ''
        self.isdetailed = False

    @staticmethod
    def forgoal(baseline, goalwt, goaltime, actchangepercent, mincals, eps):
        logMessage = ''
        holdcals = 0.0

        goalinter = Intervention()
        goalinter.title = 'Goal Intervention'
        goalinter.day = 1
        goalinter.calories = mincals
        goalinter.actchangepercent = actchangepercent
        goalinter.carbinpercent = baseline.carbIntakePct
        goalinter.setproportionalsodium(baseline)
        if (baseline.weight == goalwt) and (actchangepercent == 0):
            goalinter.calories = baseline.getMaintCals()
            goalinter.setproportionalsodium(baseline)
        else:
            starvtest = BodyModel.projectFromBaselineViaIntervention(baseline, goalinter, goaltime)

            starvwt = starvtest.getWeight(baseline)
            starvwt = 0 if starvwt < 0 else starvwt
            error = math.fabs(starvwt - goalwt)

            if error < eps or goalwt <= starvwt:
                # logMessage = 'PROBLEM in calsforgoal'
                # + '    error is ' + error
                # + '    starvwt is' + starvwt
                # + '    starv[0] is' + starvtest.fat
                # + '    starv[1] is' + starvtest.lean
                # + '    starv[2] is' + starvtest.decw
                # + '    goalwt is' + goalwt
                # + '    mincals is ' + mincals
                # + '    goalwt is ' + goalwt
                # + '    goaltime is ' + goaltime
                # + '    eps is ' + eps

                goalinter.calories = 0.0
                raise Exception('Unachievable Goal')

            checkcals = mincals
            calstep = 200.0

            i = 0
            PCXerror = 0
            tmp = True
            while tmp:
                i += 1
                holdcals = checkcals
                checkcals += calstep

                goalinter.calories = checkcals
                goalinter.setproportionalsodium(baseline)

                testbc = BodyModel.projectFromBaselineViaIntervention(baseline, goalinter, goaltime)
                testwt = testbc.getWeight(baseline)

                if testwt < 0.0:
                    PCXerror += 1
                    print("NEGATIVE testwt " + PCXerror)
                    if PCXerror > 10:
                        raise Exception('Unachievable Goal')

                error = math.fabs(goalwt - testwt)

                if i == 0:
                    # logMessage = 'Loop report ' + i
                    # + '    error=' + error
                    # + '    bc=' + testbc.fat + ',' + testbc.lean
                    # + '    testwt=' + testwt
                    # + '    calstep=' + calstep
                    # + '    holdcals=' + holdcals
                    print('error meh')

                if (error > eps) and (testwt > goalwt):
                    calstep /= 2.0
                    checkcals = holdcals

                if not error > eps:
                    tmp = False

            return goalinter

    def getAct(self, baseline):
        return baseline.getActivityParam() * (1.0 + self.actchangepercent / 100.0)

    def setproportionalsodium(self, baseline):
        self.sodium = (baseline.sodium * self.calories / baseline.getMaintCals())

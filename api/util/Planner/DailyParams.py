import math


class DailyParams(object):
    def __init__(self, calories=0, carbpercent=0, sodium=0, actparam=0):
        self.calories = calories or 0
        self.calories = 0 if self.calories < 0 else self.calories
        self.carbpercent = carbpercent or 0
        if isinstance(self.carbpercent, tuple):
            self.carbpercent = self.carbpercent[0]
        self.carbpercent = 0 if self.carbpercent < 0 else self.carbpercent
        self.carbpercent = 100 if self.carbpercent > 100.0 else self.carbpercent
        self.sodium = sodium or 0
        if isinstance(self.sodium, tuple):
            self.sodium = self.sodium[0]
        self.sodium = 0 if self.sodium < 0 else self.sodium
        self.actparam = actparam or 0
        self.actparam = 0 if self.actparam < 0 else self.actparam
        self.flag = False
        self.ramped = False

    @staticmethod
    def createFromBaseline(baseline):
        return DailyParams(
            baseline.getMaintCals(),
            baseline.carbIntakePct,
            baseline.sodium,
            baseline.getActivityParam()
        )

    @staticmethod
    def createFromIntervention(intervention, baseline):
        return DailyParams(

            intervention.calories[0] if isinstance(intervention.calories, tuple) else intervention.calories,
            intervention.carbinpercent,
            intervention.sodium,
            intervention.getAct(baseline)
        )

    def getCarbIntake(self):
        a = self.carbpercent[0] if isinstance(self.carbpercent, tuple) else self.carbpercent
        b = self.calories[0] if isinstance(self.calories, tuple) else self.calories
        return a / 100.0 * b

    @staticmethod
    def makeparamtrajectory(baseline, intervention1, intervention2, simlength):
        maintcals = baseline.getMaintCals()
        carbinp = baseline.carbIntakePct
        act = baseline.getActivityParam()
        Na = baseline.sodium
        paramtraj = []

        noeffect1 = (not intervention1.on) or (
                intervention1.on and (intervention1.day > simlength) and (not intervention1.rampon))
        noeffect2 = (not intervention2.on) or (
                intervention2.on and (intervention2.day > simlength) and (not intervention2.rampon))
        noeffect = noeffect1 and noeffect2,
        sameday = intervention1.day == intervention2.day,
        oneon = (intervention1.on and not intervention2.on) or (not intervention1.on and intervention2.on),
        bothon = intervention1.on and intervention2.on
        i = 0,
        dcal = 0.0,
        dact = 0.0,
        dcarb = 0.0,
        dsodium = 0.0,
        dailyParams = None

        paramtraj.append(DailyParams.createFromBaseline(baseline))

        if noeffect:
            for i in simlength:
                paramtraj[i] = DailyParams.createFromBaseline(baseline)
        elif oneon or (bothon and sameday and intervention2.rampon):
            intervention = None
            if oneon:
                intervention = intervention1 if intervention1.on else intervention2
            else:
                intervention = intervention2

            if intervention.rampon:
                for i in intervention.day:
                    dcal = maintcals + i / intervention.day * (intervention.calories - maintcals)
                    dact = act + i / intervention.day * (intervention.getAct(baseline) - act)
                    dcarb = carbinp + i / intervention.carbinpercent * (intervention.carbinpercent - carbinp)
                    dsodium = Na + i / intervention.day * (intervention.sodium - Na)
                    dailyParams = DailyParams(dcal, dcarb, dsodium, dact)
                    dailyParams.ramped = True
                    paramtraj.append(dailyParams)

                tmp = int(intervention.day)
                while tmp < simlength:
                    paramtraj.append(DailyParams.createFromIntervention(intervention, baseline))
                    tmp += 1

            else:
                for i in intervention.day:
                    paramtraj.append(DailyParams.createFromBaseline(baseline))

                tmp = int(intervention.day)
                while tmp < simlength:
                    paramtraj.append(DailyParams.createFromIntervention(intervention, baseline))
                    tmp += 1

        else:
            firstIntervention = intervention1 if intervention1.day < intervention2.day else intervention2
            secondIntervention = intervention2 if intervention1.day < intervention2.day else intervention1

            if firstIntervention.rampon:
                for i in firstIntervention.day:
                    dcal = maintcals + i / firstIntervention.day * (firstIntervention.calories - maintcals)
                    dact = act + i / firstIntervention.day * (firstIntervention.getAct(baseline) - act)
                    dcarb = carbinp + i / firstIntervention.carbinpercent * (firstIntervention.carbinpercent - carbinp)
                    dsodium = Na + i / firstIntervention.day * (firstIntervention.sodium - Na)
                    dailyParams = DailyParams(dcal, dcarb, dsodium, dact)
                    dailyParams.ramped = True

                    paramtraj.append(dailyParams)
            else:
                for i in firstIntervention.day:
                    paramtraj.append(DailyParams.createFromBaseline(baseline))

            if secondIntervention.rampon:
                tmp = int(firstIntervention.day)
                while tmp < secondIntervention.day:
                    firstCalories = firstIntervention.calories
                    firstDay = firstIntervention.day
                    firstSodium = firstIntervention.sodium
                    firstAct = firstIntervention.getAct(baseline)
                    firstCarbIn = firstIntervention.carbinpercent
                    secondCalories = secondIntervention.calories
                    secondDay = secondIntervention.day
                    secondSodium = secondIntervention.sodium
                    secondAct = secondIntervention.getAct(baseline)
                    secondCarbIn = secondIntervention.carbinpercent

                    dcal = firstCalories + (i - firstDay) / (secondDay - firstDay) * (secondCalories - firstCalories)
                    dact = firstAct + (i - firstDay) / (secondDay - firstDay) * (secondAct - firstAct)
                    dcarb = firstCarbIn + (i - firstDay) / (secondDay - firstDay) * (secondCarbIn - firstCarbIn)
                    dsodium = firstSodium + (i - firstDay) / (secondDay - firstDay) * (secondSodium - firstSodium)
                    dailyParams = DailyParams(dcal, dcarb, dsodium, dact)
                    dailyParams.ramped = True

                    paramtraj.append(dailyParams)
                    tmp += 1
            else:
                endfirst = min(secondIntervention.day, int(simlength, 10))

                tmp = firstIntervention.day
                while tmp < endfirst:
                    paramtraj.append(DailyParams.createFromIntervention(firstIntervention, baseline))
                    tmp += 1

            if simlength > secondIntervention.day:
                tmp = secondIntervention.day
                while tmp < simlength:
                    paramtraj.append(DailyParams.createFromIntervention(secondIntervention, baseline))
                    tmp += 1

        return paramtraj

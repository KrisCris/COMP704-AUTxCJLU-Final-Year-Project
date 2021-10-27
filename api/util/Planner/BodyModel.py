import math

from util.Planner.BodyChange import BodyChange
from util.Planner.DailyParams import DailyParams

RK4wt = [1, 2, 3, 4]


class BodyModel(object):
    def __init__(self, fat=0, lean=0, glycogen=0, decw=0, therm=0):
        self.RK4wt = [1, 2, 3, 4]
        self.fat = fat or 0
        self.lean = lean or 0
        self.glycogen = glycogen or 0
        self.decw = decw or 0
        self.therm = therm or 0

    @staticmethod
    def createFromBaseline(baseline):
        return BodyModel(
            baseline.getFatWeight(),
            baseline.getLeanWeight(),
            baseline.glycogen,
            baseline.dECW,
            baseline.getTherm()
        )

    @staticmethod
    def projectFromBaseline(baseline, dailyParams, simlength):
        loop = BodyModel.createFromBaseline(baseline)

        for i in range(simlength):
            loop = BodyModel.RungeKatta(bodyModel=loop, baseline=baseline, dailyParams=dailyParams)

        return loop

    @staticmethod
    def projectFromBaselineViaIntervention(baseline, intervention, simlength):
        dailyParams = DailyParams.createFromIntervention(intervention, baseline)
        return BodyModel.projectFromBaseline(baseline=baseline, dailyParams=dailyParams, simlength=simlength)

    def getWeight(self, baseline):
        weight = self.fat + self.lean + baseline.getGlycogenH2O(self.glycogen) + self.decw
        return weight

    def getFatFree(self, baseline):
        return self.getWeight(baseline) - self.fat

    def getFatPercent(self, baseline):
        return self.fat / self.getWeight(baseline) * 100.0

    def getBMI(self, baseline):
        return baseline.getNewBMI(self.getWeight(baseline))

    def dt(self, baseline, dailyParams):
        df = self.dfdt(baseline, dailyParams),
        dl = self.dldt(baseline, dailyParams),
        dg = self.dgdt(baseline, dailyParams),
        dDecw = self.dDecwdt(baseline, dailyParams),
        dtherm = self.dthermdt(baseline, dailyParams)

        return BodyChange(df, dl, dg, dDecw, dtherm)

    @staticmethod
    def RungeKatta(bodyModel, baseline, dailyParams):
        dt1 = bodyModel.dt(baseline, dailyParams)
        b2 = bodyModel.addchange(dt1, 0.5)
        dt2 = b2.dt(baseline, dailyParams)
        b3 = bodyModel.addchange(dt2, 0.5)
        dt3 = b3.dt(baseline, dailyParams)
        b4 = bodyModel.addchange(dt3, 1.0)
        dt4 = b4.dt(baseline, dailyParams)
        finaldt = bodyModel.avgdt_weighted(RK4wt, [dt1, dt2, dt3, dt4])
        finalstate = bodyModel.addchange(finaldt, 1.0)

        return finalstate

    def getTEE(self, baseline, dailyParams):
        p = self.getp()
        calin = dailyParams.calories
        carbflux = self.carbflux(baseline, dailyParams)
        Expend = self.getExpend(baseline, dailyParams)

        return (Expend + (calin - carbflux) * ((1.0 - p) * 180.0 / 9440.0 + p * 230.0 / 1807.0)) / (
                1.0 + p * 230.0 / 1807.0 + (1.0 - p) * 180.0 / 9440.0)

    def getExpend(self, baseline, dailyParams):
        TEF = 0.1 * dailyParams.calories,
        TEF = TEF[0]
        weight = baseline.getNewWeightFromBodyModel(self)
        k = baseline.getK()
        return k + 22.0 * self.lean + 3.2 * self.fat + dailyParams.actparam * weight + self.therm + TEF

    def getp(self):
        return 1.990762711864407 / (1.990762711864407 + self.fat)

    def carbflux(self, baseline, dailyParams):
        k_carb = baseline.getCarbsIn() / math.pow(baseline.glycogen, 2.0)
        return dailyParams.getCarbIntake() - k_carb * math.pow(self.glycogen, 2.0)

    def Na_imbal(self, baseline, dailyParams):
        so = dailyParams.sodium[0] if isinstance(dailyParams.sodium, tuple) else dailyParams.sodium
        carbintake = dailyParams.getCarbIntake()
        carbsin = baseline.getCarbsIn()
        return so - baseline.sodium - 3000.0 * self.decw - 4000.0 * (
                1.0 - carbintake / carbsin)

    def dfdt(self, baseline, dailyParams):
        dfdt = (1.0 - self.getp()) * (
                dailyParams.calories - self.getTEE(baseline, dailyParams) - self.carbflux(baseline,
                                                                                          dailyParams)) / 9440.0
        return dfdt

    def dldt(self, baseline, dailyParams):
        dldt = self.getp() * (dailyParams.calories - self.getTEE(baseline, dailyParams) - self.carbflux(baseline,
                                                                                                        dailyParams)) / 1807.0
        return dldt

    def dgdt(self, baseline, dailyParams):
        return self.carbflux(baseline, dailyParams) / 4180.0

    def dDecwdt(self, baseline, dailyParams):
        return self.Na_imbal(baseline, dailyParams) / 3220.0

    def dthermdt(self, baseline, dailyParams):
        return (0.14 * dailyParams.calories - self.therm) / 14.0

    def addchange(self, bchange, tstep):
        df = bchange.df
        if isinstance(df, tuple):
            df = df[0]
        dl = bchange.dl
        if isinstance(dl, tuple):
            dl = dl[0]
        dg = bchange.dg
        if isinstance(dg, tuple):
            dg = dg[0]
        dDecw = bchange.dDecw
        if isinstance(dDecw, tuple):
            dDecw = dDecw[0]
        dtherm = bchange.dtherm
        return BodyModel(
            self.fat + tstep * df,
            self.lean + tstep * dl,
            self.glycogen + tstep * dg,
            self.decw + tstep * dDecw,
            self.therm + tstep * dtherm
        )

    def cals4balance(self, baseline, act):
        weight = self.getWeight(baseline)
        Expend_no_food = baseline.getK() + 22.0 * self.lean + 3.2 * self.fat + act * weight
        p = self.getp()
        p_d = 1.0 + p * 230.0 / 1807.0 + (1.0 - p) * 180.0 / 9440.0
        p_n = (1.0 - p) * 180.0 / 9440.0 + p * 230.0 / 1807.0
        maint_nocflux = Expend_no_food / (p_d - p_n - 0.24)

        return maint_nocflux

    @staticmethod
    def Bodytraj(baseline, paramtraj):
        simlength = paramtraj.length
        bodytraj = [BodyModel(baseline)]

        for i in range(simlength):
            bodytraj.append(BodyModel.RungeKatta(bodytraj[i - 1], baseline, paramtraj[i - 1], paramtraj[i]))

        return bodytraj

    def avgdt(self, bchange):
        sumf = 0.0
        suml = 0.0
        sumg = 0.0
        sumdecw = 0.0
        sumtherm = 0.0

        for i in range(len(bchange)):
            sumf += bchange[i].df
            suml += bchange[i].dl
            sumg += bchange[i].dg
            sumdecw += bchange[i].dDecw
            sumtherm += bchange[i].dtherm

        nf = sumf / bchange.length
        nl = suml / bchange.length
        ng = sumg / bchange.length
        ndecw = sumdecw / bchange.length
        ntherm = sumtherm / bchange.length

        return BodyChange(nf, nl, ng, ndecw, ntherm)

    def avgdt_weighted(self, wt, bchange):
        sumf = 0.0
        suml = 0.0
        sumg = 0.0
        sumdecw = 0.0
        sumtherm = 0.0
        wti = 0
        wtsum = 0

        for i in range(len(bchange)):
            try:
                wti = wt[i]
            except Exception:
                wti = 1

            wti = 1 if wti < 0 else wti
            wtsum += wti
            sumf += wti * bchange[i].df[0]
            suml += wti * bchange[i].dl[0]
            sumg += wti * bchange[i].dg[0]
            sumdecw += wti * bchange[i].dDecw[0]
            sumtherm += wti * bchange[i].dtherm

        nf = sumf / wtsum
        nl = suml / wtsum
        ng = sumg / wtsum
        ndecw = sumdecw / wtsum
        ntherm = sumtherm / wtsum

        return BodyChange(nf, nl, ng, ndecw, ntherm)

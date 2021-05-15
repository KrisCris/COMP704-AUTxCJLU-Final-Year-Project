import math

MAX_AGE = 250.0
INITIAL_AGE = 23.0
MIN_HEIGHT = 0.1
MAX_HEIGHT = 400.0
INITIAL_HEIGHT = 180.0
MIN_WEIGHT = 0.1
INITIAL_WEIGHT = 70.0
MIN_BFP = 0.0
MAX_BFP = 100.0
INITIAL_BFP = 18.0
INITIAL_RMR = 1708.0
MIN_PAL = 1.0
INITIAL_PAL = 1.6
INITIAL_CARB_INTAKE_PCT = 50.0
INITIAL_SODIUM = 4000.0
INITIAL_GLYCOGEN = 0.5
INITIAL_DELTA_E = 0
INITIAL_DECW = 0


class Baseline(object):

    def __init__(self, isMale=True, age=INITIAL_AGE, height=INITIAL_HEIGHT, weight=INITIAL_WEIGHT, pal=INITIAL_PAL,
                 bfp=INITIAL_BFP, rmr=INITIAL_RMR):
        # settled attributes
        self.isMale = isMale
        self.age = age
        self.height = height
        self.weight = weight
        # Physical Activity Level, 1.4 - 2.5, DEFAULT = 1.6
        self.pal = pal

        # TODO need fix for further investigation for these values
        self.maximumage = MAX_AGE

        # Body Fat Percentage
        self.bfp = bfp or INITIAL_BFP
        # self.bfp = (self.bfp < MIN_BFP) ? MIN_BFP: self.bfp
        # self.bfp = (self.bfp > MAX_BFP) ? MAX_BFP: self.bfp

        # Resting Metabolic Rate
        self.rmr = rmr or INITIAL_RMR

        self.bfpCalc = True
        self.rmrCalc = False

        self.carbIntakePct = INITIAL_CARB_INTAKE_PCT
        self.sodium = INITIAL_SODIUM
        self.delta_E = INITIAL_DELTA_E
        self.dECW = INITIAL_DECW
        self.glycogen = INITIAL_GLYCOGEN

    # set and return the body fat percentage in $self.bfp percent
    def getBFP(self):
        if self.isMale:
            self.bfp = (0.14 * self.age + 37.310000000000002 * math.log(self.getBMI()) - 103.94)
        else:
            self.bfp = (0.14 * self.age + 39.960000000000001 * math.log(self.getBMI()) - 102.01000000000001)

        # weird fix?
        self.bfp = 0 if self.bfp < 0 else self.bfp
        self.bfp = 60 if self.bfp > 60 else self.bfp

        return self.bfp

    # set and return the resting metabolic rate in $self.rmr Cal/day
    def getRMR(self):
        if self.isMale:
            self.rmr = (9.99 * self.weight + 625.0 * self.height / 100.0 - 4.92 * self.age + 5.0)
        else:
            self.rmr = (9.99 * self.weight + 625.0 * self.height / 100.0 - 4.92 * self.age - 161.0)

        return self.rmr

    # the range of healthy weight
    def getHealthyWeightRange(self):
        hwr = {}
        hwr.low = round(18.5 * math.pow((self.height / 100), 2))
        hwr.high = round(25 * math.pow((self.height / 100), 2))
        return hwr

    # no idea what self is
    def getActivityParam(self):
        return (0.9 * self.getRMR() * self.pal - self.getRMR()) / self.weight

    def getMaintCals(self):
        return self.pal * self.getRMR()

    def getTEE(self):
        return self.pal * self.getRMR()

    def getFatWeight(self):
        return self.weight * self.getBFP() / 100.0

    def getLeanWeight(self):
        return self.weight - self.getFatWeight()

    def getK(self):
        return 0.76 * self.getMaintCals() - self.delta_E - 22.0 * self.getLeanWeight() - 3.2 * self.getFatWeight() \
               - self.getActivityParam() * self.weight

    def getBMI(self):
        return self.weight / math.pow(self.height / 100.0, 2.0)

    def getNewBMI(self, newWeight):
        return newWeight / math.pow(self.height / 100.0, 2.0)

    def proportionalSodium(self, newCals):
        return self.sodium * newCals / self.getMaintCals()

    def getCarbsIn(self):
        return self.carbIntakePct / 100.0 * self.getMaintCals()

    def getGlycogenH2O(self, newGlycogen):
        return 3.7 * (newGlycogen - self.glycogen)

    def getTherm(self):
        return 0.14 * self.getTEE()

    def getNewWeight(self, fat, lean, glycogen, deltaECW):
        return fat + lean + self.getGlycogenH2O(glycogen) + deltaECW

    def getNewWeightFromBodyModel(self, bodyModel):
        return bodyModel.fat + bodyModel.lean + self.getGlycogenH2O(bodyModel.glycogen) + bodyModel.decw

    def glycogenEquation(self, caloricIntake):
        return self.glycogen * math.sqrt(self.carbIntakePct / 100.0 * caloricIntake / self.getCarbsIn())

    def deltaECWEquation(self, caloricIntake):
        return ((self.sodium / self.getMaintCals() + 4000.0 * self.carbIntakePct / (
                100.0 * self.getCarbsIn())) * caloricIntake - (self.sodium + 4000.0)) / 3000.0

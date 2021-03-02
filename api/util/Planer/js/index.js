const Baseline = require('./baseline');
const Intervention = require('./intervention');
const BodyModel = require('./bodymodel');

const ENERGYUNITS = 1;

//Entradas
const age = process.argv[2]; // Ano
const height = process.argv[3]; // Centímetros
const weight = process.argv[4]; // Quilogramas
const physicalActivityLevel = process.argv[5]; // 1.4 - 2.3
var goalTime = process.argv[6]; //Dias para conseguir o objetivo.
var goalWeight = process.argv[7]; // Quilogramas

const baseline = new Baseline(true, age, height, weight, true, false, physicalActivityLevel);

var goalIntervention = new Intervention();
var goalMaintenanceIntervention = goalIntervention;

if (Math.abs(goalWeight - baseline.weight) < .02) {
  goalWeight = baseline.weight;
}

let unachievableGoal = false;

try {
  goalIntervention = Intervention.forgoal(baseline, goalWeight, parseInt(goalTime), 0, 0, 0.001);
  unachievableGoal = false;
} catch (err) {
  unachievableGoal = true;
}

const goalCalsField = Math.round(goalIntervention.calories * ENERGYUNITS);
let goalMaintCals = goalCalsField;

var goalbc = new BodyModel.projectFromBaselineViaIntervention(baseline, goalIntervention, parseInt(goalTime) + 1);
var weightAtGoal = baseline.getNewWeightFromBodyModel(goalbc);
var bfpAtGoal = goalbc.getFatPercent(baseline);

if (goalWeight == baseline.weight && goalMaintenanceIntervention.actchangepercent == 0) {
    goalMaintCals = Math.round(baseline.getMaintCals());
} else {
    goalMaintCals = Math.round(goalbc.cals4balance(baseline, goalMaintenanceIntervention.getAct(baseline)));
}

console.log(goalCalsField, unachievableGoal, goalMaintCals);

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Plan {
  static const List<String> planTypes = [
    "None",
    "shedWeight",
    "maintain",
    "buildMuscle",
  ];
  int id;
  int planType;
  int startTime;
  int endTime;
  int goalWeight;
  double dailyCaloriesLowerLimit;
  double dailyCaloriesUpperLimit;
  double dailyProteinLowerLimit;
  double dailyProteinUpperLimit;

  Plan(
      {@required this.planType,
      @required this.id,
      @required this.startTime,
      @required this.endTime,
        @required double goalWeight,
      @required this.dailyCaloriesUpperLimit,
      @required this.dailyProteinUpperLimit,
      @required this.dailyProteinLowerLimit,
      @required this.dailyCaloriesLowerLimit}) {
  if(goalWeight != null){
    this.goalWeight = goalWeight.floor();
  }
  }
  String getPlanType() {
    return Plan.planTypes[this.planType];
  }
  int getLeftDays(){
    int nowTime = (new DateTime.now().millisecondsSinceEpoch/1000).floor();
    int leftTime = this.endTime - nowTime;
    int days = (leftTime/(3600*24)).floor();
    return days;
  }
  int getKeepDays(){
    int nowTime = (new DateTime.now().millisecondsSinceEpoch/1000).floor();
    int keepTime = nowTime - this.startTime;
    int days = (keepTime/(3600*24)).floor();
    return days;
  }
  void save() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.setInt("planType", planType);
    pre.setInt("planId", id);
    pre.setInt("startTime", startTime);
    pre.setInt("endTime", endTime);
    pre.setDouble("goalWeight", goalWeight.floorToDouble());
    pre.setDouble("dailyCaloriesLowerLimit", dailyCaloriesLowerLimit);
    pre.setDouble("dailyCaloriesUpperLimit", dailyCaloriesUpperLimit);
    pre.setDouble("dailyProteinLowerLimit", dailyProteinLowerLimit);
    pre.setDouble("dailyProteinUpperLimit", dailyProteinUpperLimit);
  }

  static removeLocal() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove("planType");
    pre.remove("planId");
    pre.remove("startTime");
    pre.remove("endTime");
    pre.remove("goalWeight");
    pre.remove("dailyCaloriesLowerLimit");
    pre.remove("dailyCaloriesUpperLimit");
    pre.remove("dailyProteinLowerLimit");
    pre.remove("dailyProteinUpperLimit");
  }

  static Plan readLocal() {
    SharedPreferences pre = LocalDataManager.pre;
    if( pre.getInt("planId") == null){
      return null;
    }
    Plan plan = new Plan(
        planType: pre.getInt("planType"),
        id: pre.getInt("planId"),
        startTime: pre.getInt("startTime"),
        endTime: pre.getInt("endTime"),
        goalWeight: pre.getDouble("goalWeight"),
        dailyCaloriesUpperLimit: pre.getDouble("dailyCaloriesLowerLimit"),
        dailyProteinUpperLimit: pre.getDouble("dailyCaloriesUpperLimit"),
        dailyProteinLowerLimit: pre.getDouble("dailyProteinLowerLimit"),
        dailyCaloriesLowerLimit: pre.getDouble("dailyProteinUpperLimit"));
    return plan;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/LocalDataManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Plan {
  static const List<String> planTypes = [
    "Loose Weight",
    "Maintain",
    "Muscle Gain",
    "None",
  ];
  int id;
  int planType;
  int startTime;
  int endTime;
  double dailyCaloriesLowerLimit;
  double dailyCaloriesUpperLimit;
  double dailyProteinLowerLimit;
  double dailyProteinUpperLimit;

  Plan(
      {@required this.planType,
      @required this.id,
      @required this.startTime,
      @required this.endTime,
      @required this.dailyCaloriesUpperLimit,
      @required this.dailyProteinUpperLimit,
      @required this.dailyProteinLowerLimit,
      @required this.dailyCaloriesLowerLimit}) {}
  String getPlanType() {
    return Plan.planTypes[this.planType];
  }

  void save() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.setInt("planType", planType);
    pre.setInt("planId", id);
    pre.setInt("startTime", startTime);
    pre.setInt("endTime", endTime);
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
        dailyCaloriesUpperLimit: pre.getDouble("dailyCaloriesLowerLimit"),
        dailyProteinUpperLimit: pre.getDouble("dailyCaloriesUpperLimit"),
        dailyProteinLowerLimit: pre.getDouble("dailyProteinLowerLimit"),
        dailyCaloriesLowerLimit: pre.getDouble("dailyProteinUpperLimit"));
    return plan;
  }
}

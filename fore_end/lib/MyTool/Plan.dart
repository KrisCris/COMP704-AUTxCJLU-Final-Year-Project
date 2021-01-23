import 'package:flutter/cupertino.dart';

class Plan {
  static const List<String> planTypes = ["None","Muscle Gain","Loose Weight","Maintain"];
  int id;
  String planType;
  double startTime;
  double endTime;
  double dailyCaloriesLowerLimit;
  double dailyCaloriesUpperLimit;
  double dailyProteinLowerLimit;
  double dailyProteinUpperLimit;

  Plan({int planType=0,
    @required this.id,
    @required this.startTime,
    @required this.endTime,
    @required this.dailyCaloriesUpperLimit,
    this.dailyProteinUpperLimit=0,
    this.dailyProteinLowerLimit=0,
    this.dailyCaloriesLowerLimit=0}){
    this.planType = Plan.planTypes[planType];
  }

}
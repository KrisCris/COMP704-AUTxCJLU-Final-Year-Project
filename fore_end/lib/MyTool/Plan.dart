import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/Mycomponents/widgets/plan/ExtendTimeHint.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/account/UpdateBody.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Plan {
  static const List<String> planTypes = [
    "None",
    "shedWeight",
    "maintain",
    "buildMuscle",
  ];
  int id;
  int planType;
  int startTime;
  int extendDays;
  int endTime;
  int goalWeight;
  double dailyCaloriesLowerLimit;
  double dailyCaloriesUpperLimit;
  double dailyProteinLowerLimit;
  double dailyProteinUpperLimit;
  bool pastDeadline;
  int delayDays;

  Plan._internal(
    int planType,
    int id,
    int startTime,
    int endTime,
    int goalWeight,
    int extendDays,
    double dailyCaloriesUpperLimit,
    double dailyCaloriesLowerLimit,
    double dailyProteinUpperLimit,
    double dailyProteinLowerLimit,
  ) {
    this.planType = planType;
    this.id = id;
    this.startTime = startTime;
    this.endTime = endTime;
    this.goalWeight = goalWeight;
    this.extendDays = extendDays;
    this.dailyCaloriesUpperLimit = dailyCaloriesUpperLimit;
    this.dailyCaloriesLowerLimit = dailyCaloriesLowerLimit;
    this.dailyProteinUpperLimit = dailyProteinUpperLimit;
    this.dailyProteinLowerLimit = dailyProteinLowerLimit;
  }
  static Plan generatePlan(
    int planType,
    int id,
    int startTime,
    int endTime,
    int goalWeight,
    int extendDays,
    double dailyCaloriesUpperLimit,
    double dailyCaloriesLowerLimit,
    double dailyProteinUpperLimit,
    double dailyProteinLowerLimit,
  ) {
    if (planType == 1) {
      return ShedWeightPlan(
          id,
          startTime,
          endTime,
          goalWeight,
          extendDays,
          dailyCaloriesUpperLimit,
          dailyCaloriesLowerLimit,
          dailyProteinUpperLimit,
          dailyProteinLowerLimit);
    } else if (planType == 2) {
      return BuildMusclePlan(
          id,
          startTime,
          endTime,
          goalWeight,
          extendDays,
          dailyCaloriesUpperLimit,
          dailyCaloriesLowerLimit,
          dailyProteinUpperLimit,
          dailyProteinLowerLimit);
    } else if (planType == 3) {
      return MaintainPlan(
          id,
          startTime,
          endTime,
          goalWeight,
          extendDays,
          dailyCaloriesUpperLimit,
          dailyCaloriesLowerLimit,
          dailyProteinUpperLimit,
          dailyProteinLowerLimit);
    } else {
      return null;
    }
  }

  static Plan fromJson(Map<String, dynamic> json) {
    return Plan.generatePlan(
        json['planType'],
        json['id'],
        json['startTime'],
        json['endTime'],
        json['goalWeight'],
        json['extendDays'],
        json['caloriesUpper'],
        json['caloriesLower'],
        json['proteinUpper'],
        json['proteinLower']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planType'] = this.planType;
    data['id'] = this.id;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['extendDays'] = this.extendDays;
    data['goalWeight'] = this.goalWeight;
    data['caloriesUpper'] = this.dailyCaloriesUpperLimit;
    data['caloriesLower'] = this.dailyCaloriesLowerLimit;
    data['proteinUpper'] = this.dailyProteinUpperLimit;
    data['proteinLower'] = this.dailyProteinLowerLimit;
    return data;
  }

  String getPlanType();
  int getLeftDays();
  Future<int> calculateDelayDays();
  void solvePastDeadLine(BuildContext context);
  void solveUpdateWeight(BuildContext context);

  int getKeepDays() {
    int nowTime = (new DateTime.now().millisecondsSinceEpoch / 1000).floor();
    int keepTime = nowTime - this.startTime;
    int days = (keepTime / (3600 * 24)).floor();
    return days;
  }

  void save() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.setString("plan", jsonEncode(this));
  }

  static removeLocal() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove("plan");
  }

  static Plan readLocal() {
    SharedPreferences pre = LocalDataManager.pre;
    String json = pre.getString("plan");
    return Plan.fromJson(jsonDecode(json));
  }
}

class ShedWeightPlan extends Plan {
  ShedWeightPlan(
    int id,
    int startTime,
    int endTime,
    int goalWeight,
    int extendDays,
    double dailyCaloriesUpperLimit,
    double dailyCaloriesLowerLimit,
    double dailyProteinUpperLimit,
    double dailyProteinLowerLimit,
  ) : super._internal(
            1,
            id,
            startTime,
            endTime,
            goalWeight,
            extendDays,
            dailyCaloriesUpperLimit,
            dailyCaloriesLowerLimit,
            dailyProteinUpperLimit,
            dailyProteinLowerLimit) {
    this.pastDeadline = DateTime.now().millisecondsSinceEpoch >
        endTime * 1000 + 3600 * 24 * extendDays * 1000;
  }

  @override
  int getLeftDays() {
    int nowTime = (new DateTime.now().millisecondsSinceEpoch / 1000).floor();
    int leftTime = this.endTime - nowTime;
    int days = (leftTime / (3600 * 24)).floor();
    return days;
  }

  @override
  String getPlanType() {
    return Plan.planTypes[1];
  }

  @override
  Future<int> calculateDelayDays() async {
    User u = User.getInstance();
    Response res = await Requests.calculateDelayTime(
        {"uid": u.uid, "token": u.token, "pid": this.id});
    if (res != null && res.data['code'] == 1) {
      this.delayDays = res.data['data']['ext'];
      return this.delayDays;
    } else {
      return null;
    }
  }

  @override
  void solvePastDeadLine(BuildContext context) {
    User u = User.getInstance();
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ExtendTimeHint(
          extendDays: this.delayDays,
        );
      },
    ).then((value) async {
      //accept delay
      if (value == true) {
        Response res = await Requests.delayPlan(
            {"uid": u.uid, "token": u.token, "pid": this.id});
        if (res != null && res.data['code'] == 1) {
          this.extendDays = res.data['data']['ext'];
          this.save();
        }
      }
      //finish plan
      else {
        bool success = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return UpdateBody(
              text:
                  "Before change your plan, please record your current weight",
              needHeight: false,
              needCancel: false,
              onUpdate: () async {
                Response res = await Requests.finishPlan({
                  "uid": u.uid,
                  "token": u.token,
                  "pid": this.id,
                });
                if (res != null && res.data['code'] == 1) {
                  Navigator.of(context).pop(true);
                }
              },
            );
          },
        );
        //create new plan after finish plan
        if (success) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return GuidePage(firstTime: false);
          }), (route) {
            return route == null;
          });
        }
      }
    });
  }
  @override
  void solveUpdateWeight(BuildContext context) {
    
  }
}

class BuildMusclePlan extends Plan {
  BuildMusclePlan(
    int id,
    int startTime,
    int endTime,
    int goalWeight,
    int extendDays,
    double dailyCaloriesUpperLimit,
    double dailyCaloriesLowerLimit,
    double dailyProteinUpperLimit,
    double dailyProteinLowerLimit,
  ) : super._internal(
            2,
            id,
            startTime,
            endTime,
            goalWeight,
            extendDays,
            dailyCaloriesUpperLimit,
            dailyCaloriesLowerLimit,
            dailyProteinUpperLimit,
            dailyProteinLowerLimit) {
    this.pastDeadline = DateTime.now().millisecondsSinceEpoch >
        endTime * 1000 + 3600 * 24 * extendDays * 1000;
  }

  @override
  int getLeftDays() {
    int nowTime = (new DateTime.now().millisecondsSinceEpoch / 1000).floor();
    int leftTime = this.endTime - nowTime;
    int days = (leftTime / (3600 * 24)).floor();
    return days;
  }

  @override
  String getPlanType() {
    return Plan.planTypes[2];
  }

  @override
  Future<int> calculateDelayDays() {
    // TODO: implement calculateDelayDays
    throw UnimplementedError();
  }

  @override
  void solvePastDeadLine(BuildContext context) {
    // TODO: implement solvePastDeadLine
  }

  @override
  void solveUpdateWeight(BuildContext context) {
    // TODO: implement solveUpdateWeight
  }
}

class MaintainPlan extends Plan {
  MaintainPlan(
    int id,
    int startTime,
    int endTime,
    int goalWeight,
    int extendDays,
    double dailyCaloriesUpperLimit,
    double dailyCaloriesLowerLimit,
    double dailyProteinUpperLimit,
    double dailyProteinLowerLimit,
  ) : super._internal(
            3,
            id,
            startTime,
            endTime,
            goalWeight,
            extendDays,
            dailyCaloriesUpperLimit,
            dailyCaloriesLowerLimit,
            dailyProteinUpperLimit,
            dailyProteinLowerLimit) {
    this.pastDeadline = false;
  }

  @override
  int getLeftDays() {
    return -1;
  }

  @override
  String getPlanType() {
    return Plan.planTypes[3];
  }

  @override
  Future<int> calculateDelayDays() {
    // TODO: implement calculateDelayDays
    throw UnimplementedError();
  }

  @override
  void solvePastDeadLine(BuildContext context) {
    // TODO: implement solvePastDeadLine
  }

  @override
  void solveUpdateWeight(BuildContext context) {
    // TODO: implement solveUpdateWeight
  }
}

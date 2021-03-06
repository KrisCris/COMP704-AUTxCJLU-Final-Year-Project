import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Models/User.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/LocalDataManager.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/Req.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/widgets/basic/DotBox.dart';
import 'package:fore_end/Components/widgets/plan/ChooseExtendTime.dart';
import 'package:fore_end/Components/widgets/plan/ExtendTimeHint.dart';
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
  int calculatedDelayDays;

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
    } else if (planType == 3) {
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
    } else if (planType == 2) {
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
        json['extendDays'] ?? 0,
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
    return json == null ? null : Plan.fromJson(jsonDecode(json));
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
        null, {"uid": u.uid, "token": u.token, "pid": this.id});
    if (res != null && res.data['code'] == 1) {
      this.calculatedDelayDays = res.data['data']['ext'];
      return this.calculatedDelayDays;
    } else {
      return null;
    }
  }

  @override
  void solvePastDeadLine(BuildContext context) async {
    if (!this.pastDeadline) return;
    User u = User.getInstance();
    bool b = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ExtendTimeHint(
          title: CustomLocalizations.of(context).planDelayFor +
              this.calculatedDelayDays.toString() +
              CustomLocalizations.of(context).days +
              "," +
              CustomLocalizations.of(context).planDelayChoose,
          onClickAccept: () async {
            Response res = await Requests.delayPlan(
                context, {"uid": u.uid, "token": u.token, "pid": this.id});
            if (res != null && res.data['code'] == 1) {
              this.extendDays = res.data['data']['ext'];
              this.save();
            }
          },
        );
      },
    );
    //accept delay
    if (b == true) {
    }
    //finish plan
    else {
      bool success = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          UpdateBody updt = UpdateBody(
            text: CustomLocalizations.of(context).beforeChangePlan,
            needHeight: false,
            needCancel: false,
          );
          updt.onUpdate = () async {
            Response res = await Requests.finishPlan(context, {
              "uid": u.uid,
              "token": u.token,
              "pid": this.id,
              "weight": updt.getWeight()
            });
            if (res != null && res.data['code'] == 1) {
              u.bodyWeight = updt.weight.widgetValue.value;
              Navigator.of(context).pop(true);
            }
          };
          return updt;
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
  }

  @override
  void solveUpdateWeight(BuildContext context) async {
    User u = User.getInstance();
    int valueIntStart = await showDialog<int>(
      context: context,
      builder: (BuildContext context2) {
        UpdateBody updt = UpdateBody(
          text: CustomLocalizations.of(context2).updateBodyTitle,
          needHeight: false,
          needCancel: true,
        );
        updt.onUpdate = () async {
          Response res = await Requests.updateBody(context, {
            "uid": u.uid,
            "token": u.token,
            "weight": updt.getWeight(),
            "height": updt.getHeight(),
          });
          if (res == null) return;

          if (res.data['code'] == 1) {
            double v = updt.getWeight().toDouble();
            u.bodyWeight = v;
            //????????????
            if (res.data['data'] == null) {
              Navigator.of(context2).pop(-1);
            }
            //??????????????????
            else {
              this.dailyCaloriesUpperLimit =
                  NumUtil.getNumByValueDouble(res.data['data']['ch'], 1);
              this.dailyCaloriesLowerLimit =
                  NumUtil.getNumByValueDouble(res.data['data']['cl'], 1);
              this.dailyProteinUpperLimit =
                  NumUtil.getNumByValueDouble(res.data['data']['ph'], 1);
              this.dailyProteinLowerLimit =
                  NumUtil.getNumByValueDouble(res.data['data']['pl'], 1);
              this.save();
              Navigator.of(context2).pop(0);
            }
          }
          //????????????
          else if (res.data['code'] == -2) {
            int v = updt.weight.widgetValue.value;
            u.bodyWeight = v.toDouble();
            this.calculatedDelayDays = res.data['data']['recommend_ext'];
            Navigator.of(context2).pop(-2);
          }
        };
        return updt;
      },
    );
    //????????????
    if (valueIntStart == -1) {
      int valueInt = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context3) {
            return Container(
              height: ScreenTool.partOfScreenHeight(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DotColumn(borderRadius: 5, children: [
                    SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
                    Container(
                      child: Text(
                        CustomLocalizations.of(context3).planSuccessCreateNew,
                        style: TextStyle(
                            fontFamily: "Futura",
                            fontSize: 15,
                            color: MyTheme.convert(ThemeColorName.NormalText)),
                      ),
                      width: ScreenTool.partOfScreenWidth(0.6),
                    ),
                    SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
                  ])
                ],
              ),
            );
          });
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
        return GuidePage(firstTime: false);
      }), (route) {
        return route == null;
      });
    }
    //??????????????????
    else if (valueIntStart == 0) {
    }
    //????????????
    else if (valueIntStart == -2) {
      bool valueBool = await showDialog<bool>(
        context: context,
        builder: (BuildContext context4) {
          return ExtendTimeHint(
            title: CustomLocalizations.of(context4).planDelayFor +
                this.calculatedDelayDays.toString() +
                CustomLocalizations.of(context4).days +
                "," +
                CustomLocalizations.of(context4).planDelayChoose,
            onClickAccept: () async {
              Response res = await Requests.delayAndUpdatePlan(
                  context, {"uid": u.uid, "token": u.token, "pid": this.id});
              if (res != null && res.data['code'] == 1) {
                this.extendDays = res.data['data']['ext'];
                this.save();
              }
            },
            onClickFinish: () async {
              Response res = await Requests.finishPlan(context, {
                "uid": u.uid,
                "token": u.token,
                "pid": this.id,
                "weight": u.bodyWeight,
              });
            },
          );
        },
      );
      //accept delay
      if (valueBool == true) {
      }
      //finish plan
      else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return GuidePage(firstTime: false);
        }), (route) {
          return route == null;
        });
      }
    }
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
    return Plan.planTypes[3];
  }

  @override
  Future<int> calculateDelayDays() {
    return Future.value(-1);
  }

  @override
  void solvePastDeadLine(BuildContext context) async {
    if (!this.pastDeadline) return;
    User u = User.getInstance();
    bool b = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ExtendTimeHint(
          title: CustomLocalizations.of(context).planSuccessTwoChoise,
          delayText: CustomLocalizations.of(context).continuePlanButton,
          finishText: CustomLocalizations.of(context).changePlanButton,
        );
      },
    );
    //continue plan
    if (b == true) {
      int day = await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ChooseExtendTime();
          });
      this.extendDays = day;
      this.save();
    }
    //finish plan
    else {
      bool success = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          UpdateBody updt = UpdateBody(
            text: CustomLocalizations.of(context).beforeChangePlan,
            needHeight: false,
            needCancel: false,
          );
          updt.onUpdate = () async {
            Response res = await Requests.finishPlan(context, {
              "uid": u.uid,
              "token": u.token,
              "pid": this.id,
              "weight": updt.getWeight(),
            });
            if (res != null && res.data['code'] == 1) {
              u.bodyWeight = updt.weight.widgetValue.value;
              Navigator.of(context).pop(true);
            }
          };
          return updt;
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
  }

  @override
  void solveUpdateWeight(BuildContext context) async {
    User u = User.getInstance();
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          UpdateBody updt = UpdateBody(
            text: CustomLocalizations.of(context).updateBodyTitle,
            needHeight: false,
            needCancel: true,
          );
          updt.onUpdate = () async {
            Response res = await Requests.updateBody(context, {
              "uid": u.uid,
              "token": u.token,
              "weight": updt.getWeight(),
              "height": updt.getHeight(),
            });
            if (res == null) return;
            //??????????????????
            if (res.data['code'] == 1) {
              Navigator.of(context).pop(1);
            } else if (res.data['code'] == -2) {
              //TODO:?????????????????????
            }
          };
          return updt;
        });
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
    this.pastDeadline = false;
  }

  @override
  int getLeftDays() {
    return -1;
  }

  @override
  String getPlanType() {
    return Plan.planTypes[2];
  }

  @override
  Future<int> calculateDelayDays() {
    return Future.value(-1);
  }

  @override
  void solvePastDeadLine(BuildContext context) async {
    return;
  }

  @override
  void solveUpdateWeight(BuildContext context) async {
    User u = User.getInstance();
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          UpdateBody updt = UpdateBody(
            text: CustomLocalizations.of(context).updateBodyTitle,
            needHeight: false,
            needCancel: true,
          );
          updt.onUpdate = () async {
            Response res = await Requests.updateBody(context, {
              "uid": u.uid,
              "token": u.token,
              "weight": updt.getWeight(),
            });
            if (res == null) return;
            //??????????????????
            if (res.data['code'] == 1) {
              Navigator.of(context).pop(1);
            } else if (res.data['code'] == -2) {
              //TODO:?????????????????????
            }
          };
          return updt;
        });
  }
}

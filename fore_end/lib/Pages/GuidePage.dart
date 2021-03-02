
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/widgets/plan/BodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/plan/ConfirmPlan.dart';
import 'package:fore_end/Mycomponents/widgets/plan/ExtraBodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/plan/GoalInpter.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanChooser.dart';

import 'main/MainPage.dart';

class GuidePage extends StatefulWidget {
  bool firstTime;
  GuidePage({this.firstTime = true});

  @override
  State<StatefulWidget> createState() {
   return GuidePageState();
  }
}


class GuidePageState extends State<GuidePage> with TickerProviderStateMixin{
  TabController ctl;

  @override
  void initState() {
    super.initState();
    this.ctl =  TabController(
      length: 5,
      vsync: this,
    );
  }
  @override
  Widget build(BuildContext context) {
    PlanChooser plan = PlanChooser();
    BodyDataInputer body = BodyDataInputer();
    ExtraBodyDataInputer body2 = ExtraBodyDataInputer();
    GoalInputer goal = GoalInputer();
    ConfirmPlan planPreview = ConfirmPlan();

    plan.setNextDo(() {
      ctl.animateTo(1,
          duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      goal.planType.value = plan.planType;
    });
    body.setNextDo(() {
      ctl.animateTo(2,
          duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
    body2.setNextDo(() {
      goal.setData(body.genderRatio, body.bodyHeight, body.bodyWeight,
          body2.age, body2.exerciseRatio);
      //maintain情况下
      if(plan.planType == 2){
        this.askForPreview(context, plan, body, body2, null, planPreview);
        return;
      }else{
        ctl.animateTo(3,
            duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      }
    });
    goal.setNextDo((){this.askForPreview(context, plan, body, body2, goal, planPreview);});

    return TabBarView(
      controller: ctl,
      physics: NeverScrollableScrollPhysics(),
      children: [plan, body, body2, goal, planPreview],
    );
  }


  void askForPreview(BuildContext context, PlanChooser plan, BodyDataInputer body, ExtraBodyDataInputer body2, GoalInputer goal, ConfirmPlan planPreview) async {
    int planType = plan.planType;
    double bodyHeight = body.bodyHeight;
    int bodyWeight = body.bodyWeight;
    int goalWeight = bodyWeight;
    int gender = body.gender;
    int age = body2.age;
    double exerciseRatio = body2.exerciseRatio;
    int days = 0;
    if(goal != null){
      days = goal.days;
    }

    if (planType == 1 && goal != null) {
      goalWeight -= goal.weightLose;
    }
    Response res = await Requests.previewPlan({
      "height": bodyHeight*100,
      "weight": bodyWeight.round(),
      "age": age,
      "gender": gender,
      "plan": planType,
      "duration": days,
      "goal_weight": goalWeight,
      "pal": exerciseRatio
    });
    if (res.data["code"] == -2) {
      //TODO:计划不合理的情况
    } else if (res.data["code"] == 1) {
      dynamic data = res.data['data'];
      planPreview.setNextDo(()async{
        User u = User.getInstance();
        Response res = await this.finishOldPlan();
        res = await Requests.setPlan({
          "uid":u.uid,
          "token":u.token,
          "height": bodyHeight*100,
          "weight": bodyWeight.round(),
          "age": age,
          "gender": gender,
          "type": planType,
          "duration": days,
          "goalWeight": goalWeight,
          "calories": (data["goalCal"] as int),
          "pal":exerciseRatio,
          "maintCalories": (data["completedCal"] as int)
        });
        if(res.data['code'] == 1){
          u.setPlan(res);
          if(widget.firstTime){
            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context){
              return new MainPage(user:u);
            }),(ct)=>false);
          }else{
            Navigator.pop(context);
          }
        }else{
          //TODO:创建计划失败的情况
        }
      });
      planPreview.setBackDo(() {
        ctl.animateTo(0,
            duration: Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn);
      });
      planPreview.setPlanType(planType);
      planPreview.setNutrition(
          (data["goalCal"] as int).floorToDouble(),
          (data["completedCal"] as int).floorToDouble(),
          (data["maintainCal"] as int).floorToDouble(),
          data["protein_l"], data["protein_h"],
          data["low"]);
      ctl.animateTo(4,
          duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    }
  }

  Future<Response> finishOldPlan() async {
    User u = User.getInstance();
    Response res = await Requests.finishPlan({
      "uid":u.uid,
      "token":u.token,
      "pid":u.plan?.id ?? -1,
      "weight":u.bodyWeight.floor()
    });
    return res;
  }
}
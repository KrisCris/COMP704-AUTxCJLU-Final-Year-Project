import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/widgets/BodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/ConfirmPlan.dart';
import 'package:fore_end/Mycomponents/widgets/ExtraBodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/GoalInpter.dart';
import 'package:fore_end/Mycomponents/widgets/PlanChooser.dart';

import 'MainPage.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController ctl = PageController(
      initialPage: 0,
      keepPage: true,
    );
    PlanChooser plan = PlanChooser();
    BodyDataInputer body = BodyDataInputer();
    ExtraBodyDataInputer body2 = ExtraBodyDataInputer();
    GoalInputer goal = GoalInputer();
    ConfirmPlan planPreview = ConfirmPlan();

    plan.setNextDo(() {
      ctl.animateTo(ScreenTool.partOfScreenWidth(1),
          duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      goal.planType.value = plan.planType;
    });
    body.setNextDo(() {
      ctl.animateTo(2 * ScreenTool.partOfScreenWidth(1),
          duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
    body2.setNextDo(() {
      goal.setData(body.genderRatio, body.bodyHeight, body.bodyWeight,
          body2.age, body2.exerciseRatio);
      ctl.animateTo(3 * ScreenTool.partOfScreenWidth(1),
          duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
    goal.setNextDo(() async {
      //1 -> 减肥  2 -> 保持  3 -> 增肌
      int planType = plan.planType;
      double bodyHeight = body.bodyHeight;
      int bodyWeight = body.bodyWeight;
      int goalWeight = bodyWeight;
      int gender = body.gender;
      int age = body2.age;
      double exerciseRatio = body2.exerciseRatio;
      int days = goal.days;

      if (planType == 1) {
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
          Response res = await Requests.setPlan({
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
            "maintCalories": (data["completedCal"] as int)
          });
          if(res.data['code'] == 1){

            u.setPlan(res);
            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context){
              return new MainPage(user:u);
            }),(ct)=>false);
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
        planPreview.setCalories(
            (data["goalCal"] as int).floorToDouble(),
            (data["completedCal"] as int).floorToDouble(),
            (data["maintainCal"] as int).floorToDouble(),
            data["low"]);
        ctl.animateTo(4 * ScreenTool.partOfScreenWidth(1),
            duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      }
    });

    return PageView(
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: ctl,
      physics: NeverScrollableScrollPhysics(),
      pageSnapping: true,
      onPageChanged: (index) {},
      children: [plan, body, body2, goal, planPreview],
    );
  }
}

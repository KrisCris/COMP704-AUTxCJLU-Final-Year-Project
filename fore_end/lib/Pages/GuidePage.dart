import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/widgets/BodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/ExtraBodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/GoalInpter.dart';
import 'package:fore_end/Mycomponents/widgets/PlanChooser.dart';

class GuidePage extends StatelessWidget{

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

    plan.setNextDo((){
      ctl.animateTo(ScreenTool.partOfScreenWidth(1), duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
      goal.planType.value = plan.planType;
    });
    body.setNextDo((){
      ctl.animateTo(2*ScreenTool.partOfScreenWidth(1), duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
    body2.setNextDo((){
      goal.setData(body.genderRatio, body.bodyHeight, body.bodyWeight, body2.age,body2.exerciseRatio);
      ctl.animateTo(3*ScreenTool.partOfScreenWidth(1), duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
    });
    goal.setNextDo((){
        //0 -> 增肌  1 -> 减肥  2 -> 保持
        int planType = plan.planType;
        double bodyHeight = body.bodyHeight;
        int bodyWeight =body.bodyWeight;
        int genderRatio = body.genderRatio;
        int age = body2.age;
        double exerciseRatio = body2.exerciseRatio;
        int days = goal.days;
        int weightLose;
        int muscleGain;

        if(planType == 0){
          muscleGain = goal.gainMuscle;
        }else if(planType == 1){
          weightLose = goal.weightLose;
        }
        //TODO: 发送后台创建计划
    });

    return PageView(
          scrollDirection: Axis.horizontal,
          reverse: false,
          controller: ctl,
          physics:NeverScrollableScrollPhysics(),
          pageSnapping: true,
          onPageChanged: (index) {
          },
          children: [
            plan,
            body,
            body2,
            goal
          ],
        );
  }
}
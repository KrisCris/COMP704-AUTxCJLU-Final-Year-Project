import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/DotBox.dart';

class GoalData extends StatelessWidget {
  double width;
  double height;
  double margin;
  Color backgroundColor;
  Color textColor;

  GoalData(
      {@required double width,
      @required double height,
      this.margin = 20,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.white}) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
  }
  @override
  Widget build(BuildContext context) {
    return DotColumn(
        width: this.width,
        height: this.height,
        borderRadius: 6,
        mainAxisAlignment: MainAxisAlignment.start,
        backgroundColor: this.backgroundColor,
        children: getGoal(User.getInstance()));
  }

  List<Widget> getGoal(User u) {
    List<Widget> goals = [
      SizedBox(height: margin),
      TitleText(
        text: "Plan Continues For " + u.plan.getKeepDays().toString() + " days",
        maxWidth: this.width - 2 * margin,
        maxHeight: 30,
        underLineDistance: 1,
        underLineLength: this.width * 2 / 3,
        fontColor: this.textColor,
        dividerColor: this.textColor,
        fontSize: 17,
      ),
      SizedBox(height: margin),
    ];
    List<Widget> weight = [SizedBox(height: 0)];
    if (u.plan.planType == 1) {
      weight = this.getLoseWeight(u);
    }else if(u.plan.planType == 2){
      weight = this.getMaintain(u);
    }else if(u.plan.planType == 3){
      //TODO: 增肌类型得数值表示暂时和maintain一样
      weight = this.getMaintain(u);
    }
    goals.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weight,
    ));
    goals.add(SizedBox(height: margin));
    return goals;
  }
  List<Widget> getMaintain(User u){
    List<Widget> weight = [];
    weight.add(Container(
      width: this.width  - margin*2,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "current weight",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color:this.textColor,
                decoration: TextDecoration.none),
          ),
          Text(
            u.bodyWeight.toString() + "   KG",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: this.textColor,
                decoration: TextDecoration.none),
          )
        ],
      ),
    ));
    return weight;
  }
  List<Widget> getLoseWeight(User u){
    List<Widget> weight = [];
    weight.add(Container(
      width: this.width / 3 - margin*2/3,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text(
            "current weight",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: this.textColor,
                decoration: TextDecoration.none),
          ),
          Text(
            u.bodyWeight.toString() + "   KG",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: this.textColor,
                decoration: TextDecoration.none),
          )
        ],
      ),
    ));
    weight.add(Container(
      width: this.width / 3 - margin*2/3,
      alignment:Alignment.center,
      child: Column(
        children: [
          Text(
            "goal weight",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: this.textColor,
                decoration: TextDecoration.none),
          ),
          Text(
            u.plan.goalWeight.toString() + "   KG",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: this.textColor,
                decoration: TextDecoration.none),
          )
        ],
      ),
    ));
    weight.add(Container(
      width: this.width / 3 - margin*2/3,
      alignment:Alignment.centerRight,
      child: Column(
        children: [
          Text(
            "remain weight",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: this.textColor,
                decoration: TextDecoration.none),
          ),
          Text(
            (u.bodyWeight - u.plan.goalWeight).toString() + "   KG",
            style: TextStyle(
                fontFamily: "Futura",
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: this.textColor,
                decoration: TextDecoration.none),
          )
        ],
      ),
    ));
    return weight;
  }
}

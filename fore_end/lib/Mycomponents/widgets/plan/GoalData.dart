import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';

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
      Color backgroundColor,
      Color textColor}) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    this.backgroundColor = backgroundColor ?? MyTheme.convert(ThemeColorName.ComponentBackground);
    this.textColor = textColor ?? MyTheme.convert(ThemeColorName.NormalText);
  }
  @override
  Widget build(BuildContext context) {
    return DotColumn(
        width: this.width,
        height: this.height,
        borderRadius: 6,
        mainAxisAlignment: MainAxisAlignment.start,
        backgroundColor: this.backgroundColor,
        children: getGoal(User.getInstance(),context));
  }

  List<Widget> getGoal(User u,BuildContext context) {
    List<Widget> goals = [
      SizedBox(height: margin),
      TitleText(
        text: CustomLocalizations.of(context).planKeep + u.plan.getKeepDays().toString() + CustomLocalizations.of(context).days,
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
      weight = this.getLoseWeight(u,context);
    }else if(u.plan.planType == 2){
      weight = this.getMaintain(u,context);
    }else if(u.plan.planType == 3){
      //TODO: 增肌类型得数值表示暂时和maintain一样
      weight = this.getMaintain(u,context);
    }
    goals.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weight,
    ));
    goals.add(SizedBox(height: margin));
    return goals;
  }
  List<Widget> getMaintain(User u, BuildContext context){
    List<Widget> weight = [];
    weight.add(Container(
      width: this.width  - margin*2,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            CustomLocalizations.of(context).currentWeight,
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
  List<Widget> getLoseWeight(User u, BuildContext context){
    List<Widget> weight = [];
    weight.add(Container(
      width: this.width / 3 - margin*2/3,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text(
            CustomLocalizations.of(context).currentWeight,
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
            CustomLocalizations.of(context).goalWeight,
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
            CustomLocalizations.of(context).remainWeight,
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

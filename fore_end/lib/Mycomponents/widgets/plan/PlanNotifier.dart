import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/DotBox.dart';

class PlanNotifier extends StatelessWidget {
  double width;
  double height;
  Color backgroundColor;
  PlanNotifier(
      {@required double width,
      @required double height,
      this.backgroundColor = Colors.white}) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
  }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    Plan p = u.plan;
    double barThickness = 15;
    ValueBar calories = ValueBar<double>(
      minVal: 0.0,
      maxVal: p.dailyCaloriesUpperLimit,
      adjustVal: 1.0,
      width: 0.7,
      borderThickness: 6,
      showDragHead: false,
      valuePosition: ValuePosition.right,
      borderRadius_RT_RB_RT_RB: [5, 5, 5, 5],
      roundNum: 1,
      initVal: 100,
      showBorder: false,
      showAdjustButton: false,
      showValue: true,
      unit: "/ " + p.dailyCaloriesUpperLimit.toString(),
      barColor: Color(0xFFAFEC71),
      fontColor: Color(0xFF5079AF),
      barThickness: barThickness,
    );
    List<Widget> content = [
      SizedBox(height: 40),
      Stack(
        children: [
          Row(
            children: [
              Transform.translate(
                  offset: Offset(
                      0, -barThickness - ValueBar.backgroundExtraSpace * 2),
                  child: TitleText(
                    text: "Today's Calories",
                    fontSize: 16,
                    underLineLength: 0,
                    maxHeight: 25,
                    maxWidth: 0.7,
                    fontColor: Color(0xFF5079AF),
                  ))
            ],
          ),
          calories
        ],
      ),
    ];
    if(true){
      ValueBar protein = ValueBar<double>(
        minVal: 0.0,
        maxVal: p.dailyProteinUpperLimit,
        adjustVal: 1.0,
        width: 0.7,
        borderThickness: 6,
        showDragHead: false,
        valuePosition: ValuePosition.right,
        borderRadius_RT_RB_RT_RB: [5, 5, 5, 5],
        roundNum: 1,
        initVal: 5,
        showBorder: false,
        showAdjustButton: false,
        showValue: true,
        unit: "/ " + p.dailyProteinUpperLimit.toString(),
        barColor: Color(0xFF72DEEF),
        fontColor: Color(0xFF5079AF),
        barThickness: barThickness,
      );
      content.addAll([
        SizedBox(height: 20),
        Stack(
          children: [
            Row(
              children: [
                Transform.translate(
                    offset: Offset(
                        0, -barThickness - ValueBar.backgroundExtraSpace * 2),
                    child: TitleText(
                      text: "Today's Protein",
                      fontSize: 16,
                      underLineLength: 0,
                      maxHeight: 25,
                      maxWidth: 0.7,
                      fontColor: Color(0xFF5079AF),
                    ))
              ],
            ),
            protein
          ],
        ),
      ]);
    }
    DotBox box = DotBox(
      width: this.width,
      height: this.height,
      borderRadius: 6,
      backgroundColor: this.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: content
      ),
    );
    return box;
  }
}

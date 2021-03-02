import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/DotBox.dart';

class PlanNotifier extends StatelessWidget {
  double width;
  double height;
  double margin;
  Color backgroundColor;
  PlanNotifier(
      {@required double width,
      @required double height,
      this.margin = 20,
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
      width: this.width - 2 * margin,
      borderThickness: 6,
      showDragHead: false,
      valuePosition: ValuePosition.right,
      borderRadius_RT_RB_RT_RB: [5, 5, 5, 5],
      roundNum: 1,
      initVal: 100,
      showBorder: false,
      couldExpand: true,
      showAdjustButton: false,
      showValue: true,
      unit: "/ " + p.dailyCaloriesUpperLimit.toString(),
      barColor: Color(0xFFAFEC71),
      fontColor: Color(0xFF5079AF),
      barThickness: barThickness,
    );
    List<Widget> content = [
      SizedBox(height: 20 + margin),
      Stack(
        children: [
          Row(
            children: [
              Transform.translate(
                  offset: Offset(
                      0, -barThickness - ValueBar.backgroundExtraSpace * 2),
                  child: TitleText(
                    text: "Today's Calories",
                    fontSize: 15,
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
    if (p.planType == 1) {
      ValueBar protein = ValueBar<double>(
        minVal: 0.0,
        maxVal: p.dailyProteinUpperLimit,
        adjustVal: 1.0,
        width: this.width - 2 * margin,
        borderThickness: 6,
        showDragHead: false,
        valuePosition: ValuePosition.right,
        borderRadius_RT_RB_RT_RB: [5, 5, 5, 5],
        roundNum: 1,
        initVal: 5,
        showBorder: false,
        showAdjustButton: false,
        couldExpand: true,
        showValue: true,
        unit: "/ " + p.dailyProteinUpperLimit.toString(),
        barColor: Color(0xFF72DEEF),
        fontColor: Color(0xFF5079AF),
        barThickness: barThickness,
      );
      content.addAll([
        SizedBox(height: 20 + this.margin),
        Stack(
          children: [
            Row(
              children: [
                Transform.translate(
                    offset: Offset(
                        0, -barThickness - ValueBar.backgroundExtraSpace * 2),
                    child: TitleText(
                      text: "Today's Protein",
                      fontSize: 15,
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
        SizedBox(height: this.margin)
      ]);
    }
    DotColumn box = DotColumn(
        width: this.width,
        height: this.height,
        borderRadius: 6,
        mainAxisAlignment: MainAxisAlignment.start,
        backgroundColor: this.backgroundColor,
        children: content);
    return box;
  }
}

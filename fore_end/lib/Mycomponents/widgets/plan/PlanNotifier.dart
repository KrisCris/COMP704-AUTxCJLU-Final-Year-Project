import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';

class PlanNotifier extends StatelessWidget {
  double width;
  double height;
  double margin;
  Color backgroundColor;
  Color effectColor;
  PlanNotifier(
      {@required double width,
      @required double height,
      this.margin = 20,
      Color backgroundColor,
        Color effectColor
      }) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    this.backgroundColor = backgroundColor ?? MyTheme.convert(ThemeColorName.ComponentBackground);
    this.effectColor = effectColor;
  }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    Plan p = u.plan;
    double barThickness = 15;
    ValueBar calories = ValueBar<int>(
      minVal: 0,
      maxVal: p.dailyCaloriesUpperLimit.floor(),
      adjustVal: 1,
      width: this.width - 2 * margin,
      borderThickness: 6,
      showDragHead: false,
      valuePosition: ValuePosition.right,
      borderRadius_RT_RB_RT_RB: [5, 5, 5, 5],
      roundNum: 1,
      initVal: u.getTodayCaloriesIntake(),
      showBorder: false,
      couldExpand: true,
      showAdjustButton: false,
      showValue: true,
      unit: "/ " + p.dailyCaloriesUpperLimit.floor().toString(),
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
                    text: CustomLocalizations.of(context).todayCal,
                    fontSize: 15,
                    underLineLength: 0,
                    maxHeight: 25,
                    maxWidth: 0.7,
                  ))
            ],
          ),
          calories
        ],
      ),
    ];
    if (p.planType == 3) {
      ValueBar protein = ValueBar<int>(
        minVal: 0,
        maxVal: p.dailyProteinUpperLimit.floor(),
        adjustVal: 1,
        width: this.width - 2 * margin,
        borderThickness: 6,
        showDragHead: false,
        valuePosition: ValuePosition.right,
        borderRadius_RT_RB_RT_RB: [5, 5, 5, 5],
        roundNum: 1,
        initVal: u.getTodayProteinIntake(),
        showBorder: false,
        showAdjustButton: false,
        couldExpand: true,
        showValue: true,
        unit: "/ " + p.dailyProteinUpperLimit.floor().toString(),
        barColor: Color(0xFF72DEEF),
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
                    ))
              ],
            ),
            protein
          ],
        ),
      ]);
    }
    content.add(SizedBox(height: this.margin));
    DotColumn box = DotColumn(
        width: this.width,
        height: this.height,
        borderRadius: 6,
        mainAxisAlignment: MainAxisAlignment.start,
        backgroundColor: this.backgroundColor,
        paintColor: this.effectColor,
        children: content);
    return box;
  }
}

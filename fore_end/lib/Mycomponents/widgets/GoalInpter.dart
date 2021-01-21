import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class GoalInputer extends StatefulWidget {
  Function nextDo;
  ValueNotifier<int> planType;
  int days;
  int weightLose;
  int gainMuscle;

  GoalInputer({this.nextDo}) {
    this.planType = ValueNotifier<int>(0);
  }
  void setNextDo(Function f) {
    this.nextDo = f;
  }

  @override
  State<StatefulWidget> createState() {
    return GoalInputerState();
  }
}

class GoalInputerState extends State<GoalInputer> {
  @override
  void didUpdateWidget(covariant GoalInputer oldWidget) {
    widget.planType = oldWidget.planType;
    widget.days = oldWidget.days;
    widget.gainMuscle = oldWidget.gainMuscle;
    widget.weightLose = oldWidget.weightLose;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    widget.planType.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomButton nextButton = CustomButton(
      theme: MyTheme.blueStyle,
      radius: 5,
      fontsize: 15,
      width: 0.8,
      height: 50,
      text: "Next Step",
      disabled: false,
      tapFunc: widget.nextDo,
    );
    return Stack(
      children: [
        this.getBackground(),
        Container(
          width: ScreenTool.partOfScreenWidth(1),
          height: ScreenTool.partOfScreenHeight(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
              this.getHeader(),
              SizedBox(height: 30),
              this.getContent(),
              Expanded(child: (SizedBox())),
              nextButton,
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }

  Widget getBackground() {
    return ClipRect(
      child: CustomPaint(
        foregroundPainter: LinePainter(
            color: Color(0xFF183F72), k: -1, lineWidth: 10, lineGap: 30),
        child: Container(
          width: ScreenTool.partOfScreenWidth(1),
          height: ScreenTool.partOfScreenHeight(1),
          color: Color(0xFF234C82),
        ),
      ),
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        Text("Set Your Goal",
            style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget getLoseWeightSetting() {
    ValueBar day = ValueBar<int>(
      barThickness: 20,
      width: 0.8,
      maxVal: 365,
      minVal: 1,
      initVal: 30,
      borderThickness: 4,
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
      borderRadius_RT_RB_RT_RB: [2, 2, 2, 2],
      edgeEmpty: [0, 0.95, 0, 0.95],
    );
    ValueBar weight = ValueBar<int>(
      barThickness: 20,
      width: 0.8,
      maxVal: 50,
      minVal: 1,
      initVal: 10,
      barColor: Color(0xFFEB9D33),
      effectColor: Color(0xFFECBC7B),
      borderThickness: 4,
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
      borderRadius_RT_RB_RT_RB: [2, 2, 2, 2],
      edgeEmpty: [0, 0.95, 0, 0.95],
    );
    day.setOnChange((){
      widget.days = day.widgetValue.value;
    });
    weight.setOnChange((){
      widget.weightLose = weight.widgetValue.value;
    });

    widget.days = day.widgetValue.value;
    widget.weightLose = weight.widgetValue.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
            Container(
              width: ScreenTool.partOfScreenWidth(0.55),
              height: 80,
              child: TitleText(
                text: "How Many Days Do You Want To Spend To Lose Your Weight?",
                maxWidth: 0.6,
                maxHeight: 50,
                underLineLength: 0,
              ),
            ),
          ],
        ),
        day,
        SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
            Container(
              width: ScreenTool.partOfScreenWidth(0.55),
              height: 80,
              child: TitleText(
                text: "How Much Weight Do You Want To Lose (KG) ?",
                maxWidth: 0.6,
                maxHeight: 50,
                underLineLength: 0,
              ),
            ),
          ],
        ),
        weight,
        SizedBox(height: 30)
      ],
    );
  }

  Widget getContent() {
    if (widget.planType.value == 0) {
    } else if (widget.planType.value == 1) {
      return getLoseWeightSetting();
    } else {}
  }
}

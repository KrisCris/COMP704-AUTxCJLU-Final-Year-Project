import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ExtraBodyDataInputer extends StatelessWidget {
  Function nextDo;
  double bodyHeight;
  int bodyWeight;

  ExtraBodyDataInputer({this.nextDo}) {
  }
  void setNextDo(Function f) {
    this.nextDo = f;
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
      tapFunc: this.nextDo,
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
              this.getSetting(),
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
        Text("A little More",
            style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget getSetting() {
    ValueBar height = ValueBar<double>(
      barThickness: 20,
      roundNum: 2,
      adjustVal: 0.1,
      width: 0.8,
      maxVal: 2.50,
      minVal: 1.00,
      initVal: 1.65,
      borderThickness: 4,
      barColor: Colors.white,
      effectColor: Color(0xFFBDBBBA),
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
    );

    ValueBar weight = ValueBar<int>(
      barThickness: 20,
      width: 0.8,
      maxVal: 200,
      minVal: 30,
      initVal: 50,
      barColor: Color(0xFFBCA5D6),
      effectColor: Color(0xFFA88EC6),
      borderThickness: 4,
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
      borderRadius_RT_RB_RT_RB: [2, 2, 2, 2],
      edgeEmpty: [0, 0.95, 0, 0.95],
    );
    height.setOnChange((){
      this.bodyHeight = height.getValue();
    });
    weight.setOnChange((){
      this.bodyWeight = weight.getValue();
    });
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
                text: "What Is Your Stature (meter) ?",
                maxWidth: 0.6,
                maxHeight: 50,
                underLineLength: 0,
              ),
            ),
          ],
        ),
        height,
        SizedBox(height: 80),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
            Container(
              width: ScreenTool.partOfScreenWidth(0.55),
              height: 80,
              child: TitleText(
                text: "What is Your Weight (KG) ?",
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

}
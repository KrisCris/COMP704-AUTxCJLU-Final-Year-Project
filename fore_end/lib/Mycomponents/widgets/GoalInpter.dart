import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';

class GoalInputer extends StatelessWidget{
  Function nextDo;
  int planType;

  GoalInputer({this.nextDo,this.planType});

  @override
  Widget build(BuildContext context) {
    CustomButton nextButton = CustomButton(
      theme: MyTheme.blueStyle,
      radius: 5,
      fontsize: 15,
      width: 0.8,
      height: 50,
      text: "Next Step",
      disabled: true,
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
              SizedBox(height: 10),

              Expanded(child: (SizedBox())),
              nextButton,
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
  Widget getBackground(){
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

  Widget getHeader(){
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

  Widget getLoseWeightSetting(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

      ],
    );
  }
}
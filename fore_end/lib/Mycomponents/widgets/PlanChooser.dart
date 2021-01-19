import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';

class PlanChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CrossFadeText info = CrossFadeText(
      text: "",
      fontSize: 14,
      fontColor: Colors.white,
    );
    CustomButton nextButton = CustomButton(
      theme: MyTheme.blueStyle,
      radius: 5,
      fontsize: 15,
      width: 0.8,
      height: 50,
      text: "Next Step",
      disabled: true,
    );
    CardChooser addMuscle = CardChooser(
      text: "Build Muscle",
      textColor: Colors.white,
      textSize: 15,
      paintColor: Color(0xFFB42626),
      backgroundColor: Color(0xFFF03838),
      width: ScreenTool.partOfScreenWidth(0.8),
      height: 80,
      borderRadius: 10,
    );
    CardChooser loseWeight = CardChooser(
      text: "Shed Weight",
      textColor: Colors.white,
      textSize: 15,
      paintColor: Color(0xFF1E9666),
      backgroundColor: Color(0xFF36BF88),
      width: ScreenTool.partOfScreenWidth(0.8),
      height: 80,
      borderRadius: 10,
    );
    CardChooser keep = CardChooser(
      text: "Maintain",
      textColor: Colors.white,
      textSize: 15,
      paintColor: Color(0xFF2978B6),
      backgroundColor: Color(0xFF3594DD),
      width: ScreenTool.partOfScreenWidth(0.8),
      height: 80,
      borderRadius: 10,
    );
    addMuscle.setOnTap(() {
      loseWeight.setUnChoosen();
      keep.setUnChoosen();
      nextButton.setDisabled(false);
      info.changeTo(
          "Eating more food with more protein and less carbohydrate. Sufficient exercise is the guarantee of gaining muscle");
    });
    loseWeight.setOnTap(() {
      addMuscle.setUnChoosen();
      keep.setUnChoosen();
      nextButton.setDisabled(false);
      info.changeTo(
          "Eating less food, reduce the amount of carbohydrate and fat in the food, keep exercises to burn the fat in the body");
    });
    keep.setOnTap(() {
      addMuscle.setUnChoosen();
      loseWeight.setUnChoosen();
      nextButton.setDisabled(false);
      info.changeTo(
          "Eating as what general people eat, not eat less deliberately or eat too much");
    });
    return Stack(
      children: [
        CustomPaint(
          foregroundPainter: LinePainter(
              color: Color(0xFF183F72), k: -1, lineWidth: 10, lineGap: 30),
          child: Container(
            width: ScreenTool.partOfScreenWidth(1),
            height: ScreenTool.partOfScreenHeight(1),
            color: Color(0xFF234C82),
          ),
        ),
        Container(
          width: ScreenTool.partOfScreenWidth(1),
          height: ScreenTool.partOfScreenHeight(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  Text("Choose Your Plan",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.55),
                    height: 80,
                    child: info,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addMuscle,
                  SizedBox(height: 20),
                  loseWeight,
                  SizedBox(height: 20),
                  keep,
                ],
              )),
              SizedBox(height: 50),
              nextButton,
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}

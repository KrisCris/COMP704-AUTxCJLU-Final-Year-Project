import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooserGroup.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class BodyDataInputer extends StatelessWidget {
  Function nextDo;
  double bodyHeight;
  int bodyWeight;
  int genderRatio;
  int gender;
  BodyDataInputer({this.nextDo});

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
      disabled: true,
      tapFunc: this.nextDo,
    );

    CardChooser male = CardChooser<int>(
      value: 5,
      text: "Male",
      textSize: 15,
      textColor: Colors.white,
      paintColor: Color(0xFF2978B6),
      backgroundColor: Color(0xFF3594DD),
      borderRadius: 10,
      width: 0.35,
      height: 70,
    );
    CardChooser female = CardChooser<int>(
      value: -161,
      text: "Female",
      textSize: 15,
      textColor: Colors.white,
      paintColor: Color(0xFFE15F5F),
      backgroundColor: Color(0xFFFF7979),
      borderRadius: 10,
      width: 0.35,
      height: 70,
    );
    ValueBar height = ValueBar<double>(
      barThickness: 14,
      roundNum: 2,
      adjustVal: 0.01,
      width: 0.8,
      valueName: "Height",
      unit: "m",
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
      barThickness: 14,
      width: 0.8,
      valueName: "Weight",
      unit: "KG",
      maxVal: 150,
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
    height.setOnChange(() {
      this.bodyHeight = height.getValue();
    });
    weight.setOnChange(() {
      this.bodyWeight = weight.getValue();
    });

    this.bodyHeight = height.getValue();
    this.bodyWeight = weight.getValue();

    CardChooserGroup<int> genderChoose = CardChooserGroup<int>(
      initVal: -1,
      cards: [male, female],
      direction: CardChooserGroupDirection.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: ScreenTool.partOfScreenWidth(0.1),
    );

    genderChoose.addValueChangeListener(() {
      if (genderChoose.getValue() >= 0) {
        this.genderRatio = genderChoose.getValue();
        if(this.genderRatio == 5){
          this.gender = 1;
        }else if(this.genderRatio == -161){
          this.gender = 2;
        }
        nextButton.setDisabled(false);
      }
    });

    return Stack(
      children: [
        ClipRect(
          child: CustomPaint(
            foregroundPainter: LinePainter(
                color: Color(0xFF183F72), k: -1, lineWidth: 10, lineGap: 30),
            child: Container(
              width: ScreenTool.partOfScreenWidth(1),
              height: ScreenTool.partOfScreenHeight(1),
              color: Color(0xFF234C82),
            ),
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
                  Text("We Need Collect Some Data",
                      style: TextStyle(
                          fontSize: 22,
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
                    width: ScreenTool.partOfScreenWidth(0.8),
                    height: 50,
                    child: Text(
                        "Please be relieved, these data will only be used as the figure support of daily energy intake.",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                    text: "Are You Male or Female ?",
                    maxHeight: 20,
                    maxWidth: 300,
                    underLineLength: 0.795,
                    fontSize: 18,
                    lineWidth: 5,
                    underLineDistance: 8,
                  )
                ],
              ),
              SizedBox(height: 30),
              CardChooserGroup<int>(
                initVal: -1,
                cards: [male, female],
                direction: CardChooserGroupDirection.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: ScreenTool.partOfScreenWidth(0.1),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                      text: "What Is Your Stature And Weight ?",
                      maxWidth: 0.6,
                      maxHeight: 40,
                      fontSize: 18,
                      lineWidth: 5,
                      underLineLength: 0.8,
                      underLineDistance: 8),
                ],
              ),
              SizedBox(height: 60),
              height,
              SizedBox(height: 30),
              weight,
              Expanded(child: (SizedBox())),
              nextButton,
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooserGroup.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ExtraBodyDataInputer extends StatelessWidget {
  Function nextDo;
  double exerciseRatio;
  int age;

  ExtraBodyDataInputer({this.nextDo}) {}
  void setNextDo(Function f) {
    this.nextDo = f;
  }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();

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
    ValueBar age = ValueBar<int>(
      barThickness: 14,
      roundNum: 2,
      adjustVal: 1,
      valueName: "Age",
      unit: "Years old",
      width: 0.8,
      maxVal: 100,
      minVal: 1,
      initVal: u.age == null?18:u.age,
      borderThickness: 4,
      barColor: Color(0xFF82BFFC),
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
    );
    ValueBar exerciseChoise = ValueBar<double>(
      adjustVal: 1,
      width: 0.8,
      barThickness: 14,
      minVal: 0,
      maxVal: 100,
      initVal: 1,
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
      mapper: {
        1.4: "very light",
        1.5: "light",
        1.7: "moderate",
        1.9: "active",
        2.1: "very active",
        2.3: "heavy"
      },
      barColor: Color(0xFF824682),
    );
    CrossFadeText describeText = CrossFadeText(
      text: "",
      fontSize: 15,
      fontColor: Colors.white,
    );
    exerciseChoise.setOnChange(() {
      this.exerciseRatio = exerciseChoise.widgetValue.value;
      if (exerciseChoise.widgetValue.value == 1.4) {
        describeText.changeTo(
            "Sitting at the computer most of the day, or sitting at a desk. Almost no activity at all.");
      } else if (exerciseChoise.widgetValue.value == 1.5) {
        describeText.changeTo(
            "Light industrial work, sales or office work that comprises light activities. Walking, non-strenuous cycling or gardening approximately once a week.");
      } else if (exerciseChoise.widgetValue.value == 1.7) {
        describeText.changeTo(
            "Regular activity at least once a week. Cleaning, kitchen staff, or delivering mail on foot or by bicycle.");
      } else if (exerciseChoise.widgetValue.value == 1.9) {
        describeText.changeTo(
            "Regular activities more than once a week, e.g., intense walking, bicycling or sports.");
      } else if (exerciseChoise.widgetValue.value == 2.1) {
        describeText.changeTo("Strenuous activities several times a week.");
      } else if (exerciseChoise.widgetValue.value == 2.3) {
        describeText
            .changeTo("Heavy industrial work, construction work or farming.");
      }
    });
    age.setOnChange(() {
      this.age = age.getValue();
    });
    this.age = age.getValue();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                    text: "What Is Your Age ?",
                    maxHeight: 25,
                    maxWidth: 250,
                    underLineLength: 0.795,
                    fontSize: 18,
                    lineWidth: 5,
                    underLineDistance: 8,
                  )
                ],
              ),
              SizedBox(height: 45),
              age,
              SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                    text: "How Do You Exercise?",
                    maxHeight: 25,
                    maxWidth: 250,
                    underLineLength: 0.795,
                    fontSize: 18,
                    lineWidth: 5,
                    underLineDistance: 8,
                  )
                ],
              ),
              SizedBox(height: 50),
              exerciseChoise,
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.8),
                    height: 100,
                    child: describeText,
                  ),
                ],
              ),
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
      child: Container(
          width: ScreenTool.partOfScreenWidth(1),
          height: ScreenTool.partOfScreenHeight(1),
          color: Color(0xFF172632)
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
                fontFamily: "Futura",
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

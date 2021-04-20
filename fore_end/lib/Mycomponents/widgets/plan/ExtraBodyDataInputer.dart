import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ExtraBodyDataInputer extends StatelessWidget {
  Function nextDo;
  double exerciseRatio;
  int age;
  GlobalKey<CrossFadeTextState> txt = new GlobalKey<CrossFadeTextState>();

  ExtraBodyDataInputer({this.nextDo}) {}
  void setNextDo(Function f) {
    this.nextDo = f;
  }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();

    CustomButton nextButton = CustomButton(
      radius: 5,
      fontsize: 15,
      width: 0.8,
      height: 50,
      text: CustomLocalizations.of(context).next,
      disabled: false,
      tapFunc: this.nextDo,
    );
    ValueBar age = ValueBar<int>(
      barThickness: 14,
      roundNum: 2,
      adjustVal: 1,
      valueName: CustomLocalizations.of(context).age,
      unit: CustomLocalizations.of(context).yearOld,
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
        1.4: CustomLocalizations.of(context).veryLight,
        1.5: CustomLocalizations.of(context).light,
        1.7: CustomLocalizations.of(context).moderate,
        1.9: CustomLocalizations.of(context).active,
        2.1: CustomLocalizations.of(context).veryActive,
        2.3: CustomLocalizations.of(context).heavy
      },
      barColor: Color(0xFF824682),
    );
    exerciseChoise.setOnChange(() {
      this.exerciseRatio = exerciseChoise.widgetValue.value;
      CrossFadeTextState stt = this.txt.currentState;
      if (exerciseChoise.widgetValue.value == 1.4) {
        stt.changeTo(CustomLocalizations.of(context).veryLightInfo);
      } else if (exerciseChoise.widgetValue.value == 1.5) {
        stt.changeTo(CustomLocalizations.of(context).lightInfo);
      } else if (exerciseChoise.widgetValue.value == 1.7) {
        stt.changeTo(CustomLocalizations.of(context).moderateInfo);
      } else if (exerciseChoise.widgetValue.value == 1.9) {
        stt.changeTo(CustomLocalizations.of(context).activeInfo);
      } else if (exerciseChoise.widgetValue.value == 2.1) {
        stt.changeTo(CustomLocalizations.of(context).veryActiveInfo);
      } else if (exerciseChoise.widgetValue.value == 2.3) {
        stt.changeTo(CustomLocalizations.of(context).heavyInfo);
      }
    });
    CrossFadeText describeText = CrossFadeText(
      text: "",
      fontSize: 15,
      fontColor: Colors.white,
      key: txt,
      onStateInitDone: (Duration timeStamp){
        CrossFadeTextState stt = this.txt.currentState;
        if (exerciseChoise.widgetValue.value == 1.4) {
          stt.changeTo(CustomLocalizations.of(context).veryLightInfo);
        } else if (exerciseChoise.widgetValue.value == 1.5) {
          stt.changeTo(CustomLocalizations.of(context).lightInfo);
        } else if (exerciseChoise.widgetValue.value == 1.7) {
          stt.changeTo(CustomLocalizations.of(context).moderateInfo);
        } else if (exerciseChoise.widgetValue.value == 1.9) {
          stt.changeTo(CustomLocalizations.of(context).activeInfo);
        } else if (exerciseChoise.widgetValue.value == 2.1) {
          stt.changeTo(CustomLocalizations.of(context).veryActiveInfo);
        } else if (exerciseChoise.widgetValue.value == 2.3) {
          stt.changeTo(CustomLocalizations.of(context).heavyInfo);
        }
      }
    );
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
              this.getHeader(context),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                    text: CustomLocalizations.of(context).ageQuestion,
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
                    text: CustomLocalizations.of(context).exerciseQuestion,
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

  Widget getHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        Text(CustomLocalizations.of(context).littleMore,
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

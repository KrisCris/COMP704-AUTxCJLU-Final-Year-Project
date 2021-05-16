import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Models/User.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/CardChooser.dart';
import 'package:fore_end/Components/buttons/CardChooserGroup.dart';
import 'package:fore_end/Components/buttons/CustomButton.dart';
import 'package:fore_end/Components/input/ValueBar.dart';
import 'package:fore_end/Components/texts/TitleText.dart';

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
    User u = User.getInstance();
    if (u.gender != null) {
      this.gender = u.gender;
      this.genderRatio = u.gender == 1 ? 5 : -161;
    }
    CustomButton nextButton = CustomButton(
      radius: 5,
      fontsize: 15,
      width: 0.8,
      height: 50,
      text: CustomLocalizations.of(context).next,
      disabled: u.gender == null,
      tapFunc: this.nextDo,
    );

    CardChooser male = CardChooser<int>(
      value: 5,
      text: CustomLocalizations.of(context).male,
      isChosen: u.gender == null
          ? false
          : u.gender == 1
              ? true
              : false,
      textSize: 15,
      textColor: Colors.white,
      backgroundColor: Color(0xFF3594DD),
      borderRadius: 10,
      width: 0.35,
      height: 70,
    );
    CardChooser female = CardChooser<int>(
      value: -161,
      text: CustomLocalizations.of(context).female,
      textSize: 15,
      isChosen: u.gender == null
          ? false
          : u.gender == 2
              ? true
              : false,
      textColor: Colors.white,
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
      valueName: CustomLocalizations.of(context).height,
      unit: "m",
      maxVal: 2.50,
      minVal: 1.00,
      initVal: u.bodyHeight == null ? 1.65 : u.bodyHeight,
      borderThickness: 4,
      barColor: Colors.white,
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
    );

    ValueBar weight = ValueBar<int>(
      barThickness: 14,
      width: 0.8,
      valueName: CustomLocalizations.of(context).weight,
      unit: "KG",
      maxVal: 150,
      minVal: 30,
      initVal: u.bodyWeight == null ? 50 : u.bodyWeight.floor(),
      adjustVal: 1,
      barColor: Color(0xFFBCA5D6),
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
        if (this.genderRatio == 5) {
          this.gender = 1;
        } else if (this.genderRatio == -161) {
          this.gender = 2;
        }
        nextButton.setDisabled(false);
      }
    });

    return Stack(
      children: [
        ClipRect(
          child: Container(
              width: ScreenTool.partOfScreenWidth(1),
              height: ScreenTool.partOfScreenHeight(1),
              color: Color(0xFF172632)),
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
                  Container(
                    // height: 80,
                    width: ScreenTool.partOfScreenWidth(0.8),
                    child: Text(CustomLocalizations.of(context).collectBodyData,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: "Futura",
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.8),
                    height: 80,
                    child: Text(
                        CustomLocalizations.of(context).collectBodyDataInfo,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "Futura",
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
                    text: CustomLocalizations.of(context).genderQuestion,
                    maxHeight: 30,
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
                      text: CustomLocalizations.of(context).bodyDataQuestion,
                      maxWidth: 0.8,
                      maxHeight: 35,
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

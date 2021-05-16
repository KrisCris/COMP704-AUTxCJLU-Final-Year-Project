import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/CardChooser.dart';
import 'package:fore_end/Components/buttons/CardChooserGroup.dart';
import 'package:fore_end/Components/buttons/CustomButton.dart';
import 'package:fore_end/Components/texts/CrossFadeText.dart';

class PlanChooser extends StatelessWidget {
  Function nextDo;
  int planType;
  GlobalKey<CrossFadeTextState> txt = new GlobalKey<CrossFadeTextState>();
  PlanChooser({this.nextDo});

  void setNextDo(Function f) {
    this.nextDo = f;
  }

  @override
  Widget build(BuildContext context) {
    CrossFadeText info = CrossFadeText(
      text: "",
      fontSize: 14,
      fontColor: Colors.white,
      key: txt,
    );
    CustomButton nextButton = CustomButton(
      radius: 5,
      fontsize: 15,
      width: 0.8,
      height: 50,
      text: CustomLocalizations.of(context).next,
      disabled: true,
      tapFunc: this.nextDo,
    );
    CardChooser addMuscle = CardChooser<int>(
      value: 3,
      text: CustomLocalizations.of(context).getContent("buildMuscle"),
      textColor: Colors.white,
      textSize: 15,
      backgroundColor: Color(0xFFF03838),
      width: ScreenTool.partOfScreenWidth(0.8),
      height: 80,
      borderRadius: 10,
    );
    CardChooser loseWeight = CardChooser<int>(
      value: 1,
      text: CustomLocalizations.of(context).getContent("shedWeight"),
      textColor: Colors.white,
      textSize: 15,
      backgroundColor: Color(0xFF36BF88),
      width: ScreenTool.partOfScreenWidth(0.8),
      height: 80,
      borderRadius: 10,
    );
    CardChooser keep = CardChooser<int>(
      value: 2,
      text: CustomLocalizations.of(context).getContent("maintain"),
      textColor: Colors.white,
      textSize: 15,
      backgroundColor: Color(0xFF3594DD),
      width: ScreenTool.partOfScreenWidth(0.8),
      height: 80,
      borderRadius: 10,
    );
    addMuscle.setOnTap(() {
      txt.currentState
          .changeTo(CustomLocalizations.of(context).buildMuscleInfo);
    });
    loseWeight.setOnTap(() {
      txt.currentState.changeTo(CustomLocalizations.of(context).shedWeightInfo);
    });
    keep.setOnTap(() {
      txt.currentState.changeTo(CustomLocalizations.of(context).maintainInfo);
    });
    CardChooserGroup<int> group = CardChooserGroup<int>(
      initVal: -1,
      cards: [addMuscle, loseWeight, keep],
      direction: CardChooserGroupDirection.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 20.0,
    );
    group.addValueChangeListener(() {
      this.planType = group.getValue();
      if (group.getValue() >= 0) {
        nextButton.setDisabled(false);
      }
    });
    return Stack(
      children: [
        ClipRect(
          child: Container(
            width: ScreenTool.partOfScreenWidth(1),
            height: ScreenTool.partOfScreenHeight(1),
            color: Color(0xFF172632),
          ),
        ),
        Container(
          width: ScreenTool.partOfScreenWidth(1),
          height: ScreenTool.partOfScreenHeight(1),
          child: Column(
            children: [
              SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  Text(CustomLocalizations.of(context).choosePlan,
                      style: TextStyle(
                          fontSize: 28,
                          fontFamily: "Futura",
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
                    width: ScreenTool.partOfScreenWidth(0.75),
                    height: 75,
                    child: info,
                  ),
                ],
              ),
              SizedBox(height: ScreenTool.partOfScreenHeight(0.03)),
              Expanded(child: group),
              SizedBox(height: 10),
              nextButton,
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooserGroup.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';

class PlanChooser extends StatelessWidget {
  Function nextDo;
  int planType;

  PlanChooser({this.nextDo});

  void setNextDo(Function f){
    this.nextDo = f;
  }

  @override
  Widget build(BuildContext context) {
    CrossFadeText info = CrossFadeText(
      text: "",
      fontSize: 14,
      fontColor: Colors.white,
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
      info.changeTo(
          CustomLocalizations.of(context).buildMuscleInfo);
    });
    loseWeight.setOnTap(() {
      info.changeTo(
          CustomLocalizations.of(context).shedWeightInfo);
    });
    keep.setOnTap(() {
      info.changeTo(CustomLocalizations.of(context).maintainInfo);
    });
    CardChooserGroup<int> group = CardChooserGroup<int>(
      initVal: -1,
      cards: [
        addMuscle,
        loseWeight,
        keep
      ],
      direction: CardChooserGroupDirection.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 20.0,
    );
    group.addValueChangeListener((){
      this.planType = group.getValue();
      if(group.getValue() >=0){
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
            mainAxisAlignment: MainAxisAlignment.start,
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
              Expanded(
                  child: group
              ),
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

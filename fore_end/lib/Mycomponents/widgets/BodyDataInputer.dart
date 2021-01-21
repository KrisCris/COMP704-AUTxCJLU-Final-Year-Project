import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooserGroup.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class BodyDataInputer extends StatelessWidget {
  Function nextDo;

  BodyDataInputer({this.nextDo});

  void setNextDo(Function f){
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
      value: 1,
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
    CardChooser noExercise = CardChooser<double>(
      value: 1.3,
      text: "I hardly do exercise.",
      textSize: 14,
      textColor: Colors.white,
      paintColor: Color(0xFFB4A122),
      backgroundColor: Color(0xFFD1BC2C),
      borderRadius: 6,
      width: 0.8,
      height: 40,
    );
    CardChooser haveExercise = CardChooser<double>(
      value: 1.55,
      text: "I did exercise regularly.",
      textSize: 14,
      textColor: Colors.white,
      paintColor: Color(0xFFBD7E28),
      backgroundColor: Color(0xFFD38F33),
      borderRadius: 6,
      width: 0.8,
      height: 40,
    );
    CardChooser lotExercise = CardChooser<double>(
      value: 1.8,
      text: "I am professional athletes.",
      textSize: 14,
      textColor: Colors.white,
      paintColor: Color(0xFFCE602A),
      backgroundColor: Color(0xFFE66D32),
      borderRadius: 6,
      width: 0.8,
      height: 40,
    );

    CardChooserGroup<int> genderChoose = CardChooserGroup<int>(
      initVal: -1,
      cards: [male, female],
      direction: CardChooserGroupDirection.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: ScreenTool.partOfScreenWidth(0.1),
    );
    CardChooserGroup<double> exerciseChoose = CardChooserGroup<double>(
      initVal: -1,
      cards: [noExercise, haveExercise,lotExercise],
      direction: CardChooserGroupDirection.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 20.0,
    );
    genderChoose.addValueChangeListener((){
      if(exerciseChoose.getValue() >= 0 && genderChoose.getValue() >= 0){
        nextButton.setDisabled(false);
      }
    });
    exerciseChoose.addValueChangeListener((){
      if(exerciseChoose.getValue() >= 0 && genderChoose.getValue() >= 0){
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
                    width: ScreenTool.partOfScreenWidth(0.55),
                    height: 70,
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
                )],
              ),
              SizedBox(height: 30),
              CardChooserGroup<int>(
                initVal: -1,
                cards: [male, female],
                direction: CardChooserGroupDirection.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: ScreenTool.partOfScreenWidth(0.1),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                    text: "How Do You Exercise?",
                    maxHeight: 20,
                    maxWidth: 250,
                    underLineLength: 0.795,
                    fontSize: 18,
                    lineWidth: 5,
                    underLineDistance: 8,
                  )],
              ),
              SizedBox(height: 30),
              CardChooserGroup<double>(
                initVal: -1,
                cards: [noExercise, haveExercise,lotExercise],
                direction: CardChooserGroupDirection.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: 20.0,
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
}

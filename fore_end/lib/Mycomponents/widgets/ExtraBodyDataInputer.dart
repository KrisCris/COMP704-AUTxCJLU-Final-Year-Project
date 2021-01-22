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

class ExtraBodyDataInputer extends StatelessWidget {
  Function nextDo;
  double exerciseRatio;
  int age;

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
      disabled: true,
      tapFunc: this.nextDo,
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
      height: 50,
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
      height: 50,
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
      height: 50,
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
      initVal: 10,
      borderThickness: 4,
      barColor: Color(0xFF82BFFC),
      effectColor: Color(0xFF4EA5FC),
      showValue: true,
      showAdjustButton: true,
      showBorder: false,
    );
    age.setOnChange((){
      this.age = age.getValue();
    });
    this.age = age.getValue();
    CardChooserGroup<double> exerciseChoose = CardChooserGroup<double>(
      initVal: -1,
      cards: [noExercise, haveExercise,lotExercise],
      direction: CardChooserGroupDirection.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      gap: 25.0,
    );
    exerciseChoose.addValueChangeListener((){
      if(exerciseChoose.getValue() >= 0){
        this.exerciseRatio = exerciseChoose.getValue();
        nextButton.setDisabled(false);
      }
    });
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
                  )],
              ),
              SizedBox(height: 45),
              age,
              SizedBox(height: 40),
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
              SizedBox(height: 40),
              exerciseChoose,
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
}
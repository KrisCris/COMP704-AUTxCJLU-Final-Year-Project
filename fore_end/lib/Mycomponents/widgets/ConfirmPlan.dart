import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ConfirmPlan extends StatelessWidget {
  Function nextDo;
  Function backDo;

  String planType;
  int planTypeNum;
  double dailyCalories;
  double dailyCaloriesAfterDone;
  double keepCalories;
  bool isTooLow;

  ConfirmPlan({this.nextDo, this.backDo});

  void setNextDo(Function f) {
    this.nextDo = f;
  }
  void setBackDo(Function f){
    this.backDo = f;
  }
  void setPlanType(int type){
    this.planTypeNum = type;
    if(type == 1){
      this.planType = "shed Weight";
    }else if(type == 2){
      this.planType = "maintain";
    }else if(type == 3){
      this.planType = "build muscle";
    }else{
      this.planType = "none";
    }
  }
  void setCalories(double goalCal, double goalMaintainCal, double maintainCal, bool low){
    this.dailyCalories = goalCal;
    this.dailyCaloriesAfterDone = goalMaintainCal;
    this.keepCalories = maintainCal;
    this.isTooLow = low;
  }
  @override
  Widget build(BuildContext context) {
    CustomButton nextButton = CustomButton(
      theme: MyTheme.blueStyle,
      radius: 5,
      fontsize: 15,
      width: 0.35,
      height: 50,
      text: "Create Plan",
      disabled: false,
      tapFunc: this.nextDo,
    );

    CustomButton backButton = CustomButton(
      theme: MyTheme.blueStyle,
      radius: 5,
      firstThemeState: ComponentThemeState.error,
      fontsize: 15,
      width: 0.35,
      height: 50,
      text: "Adjust Plan",
      disabled: false,
      tapFunc: this.backDo,
    );

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
                  Text("Here is Your Plan",
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
                  TitleText(
                    text: "Your Plan is " + this.planType,
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
              this.getContent(),
              Expanded(child: (SizedBox())),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  backButton,
                  Expanded(child:SizedBox()),
                  nextButton,
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
  Widget getContent(){
    if(this.planTypeNum == 1){
      return this.getLoseWeight();
    }else if(this.planTypeNum == 2){
      //TODO:返回保持身材情况的plan预览
    }else if(this.planTypeNum == 3){
      //TODO: 返回增肌身材情况的plan预览
    }else{

    }
  }
  Widget getLoseWeight(){
    Widget isTooLow =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "Your plan is " + (this.isTooLow?"unbalanced, you will eat not enough":"balanced"),
          maxHeight: 50,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 0,
          underLineDistance: 8,
        )
      ],
    );
    Widget daily =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "You should eat less than " + this.dailyCalories.toString()+" Calories every day",
          maxHeight: 50,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 8,
        )
      ],
    );
    Widget done =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "After complete your goal, you should not eat more than " + this.dailyCaloriesAfterDone.toString()+" Calories every day to maintian your weight",
          maxHeight: 50,
          maxWidth: 300,
          underLineLength: 0.795,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 12,
        )
      ],
    );
    return Column(
      children: [
        isTooLow,
        daily,
        done
      ],
    );
  }
}
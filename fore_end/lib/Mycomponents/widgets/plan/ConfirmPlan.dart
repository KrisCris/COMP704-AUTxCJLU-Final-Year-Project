import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/text/ValueText.dart';

class ConfirmPlan extends StatelessWidget {
  Function nextDo;
  Function backDo;

  String planType;
  int planTypeNum;
  double dailyCalories;
  double dailyCaloriesAfterDone;
  double dailyProteinL;
  double dailyProteinH;
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
  void setNutrition(double goalCal, double goalMaintainCal, double maintainCal, double proteinL, double proteinH,bool low){
    this.dailyCalories = goalCal;
    this.dailyCaloriesAfterDone = goalMaintainCal;
    this.dailyProteinL = proteinL;
    this.dailyProteinH = proteinH;
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
                  Text("Here is Your Plan",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontFamily: "Futura",
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
                  TitleText(
                    text: "Your Plan is " + this.planType,
                    maxHeight: 25,
                    maxWidth: 300,
                    underLineLength: 0.795,
                    fontSize: 18,
                    lineWidth: 3,
                    underLineDistance: 8,
                  )
                ],
              ),
              SizedBox(height: 30),
              this.isTooLow?isTooLow:SizedBox(height: 0),
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
      return this.getMaintain();
    }else if(this.planTypeNum == 3){
      return this.getBuildMuscle();
    }else{

    }
  }
  Widget getMaintain(){
    Widget dailyCal =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "To maintain your body shape, the recommended daily calories  intake is",
          maxHeight: 60,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 8,
        )
      ],
    );
    Widget dailyCalVal = ValueText<int>(
      numUpper: this.dailyCalories.floor(),
      unit: "KCal",
      rowMainAxisAlignment: MainAxisAlignment.center,
      valueFontSize: 23,
      unitFontSize: 14,
      fontColor: Color(0xFFE28800),
    );
    List<Widget> content = [];
    content.addAll([
      dailyCal,
      SizedBox(height: 20),
      Container(
        width: ScreenTool.partOfScreenWidth(0.8),
        height: 70,
        margin: EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: dailyCalVal,
      ),
      SizedBox(height: 20),
    ]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: content
    );
  }
  Widget getBuildMuscle(){
    Widget dailyCal =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "To achieve the goal, the recommended daily calories  intake is around ",
          maxHeight: 50,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 8,
        )
      ],
    );
    Widget dailyPro =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "To achieve the goal, the recommended daily protein intake is around ",
          maxHeight: 50,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 8,
        )
      ],
    );
    Widget dailyCalVal = ValueText<int>(
      numUpper: this.dailyCalories.floor(),
      unit: "KCal",
      rowMainAxisAlignment: MainAxisAlignment.center,
      valueFontSize: 23,
      unitFontSize: 14,
      fontColor: Color(0xFFE28800),
    );
    Widget dailyProVal = ValueText<int>(
      numLower: this.dailyProteinL.floor(),
      numUpper: this.dailyProteinH.floor(),
      unit: "gram",
      rowMainAxisAlignment: MainAxisAlignment.center,
      valueFontSize: 23,
      unitFontSize: 14,
      fontColor: Color(0xFFE28800),
    );
    List<Widget> content = [];
    content.addAll([
      dailyCal,
      SizedBox(height: 20),
      Container(
        width: ScreenTool.partOfScreenWidth(0.8),
        height: 70,
        margin: EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: dailyCalVal,
      ),
      SizedBox(height: 20),
      dailyPro,
      SizedBox(height: 20),
      Container(
        width: ScreenTool.partOfScreenWidth(0.8),
        height: 70,
        margin: EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: dailyProVal,
      ),
    ]);
    return Column(
        children: content
    );
  }
  Widget getLoseWeight(){
    Widget daily =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "To achieve the goal, the recommended daily calories intake is around ",
          maxHeight: 50,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 8,
        )
      ],
    );
    Widget dailyVal = ValueText<int>(
      numUpper: this.dailyCalories.floor(),
      unit: "KCal",
      rowMainAxisAlignment: MainAxisAlignment.center,
      valueFontSize: 23,
      unitFontSize: 14,
      fontColor: Color(0xFFE28800),
    );
    Widget done =Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.1)),
        TitleText(
          text: "After complete your goal, to maintian your weight, the recommended daily calories intake is around",
          maxHeight: 80,
          maxWidth: 300,
          underLineLength: 0,
          fontSize: 15,
          lineWidth: 5,
          underLineDistance: 12,
        )
      ],
    );
    Widget doneVal = ValueText<int>(
      numUpper: this.dailyCaloriesAfterDone.floor(),
      unit: "KCal",
      rowMainAxisAlignment: MainAxisAlignment.center,
      valueFontSize: 23,
      unitFontSize: 14,
      fontColor: Color(0xFFE28800),
    );
    List<Widget> content = [];
    content.addAll([
      daily,
      SizedBox(height: 20),
      Container(
        width: ScreenTool.partOfScreenWidth(0.8),
        height: 70,
        margin: EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: dailyVal,
      ),
      SizedBox(height: 20),
      done,
      SizedBox(height: 20),
      Container(
        width: ScreenTool.partOfScreenWidth(0.8),
        height: 70,
        margin: EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          color: Color(0xCCFFFFFF),
          borderRadius: BorderRadius.circular(5),
        ),
        child: doneVal,
      ),
    ]);

    return Column(
      children: content
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/plan/GoalData.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanNotifier.dart';

class DietPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
      return new DietPageState();
  }
  
}

class DietPageState extends State<DietPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: "Plan Progress",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.95,
                maxHeight: 30,
              ),
            ],
          ),
          SizedBox(height: 5),
          PlanNotifier(width: 0.95, height: 100,backgroundColor: Color(0xFF1F405A),effectColor: Colors.black12,),
          Expanded(child:SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: "Today's Meal",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.95,
                maxHeight: 30,
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            width: ScreenTool.partOfScreenWidth(0.95),
            height: 220,
            child: MealListUI(
                backgroundColor:Color(0xFF1F405A),
                textColor:Color(0xFFD1D1D1),
                unitColor:Color(0xFFD1D1D1),
                iconColor:Color(0xFFD1D1D1)),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
  
}
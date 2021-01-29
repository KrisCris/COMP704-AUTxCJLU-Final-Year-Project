import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
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
          GoalData(width: 0.95, height: 100,backgroundColor:Color(0xFFF1F1F1)),
          SizedBox(height: 10),
          PlanNotifier(width: 0.95, height: 100,backgroundColor: Color(0xFFF1F1F1)),
          SizedBox(height: 10,),
          Container(
            width: ScreenTool.partOfScreenWidth(0.95),
            height: 220,
            child: MealListUI(),
          ),
        ],
      ),
    );
  }
  
}
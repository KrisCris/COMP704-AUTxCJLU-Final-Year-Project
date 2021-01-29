import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/plan/GoalData.dart';

class PlanDetailPage extends StatelessWidget{
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
                text: "Your Plan",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.475,
                maxHeight: 30,
              ),
            ],
          ),
          SizedBox(height: 5),
          GoalData(width: 0.95, height: 100,backgroundColor: Color(0xFF1F405A),textColor:Color(0xFFD1D1D1),),
        ],
      ),
    );
  }

}
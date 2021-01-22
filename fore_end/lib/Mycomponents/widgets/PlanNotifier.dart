import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/DotBox.dart';

class PlanNotifier extends StatelessWidget{
  double width;
  double height;
  PlanNotifier({@required double width, @required double height}){
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
  }

  @override
  Widget build(BuildContext context) {
      //User u = User.getInstance();
      //Plan p = u.plan;
      ValueBar calories = ValueBar<double>(
        minVal: 0.0,
        maxVal: 4200.0,
        width: 0.7,
        borderThickness: 6,
        showDragHead: false,
        valuePosition: ValuePosition.right,
        borderRadius_RT_RB_RT_RB: [5,5,5,5],
        roundNum: 1,
        initVal: 1259,
        showBorder: false,
        showAdjustButton: false,
        showValue: true,
        unit: "/ "+4200.toString(),
        barColor: Color(0xFFAFEC71),
        effectColor: Color(0xFF99D45F),
        fontColor: Color(0xFF5079AF),
        barThickness: 15,
      );
      DotBox box = DotBox(
        width: this.width,
        height: this.height,
        borderRadius: 6,
        backgroundColor: Color(0xFFF3F3F3),
        paintColor: Color(0xFFDCDDDF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 26),
            Stack(
              children: [
                Row(
                  children:[
                    Transform.translate(
                      offset: Offset(0,-2),
                      child:TitleText(
                        text: "Today's Calories",
                        fontSize: 18,
                        underLineLength: 0,
                        maxWidth: 0.7,
                        fontColor: Color(0xFF5079AF),
                      )
                    )
                  ],
                ),
                calories
              ],
            )
          ],
        ),
      );
      return box;
  }
  
}
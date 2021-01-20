import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/widgets/BodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/PlanChooser.dart';

class GuidePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    PageController ctl = PageController(
      initialPage: 0,
      keepPage: true,
    );
    return PageView(
          scrollDirection: Axis.horizontal,
          reverse: false,
          controller: ctl,
          physics:NeverScrollableScrollPhysics(),
          pageSnapping: true,
          onPageChanged: (index) {
          },
          children: [
            PlanChooser(nextDo: (){
              ctl.animateTo(ScreenTool.partOfScreenWidth(1), duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
            },),
            BodyDataInputer()
          ],
        );
  }
}
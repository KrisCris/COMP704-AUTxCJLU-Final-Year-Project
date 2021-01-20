import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/BodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/PlanChooser.dart';

class ComponentTestPage extends StatelessWidget {
  var _value;
  @override
  Widget build(BuildContext context) {
    PageController ctl = PageController(
      initialPage: 0,
      keepPage: true,
    );
    return BackGround(
        sigmaY: 10,
        sigmaX: 10,
        opacity: 0.7,
        child: PageView(
          scrollDirection: Axis.horizontal,
          reverse: false,
          controller: ctl,
          physics:NeverScrollableScrollPhysics(),
          pageSnapping: true,
          onPageChanged: (index) {
            //监听事件
            print('index=====$index');
          },
          children: [
            PlanChooser(nextDo: (){
              ctl.animateTo(ScreenTool.partOfScreenWidth(1), duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
            },),
            BodyDataInputer()
          ],
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueBar<int>(
              barThickness: 20,
              borderThickness: 4,
              width: 0.7,
              initVal: 20,
              showValue: true,
              showAdjustButton: false,
              borderDistance: 1,
              borderRadius_RT_RB_RT_RB: [2,2,2,2],
              edgeEmpty: [0,0.95,0,0.95],
            )
          ],
        )
    );
  }
}

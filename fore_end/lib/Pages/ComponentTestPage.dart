import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/painter/DroplinePainter.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/Mycomponents/widgets/plan/BodyDataInputer.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/Mycomponents/widgets/plan/PlanChooser.dart';
import 'dart:math' as math;

import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/Mycomponents/widgets/plan/PlanNotifier.dart';

// ignore: must_be_immutable
class ComponentTestPage extends StatefulWidget {
  State state;
  int animateDuration = 800;

  @override
  State<StatefulWidget> createState() {
    this.state = ComponentTestState();
    return this.state;
  }
}

class ComponentTestState extends State<ComponentTestPage>
    with TickerProviderStateMixin {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF172632),
        width: ScreenTool.partOfScreenWidth(1),
        height: ScreenTool.partOfScreenHeight(1),
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: ScreenTool.partOfScreenWidth(0.8)
          ),
          child: PlanNotifier(width: 0.8, height: 100,backgroundColor: Color(0xFFF4F4F5),)),
        );
  }
}

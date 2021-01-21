import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/painter/DroplinePainter.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/BodyDataInputer.dart';
import 'package:fore_end/Mycomponents/widgets/PlanChooser.dart';
import 'dart:math' as math;

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
  TweenAnimation<double> dropAnimation;
  TweenAnimation<double> rotateAnimation;

  @override
  void dispose() {
    dropAnimation.dispose();
    rotateAnimation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dropAnimation = new TweenAnimation();
    rotateAnimation = new TweenAnimation();

    dropAnimation.initAnimation(0.0, 120 * 1.75, widget.animateDuration, this,
        () {
      setState(() {});
    });
    rotateAnimation.initAnimation(math.pi / 4, 0, widget.animateDuration, this,
        () {
      setState(() {});
    });

    dropAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        dropAnimation
            .initAnimation(0.0, 120 * 1.75, 1000, this, () {
          setState(() {});
        });
        dropAnimation.forward();
      }
    });
    rotateAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        rotateAnimation
            .initAnimation(math.pi / 2, 0, 1000, this, () {
          setState(() {});
        });
        rotateAnimation.forward();
      }
    });

    rotateAnimation.beginAnimation();
    dropAnimation.beginAnimation();
  }

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
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child:
            Container(
              width: 280,
              height: 120,
              color: Colors.blueAccent,
              child: Stack(
                children: [
                  CustomPaint(
                    foregroundPainter: DropLinePainter(
                        radians: this.rotateAnimation.getValue(),
                        yOffset: this.dropAnimation.getValue(),
                        lineNum: 6,
                        heightPercent: 0.85,
                        strokeWidth: 12
                    ),
                    child: Container(
                      width: 280,
                      height: 120,
                    ),
                  ),
                ],
              ),
            ),
            )
          ],
        ));
  }
}

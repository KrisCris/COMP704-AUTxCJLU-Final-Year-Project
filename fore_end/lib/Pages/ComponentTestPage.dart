import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/PlanChooser.dart';

class ComponentTestPage extends StatelessWidget {
  var _value;
  @override
  Widget build(BuildContext context) {
    return BackGround(
        sigmaY: 10,
        sigmaX: 10,
        opacity: 0.7,
        child: PlanChooser());
  }
}

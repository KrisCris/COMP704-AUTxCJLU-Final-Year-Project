import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/User.dart';

class PlanNotifier extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      User u = User.getInstance();
      Plan p = u.plan;
  }
  
}
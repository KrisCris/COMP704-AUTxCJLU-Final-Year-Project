import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Mycomponents/widgets/MealList.dart';

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
   return  ListView(
     scrollDirection: Axis.vertical,
     children: <Widget>[
       SizedBox(height: 50,),
       Container(width: 100,height: 100,color: Colors.red,),
       Container(width: 100,height: 50,color: Colors.blue,),
       MealListUI(),
       Container(width: 100,height: 50,color: Colors.blue,),
       Container(width: 100,height: 100,color: Colors.red,),
     ],

   );

  }
}

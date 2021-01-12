import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/ExpandListView.dart';
import 'package:fore_end/Mycomponents/widgets/FoodBox.dart';

class ComponentTestPage extends StatelessWidget {
  var _value;
  @override
  Widget build(BuildContext context) {
    ExpandListView list = ExpandListView(width: 200,height: 200,);
    return BackGround(
      opacity: 0.5,
      child: FoodBox(food: Food(name: "apple",calorie: 23.0),width: 0.8,)
    );
  }
}

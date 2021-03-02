import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:fore_end/Mycomponents/widgets/food/DetailedMealList.dart';
import 'package:fore_end/Mycomponents/widgets/food/SmallFoodBox.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/Mycomponents/widgets/food/MealList.dart';
import 'dart:math' as math;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
      color: Colors.green,
      child: Center(
        child: DetailedMealList(
          meal: Meal(mealName: "breakfast",encoded:"Rice-237-12,Pork-419-58,lettus-64-1"),
          width: 0.9,
          dragAreaHeight: 50,
        )
      )
    );
  }
}

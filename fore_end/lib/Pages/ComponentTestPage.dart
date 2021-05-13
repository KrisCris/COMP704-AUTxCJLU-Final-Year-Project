import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:fore_end/Mycomponents/widgets/food/CaloriesChart.dart';
import 'package:fore_end/Mycomponents/widgets/food/DetailedMealList.dart';
import 'package:fore_end/Mycomponents/widgets/food/NutritionPieChart.dart';
import 'package:fore_end/Mycomponents/widgets/food/SmallFoodBox.dart';
import 'package:fore_end/Mycomponents/widgets/food/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/food/ValueAdjuster.dart';
import 'dart:math' as math;
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'FoodDetailsPage.dart';




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
    return Container();
  }



}

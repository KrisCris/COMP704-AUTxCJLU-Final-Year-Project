import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PersentBar.dart';
import 'package:fore_end/Mycomponents/widgets/food/RecommandFoodCircle.dart';
import 'package:fore_end/Mycomponents/widgets/food/SwitchFoodInfoArea.dart';

class FoodRecommandation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FoodRecommandationState();
  }
}

class FoodRecommandationState extends State<FoodRecommandation> {
  List<Food> selectedFood;
  Food nowFood;
  GlobalKey<SwitchFoodInfoAreaState> foodinfo;
  GlobalKey<CrossFadeTextState> totalCal;
  GlobalKey<PersentBarState> persentBar;

  @override
  void initState() {
    this.selectedFood = new List<Food>();
    this.foodinfo = new GlobalKey<SwitchFoodInfoAreaState>();
    this.totalCal = new GlobalKey<CrossFadeTextState>();
    this.persentBar = new GlobalKey<PersentBarState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      color: MyTheme.convert(ThemeColorName.PageBackground),
      child: Column(
        children: [
          SizedBox(
            height: ScreenTool.partOfScreenHeight(0.05),
          ),
          backArrow(),
          recommandTitle(),
          SizedBox(height: 20),
          foodSelectArea(),
          SizedBox(height: 20),
          SwitchFoodInfoArea(
            key: this.foodinfo,
            width: 0.9,
            height: 0.4,
            onWeightChange: (Food f) {
              this.updateCalories();
            },
          ),
          Expanded(child: SizedBox()),
          CalorieHint(),
        ],
      ),
    );
  }

  double calculateTotalCalorie({Food food}) {
    double total = 0;
    for (Food f in this.selectedFood) {
      total += f.getCalories();
    }
    return total;
  }

  Widget backArrow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomIconButton(
            icon: FontAwesomeIcons.arrowLeft, backgroundOpacity: 0),
        TitleText(
          text: "Recommand Meal",
          underLineLength: 0,
          maxHeight: 20,
          fontSize: 15,
        ),
      ],
    );
  }

  Widget recommandTitle() {
    return Row(
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
        TitleText(
          text: "Recommanded Lunch",
          underLineLength: 200,
          maxHeight: 20,
          maxWidth: 0.95,
          fontSize: 13,
        )
      ],
    );
  }

  Widget foodSelectArea() {
    double picRadius = ScreenTool.partOfScreenHeight(0.075);
    double containerHeight = 2 * picRadius;
    double verticalGap = (containerHeight - picRadius) / 2;
    Random rnd = Random();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
        Container(
          height: containerHeight,
          width: ScreenTool.partOfScreenWidth(0.9),
          decoration: BoxDecoration(
              color: MyTheme.convert(ThemeColorName.ComponentBackground),
              borderRadius: BorderRadius.circular(5)),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (BuildContext ctx, int idx) {
                RecommandFoodCircle w = RecommandFoodCircle(
                  food: Food(
                      name: "test food - " + idx.toString(),
                      calorie: NumUtil.getNumByValueDouble(
                          rnd.nextDouble() * rnd.nextInt(300), 1),
                      fat: NumUtil.getNumByValueDouble(
                          rnd.nextDouble() * rnd.nextInt(300), 1),
                      protein: NumUtil.getNumByValueDouble(
                          rnd.nextDouble() * rnd.nextInt(300), 1),
                      weight: 10),
                  pictureSize: ScreenTool.partOfScreenHeight(0.075),
                );
                w.onClick = () {
                  this.nowFood = w.food;
                  this.foodinfo.currentState.changeTo(this.nowFood);
                };
                w.onCheck = () {
                  this.selectedFood.add(w.food);
                  this.updateCalories();
                };
                w.onUnCheck = () {
                  this.selectedFood.remove(w.food);
                  this.updateCalories();
                };
                return Container(
                    margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: verticalGap,
                        bottom: verticalGap),
                    child: w);
              }),
        ),
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
      ],
    );
  }

  Widget CalorieHint() {
    double totalCal = calculateTotalCalorie();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
        Column(
          children: [
            PersentBar(key: persentBar, width: 0.9, height: 5, sections: [
              PersentSection(
                normalColor: Colors.green,
                highColor: MyTheme.convert(ThemeColorName.Error),
                persent: totalCal / 2000,
                maxPersent: 0.7,
                name: "Calorie Persent",
              )
            ]),
            Container(
              width: ScreenTool.partOfScreenWidth(0.9),
              height: ScreenTool.partOfScreenHeight(0.07),
              decoration: BoxDecoration(
                  color: MyTheme.convert(ThemeColorName.ComponentBackground),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 100),
                  CrossFadeText(
                    key: this.totalCal,
                    text: totalCal.toString() + " Kcal",
                    fontSize: 13,
                  ),
                  Expanded(child: SizedBox()),
                  CustomButton(
                    text: "Add to Meal",
                    firstColorName: ThemeColorName.Success,
                    textColor: MyTheme.convert(ThemeColorName.NormalText),
                    fontsize: 13,
                    radius: 5,
                  ),
                  SizedBox(width: 20)
                ],
              ),
            )
          ],
        ),
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
      ],
    );
  }

  void redrawProgressBar(){
    this.persentBar.currentState.changePersentByIndex(
        0, this.calculateTotalCalorie() / 2000);
  }
  void updateCalories(){
    this.totalCal.currentState.changeTo(
        this.calculateTotalCalorie().toString() + " Kcal");
    this.redrawProgressBar();
  }
}

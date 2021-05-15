import 'dart:convert';
import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/buttons/RotateIcon.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PersentBar.dart';
import 'package:fore_end/Mycomponents/widgets/food/RecommandFoodCircle.dart';
import 'package:fore_end/Mycomponents/widgets/food/SwitchFoodInfoArea.dart';

class FoodRecommandation extends StatefulWidget {
  String mealType;
  int persent;

  FoodRecommandation({this.mealType}) {
    User u = User.getInstance();
    if (this.mealType == null) {
      int hour = DateTime.now().hour;
      if (hour > 4 && hour <= 11) {
        this.mealType = "breakfast";
        this.persent = u.breakfastRatio;
      } else if (hour > 11 && hour <= 16) {
        this.mealType = "lunch";
        this.persent = u.lunchRatio;
      } else if ((hour > 16 && hour <= 24) || (hour >= 0 && hour < 4)) {
        this.mealType = "dinner";
        this.persent = u.dinnerRatio;
      }
    }
  }

  @override
  State<StatefulWidget> createState() {
    return FoodRecommandationState();
  }
}

class FoodRecommandationState extends State<FoodRecommandation> {
  List<Food> selectedFood;
  List<Food> recommendedFood;
  Food nowFood;
  double caloriesLimit;
  GlobalKey<SwitchFoodInfoAreaState> foodinfo;
  GlobalKey<CrossFadeTextState> calSuggest;
  GlobalKey<PersentBarState> persentBar;

  @override
  void initState() {
    this.selectedFood = new List<Food>();
    this.recommendedFood = [];
    this.foodinfo = new GlobalKey<SwitchFoodInfoAreaState>();
    this.calSuggest = new GlobalKey<CrossFadeTextState>();
    this.persentBar = new GlobalKey<PersentBarState>();
    if (widget.mealType == null) {
      widget.mealType = "";
    }
    User u = User.getInstance();

    ///计算建议摄入量上限
    ///先计算当前最大可摄入量
    this.caloriesLimit = u.plan.dailyCaloriesUpperLimit.floorToDouble() -
        u.getTodayCaloriesIntake().floorToDouble();

    ///再计算按照比例得到的建议摄入量
    double recommendLimit = u.plan.dailyCaloriesUpperLimit.floorToDouble() *
        this.widget.persent *
        0.01;

    ///比较两个量，如果当前最大可摄入量>比例建议量，则按照比例建议量作为摄入量上限
    if (this.caloriesLimit > recommendLimit) {
      int mealidx = this.mealTypeConvert() - 1;

      ///如果当前这餐已经有了，则减去
      this.caloriesLimit =
          recommendLimit - (u.meals.value)[mealidx].calculateTotalCalories();
      if (this.caloriesLimit <= 0) {
        this.caloriesLimit = 1;
      }
    }
    Requests.recommandFood(context, {
      "uid": u.uid,
      "token": u.token,
      "pid": u.plan.id,
      "mealType": mealTypeConvert()
    }).then((res) {
      if (res == null) {
        return;
      }
      if (res.data['code'] == 1) {
        for (List m in res.data['data']['randFoods'].values) {
          for (Map fd in m) {
            Food f = new Food.fromJson(fd);
            f.weight = 10;
            this.recommendedFood.add(f);
          }
        }
        setState(() {});
      }
    });
    super.initState();
  }

  int mealTypeConvert() {
    String s = widget.mealType.toLowerCase();
    switch (s) {
      case "breakfast":
        {
          return 1;
        }
      case "lunch":
        {
          return 2;
        }
      case "dinner":
        {
          return 3;
        }
      default:
        {
          return 3;
        }
    }
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
          icon: FontAwesomeIcons.arrowLeft,
          backgroundOpacity: 0,
          onClick: () {
            Navigator.of(context).pop();
          },
        ),
        TitleText(
          text: CustomLocalizations.of(context).recommandMeal,
          underLineLength: 0,
          maxHeight: 28,
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
          text: CustomLocalizations.of(context).recommand +
              CustomLocalizations.of(context).getContent(widget.mealType),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
        Expanded(
          child: Container(
              height: containerHeight,
              decoration: BoxDecoration(
                  color: MyTheme.convert(ThemeColorName.ComponentBackground),
                  borderRadius: BorderRadius.circular(5)),
              child: AnimatedCrossFade(
                firstChild: Container(
                  alignment: Alignment.center,
                  child: RotateIcon(
                    icon: FontAwesomeIcons.spinner,
                    angle: 2 * pi,
                    autoPlay: true,
                    recycle: true,
                    rotateTime: 1000,
                  ),
                ),
                secondChild:
                    this.buildRecommendList(picRadius, containerHeight),
                duration: Duration(milliseconds: 300),
                crossFadeState: this.recommendedFood.length == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              )),
        ),
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
      ],
    );
  }

  Widget buildRecommendList(double picRadius, double containerHeight) {
    double verticalGap = (containerHeight - picRadius) / 2;
    return Container(
      height: containerHeight,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: this.recommendedFood.length,
          itemBuilder: (BuildContext ctx, int idx) {
            RecommandFoodCircle w = RecommandFoodCircle(
              food: this.recommendedFood[idx],
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
                    left: 10, right: 10, top: verticalGap, bottom: verticalGap),
                child: w);
          }),
    );
  }

  Widget CalorieHint() {
    double totalCal = calculateTotalCalorie();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            PersentBar(key: persentBar, width: 1, height: 5, sections: [
              PersentSection(
                normalColor: Colors.green,
                highColor: MyTheme.convert(ThemeColorName.Error),
                persent: totalCal / this.caloriesLimit,
                maxPersent: 1,
                name: CustomLocalizations.of(context).calories +
                    CustomLocalizations.of(context).persent,
              )
            ]),
            Container(
              width: ScreenTool.partOfScreenWidth(1),
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
                    key: this.calSuggest,
                    text: totalCal.floor().toString() +
                        " / " +
                        this.caloriesLimit.floor().toString() +
                        " Kcal",
                    fontSize: 13,
                  ),
                  Expanded(child: SizedBox()),
                  CustomButton(
                    text: CustomLocalizations.of(context).add +
                        " " +
                        CustomLocalizations.of(context).to +
                        " " +
                        CustomLocalizations.of(context)
                            .getContent(widget.mealType),
                    firstColorName: ThemeColorName.Success,
                    textColor: MyTheme.convert(ThemeColorName.NormalText),
                    fontsize: 13,
                    width: 60,
                    radius: 5,
                    tapFunc: () async {
                      User u = User.getInstance();
                      bool newMeal = false;
                      Meal m = u.getMealByName(widget.mealType);
                      if (m == null) {
                        m = new Meal(mealName: widget.mealType);
                        newMeal = true;
                      }
                      Response res = await Requests.consumeFoods(context, {
                        "uid": u.uid,
                        "token": u.token,
                        "pid": u.plan.id,
                        "type": mealTypeConvert(),
                        "foods_info": jsonEncode(this.selectedFood),
                      });
                      if (res == null) {
                        return;
                      }
                      if (res.data['code'] != 1) {
                        return;
                      }
                      for (Food f in this.selectedFood) {
                        m.addFood(f);
                      }
                      if (newMeal) {
                        u.meals.value.add(m);
                      }
                      m.time = (res.data['data']['stmp'] * 1000);
                      m.save();
                      Navigator.of(context).pop(true);
                    },
                  ),
                  SizedBox(width: 20)
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  void redrawProgressBar() {
    this.persentBar.currentState.changePersentByIndex(
        0, this.calculateTotalCalorie() / (this.caloriesLimit));
  }

  void updateCalories() {
    this.calSuggest.currentState.changeTo(
        this.calculateTotalCalorie().floor().toString() +
            " / " +
            this.caloriesLimit.floor().toString() +
            " Kcal");
    this.redrawProgressBar();
  }
}

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
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PersentBar.dart';
import 'package:fore_end/Mycomponents/widgets/food/RecommandFoodCircle.dart';
import 'package:fore_end/Mycomponents/widgets/food/SwitchFoodInfoArea.dart';

class FoodRecommandation extends StatefulWidget {
  String mealType;

  FoodRecommandation({this.mealType}){
    if(this.mealType == null){
      int hour = DateTime.now().hour;
      if(hour >4 && hour <=11){
        this.mealType = "breakfast";
      }else if(hour >11 && hour <=16){
        this.mealType = "lunch";
      }else if(hour>16 && hour <=4){
        this.mealType = "dinner";
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
  GlobalKey<CrossFadeTextState> totalCal;
  GlobalKey<PersentBarState> persentBar;


  @override
  void initState() {
    this.selectedFood = new List<Food>();
    this.recommendedFood = [];
    this.foodinfo = new GlobalKey<SwitchFoodInfoAreaState>();
    this.totalCal = new GlobalKey<CrossFadeTextState>();
    this.persentBar = new GlobalKey<PersentBarState>();
    if(widget.mealType == null){
        widget.mealType = "";
    }
    User u = User.getInstance();
    this.caloriesLimit = u.plan.dailyCaloriesUpperLimit;
    Requests.recommandFood({
      "uid":u.uid,
      "token":u.token,
      "pid":u.plan.id,
      "mealType":mealTypeConvert()
    }).then((res){
      if(res == null){
        return;
      }
      if(res.data['code'] == 1){
        for(List m  in res.data['data']['randFoods'].values){
          for(Map fd in m){
            Food f = new Food.fromJson(fd);
            if(CustomLocalizations.of(context).nowLanguage() == 'zh'){
              f.name = fd['cnName'];
            }
            this.recommendedFood.add(f);
          }
        }
        setState(() {});
      }
    });
    super.initState();
  }

  int mealTypeConvert(){
    String s = widget.mealType.toLowerCase();
    switch(s){
      case "breakfast":{
        return 1;
      }
      case "lunch":{
        return 2;
      }
      case "dinner":{
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
            icon: FontAwesomeIcons.arrowLeft, backgroundOpacity: 0,onClick: (){
              Navigator.of(context).pop();
        },),
        TitleText(
          text: CustomLocalizations.of(context).recommandMeal,
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
          text: CustomLocalizations.of(context).recommand + CustomLocalizations.of(context).getContent(widget.mealType),
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
                name: CustomLocalizations.of(context).calories+CustomLocalizations.of(context).persent,
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
                    text: CustomLocalizations.of(context).add+" "+CustomLocalizations.of(context).to+" "+this.widget.mealType,
                    firstColorName: ThemeColorName.Success,
                    textColor: MyTheme.convert(ThemeColorName.NormalText),
                    fontsize: 13,
                    width: 60,
                    radius: 5,
                    tapFunc: ()async{
                      User u = User.getInstance();
                      bool newMeal = false;
                      Meal m = u.getMealByName(widget.mealType);
                      if(m == null){
                        m = new Meal(mealName: widget.mealType);
                        newMeal = true;
                      }
                      Response res = await Requests.consumeFoods({
                        "uid": u.uid,
                        "token":u.token,
                        "pid": u.plan.id,
                        "type": mealTypeConvert(),
                        "foods_info":jsonEncode(this.selectedFood),
                      });
                      if(res == null){
                        return;
                      }
                      if(res.data['code'] != 1){
                        return;
                      }
                      for(Food f in this.selectedFood){
                        m.addFood(f);
                      }
                      if(newMeal){
                        u.meals.value.add(m);
                      }
                      m.time = (res.data['data']['stmp']*1000);
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
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
      ],
    );
  }

  void redrawProgressBar(){
    this.persentBar.currentState.changePersentByIndex(
        0, this.calculateTotalCalorie() / this.caloriesLimit);
  }
  void updateCalories(){
    this.totalCal.currentState.changeTo(
        this.calculateTotalCalorie().toString() + " Kcal");
    this.redrawProgressBar();
  }
}

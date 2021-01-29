import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Mycomponents/widgets/MealList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Food.dart';
import 'LocalDataManager.dart';

class Meal{
  static const IconData defaultIcon = FontAwesomeIcons.coffee;
  static const Map<String, IconData> mealIcon = {
    "breakfast":FontAwesomeIcons.coffee,
    "lunch":FontAwesomeIcons.hamburger,
    "dinner":FontAwesomeIcons.apple
  };
  String mealName;
  GlobalKey<MealViewState> key;
  List<Food> foods;

  Meal({this.mealName, String encoded}){
    if(encoded != null){
      this.foods = Meal.decode(encoded);
    }else{
      this.foods = [];
    }
    key = GlobalKey<MealViewState>();
  }
  Meal.object({this.mealName, this.foods}){
    key = GlobalKey<MealViewState>();
  }


  void addFood(Food fd){
    foods.add(fd);
  }
  void addFoodWithString(String fd){
    foods.addAll(Meal.decode(fd));
  }

  void save(){
    SharedPreferences pre = LocalDataManager.pre;
    pre.setString(this.mealName, this._encode());
  }
  void delete(){
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove(this.mealName);
  }
  void read(){
    SharedPreferences pre = LocalDataManager.pre;
    this.addFoodWithString(pre.getString(this.mealName));
  }
  IconData getIcon(){
    if(Meal.mealIcon.containsKey(this.mealName)){
      return Meal.mealIcon[this.mealName];
    }
    return Meal.defaultIcon;
  }
  String listFoodsName(){
    String res = "";
    int idx = 0;
    for(Food fd in this.foods){
      if(idx > 2){
        res +="...";
        break;
      }
      res += fd.name + "\n";
      idx++;
    }
    return res;
  }
  int calculateTotalCalories(){
    double cal = 0;
    this.foods.forEach((fd) {
      cal += fd.calorie;
    });
    return cal.floor();
  }
  int calculateTotalProtein(){
    double pro = 0;
    this.foods.forEach((fd) {
      pro += fd.protein;
    });
    return pro.floor();
  }
  String _encode(){
    String res = "";
    for(Food fd in foods){
      res += fd.name + "-";
      res += fd.calorie.toString() + "-";
      res += fd.protein.toString() +",";
    }
  }
  static List<Food> decode(String str){
    if(str == null)return [];
    List<Food> result = [];
    List<String> foodInfo = str.split(',');
    for(String fi in foodInfo){
      List<String> food = fi.split('-');
      result.add(Food(
        name: food[0],
        calorie: double.parse(food[1]),
        protein: double.parse(food[2])
      ));
    }
    return result;
  }
}
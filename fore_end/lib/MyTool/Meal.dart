import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Mycomponents/widgets/food/MealList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Food.dart';
import 'util/LocalDataManager.dart';

class Meal {
  static const IconData defaultIcon = FontAwesomeIcons.coffee;
  static const Map<String, IconData> mealIcon = {
    "breakfast": FontAwesomeIcons.coffee,
    "lunch": FontAwesomeIcons.hamburger,
    "dinner": FontAwesomeIcons.appleAlt,
  };
  String mealName;
  int time;
  GlobalKey<MealViewState> key;
  List<Food> foods;

  Meal({this.mealName, String encoded}) {
    if (encoded != null) {
      this.foods = Meal.decode(encoded);
    } else {
      this.foods = [];
    }
    key = GlobalKey<MealViewState>();
  }
  Meal.object({this.mealName, this.foods}) {
    key = GlobalKey<MealViewState>();
  }

  void addFood(Food fd) {
    foods.add(fd);
  }

  void addFoodWithString(String fd) {
    foods.addAll(Meal.decode(fd));
  }

  void save() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.setInt(this.mealName+"Time", this.time);
    pre.setString(this.mealName, this._encode());
  }

  void delete() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove(this.mealName);
    pre.remove(this.mealName+"Time");
  }

  void read({SharedPreferences pre}) {
    SharedPreferences preLocal = LocalDataManager.pre;
    if (preLocal == null) {
      preLocal = pre;
    }
    this.time = preLocal.getInt(this.mealName+"Time");
    this.addFoodWithString(preLocal.getString(this.mealName));
  }

  IconData getIcon() {
    if (Meal.mealIcon.containsKey(this.mealName)) {
      return Meal.mealIcon[this.mealName];
    }
    return Meal.defaultIcon;
  }

  String listFoodsName() {
    String res = "";
    int idx = 0;
    for (Food fd in this.foods) {
      if (idx > 2) {
        res += "...";
        break;
      }
      res += fd.name + "\n";
      idx++;
    }
    return res;
  }

  int calculateTotalCalories() {
    double cal = 0;
    this.foods.forEach((fd) {
      cal += fd.getCalories();
    });
    return cal.floor();
  }

  int calculateTotalProtein() {
    double pro = 0;
    this.foods.forEach((fd) {
      pro += fd.getProtein();
    });
    return pro.floor();
  }

  ///food类又增加了许多其他的东西，不知道现在匹配方法够不够
  String _encode() {
    String res = jsonEncode(foods);
    return res;
  }

  static List<Food> decode(String str) {
    var data = jsonDecode(str);
    List<Food> res = [];
    for(Map m in data){
      res.add(Food.fromJson(m));
    }
    return res;
  }
}

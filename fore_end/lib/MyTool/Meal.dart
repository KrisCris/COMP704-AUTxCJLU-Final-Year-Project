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
    "dinner": FontAwesomeIcons.apple
  };
  String mealName;
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
    pre.setString(this.mealName, this._encode());
  }

  void delete() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove(this.mealName);
  }

  void read({SharedPreferences pre}) {
    SharedPreferences preLocal = LocalDataManager.pre;
    if (preLocal == null) {
      preLocal = pre;
    }
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
    String res = "";
    for (Food fd in foods) {
      res += fd.name + "-";
      res += fd.id.toString() + "-";
      res += fd.weight.toString()+"-";
      res += fd.calorie.toString() + "-";
      res += fd.protein.toString() + "-";
      res += fd.fat.toString() + "-";
      res += fd.cholesterol.toString() + "-";
      res += fd.cellulose.toString() + "-";
      res += fd.carbohydrate.toString() + "-";
      res += fd.cellulose.toString() + "-";
    }
  }

  static List<Food> decode(String str) {
    if (str == null || !str.contains(",")) return [];
    List<Food> result = [];
    List<String> foodInfo = str.split(',');
    for (String fi in foodInfo) {
      List<String> food = fi.split('-');
      result.add(Food(
        name: food[0],
        id: int.parse(food[1]),
        weight: int.parse(food[2]),
        calorie: double.parse(food[3]),
        protein: double.parse(food[4]),
        fat: double.parse(food[5]),
        cholesterol: double.parse(food[6]),
        carbohydrate: double.parse(food[7]),
        cellulose: double.parse(food[8]),
      ));
    }
    return result;
  }
}

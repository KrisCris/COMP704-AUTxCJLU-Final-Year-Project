import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MealsListData {
  MealsListData({
    this.titleTxt = '',
    this.meals,
    this.kacl = 0,
    this.mealsIcon,
  });

  String titleTxt;
  String titleColor;
  List<String> meals;
  IconData mealsIcon;
  int kacl;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      titleTxt: 'Breakfast',
      kacl: 525,
      meals: <String>['Bread', 'Peanut butter', 'Apple','Banana Pie','Banana Pie','Banana Pie'],
      mealsIcon: FontAwesomeIcons.coffee,

    ),
    MealsListData(
      titleTxt: 'Lunch',
      kacl: 602,
      meals: <String>['Salmon', 'Mixed veggies', 'Avocado'],
      mealsIcon: FontAwesomeIcons.hamburger,
    ),
    MealsListData(
      titleTxt: 'Dinner',
      kacl: 123,
      meals: <String>['Bread', 'Peanut butter', 'Apple'],
      mealsIcon: FontAwesomeIcons.apple,
    ),
  ];
}
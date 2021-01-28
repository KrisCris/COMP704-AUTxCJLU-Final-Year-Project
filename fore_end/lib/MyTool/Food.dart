import 'package:flutter/cupertino.dart';

class Food {
  String name;
  double calorie;
  double protein;

  Food({this.name,this.calorie=0,this.protein=0});

  String getCalorie(){
    return calorie.toString() + "Kcal";
  }
}
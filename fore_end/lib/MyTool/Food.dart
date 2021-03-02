import 'package:flutter/cupertino.dart';

class Food {
  String name;
  double calorie;

  Food({this.name,this.calorie});

  String getCalorie(){
    return calorie.toString() + "Kcal";
  }
}
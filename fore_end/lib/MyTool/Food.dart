import 'package:flutter/cupertino.dart';

class Food {
  static const String defaultPicturePath = "image/defaultFood.png";
  String picture;
  String name;
  double calorie;
  double protein;

  Food({this.name,this.calorie=0,this.protein=0,this.picture});

  String getCalorie(){
    return calorie.toString() + "Kcal";
  }
}
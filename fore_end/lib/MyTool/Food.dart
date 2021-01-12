import 'package:flutter/cupertino.dart';

class Food {
  String name;
  Image image;
  double calorie;

  Food({this.name,this.calorie, this.image});

  String getCalorie(){
    return calorie.toString() + "KJ";
  }
}
import 'package:flutter/cupertino.dart';

class Food {
  static const String defaultPicturePath = "image/defaultFood.png";
  String picture;
  String name;
  ///Food ID 在数据库里的ID
  int id;

  ///服务器里面的category好像是String类型  所以我不太确定
  int category;
  ///目前的营养物质一共有6种
  ///卡路里
  double calorie;
  ///脂肪
  double fat;
  ///胆固醇
  double cholesterol;
  ///纤维素
  double cellulose;

  ///蛋白质
  double protein;
  ///碳水
  double carbohydrate;
  /// 因为数据库里面的数据都基于100g计算的，所以默认就是100g，拍照的时候允许用户增加克数，然后营养和卡路里就乘以这个克数（份数）就好了。
  int weight;     ///重量 ~ 份数  所以默认1

  Food({
    this.name,
    this.id,
    this.picture,
    this.category,
    this.fat=0,
    this.calorie=0,
    this.protein=0,
    this.cholesterol=0,
    this.carbohydrate=0,
    this.cellulose=0,
    ///weight只是为了计算营养价值和显示使用 用户可以增加
    this.weight=1,
  });

  String getCalorie(){
    return calorie.toString() + "Kcal";
  }

  String getProtein(){
    return protein.toString() + "g";
  }

  String getFat(){
    return fat.toString() + "g";
  }

  String getCholesterol(){
    return cholesterol.toString() + "mg";
  }

  String getCarbohydrate(){
    return carbohydrate.toString() + "mg";
  }

  String getCellulose(){
    return cellulose.toString()+"mg";
  }


  String getWeight(){
    return weight.toString() + "00g";
  }
  void setWeight(int newWeight){
    this.weight=newWeight;
  }


}
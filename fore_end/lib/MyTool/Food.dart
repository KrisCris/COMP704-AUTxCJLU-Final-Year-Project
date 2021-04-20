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
  ///重量
  int weight;

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
  Food.fromJson(Map<String,dynamic> json){
    this.id = json['id'];
    this.name = json['name'];
    this.picture = json['picture'];
    this.weight = json['weight'];
    this.calorie =json['calories'];
    this.protein = json['protein'];
    this.fat = 0;
    this.cholesterol = 0;
    this.cellulose = 0;
    this.category = 0;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['calories'] = this.calorie;
    data['picture'] = this.picture;
    data['protein'] = this.protein;
    data['weight'] = this.weight;
    return data;
  }
  String getCaloriePerUnit(){
    return calorie.toString() + "Kcal/100g";
  }
  int getCalories(){
    return (calorie*weight/100).floor();
  }
  String getProteinPerUnit(){
    return protein.toString() + "g/100g";
  }
  int getProtein(){
    return (protein*weight/100).floor();
  }
  String getFatPerUnit(){
    return fat.toString() + "g/100g";
  }
  int getFat(){
    return (fat*weight/100).floor();
  }
  String getCholesterolPerUnit(){
    return cholesterol.toString() + "mg/100g";
  }
  int getCholesterol(){
    return (cholesterol*weight).floor();
  }
  String getCarbohydratePerUnit(){
    return carbohydrate.toString() + "mg/100g";
  }
  int getCarbohydrate(){
    return (carbohydrate*weight).floor();
  }
  String getCellulosePerUnit(){
    return cellulose.toString()+"mg/100g";
  }
  int getCellulose(){
    return (cellulose*weight).floor();
  }
  String getWeight(){
    return weight.toString() + "00g";
  }
  void setWeight(int newWeight){
    this.weight=newWeight;
  }
}
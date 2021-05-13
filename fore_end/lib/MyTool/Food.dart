import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';

class Food {
  static const String defaultPicturePath = "image/defaultFood.png";
  String picture;
  String _name;
  String _cnName;
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
    String name,
    String cnName,
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
    this.weight=0,
  }){
    this._name = name;
    this._cnName = cnName;
  }
  Food.fromJson(Map<String,dynamic> json){
    this.id = json['id'];
    this._name = json['name'];
    this._cnName = json['cnName'];
    this.picture = json['picture']??json['img'];
    this.weight = json['weight'] ??0;
    this.calorie =json['calories']??0;
    this.protein = json['protein']??0;
    this.carbohydrate = json['carbohydrate']??0;
    this.fat = json['fat']??0;
    this.cholesterol = json['cholesterol']??0;
    this.cellulose = json['cellulose']??0;
    this.category = json['category']??0;
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['cnName'] = this._cnName;
    data['id'] = this.id;
    data['calories'] = this.calorie;
    data['carbohydrate']= this.carbohydrate;
    data['picture'] = this.picture;
    data['protein'] = this.protein;
    data['weight'] = this.weight;
    return data;
  }
  String getRawName(){
    return _name;
  }
  String getName(BuildContext context){
    String language = CustomLocalizations.of(context).nowLanguage();
    if(language == 'zh'){
      if(_cnName != null){
        return _cnName;
      }else{
        return "${_name[0].toUpperCase()}${_name.substring(1)}";
      }
    }else{
      return "${_name[0].toUpperCase()}${_name.substring(1)}";
    }
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
  double calculatePercent(String label){
    Map mapper = {
      'protein':this.protein,
      'fat':this.fat,
      'cellulose':this.cellulose,
      'carbohydrate':this.carbohydrate,
      'cholesterol':this.cholesterol,
    };
    if(!mapper.containsKey(label))return 0;

    double total = fat+protein+cholesterol+carbohydrate+cellulose;
    double target = mapper[label];
    return target/total;
  }

  double calculateThreeNutritionPercent(String label){
    Map mapper = {
      'protein':this.protein,
      'fat':this.fat,
      'carbohydrate':this.carbohydrate,
    };
    if(!mapper.containsKey(label))return 0;

    double total = fat+protein+carbohydrate;
    double target = mapper[label];
    return target/total;
  }

}
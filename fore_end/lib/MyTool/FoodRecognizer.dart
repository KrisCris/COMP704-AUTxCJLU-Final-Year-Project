import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/widgets/FoodBox.dart';
import 'Food.dart';
import 'Meal.dart';
import 'Req.dart';
import 'package:image/image.dart' as cropper;

class FoodRecognizer{
  static final FoodRecognizer _instance = FoodRecognizer._privateConstructor();
  static FoodRecognizer get instance => _instance;
  FoodRecognizer._privateConstructor(){
    this.targetPicInfo = new ValueNotifier<Queue<RequestItem>>(new Queue());
    this.foods = List<FoodBox>();
    this.targetPicInfo.addListener(() {
      RequestItem item  = this.targetPicInfo.value.removeFirst();
      FoodRecognizer._sendFoodRecognizeRequest(item.bs64, item.byte,item.rotate);
    });
  }

  ValueNotifier<Queue<RequestItem>> targetPicInfo;
  List<FoodBox> foods;
  Function onRecognizedDone;
  GlobalKey relatedKey;

  static void addFoodPic(String targetPicBase64, Uint8List byte, int rotate){
    if(_instance == null) {
      print("Try add Food when Recognizer is not init yet");
      return;
    }
    FoodRecognizer._instance.targetPicInfo.value = Queue.from(
        FoodRecognizer._instance.targetPicInfo.value)..add(new RequestItem(
      bs64: targetPicBase64,
      byte: byte,
      rotate: rotate
    ));
  }
  static void addFoodToMeal(Meal m){
    User u = User.getInstance();
    List<FoodBox> l = FoodRecognizer.instance.foods;
    for(FoodBox fb in l){
      m.addFood(fb.food);
    }
    u.refreshMeal();
    u.saveMeal();
    l.clear();
    FoodRecognizer._instance?.relatedKey?.currentState?.setState(() {});
  }
  static void addFoodToMealName(String mealName){
    User u = User.getInstance();
    Meal m = u.getMealByName(mealName);
    if(m != null){
      FoodRecognizer.addFoodToMeal(m);
    }
  }
  static void _sendFoodRecognizeRequest(String bs64,Uint8List byte,int rotate) async{
    if(_instance == null) {
      print("Try recognize Food when Recognizer is not init yet");
      return;
    }
    Response res = await Requests.foodDetect({
      "food_b64":bs64,
      "rotation":rotate
    });

    if(res.data['code']== 1){
      for(dynamic r in res.data['data']){
        var position = r['basic'];
        var info = r['info'];
        double cal = 0;
        if(info['calories'] is int){
          cal = (info['calories'] as int).toDouble();
        }else if(info['calories'] is double){
          cal = info['calories'];
        }
        String name = position['name'];
        FoodBox fd = FoodBox(
          food: Food(name: name, calorie: cal,picture: position['img']),
          borderRadius: 5,
        );
        fd.setRemoveFunc((){
          List<FoodBox> list = FoodRecognizer._instance.foods;
          FoodRecognizer._instance.foods.remove(fd);
          FoodRecognizer._instance?.relatedKey?.currentState?.setState(() {});
        });
        FoodRecognizer._instance.foods.add(fd);
        Fluttertoast.showToast(
          msg: "Food Recognized Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black26,
          fontSize: 13,
        );
      }
      if(FoodRecognizer.instance.onRecognizedDone != null){
        FoodRecognizer.instance.onRecognizedDone();
      }
    }else{
      Fluttertoast.showToast(
        msg: "No Food Found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.black45,
        fontSize: 13,
      );
    }
  }
  bool isEmpty(){
    return FoodRecognizer.instance.foods.isEmpty;
  }
  void setOnRecognizedDone(Function f){
    this.onRecognizedDone = f;
  }
  void removeOnRecognizedDone(){
    this.onRecognizedDone = null;
  }
  void setKey(Key k){
    this.relatedKey = k;
  }

}
class RequestItem{
  String bs64;
  Uint8List byte;
  int rotate;
  RequestItem({this.bs64,this.byte,this.rotate});
}
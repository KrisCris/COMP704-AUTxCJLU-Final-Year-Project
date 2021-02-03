import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/widgets/food/FoodBox.dart';
import 'Food.dart';
import 'Meal.dart';
import 'util/Req.dart';
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

  ///这里是按照三餐的名字保存记录，上传服务器和本地保存
  static void addFoodToMealName(String mealName) async{
    User u = User.getInstance();
    Meal m = u.getMealByName(mealName);
    int mealsType=mealName=="breakfast"? 1 : {mealName=="lunch"?2:3};
    if(m != null){
      FoodRecognizer.addFoodToMeal(m);
      List<List> totalFoodInfo=new List<List>();
      for(Food food in m.foods){
        int foodId=food.id;
        List singleFoodInfo=[];
        ///现在fid就是食物在数据库里的id，现在还没有这个数据，等数据库有了再写上去
        singleFoodInfo.add(foodId);
        singleFoodInfo.add(food.name);
        singleFoodInfo.add(food.calorie);
        singleFoodInfo.add(food.protein);
        totalFoodInfo.add(singleFoodInfo);
      }
      Response res = await Requests.consumeFoods({
        "uid": u.uid,
        "pid": u.plan.id,
        "type": mealsType.toString(),
        "foods_info":totalFoodInfo,
      });

      if (res.data["code"] == 1) {
        print("保存成功");
        print(res.data);
      }else {
        print("保存失败");
      }
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
        double fat= 0;
        double cholesterol= 0;
        double cellulose= 0;
        double protein= 0;
        double carbohydrate= 0;
        int foodID=info['id'];
        int foodCategory=info['category'];


        if(info['calories'] is int){
          cal = (info['calories'] as int).toDouble();
        }else if(info['calories'] is double){
          cal = info['calories'];
        }
        if(info['carbohydrate'] is int){
          carbohydrate = (info['carbohydrate'] as int).toDouble();
        }else if(info['carbohydrate'] is double){
          carbohydrate = info['carbohydrate'];
        }

        if(info['fat'] is int){
          fat = (info['fat'] as int).toDouble();
        }else if(info['fat'] is double){
          fat = info['fat'];
        }
        if(info['protein'] is int){
          protein = (info['protein'] as int).toDouble();
        }else if(info['protein'] is double){
          protein = info['protein'];
        }
        if(info['cholesterol'] is int){
          cholesterol = (info['cholesterol'] as int).toDouble();
        }else if(info['cholesterol'] is double){
          cholesterol = info['cholesterol'];
        }
        if(info['cellulose'] is int){
          cellulose = (info['cellulose'] as int).toDouble();
        }else if(info['cellulose'] is double){
          cellulose = info['cellulose'];
        }

        String name = position['name'];
        FoodBox fd = FoodBox(
          food: Food(
            name: name,
            id: foodID,
            category: foodCategory,
            picture: position['img'],
            calorie: cal,
            protein: protein,
            fat: fat,
            carbohydrate: carbohydrate,
            cellulose: cellulose,
            cholesterol: cholesterol,
          ),
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
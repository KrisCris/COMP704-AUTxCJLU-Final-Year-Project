import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/Mycomponents/widgets/FoodBox.dart';
import 'Food.dart';
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
        FoodRecognizer._instance.foods.add(
            FoodBox(
              food: Food(name: position['name'], calorie: cal),
              picture: position['img'],
            )
        );
      }
      if(FoodRecognizer.instance.onRecognizedDone != null){
        FoodRecognizer.instance.onRecognizedDone();
      }
    }else{
      print("No Food Found, Asshole!");
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

}
class RequestItem{
  String bs64;
  Uint8List byte;
  int rotate;
  RequestItem({this.bs64,this.byte,this.rotate});
}
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
    this.targetPicBase64 = new ValueNotifier<Queue<String>>(new Queue());
    this.foods = List<FoodBox>();
    this.targetPicBase64.addListener(() {
      String bs64 = this.targetPicBase64.value.removeFirst();
      FoodRecognizer._sendFoodRecognizeRequest(bs64);
    });
  }

  ValueNotifier<Queue<String>> targetPicBase64;
  List<FoodBox> foods;
  Function onRecognizedDone;

  static void addFoodPic(String targetPicBase64){
    if(_instance == null) {
      print("Try add Food when Recognizer is not init yet");
      return;
    }
      FoodRecognizer._instance.targetPicBase64.value = Queue.from(FoodRecognizer._instance.targetPicBase64.value)..add(targetPicBase64);
  }

  static void _sendFoodRecognizeRequest(String bs64) async{
    if(_instance == null) {
      print("Try recognize Food when Recognizer is not init yet");
      return;
    }
    Response res = await Requests.foodDetect({
      "food_b64":bs64
    });
    if(res.data['code']== 1){
      for(dynamic r in res.data['data']){
        var position = r['basic'];
        var info = r['info'];
        cropper.Image imgOri = cropper.Image.fromBytes(
            position['pw'],
            position['ph'],
            base64Decode(bs64));
        cropper.Image img = cropper.copyCrop(
            imgOri,
            (position['x'] as double).round(),
            (position['y'] as double).round(),
            (position['w'] as double).round(),
            (position['h'] as double).round());
        FoodRecognizer._instance.foods.add(
            FoodBox(
              food: Food(name: position['name'], calorie: info['calorie']),
              picture: base64Encode(img.getBytes()),
            )
        );
      }
      if(FoodRecognizer.instance.onRecognizedDone != null){
        FoodRecognizer.instance.onRecognizedDone();
      }
    }else{

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

  Uint8List crop(Uint8List byte, int x, int y, int width, int height){
    Uint8List res = new Uint8List(width*height);
    for(int yi = y-1;yi < yi+height;yi++ ){
      for(int xi = x-1;xi < xi+width;xi++){
        res.add(byte[yi*width+xi]);
      }
    }
    return res;
  }
}
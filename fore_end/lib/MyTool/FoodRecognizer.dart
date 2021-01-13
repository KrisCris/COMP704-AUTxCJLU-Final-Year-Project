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
    byteList = new Queue();
    this.foods = List<FoodBox>();
    this.targetPicBase64.addListener(() {
      String bs64 = this.targetPicBase64.value.removeFirst();
      Uint8List u8 = byteList.removeFirst();
      FoodRecognizer._sendFoodRecognizeRequest(bs64, u8);
    });
  }

  ValueNotifier<Queue<String>> targetPicBase64;
  Queue<Uint8List> byteList;
  List<FoodBox> foods;
  Function onRecognizedDone;

  static void addFoodPic(String targetPicBase64, Uint8List byte){
    if(_instance == null) {
      print("Try add Food when Recognizer is not init yet");
      return;
    }
    FoodRecognizer._instance.byteList.add(byte);
    FoodRecognizer._instance.targetPicBase64.value = Queue.from(FoodRecognizer._instance.targetPicBase64.value)..add(targetPicBase64);
  }

  static void _sendFoodRecognizeRequest(String bs64,Uint8List byte) async{
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
        double width = position['x2'] - position['x1'];
        double height = position['y2'] - position['y1'];
        cropper.Image img = cropper.decodeImage(byte);


        var info = r['info'];
        double cal = (info['calories'] as int).toDouble();

        img = cropper.copyCrop(
            img,
            (position['x1'] as double).round(),
            (position['y1'] as double).round(),
            width.round(),
            height.round());
        FoodRecognizer._instance.foods.add(
            FoodBox(
              food: Food(name: position['name'], calorie: cal),
              picture: base64Encode(Uint8List.fromList(cropper.encodePng(img))),
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

  static Uint8List _crop(Uint8List byte, int x, int y, int width, int height){
    Uint8List res = new Uint8List(width*height);
    int xt = 0;
    int yt = 0;
    for(int yi = y-1;yi < yi+height;yi++ ){
      for(int xi = x-1;xi < xi+width;xi++){
        print((yt*width + xt).toString());
        res[yt*width + xt] = byte[yi*width+xi];
        xt++;
      }
      yt++;
    }
    return res;
  }
}
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/FoodBox.dart';
import 'package:image/image.dart' as cropper;


class ResultPage extends StatefulWidget {
  String backgroundBase64;
  String targetPicBase64;
  Image targetPic;
  ValueNotifier<bool> isDone;
  List<FoodBox> foods;

  ResultPage({String backgroundBase64, String targetPicBase64}) {
    this.backgroundBase64 = backgroundBase64;
    this.targetPicBase64 = targetPicBase64;
    this.isDone = ValueNotifier<bool>(false);
    this.foods = List<FoodBox>();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ResultPageState();
  }


}
class ResultPageState extends State<ResultPage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isDone.addListener(() {setState(() {});});
    this.sendFoodRecognizeRequest();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget header = Row(
      children: [
        Expanded(
            child: Text(
              "RESULTS",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Futura",
                  color: Colors.black),
            )),
        Icon(FontAwesomeIcons.cross),
        SizedBox(width: 10,),
      ],
    );
    Widget content = AnimatedCrossFade(
        firstChild: this.getWaiting(),
        secondChild: this.getResult(),
        crossFadeState: widget.isDone.value
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 100));

    return BackGround.base64(
        base64: widget.backgroundBase64,
        sigmaX: 10,
        sigmaY: 10,
        opacity: 0.7,
        child: Column(
          children: [
            header,
            content
          ],
        ));
  }

  Widget getWaiting(){
    return Container(
      width: 100,
      height:100,
      child: Text("Waiting For Results..."),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
      ),
    );
  }
  Widget getResult(){
    return Column(
      children: widget.foods,
    );
  }

  void sendFoodRecognizeRequest() async{
    widget.targetPic = Image.memory(base64Decode(widget.targetPicBase64));

    Response res = await Requests.foodDetect({
      "food_b64":widget.targetPicBase64
    });
    if(res.data.code == 1){
      for(dynamic r in res.data['data']){
        cropper.Image img = cropper.copyCrop(
            cropper.Image.fromBytes(
                widget.targetPic.width.round(),
                widget.targetPic.height.round(),
                base64Decode(widget.targetPicBase64)),
            r['x'], r["y"], r["w"], r["h"]);
        widget.foods.add(
            FoodBox(
              food: Food(name: r['name'], calorie: r['calorie']),
              picture: base64Encode(img.getBytes()),
            )
        );
      }
      widget.isDone.value = true;
    }else{

    }
  }
}
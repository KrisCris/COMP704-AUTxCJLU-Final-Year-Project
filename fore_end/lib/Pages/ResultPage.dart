
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';


class ResultPage extends StatefulWidget {
  static const String defaultBackground = "image/fruit-main.jpg";
  String backgroundBase64;
  FoodRecognizer recognizer;

  ResultPage({String backgroundBase64}) {
    this.backgroundBase64 = backgroundBase64;
    if(backgroundBase64 == null){
      this.backgroundBase64 = ResultPage.defaultBackground;
    }
    this.recognizer = FoodRecognizer.instance;
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
    widget.recognizer.setOnRecognizedDone((){
      if(!mounted)return;
      setState(() {});
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    widget.recognizer.removeOnRecognizedDone();
    super.dispose();
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
        crossFadeState: widget.recognizer.isEmpty()
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Waiting For Results...")],
    );
  }
  Widget getResult(){
    return ListView(
      children: widget.recognizer.foods,
    );
  }
}
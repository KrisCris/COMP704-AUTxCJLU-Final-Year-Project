import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/FoodBox.dart';

class ResultPage extends StatefulWidget {
  static const String defaultBackground = "image/fruit-main.jpg";
  String backgroundBase64;
  FoodRecognizer recognizer;

  ResultPage({String backgroundBase64}) {
    this.backgroundBase64 = backgroundBase64;
    if (backgroundBase64 == null) {
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

class ResultPageState extends State<ResultPage> {
  bool scrolling = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.recognizer.setOnRecognizedDone(() {
      if (!mounted) return;
      setState(() {});
    });
    this.setAllPicEnable();
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
        SizedBox(
          width: 15,
        ),
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
        Icon(FontAwesomeIcons.times),
        SizedBox(
          width: 10,
        ),
      ],
    );
    Widget content = Expanded(
        child: AnimatedCrossFade(
            firstChild: this.getWaiting(),
            secondChild: this.getResult(),
            crossFadeState: widget.recognizer.isEmpty()
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 100)));

    return BackGround(
        sigmaX: 10,
        sigmaY: 10,
        opacity: 0.7,
        child: Column(
          children: [
            SizedBox(
              height: ScreenTool.partOfScreenHeight(0.05),
            ),
            header,
            content
          ],
        ));
  }

  Widget getWaiting() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text("Waiting For Results...")],
    );
  }

  Widget getResult() {
    return NotificationListener(
      onNotification: this.scrollNotification,
        child: ListView(
      shrinkWrap: true,
      children: widget.recognizer.foods,
    ));
  }

  bool scrollNotification(Notification notification){
    ///通知类型
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        ///在这里更新标识 刷新页面 不加载图片
        print("开始滚动");
        this.setAllPicDefault();
        break;
      case ScrollUpdateNotification:
        ///正在滚动
        break;
      case ScrollEndNotification:
        print("停止滚动");
        ///在这里更新标识 刷新页面 加载图片
        this.setAllPicEnable();
        break;
      case OverscrollNotification:
        print("滚动到边界");
        break;
    }
    return true;
  }

  void setAllPicDefault(){
    for(FoodBox fb in widget.recognizer.foods){
      fb.setShow(false);
    }
  }
  void setAllPicEnable() async {
    for(FoodBox fb in widget.recognizer.foods){
      await fb.setShow(true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}

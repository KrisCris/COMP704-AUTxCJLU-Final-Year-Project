import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/FoodBox.dart';

class ResultPage extends StatefulWidget {
  static const String defaultBackground = "image/fruit-main.jpg";
  String backgroundBase64;
  FoodRecognizer recognizer;

  ResultPage({Key key, String backgroundBase64}) : super(key: key) {
    this.backgroundBase64 = backgroundBase64;
    if (backgroundBase64 == null) {
      this.backgroundBase64 = ResultPage.defaultBackground;
    }
    this.recognizer = FoodRecognizer.instance;
    this.recognizer.setKey(key);
  }
  @override
  State<StatefulWidget> createState() {
    return new ResultPageState();
  }
}

class ResultPageState extends State<ResultPage> {
  bool scrolling = false;

  @override
  void initState() {
    super.initState();
    widget.recognizer.setOnRecognizedDone(() {
      if (!mounted) return;
      setState(() {});
    });
    this.setAllPicEnable();
  }

  @override
  void dispose() {
    widget.recognizer.removeOnRecognizedDone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = Row(
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
        TitleText(
          text: "Your Foods Here",
          fontSize: 18,
          fontColor: Colors.white,
          dividerColor: Colors.white,
          underLineDistance: 3,
          maxHeight: 25,
          maxWidth: 200,
          underLineLength: ScreenTool.partOfScreenWidth(0.9),
        ),
        Expanded(child: SizedBox()),
        CustomIconButton(
            theme: MyTheme.WhiteAndBlack,
            icon: FontAwesomeIcons.times,
            iconSize: 23,
            buttonSize: 35,
            backgroundOpacity: 0,
          onClick: (){
              Navigator.pop(context);
          },
        ),
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
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
    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      height: ScreenTool.partOfScreenHeight(1),
      color: Color(0xFF172632),
      child: Column(
        children: [
          SizedBox(
            height: ScreenTool.partOfScreenHeight(0.05),
          ),
          header,
          content,
        ],
      ),
    );
  }

  Widget getWaiting() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "No Recognized Foods Here",
            style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.none,
                color: Colors.white,
                fontFamily: "Futura"),
          ),
        ),
      ],
    );
  }

  Widget getResult() {
    return NotificationListener(
        onNotification: this.scrollNotification,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.recognizer.foods.length,
          itemBuilder: (BuildContext context, int pos){
            return widget.recognizer.foods[pos];
          },
        ));
  }

  bool scrollNotification(Notification notification) {
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

  void setAllPicDefault() {
    for (FoodBox fb in widget.recognizer.foods) {
      fb.setShow(false);
    }
  }

  void setAllPicEnable() async {
    for (FoodBox fb in widget.recognizer.foods) {
      await fb.setShow(true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}

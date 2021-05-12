import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/util/Picker_Tool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/food/FoodBox.dart';

class ResultPage extends StatefulWidget {
  static const String defaultBackground = "image/fruit-main.jpg";
  String backgroundBase64;
  FoodRecognizer recognizer;
  CustomButton breakfastButton;
  CustomButton lunchButton;
  CustomButton dinnerButoon;

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
  List<String> mealsName;

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
    if(mealsName == null){
      mealsName = [
        CustomLocalizations.of(context).breakfast,
        CustomLocalizations.of(context).lunch,
        CustomLocalizations.of(context).dinner
      ];
    }
    ///也可以根据当前页面上面，有没有食物结果来判断是否显示下面的字 ====参考中间的提示文字
    Widget addMealTextButton =GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(
          CustomLocalizations.of(context).resultPageQuestion,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Futura',
            color: MyTheme.convert(ThemeColorName.NormalText),
            decoration: TextDecoration.none,
          ),
        ),
      ),
      onTap: (){
        ///测试点击每个食物展示底部弹窗,总卡路里通过统计整个页面食物的数据获得
        ///也可以根据当前页面上面，有没有食物结果来判断是否显示下面的字
        ///这里还可以计算总的其他营养数据 比如protein
        int cal = 0;
        widget.recognizer.foods.forEach((fd) {
          cal += (fd.food.calorie*fd.food.weight/100).toInt();
        });
        ///转为Int显示
        String totalCalories=cal.toString();

        JhPickerTool.showStringPicker(context,
            title: CustomLocalizations.of(context).total +totalCalories+ ' Kcal',
            normalIndex: 0,
            isChangeColor: true,
            data: this.mealsName, clickCallBack: (int index, var item) {
              if(index == 0){
                FoodRecognizer.addFoodToMealName("breakfast");
              }else if(index == 1){
                FoodRecognizer.addFoodToMealName("lunch");
              }else if(index == 2){
                FoodRecognizer.addFoodToMealName("dinner");
              }
            });


      },
    );

    Widget header = Row(
      children: [
        SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
        TitleText(
          text: CustomLocalizations.of(context).resultPageTitle,
          fontSize: 18,
          fontColor: MyTheme.convert(ThemeColorName.NormalText),
          dividerColor: MyTheme.convert(ThemeColorName.NormalText),
          underLineDistance: 3,
          maxHeight: 25,
          maxWidth: 200,
          underLineLength: ScreenTool.partOfScreenWidth(0.9),
        ),
        Expanded(child: SizedBox()),
        CustomIconButton(
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
          ///有可能有bug，主界面热加载会导致名为“Duplicate GlobalKeys detected in widget tree.”
          widget.recognizer.isEmpty()? Container():addMealTextButton,
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
            CustomLocalizations.of(context).resultPageEmpty,
            style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.none,
                color: MyTheme.convert(ThemeColorName.NormalText),
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
        this.setAllPicDefault();
        break;
      case ScrollUpdateNotification:
        break;
      case ScrollEndNotification:
        this.setAllPicEnable();
        break;
      case OverscrollNotification:
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

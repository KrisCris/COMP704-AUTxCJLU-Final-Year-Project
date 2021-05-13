import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/interface/Valueable.dart';

class MealLimitPercentBox extends StatefulWidget {
  final int lowerLimit;
  final int upperLimit;
  final int changeUnit;
  final int initVal;
  final String name;
  final List<GlobalKey<MealLimitPercentBoxState>> relatedBox;
  double height;
  double width;
  double borderRadius;

  MealLimitPercentBox(
      {@required this.name,
      @required this.lowerLimit,
      @required this.upperLimit,
      @required this.initVal,
      @required this.changeUnit,
        this.relatedBox,
      double height,
      double width,
      this.borderRadius = 0,
      Key k})
      : super(key: k) {
    this.height = ScreenTool.partOfScreenHeight(height);
    this.width = ScreenTool.partOfScreenWidth(width);
  }

  @override
  State<StatefulWidget> createState() {
    return new MealLimitPercentBoxState();
  }
}

class MealLimitPercentBoxState extends State<MealLimitPercentBox> {
  ValueNotifier<int> currentPersent;

  @override
  void initState() {
    currentPersent = new ValueNotifier<int>(this.widget.initVal);
    currentPersent.addListener(onChangeValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: this.widget.width,
        height: this.widget.height,
        margin: EdgeInsets.only(left: 0, right: 0),
        decoration: BoxDecoration(
          color: MyTheme.convert(ThemeColorName.ComponentBackground),
          borderRadius: BorderRadius.circular(this.widget.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              CustomLocalizations.of(context).getContent(this.widget.name),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "Futura",
                  color: MyTheme.convert(ThemeColorName.NormalText)),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      icon: FontAwesomeIcons.chevronLeft,
                      iconSize: 23,
                      buttonSize: 23,
                      backgroundOpacity: 0,
                      onClick: (){
                        this.minus();
                        this.updateMealPersent();
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        text: this.currentPersent.value.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: "Futura",
                            color: MyTheme.convert(ThemeColorName.NormalText)),
                        children: <TextSpan>[
                          TextSpan(
                              text: '%',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyTheme.convert(
                                      ThemeColorName.NormalText))),
                        ],
                      ),
                    ),
                    CustomIconButton(
                      icon: FontAwesomeIcons.chevronRight,
                      iconSize: 23,
                      backgroundOpacity: 0,
                      buttonSize: 23,
                      onClick: (){
                        this.add();
                        this.updateMealPersent();
                      },
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onHorizontalDragUpdate: (details) {
        if(details.delta.dx < 0){
          this.minus();
        }else{
          this.add();
        }
      },
      onHorizontalDragEnd: (details){
        this.updateMealPersent();
      },
    );
  }

  @override
  void onChangeValue() {
    setState(() {});
  }

  int getValue() {
    return this.currentPersent.value;
  }
  void add(){
    if(this.currentPersent.value == this.widget.upperLimit)return;

    int val = this.currentPersent.value + this.widget.changeUnit;
    if(val > this.widget.upperLimit){
      this.currentPersent.value = this.widget.upperLimit;
    }else{
      this.currentPersent.value = val;
      solveRelatedBoxChange(-1*this.widget.changeUnit);
    }
  }

  void minus(){
    if(this.currentPersent.value == this.widget.lowerLimit)return;
    int val = this.currentPersent.value - this.widget.changeUnit;
    if(val < this.widget.lowerLimit){
      this.currentPersent.value = this.widget.lowerLimit;
    }else{
      this.currentPersent.value = val;
      solveRelatedBoxChange(this.widget.changeUnit);
    }
  }

  ///val 是其他相关box需要变化的量
  void solveRelatedBoxChange(int val){
    for(GlobalKey<MealLimitPercentBoxState> stt in this.widget.relatedBox){
      if(val == 0)return;
      ///假设val负数
      if(val < 0){
        if((stt.currentState.currentPersent.value + val < stt.currentState.widget.lowerLimit)){
          stt.currentState.currentPersent.value =stt.currentState.widget.lowerLimit;
          val+=(stt.currentState.currentPersent.value-stt.currentState.widget.lowerLimit).abs();
        }else{
          stt.currentState.currentPersent.value += val;
          val=0;
        }
      }else{
        ///假设val正数
        if((stt.currentState.currentPersent.value + val > stt.currentState.widget.upperLimit)){
          stt.currentState.currentPersent.value =stt.currentState.widget.upperLimit;
          val-=(stt.currentState.currentPersent.value-stt.currentState.widget.upperLimit).abs();
        }else{
          stt.currentState.currentPersent.value += val;
          val=0;
        }
      }
    }
  }

  void updateMealPersent() async {
    User u = User.getInstance();
    print("Update Persent!");
    int breakfast = 0;
    int lunch = 0;
    int dinner = 0;
    if(this.widget.name == "breakfast"){
      breakfast = this.currentPersent.value;
      lunch = this.widget.relatedBox[0].currentState.currentPersent.value;
      dinner = this.widget.relatedBox[1].currentState.currentPersent.value;

    }else if(this.widget.name == "lunch"){
      breakfast =  this.widget.relatedBox[1].currentState.currentPersent.value;
      lunch = this.currentPersent.value;
      dinner =this.widget.relatedBox[0].currentState.currentPersent.value;

    }else if(this.widget.name == "dinner"){
      breakfast = this.widget.relatedBox[0].currentState.currentPersent.value;
      lunch = this.widget.relatedBox[1].currentState.currentPersent.value;
      dinner = this.currentPersent.value;
    }
    EasyLoading.show(status: "saving...");
    Response res = await Requests.setMealIntakeRatio({
      "uid":u.uid,
      "token":u.token,
      "breakfast":breakfast,
      "lunch":lunch,
      "dinner":dinner
    });
    if(res != null){
      if(res.data['code'] == 1){
        u.breakfastRatio = breakfast;
        u.lunchRatio = lunch;
        u.dinnerRatio = dinner;
        u.save();
      }
      EasyLoading.dismiss();
    }else{
      EasyLoading.dismiss();
      Fluttertoast.showToast(
        msg: "please check your internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.black45,
        fontSize: 13,
      );
    }
  }
}

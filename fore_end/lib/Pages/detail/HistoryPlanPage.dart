import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Models/Plan.dart';
import 'package:fore_end/Models/User.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/LocalDataManager.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/Req.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/DateButton.dart';
import 'package:fore_end/Components/texts/TitleText.dart';
import 'package:fore_end/Components/widgets/plan/PlanListItem.dart';
import "package:intl/intl.dart";
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPlanPage extends StatefulWidget {
  ///不会变的全局数据

  @override
  _HistoryPlanPageState createState() => _HistoryPlanPageState();
}

class _HistoryPlanPageState extends State<HistoryPlanPage> {
  ///数据放到State
  ///pagesData 用来存放所有不同页面的数据   然后在build 里面获取这些数据
  List<Map> pagesData = new List<Map>(); //里面放Map
  List localPagesData = new List(); //里面放离线数据 Map
  bool searching = false;
  String commentOfPlan = "减肥卓有成效，完成情况良好，未有延期记录";
  int index = 0;
  List<Consumption> plans;
  DateTime startedPlanTime;
  DateTime nowTimeWhenInit;
  DateTime finishedPlanTime;
  DateTime registerTime;

  ///默认的初始页号
  SwiperController swiperController = new SwiperController();
  //
  // @override
  // void didUpdateWidget(T oldWidget) {
  //
  // }

  ///TODO:现在这个页面还差 1.评价的判断和赋值  2.计划延迟的次数  3.计划的初始体重

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    DateTime now = DateTime.now();
    DateSelect to = DateSelect(
      width: 0.3,
      height: 40,
      buttonMargin: 18,
      beginTime: this.startedPlanTime,
      initTime: this.nowTimeWhenInit,
      lastTime: this.nowTimeWhenInit,
      isShowTwoButton: false,
      onChangeDate: (int newDate) {
        this.finishedPlanTime = DateTime.fromMillisecondsSinceEpoch(newDate);
        this.clearData();
        this.searchData();
        setState(() {});
      },
    );
    DateSelect from = DateSelect(
      width: 0.3,
      height: 40,
      buttonMargin: 18,
      beginTime: this.registerTime.add(Duration(days: -1)),
      initTime: this.registerTime.add(Duration(days: -1)),
      lastTime: this.finishedPlanTime,
      isShowTwoButton: false,
      onChangeDate: (int newDate) {
        this.startedPlanTime = DateTime.fromMillisecondsSinceEpoch(newDate);
        this.clearData();
        this.searchData();
        setState(() {});
      },
    );
    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          height: ScreenTool.partOfScreenHeight(0.1),
          // margin: EdgeInsets.only(top:20),
          padding: EdgeInsets.only(
            top: 40,
          ),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: MyTheme.convert(ThemeColorName.ComponentBackground),
          ),
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.white),
          // ),
          child: Row(
            children: [
              GestureDetector(
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 25,
                  color: MyTheme.convert(ThemeColorName.NormalIcon),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                CustomLocalizations.of(context).from,
                style: TextStyle(
                    fontSize: 20,
                    color: MyTheme.convert(ThemeColorName.NormalText),
                    fontFamily: 'Futura'),
              ),
              from,
              Text(CustomLocalizations.of(context).to,
                  style: TextStyle(
                      fontSize: 20,
                      color: MyTheme.convert(ThemeColorName.NormalText),
                      fontFamily: 'Futura')),
              to
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        Container(
            // padding: EdgeInsets.only(top: ScreenTool.partOfScreenHeight(0.05)),
            height: ScreenTool.partOfScreenHeight(0.9),
            width: ScreenTool.partOfScreenWidth(1),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(5),
              color: MyTheme.convert(ThemeColorName.ComponentBackground),
            ),
            child: this.searching
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Searching...",
                      style: TextStyle(
                          color: MyTheme.convert(ThemeColorName.NormalText),
                          fontFamily: "Futura",
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ))
                : this.index <= 0
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          "No Plan was found",
                          style: TextStyle(
                              color: MyTheme.convert(ThemeColorName.NormalText),
                              fontFamily: "Futura",
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ))
                    : this.getSwiper()),
      ],
    ));
  }

  @override
  void initState() {
    User u = User.getInstance();
    DateTime now = DateTime.now();

    this.nowTimeWhenInit = now;
    this.registerTime = now.add(Duration(days: -1 * u.registerTime()));
    this.startedPlanTime = now.add(Duration(days: -1 * u.registerTime()));
    this.finishedPlanTime = now;

    if (u.isOffline) {
      this.searching = false;
      print("历史计划界面离线成功--------1");
      SharedPreferences pre = LocalDataManager.pre;
      int bg = pre.getInt("localBeginTime");
      int ed = pre.getInt("localEndTime");
      String json = pre.getString("localHistoryPlan");
      this.localPagesData = jsonDecode(json);
      this.setValue(this.localPagesData);
      if (bg != null) {
        this.startedPlanTime = DateTime.fromMillisecondsSinceEpoch(bg);
      }
      if (ed != null) {
        this.finishedPlanTime = DateTime.fromMillisecondsSinceEpoch(ed);
      }
      print("历史计划里界面离线成功--------1");
    } else {
      this.searching = true;
      this.searchData();
    }
  }

  void clearData() {
    this.pagesData.clear();
  }

  //查询新的数据，并且刷新页面
  //仅当第一次页面渲染完成时，或是起止时间选择变化时，该函数被执行
  void searchData() async {
    User u = User.getInstance();
    this.searching = true;
    Response res = await Requests.getHistoryPlan(context, {
      "uid": u.uid,
      "token": u.token,
      "begin": (this.startedPlanTime.millisecondsSinceEpoch / 1000).floor(),
      "end": (this.finishedPlanTime.millisecondsSinceEpoch / 1000).floor()
    });
    if (res == null) return;

    for(Map everyPlan in res.data['data']){
      plans.add(Consumption.fromJson(everyPlan));
    }
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    this.searching = false;
    if (mounted) {
      setState(() {});
    }
  }



  void setValue(List pagesData) {
    // String foodNames;
    // double foodCalorie;

    List<double> totalCaloriesOfSameDay = [];
    Map<int,int> highCalorisDayOfIndex={};


    this.index = pagesData.length;
    pagesData.forEach((eachPlan) {
      this.index++;
    });

    setState(() {});
  }

  Widget getColumnContent(int idx) {
    // return SizedBox();
    return Column(
      children: [
        TitleText(
          text: this.plans[idx].planType,
          underLineLength: 0.5,
          fontSize: 25,
          maxWidth: 0.8,
          maxHeight: 40,
        ),
        SizedBox(
          height: 5,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).startPlan,
          rightText: "",
          rightValue: this.plans[idx].planBeginTime,
          isShowRightValue: true,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).finishPlan,
          rightText: "",
          rightValue: this.plans[idx].getPlanRealEndTime(context),
          isShowRightValue: true,
        ),
        SizedBox(
          height: 15,
        ),
        TitleText(
          text: CustomLocalizations.of(context).totalNutrition,
          underLineLength: 0.5,
          fontSize: 18,
          maxWidth: 0.8,
          maxHeight: 30,
        ),
        SizedBox(
          height: 5,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).caloriesTotal,
          rightText: "Kcal",
          rightValue:this.plans[idx].accumCalories,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).caloriesDaily,
          rightText: "Kcal",
          rightValue:this.plans[idx].avgCalories,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).proteinTotal,
          rightText: "g",
          rightValue:this.plans[idx].accumProtein,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).proteinDaily,
          rightText: "g",
          rightValue:this.plans[idx].avgProtein
        ),

        PlanTextItem(
          leftText: CustomLocalizations.of(context).goalWeight,
          rightText: "Kg",
          rightValue:this.plans[idx].goalWeight,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).weightStart,
          rightText: "Kg",
          rightValue:this.plans[idx].startWeight,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).weightFinish,
          rightText: "Kg",
          rightValue: this.plans[idx].achievedWeight,
        ),

        SizedBox(
          height: 15,
        ),
        TitleText(
          text: CustomLocalizations.of(context).planExecution,
          underLineLength: 0.5,
          fontSize: 18,
          maxWidth: 0.8,
          maxHeight: 30,
        ),
        SizedBox(
          height: 5,
        ),
        // PlanTextItem(
        //   leftText:
        //   CustomLocalizations.of(context).caloriesStandard,
        //   rightText: " Days",
        //   rightValue: this.data,
        // ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).caloriesOver,
          rightText: " Days",
          rightValue:this.plans[idx].daysOfCalsHigh,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).caloriesInsufficient,
          rightText: " Days",
          rightValue: this.plans[idx].daysOfcalsLow,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).prot,
          rightText: " Days",
          rightValue:this.plans[idx].daysOfproteinLow,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).proteinInsufficient,
          rightText: " Days",
          rightValue:this.plans[idx].daysOfproteinLow,
        ),
        PlanTextItem(
          leftText: CustomLocalizations.of(context).planDelayTimes,
          rightText: " Times",
          rightValue: this.numToString(this.data[idx]["exts"]),
        ),
        // SizedBox(
        //   height: 15,
        // ),
        // TitleText(
        //   text: CustomLocalizations.of(context).comment,
        //   underLineLength: 0.5,
        //   fontSize: 18,
        //   maxWidth: 0.8,
        //   maxHeight: 30,
        // ),
        // SizedBox(
        //   height: 5,
        // ),
        // Text(
        //   CustomLocalizations.of(context).commentFirst,
        //   style: TextStyle(
        //       fontSize: 15,
        //       color: MyTheme.convert(ThemeColorName.NormalText),
        //       fontFamily:
        //       'Futura'), //color: MyTheme.convert(ThemeColorName.NormalText)
        //   softWrap: true, //自动换行
        //   // textAlign: TextAlign.start,
        //   // overflow: TextOverflow.visible,
        // ),
      ],
    );
  }

  Widget getSwiper() {
    return Swiper(
      containerWidth: 0.8,
      onIndexChanged: (int index) {},
      outer: false,
      itemBuilder: (context, index) {
        return new Column(
          children: [
            Divider(
              color: MyTheme.convert(ThemeColorName.NormalText),
              thickness: 2,
            ),
            Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: MyTheme.convert(ThemeColorName.NormalText)),
                ),
                height: ScreenTool.partOfScreenHeight(0.82),
                width: ScreenTool.partOfScreenWidth(0.9),
                child: this.getColumnContent(index)),
          ],
        );
      },

      ///pagination展示默认左右分页指示器
      pagination: new SwiperPagination(
        margin: new EdgeInsets.all(9), //分页指示器与容器边框的距离
        alignment: Alignment.bottomCenter,
      ),

      ///设置示默认分页按钮 左右两边的按钮
      control: new SwiperControl(
        size: 40,
        padding: EdgeInsets.only(
          left: 10,
        ),
      ),
      controller: this.swiperController,

      indicatorLayout: PageIndicatorLayout.COLOR, //分页指示器滑动方式
      itemCount: this.index, //页数，这个应该由plan个数决定
      scrollDirection: Axis.horizontal, //滚动方向，现在是水平滚动，设置为Axis.vertical为垂直滚动
      loop: false, //无限轮播模式开关
      index: 0, //初始的时候下标位置
      autoplay: false, //自动播放开关.
      onTap: (int index) {}, //当用户手动拖拽或者自动播放引起下标改变的时候调用
      duration: 300, //动画时间，单位是毫秒
    );
  }

  String toThousands(int value) {
    String stringValue = value.toString();
    if (value >= 1000) {
      var format = NumberFormat('0,000');
      return format.format(value);
    }
    return stringValue;
  }



}

class Consumption{
  double _accumCalories;
  double _accumProtein;
  double _avgCalories;
  double _avgProtein;
  int _daysOfCalsHigh;
  int _daysOfcalsLow;
  int _daysOfproteinHigh;
  int _daysOfproteinLow;

  int _delayTimesOfPlan;
  double _startWeight;
  double _achievedWeight;
  double _goalWeight;
  bool _isPlanCompleted;
  int _planType;
  DateTime _planBeginTime;
  DateTime _planEndTime;
  DateTime _planRealEndTime;

  Consumption.fromJson(Map<String,dynamic> map){
    this._accumCalories=map["consumption"]["accumCalories"];
    this._accumProtein=map["consumption"]["accumProtein"];
    this._avgCalories=map["consumption"]["avgCalories"];
    this._avgProtein=map["consumption"]["avgProtein"];
    this._delayTimesOfPlan=map["exts"];
    this._goalWeight=map["planBrief"]["goalWeight"];
    this._achievedWeight=map["planBrief"]["achievedWeight"];
    this._startWeight=map["weeklyDetails"][0]["weight"];
    this._planBeginTime=DateTime.fromMillisecondsSinceEpoch(map["planBrief"]["begin"]*1000);
    this._planEndTime=DateTime.fromMillisecondsSinceEpoch(map["planBrief"]["end"]*1000);
    this._planRealEndTime=DateTime.fromMillisecondsSinceEpoch(map["planBrief"]["realEnd"]*1000);
    this._planType=map["planBrief"]["type"];
    this._isPlanCompleted=map["planBrief"]["hasCompleted"];

    this.assignDay(map["weeklyDetails"]);
  }

  String get planType{
   return Plan.planTypes[this._planType].toUpperCase();
  }

  String get calsHighDays{
    return this.numToString(this._daysOfCalsHigh);
  }
  String get calsLowDays{
    return this.numToString(this._daysOfcalsLow);
  }
  String get proteinHighDays{
    return this.numToString(this._daysOfproteinHigh);
  }
  String get proteinLowDays{
    return this.numToString(this._daysOfproteinLow);
  }
  String get planBeginTime{
    return this.tsToStr(this._planBeginTime);
  }
  String get planEndTime{
    return this.tsToStr(this._planEndTime);
  }
  String getPlanRealEndTime(BuildContext context){
    if(this._planRealEndTime==null) return CustomLocalizations.of(context).planIsGoing;
    return this.tsToStr(this._planRealEndTime);
  }
  String get achievedWeight{
    if(this._achievedWeight==null) return "--";
    return this.numToString(_achievedWeight);
  }


  String numToString(num n) {
    String tmp = n.toString();
    tmp = tmp.split(".")[0];
    return tmp;
  }
  String tsToStr(DateTime date) {
    return DateTime.parse(formatDate(date, [yyyy, '-', mm, '-', dd]))
        .toString()
        .split(" ")[0];
  }

  bool isEqual(DateTime dt1,DateTime dt2) {
    if (dt1 == null) return false;
    return dt1.compareTo(dt2) == 0;
  }

  void assignDay(List<Map> weeklyDetailsOfPlan){

    for(Map m in weeklyDetailsOfPlan){
      List<Map<String,dynamic>> foodsConsumeOneWeek = m['foodsConsumed'];
      double caloriesUpper=m["cH"];
      double caloriesLower=m["cL"];
      double proteinUpper=m["pH"];
      double proteinLower=m["pL"];
      DateTime dateOfStartDay;
      bool isTheFirstDay=true;
      double totalCalories=0;
      double totalProtein=0;

      for(Map food in foodsConsumeOneWeek){
        DateTime eatingTime= DateTime.parse(formatDate(DateTime.fromMillisecondsSinceEpoch(food["time"] * 1000), [yyyy, '-', mm, '-', dd]));
        if(this.isEqual(dateOfStartDay, eatingTime)){
          totalCalories+=food["calories"];
          totalProtein+=food["protein"];
        }else {
          if(totalCalories>caloriesUpper){
            this._daysOfCalsHigh++;
          }else if(totalCalories<caloriesLower){
            this._daysOfcalsLow++;
          }
          if(totalProtein>proteinUpper){
            this._daysOfproteinHigh++;
          }else if(totalProtein<proteinLower){
            this._daysOfproteinLow++;
          }
          totalProtein=0;
          totalCalories=0;
          isTheFirstDay=true;
        }
        if(isTheFirstDay){
          dateOfStartDay=eatingTime;
          totalCalories+=food["calories"];
          isTheFirstDay=false;
        }
      }
      if(totalCalories>caloriesUpper){
        this._daysOfCalsHigh++;
      }else if(totalCalories<caloriesLower){
        this._daysOfcalsLow++;
      }
      if(totalProtein>proteinUpper){
        this._daysOfproteinHigh++;
      }else if(totalProtein<proteinLower){
        this._daysOfproteinLow++;
      }
      totalProtein=0;
      totalCalories=0;
      isTheFirstDay=true;
    }
  }

  String get accumProtein {
    return this.numToString(_accumProtein);
  }
  String get avgCalories {
    return this.numToString(_avgCalories);
  }
  String get avgProtein {
    return this.numToString(_avgProtein);
  }
  String get accumCalories {
    return this.numToString(_accumCalories);
  }
  String get daysOfCalsHigh {
    return this.numToString(_daysOfCalsHigh);
  }
  String get daysOfcalsLow {
    return this.numToString(_daysOfcalsLow);
  }
  String get daysOfproteinHigh {
    return this.numToString(_daysOfproteinHigh);
  }
  String get daysOfproteinLow {
    return this.numToString(_daysOfproteinLow);
  }
  String get delayTimesOfPlan {
    return this.numToString(_delayTimesOfPlan);
  }
  String get startWeight {
    return this.numToString(_startWeight);
  }
  String get goalWeight {
    return this.numToString(_goalWeight);
  }
  // String get isPlanCompleted {
  //   return this.numToString(_isPlanCompleted);
  // }
  String get planRealEndTime {
    return this.tsToStr(_planRealEndTime);
  }



}

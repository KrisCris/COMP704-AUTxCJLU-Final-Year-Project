import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanListItem.dart';
import 'package:date_format/date_format.dart';

class HistoryPlanPage extends StatefulWidget {
  ///不会变的全局数据

  @override
  _HistoryPlanPageState createState() => _HistoryPlanPageState();
}

class _HistoryPlanPageState extends State<HistoryPlanPage> {
  ///数据放到State
  ///pagesData 用来存放所有不同页面的数据   然后在build 里面获取这些数据
  List<Map> pagesData = new List<Map>(); //里面放Map
  bool searching;

  String planType; //减肥 增肌  维持

  DateTime startedPlanTime;
  DateTime finishedPlanTime;
  DateTime nowTimeWhenInit;
  DateTime registerTime;

  int caloriesTotalInput;
  int caloriesDailyInput;
  int proteinTotalInput;
  int proteinDailyInput;
  int startedWeight;
  int finishedWeight;

  List bodyWeightUpdateList = [];

  int standardCaloriesDays;
  int overCaloriesDays;
  int lessCaloriesDays;
  int delayDays;

  String commentOfPlan = "减肥卓有成效，完成情况良好，未有延期记录";

  int index = 0;

  ///默认的初始页号
  SwiperController swiperController = new SwiperController();
  //
  // @override
  // void didUpdateWidget(T oldWidget) {
  //
  // }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    DateTime now = DateTime.now();
    DateSelect to = DateSelect(
      width: 0.3,
      height: 40,
      buttonMargin: 18,
      beginTime: this.startedPlanTime,
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
      beginTime: this.registerTime,
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
                    fontSize: 20, color: Colors.white, fontFamily: 'Futura'),
              ),
              from,
              Text(CustomLocalizations.of(context).to,
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: 'Futura')),
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
                : this.pagesData.length <= 0
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
    this.searching = true;
    this.nowTimeWhenInit = now;
    this.registerTime = now.add(Duration(days: -1 * u.registerTime()));
    this.startedPlanTime = now.add(Duration(days: -1 * u.registerTime()));
    this.finishedPlanTime = now;
    //第一次页面渲染完毕再执行接口查询
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      this.searchData();
    });
  }

  void clearData() {
    this.pagesData.clear();
  }

  //查询新的数据，并且刷新页面
  //仅当第一次页面渲染完成时，或是起止时间选择变化时，该函数被执行
  void searchData() async {
    User u = User.getInstance();
    this.searching = true;
    Response res = await Requests.getHistoryPlan({
      "uid": u.uid,
      "token": u.token,
      "begin": (this.startedPlanTime.millisecondsSinceEpoch / 1000).floor(),
      "end": (this.finishedPlanTime.millisecondsSinceEpoch / 1000).floor()
    });
    if (res == null) return;
    if (res.data['code'] != 1) return;
    for (Map m in res.data['data']) {
      //TODO:将获取到的数据填充到 [pagesData]
    }
    this.searching = false;
    setState(() {});
  }

  Swiper getSwiper() {
    return Swiper(
      onIndexChanged: (int index) {},
      outer: false,
      itemBuilder: (context, index) {
        return new Column(
          children: [
            Divider(
              color: Colors.white,
              thickness: 2,
            ),
            Container(
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 6),
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                height: ScreenTool.partOfScreenHeight(0.83),
                child: Column(
                  children: [
                    TitleText(
                      text: CustomLocalizations.of(context).shedWeight,
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
                      rightText: "2020年06月20日",
                      rightValue: 0,
                      isShowRightValue: false,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).finishPlan,
                      rightText: "2020年10月10日",
                      rightValue: 0,
                      isShowRightValue: false,
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
                      rightValue: 215130,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).caloriesDaily,
                      rightText: "Kcal",
                      rightValue: 1955,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).proteinTotal,
                      rightText: "g",
                      rightValue: 6820,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).proteinDaily,
                      rightText: "g",
                      rightValue: 62,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).weightStart,
                      rightText: "Kg",
                      rightValue: 71,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).weightFinish,
                      rightText: "Kg",
                      rightValue: 65,
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
                    PlanTextItem(
                      leftText:
                          CustomLocalizations.of(context).caloriesStandard,
                      rightText: " ",
                      rightValue: 97,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).caloriesOver,
                      rightText: " ",
                      rightValue: 10,
                    ),
                    PlanTextItem(
                      leftText:
                          CustomLocalizations.of(context).caloriesInsufficient,
                      rightText: " ",
                      rightValue: 3,
                    ),
                    PlanTextItem(
                      leftText: CustomLocalizations.of(context).planDelayTimes,
                      rightText: " ",
                      rightValue: 0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TitleText(
                      text: CustomLocalizations.of(context).comment,
                      underLineLength: 0.5,
                      fontSize: 18,
                      maxWidth: 0.8,
                      maxHeight: 30,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      CustomLocalizations.of(context).commentFirst,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily:
                              'Futura'), //color: MyTheme.convert(ThemeColorName.NormalText)
                      softWrap: true, //自动换行
                      // textAlign: TextAlign.start,
                      // overflow: TextOverflow.visible,
                    ),
                  ],
                )),
          ],
        );
      },

      ///pagination展示默认分页指示器,这里选择另外一个 ///如果需要定制自己的分页指示器，那么可以这样写：
      pagination: new SwiperPagination(
        margin: new EdgeInsets.all(10.0), //分页指示器与容器边框的距离
        alignment: Alignment.bottomCenter,
      ),

      ///设置 new SwiperControl() 展示默认分页按钮 左右两边的按钮
      control: new SwiperControl(
        size: 40,
        padding: EdgeInsets.only(
          left: 10,
        ),
      ),
      controller: this.swiperController,

      indicatorLayout: PageIndicatorLayout.COLOR, //分页指示器滑动方式
      itemCount: 5, //页数，这个应该由plan个数决定
      scrollDirection: Axis.horizontal, //滚动方向，现在是水平滚动，设置为Axis.vertical为垂直滚动
      loop: false, //无限轮播模式开关
      index: 0, //初始的时候下标位置
      autoplay: false, //自动播放开关.
      // itemWidth: ,
      // itemHeight: ,
      onTap: (int index) {
        print("123123123");
      }, //当用户手动拖拽或者自动播放引起下标改变的时候调用
      duration: 300, //动画时间，单位是毫秒

      // controller: new SwiperController(
      // ),
    );
  }
}

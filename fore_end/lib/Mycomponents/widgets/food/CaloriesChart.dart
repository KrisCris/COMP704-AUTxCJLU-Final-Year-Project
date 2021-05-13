import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaloriesBarChart extends StatefulWidget {
  DateTime mealTime;
  bool isChangeColor = false;

  ///每条柱状图的上限，超出也会显示
  int planLimitedCalories =
      User.getInstance().plan.dailyCaloriesUpperLimit.floor() ?? 2000;

  ///组件的宽高
  double width;
  double height;

  ///构建函数
  CaloriesBarChart({
    Key key,
    double width = 0.95,
    double height = 300,
  }) : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);
    this.height = this.height;
  }

  @override
  State<StatefulWidget> createState() => CaloriesBarChartState();
}

class CaloriesBarChartState extends State<CaloriesBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex;

  Map<DateTime, double> localDateValueMap = new Map<DateTime, double>();


  ///保存周几对应的现实日期，根据今天的时间来计算
  List<DayInfo> weekDateInfos;
  ///今天的数据（或者是选中的那天的数据）
  DayInfo todayInfo;

  ///初始化或者切换星期的时候，重置每周的数据
  void resetWeekDateInfos(DateTime settingday){
    DateTime settingZero = DateTime(settingday.year, settingday.month, settingday.day, 0, 0, 0);
    DateTime monday = settingZero.add(Duration(days: (settingZero.weekday - 1) * -1));
    this.weekDateInfos = [
      DayInfo(name: "Monday", abbr: "Mon", value: 0, date: monday),
      DayInfo(
          name: "Tuesday",
          abbr: "Tue",
          value: 0,
          date: monday.add(Duration(days: 1))),
      DayInfo(
          name: "Wednesday",
          abbr: "Wed",
          value: 0,
          date: monday.add(Duration(days: 2))),
      DayInfo(
          name: "Thursday",
          abbr: "Thur",
          value: 0,
          date: monday.add(Duration(days: 3))),
      DayInfo(
          name: "Friday",
          abbr: "Fri",
          value: 0,
          date: monday.add(Duration(days: 4))),
      DayInfo(
          name: "Saturday",
          abbr: "Sat",
          value: 0,
          date: monday.add(Duration(days: 5))),
      DayInfo(
          name: "Sunday",
          abbr: "Sun",
          value: 0,
          date: monday.add(Duration(days: 6))),
    ];
    this.todayInfo = this.weekDateInfos[settingZero.weekday - 1];
}

  void initialDate() {
    User u = User.getInstance();
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    this.resetWeekDateInfos(today);

    ///获取接口的数据 增加离线初始化  初始化  当用户离线才这样 否则去服务器获取数据
    if (u.isOffline) {
      SharedPreferences pre = LocalDataManager.pre;
      String json = pre.getString("localCalories");
      List LocalOneWeekCaloriesList = new List();
      LocalOneWeekCaloriesList = jsonDecode(json);
      this.assignValueBasedOnList(LocalOneWeekCaloriesList);
      this.todayInfo.value = User.getInstance().getTodayCaloriesIntake();
      setState(() {});
    } else {
      this.getHistoryCalories();
    }
  }

  ///服务器调接口的代码 并且把数据分配
  Future getHistoryCalories() async {
    int beginTime =
        (this.weekDateInfos[0].date.millisecondsSinceEpoch / 1000).floor();
    int endTime =
        (this.weekDateInfos[6].date.millisecondsSinceEpoch / 1000).floor();
    List oneWeekCaloriesList = new List();
    Response res = await Requests.getCaloriesIntake({
      "begin": beginTime,
      "end": endTime,
      "uid": User.getInstance().uid,
      "token": User.getInstance().token,
    });
    if (res.data['code'] == 1) {
      this.clearValue();
      oneWeekCaloriesList = res.data['data'];
      this.assignValueBasedOnList(oneWeekCaloriesList);
    } else {
      print("getCaloriesIntake 的接口有bug");
    }
  }

  ///处理接口返回的卡路里数据 赋值
  void assignValueBasedOnList(List caloriesList) {
    ///一周的时间，挨个去添加数据
    caloriesList.forEach((element) {
      DateTime dateOfElement =
          DateTime.fromMillisecondsSinceEpoch(element["time"] * 1000);
      DateTime formatedDate =
          DateTime.parse(formatDate(dateOfElement, [yyyy, '-', mm, '-', dd]));
      double caloriesOfElement = element["calories"];
      for (DayInfo df in this.weekDateInfos) {
        if (df.isEqual(formatedDate)) {
          df.value += caloriesOfElement.toInt();
          return;
        }
      }
    });

    setState(() {});
  }

  @override
  @mustCallSuper
  void initState() {
    this.initialDate();
  }

  @override
  void didUpdateWidget(covariant CaloriesBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.todayInfo.value = User.getInstance().getTodayCaloriesIntake();
    setState(() {});
  }

  void judgeDate({DateTime time}) {
    DateTime settingDay = DateTime(time.year, time.month, time.day,0,0,0);
    DateTime mondayDate = this.weekDateInfos[0].date;
    DateTime sundayDate = this.weekDateInfos[6].date;

    if ((settingDay.isBefore(sundayDate) || settingDay.compareTo(sundayDate) == 0) &&
        (settingDay.isAfter(mondayDate) || settingDay.compareTo(mondayDate) == 0)
    ) {
        ///如果是选择了在目前的一周内 那么什么也不用做  只需要刷新今天的数据颜色
      this.todayInfo = this.weekDateInfos[settingDay.weekday-1];
    } else {
      this.calculateDate(settingDay);
    }
    setState(() {});
  }

  ///根据设定日期所在一周的卡路里量  去服务器获取
  void calculateDate(DateTime settingDay) {
    String weekDayOfSetting = DateFormat('EEEE').format(settingDay);
    this.resetWeekDateInfos(settingDay);
    ///先设定日期处理
    this.getHistoryCalories();

    ///从接口获取每一天的数据,只有本地没有时 最后才去获取
  }
  ///每次获取数据之前都清空之前的数据
  void clearValue() {
    for (DayInfo df in this.weekDateInfos) {
      df.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTool.partOfScreenWidth(0.95),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: MyTheme.convert(ThemeColorName.ComponentBackground),
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  CustomLocalizations.of(context).caloriesChartTitle,
                  style: TextStyle(
                      color: MyTheme.convert(ThemeColorName.NormalText),
                      fontSize: 18,
                      fontFamily: 'Futura',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DateSelect(
                      gap: 7,
                      width: 0.5,
                      height: 40,
                      beginTime: DateTime(2021, 1, 1),
                      lastTime: DateTime.now(),
                      onChangeDate: (int newDate) {
                        this.judgeDate(
                            time: DateTime.fromMillisecondsSinceEpoch(newDate));

                        ///这里选择好新的日期后 设置今天的日期为新的日期
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        return makeGroupData(i, this.weekDateInfos[i].value.toDouble(),
            isTouched: i == touchedIndex,
            barColor: this.weekDateInfos[i].isEqual(this.todayInfo.date)
                ? Color(0xff72d8bf)
                : Color(0xffED9055));
      });

  ///这里是长按某行数据时的提示框，可以修改里面的提示文字，这里显示 日期 + 数值
  BarChartData mainBarData() {
    ///先初始化数据,默认就是以今天作为初始化
    // if(widget.isNeedInitial)  this.initialDate(widget.today);
    // this.calculateDate(widget.today);
    ///再构建
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              DateTime currentDate = this.weekDateInfos[group.x.toInt()].date;
              weekDay =formatDate(currentDate, [yyyy, '-', mm, '-', dd]);
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString() + ' Kcal',
                  TextStyle(color: Colors.yellow));
            }),

        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),

      ///横坐标，条形柱的设置和调用
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
              color: MyTheme.convert(ThemeColorName.NormalText),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            return this.weekDateInfos[value.toInt()].abbr;
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  ///1条形柱的颜色  和  宽度
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xff72d8bf),
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,

            ///y是每条数据的上限  比如2000 Kcal
            // y: widget.p.dailyCaloriesUpperLimit.floor().toDouble(),
            y: widget.planLimitedCalories.toDouble(),
            colors: [MyTheme.convert(ThemeColorName.PageBackground)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

class DayInfo {
  String name;
  String abbr;
  DateTime date;
  int value;

  DayInfo({this.name, this.abbr, this.date, this.value});

  bool isEqual(DateTime dt) {
    return this.date.compareTo(dt) == 0;
  }
}

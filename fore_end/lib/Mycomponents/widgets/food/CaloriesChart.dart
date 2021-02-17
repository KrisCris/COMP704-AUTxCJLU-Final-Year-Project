import 'dart:async';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CaloriesBarChart extends StatefulWidget {
  DateTime mealTime;
  ///今天的日期
  DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  String weekDayOfToday=DateFormat('EEEE').format(DateTime.now());

  bool isChangeColor=false;
  bool isNeedInitial=true;
  Plan p;

  ///下面的三种属性都要在calculateDate()方法里进行初始化

  ///保存周几对应的现实日期，根据今天的时间来计算
  DateTime mondayDate;
  DateTime tuesdayDate;
  DateTime wednesdayDate;
  DateTime thursdayDate;
  DateTime fridayDate;
  DateTime saturdayDate;
  DateTime sundayDate;

  ///来判断今天是周几，来决定突出今天的条形柱的颜色
  bool isMondayDate=false;
  bool isTuesdayDate=false;
  bool isWednesdayDate=false;
  bool isThursdayDate=false;
  bool isFridayDate=false;
  bool isSaturdayDate=false;
  bool isSundayDate=false;

  ///保存每一天应该的卡路里值
  double mondayValue=1000; //测试
  double tuesdayValue=1000;
  double wednesdayValue=1000;
  double thursdayValue=1000;
  double fridayValue=1000;
  double saturdayValue=1000;
  double sundayValue=1000;


  double planLimitedCalories=2500;

  ///组件的宽高
  double width=ScreenTool.partOfScreenWidth(0.95);
  double height=300;

  ///构建函数
  CaloriesBarChart(
    { Key key,
      double width=0.95,
      double height=300,
    }):super(key:key){
      this.width=ScreenTool.partOfScreenWidth(this.width);
      this.height=this.height;
}

  @override
  State<StatefulWidget> createState() => CaloriesBarChartState();
}

class CaloriesBarChartState extends State<CaloriesBarChart> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex;

  ///时间选择按钮的配置函数，来设置新的日期并且刷新组件
  void judgeDate({DateTime time}){

    DateTime nowCurrent = DateTime.now();
    DateTime today = DateTime(nowCurrent.year,nowCurrent.month,nowCurrent.day);
    DateTime settingDay = DateTime(time.year,time.month,time.day);
    if(settingDay.compareTo(today) == 0){
      this.calculateDate(today);
    }else{
      ///不一样再去修改
      this.calculateDate(settingDay);
    }
    setState(() {

    });
  }

  ///从服务器获取一周的卡路里记录，然后保存给widget的变量里
  void calculateDate(DateTime settingDay){
    String weekDayOfSetting=DateFormat('EEEE').format(settingDay);

    ///这里还要与今天的日期进行比较，来决定是否修改颜色，因为setstate是重新build的，所以到了第一次初始化构建的时候回直接改变颜色，等重新选择日期后无法绕过初始化 所以还是会进行修改，因此要判断是否一样

    int mondayIndex;

    switch(weekDayOfSetting){
      case 'Monday':
        widget.isMondayDate=true;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        mondayIndex=1;
        break;

      case 'Tuesday':
        widget.isTuesdayDate=true;
        widget.isMondayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        mondayIndex=-1;
        break;

      case 'Wednesday':
        widget.isWednesdayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        mondayIndex=-2;
        break;

      case 'Thursday':
        widget.isThursdayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        mondayIndex=-3;
        break;

      case 'Friday':
        widget.isFridayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        mondayIndex=-4;
        break;

      case 'Saturday':
        print("今天是周六");
        widget.isSaturdayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSundayDate=false;
        mondayIndex=-5;
        break;

      case 'Sunday':
        widget.isSundayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        mondayIndex=-6;
        break;

      default:
        print('calculateDate  none');
    }
    ///计算其他六天的具体日期，比如2/13，这里用 setting的日期来算每个星期几的日期
    widget.mondayDate=settingDay.add(Duration(days: mondayIndex));
    widget.tuesdayDate=settingDay.add(Duration(days: mondayIndex+1));
    widget.wednesdayDate=settingDay.add(Duration(days: mondayIndex+2));
    widget.thursdayDate=settingDay.add(Duration(days: mondayIndex+3));
    widget.fridayDate=settingDay.add(Duration(days: mondayIndex+4));
    widget.saturdayDate=settingDay.add(Duration(days: mondayIndex+5));
    widget.sundayDate=settingDay.add(Duration(days: mondayIndex+6));

    ///有了星期几的具体日期就可以，传入数据库来获取这一天的卡路里了。所以都设置好了
    // widget.mondayValue=1000;
    this.getHistoryCalories(widget.mondayDate,"sunday");

  }


  void initialDate(DateTime settingDay){
    String weekDayOfSetting=DateFormat('EEEE').format(settingDay);
    int mondayIndex;

    switch(weekDayOfSetting){
      case 'Monday':
        widget.isMondayDate=true;
        mondayIndex=1;
        break;

      case 'Tuesday':
        widget.isTuesdayDate=true;
        mondayIndex=-1;
        break;

      case 'Wednesday':
        widget.isWednesdayDate=true;
        mondayIndex=-2;
        break;

      case 'Thursday':
        widget.isThursdayDate=true;
        mondayIndex=-3;
        break;

      case 'Friday':
        widget.isFridayDate=true;
        mondayIndex=-4;
        break;

      case 'Saturday':
        widget.isSaturdayDate=true;
        mondayIndex=-5;
        break;

      case 'Sunday':
        widget.isSundayDate=true;
        mondayIndex=-6;
        break;

      default:
        print('calculateDate  none');
    }
    ///计算其他六天的具体日期，比如2/13，这里用 setting的日期来算每个星期几的日期
    widget.mondayDate=settingDay.add(Duration(days: mondayIndex));
    widget.tuesdayDate=settingDay.add(Duration(days: mondayIndex+1));
    widget.wednesdayDate=settingDay.add(Duration(days: mondayIndex+2));
    widget.thursdayDate=settingDay.add(Duration(days: mondayIndex+3));
    widget.fridayDate=settingDay.add(Duration(days: mondayIndex+4));
    widget.saturdayDate=settingDay.add(Duration(days: mondayIndex+5));
    widget.sundayDate=settingDay.add(Duration(days: mondayIndex+6));

    ///有了星期几的具体日期就可以，传入数据库来获取这一天的卡路里了。所以都设置好了


  }

  Future getHistoryCalories(DateTime assignedDate, String weekdayOfDate) async{
    ///先用今天的日期来测试
    int beginTime = (DateTime(assignedDate.year,assignedDate.month,assignedDate.day,0,0,0).millisecondsSinceEpoch/1000).floor();
    int endTime = (DateTime(assignedDate.year,assignedDate.month,assignedDate.day,23,59,59).millisecondsSinceEpoch/1000).floor();
    int caloriesData=100;
    try{
      Response res = await Requests.getCaloriesIntake({
        "begin": beginTime,
        "end": endTime,
        "uid": User.getInstance().uid,
      });
      if (res.data['code'] == -1) {
        print("getCaloriesIntake 获取成功！");
        caloriesData=res.data['data'];
      }
    }on DioError catch(e){
      print("getCaloriesIntake 获取失败！");
      print(e.toString());
    }
    print("today is "+ weekdayOfDate);

    widget.sundayValue=caloriesData.toDouble();
    return 100;

  }







  @override
  Widget build(BuildContext context) {
      return  Container(
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
                        color: const Color(0xff379982), fontSize: 18, fontFamily: 'Futura',fontWeight: FontWeight.bold,decoration: TextDecoration.none),
                  ),
                  SizedBox(height: 10,),
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
                    children: [DateSelect(
                      width: 0.5,
                      height: 40,
                      beginTime: DateTime(2021,1,1),
                      lastTime: DateTime.now(),
                      onChangeDate: (int newDate){
                        widget.isNeedInitial=false;
                        this.judgeDate(time:DateTime.fromMillisecondsSinceEpoch(newDate));
                        ///这里选择好新的日期后 设置今天的日期为新的日期
                      },
                    ),],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  }




  ///这里是每条数据的数值  等接口有了 可以从服务器获取每日卡路里  现在是假的 、 在最后一行代码被调用
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget.mondayValue, isTouched: i == touchedIndex,barColor: widget.isMondayDate?Color(0xffE05067):Color(0xffED9055));
      case 1:
        return makeGroupData(1, widget.tuesdayValue, isTouched: i == touchedIndex,barColor: widget.isTuesdayDate?Color(0xffE05067):Color(0xffED9055));
      case 2:
        return makeGroupData(2, widget.wednesdayValue, isTouched: i == touchedIndex,barColor: widget.isWednesdayDate?Color(0xffE05067):Color(0xffED9055));
      case 3:
        return makeGroupData(3, widget.thursdayValue, isTouched: i == touchedIndex,barColor: widget.isThursdayDate?Color(0xffE05067):Color(0xffED9055));
      case 4:
        return makeGroupData(4, widget.fridayValue, isTouched: i == touchedIndex,barColor: widget.isFridayDate?Color(0xffE05067):Color(0xffED9055));
      case 5:
        return makeGroupData(5, widget.saturdayValue, isTouched: i == touchedIndex,barColor: widget.isSaturdayDate?Color(0xffE05067):Color(0xffED9055));
      case 6:
        return makeGroupData(6, widget.sundayValue, isTouched: i == touchedIndex,barColor: widget.isSundayDate?Color(0xffE05067):Color(0xffED9055));
      default:
        return null;
    }
  });

  ///1条形柱的颜色  和  宽度
  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = const Color(0xffED9055),
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
            y:widget.planLimitedCalories,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }


  ///这里是长按某行数据时的提示框，可以修改里面的提示文字，这里显示 日期 + 数值
  BarChartData mainBarData() {
    ///先初始化数据,默认就是以今天作为初始化
    if(widget.isNeedInitial)  this.initialDate(widget.today);
    // this.calculateDate(widget.today);
    ///再构建
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay=formatDate(widget.mondayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 1:
                  weekDay=formatDate(widget.tuesdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 2:
                  weekDay=formatDate(widget.wednesdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 3:
                  weekDay=formatDate(widget.thursdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 4:
                  weekDay=formatDate(widget.fridayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 5:
                  weekDay=formatDate(widget.saturdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 6:
                  weekDay=formatDate(widget.sundayDate, [yyyy, '-', mm, '-', dd]);
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString()+' Kcal', TextStyle(color: Colors.yellow));
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
          getTextStyles: (value) =>
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
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

}
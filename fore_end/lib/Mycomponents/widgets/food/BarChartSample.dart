import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Plan.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CaloriesBarChart extends StatefulWidget {
  DateTime mealTime;

  DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  String weekDayOfToday=DateFormat('EEEE').format(DateTime.now());

  bool isChangeColor=false;
  Plan p;

  ///每个星期几 对应的日期，要根据现在的时间来计算
  DateTime mondayDate;
  DateTime tuesdayDate;
  DateTime wednesdayDate;
  DateTime thursdayDate;
  DateTime fridayDate;
  DateTime saturdayDate;
  DateTime sundayDate;

  bool isMondayDate=false;
  bool isTuesdayDate=true;
  bool isWednesdayDate=false;
  bool isThursdayDate=false;
  bool isFridayDate=false;
  bool isSaturdayDate=false;
  bool isSundayDate=false;

  double width;
  ///高度
  double height;

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


  ///设定新的时间 ，就重新刷新新的界面
  ///1.获取今天的日期，然后转化为星期几，比如是今天是星期三，就把除了星期三的今天都更新
  ///2.再把对应的星期的颜色变成绿色，默认其他数值为0
  ///3.如果日期选择器改变了时间，就把选择的日期的对应星期几突出显示，并且
  void judgeDate({DateTime time}){
    time = time ?? widget.mealTime;
    DateTime nowCurrent = DateTime.now();
    DateTime today = DateTime(nowCurrent.year,nowCurrent.month,nowCurrent.day);
    DateTime settingDay = DateTime(time.year,time.month,time.day);


    if(settingDay.compareTo(today) == 0){
      User u = User.getInstance();
      if(mounted){
        setState(() {});
      }
    }
  }

  ///获取之前几天的数据可以根据服务器接口来获取卡路里。
  void calculateDate(String todayWeek){
    switch(todayWeek){
      case 'Monday':
        widget.isMondayDate=true;
        print("22");
        break;

      case 'Tuesday':
        print("22");
        widget.isTuesdayDate=true;
        break;

      case 'Wednesday':
        print("22");
        widget.isWednesdayDate=true;

        break;

      case 'Thursday':
        print("22");
        widget.isThursdayDate=true;
        break;

      case 'Friday':
        print("22");
        widget.isFridayDate=true;
        break;

      case 'Saturday':
        print("22");
        widget.isSaturdayDate=true;
        break;

      case 'Sunday':
        print("22");
        widget.isSundayDate=true;
        break;

      default:
        print('calculateDate  none');
    }

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
                // mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'History Daily Calories',
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
                        this.judgeDate(time:DateTime.fromMillisecondsSinceEpoch(newDate));
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


  ///条形柱的颜色  和  宽度
  BarChartGroupData makeGroupData(
      int x,
      double y, {
        ///条形柱的颜色  和  宽度
        bool isTouched = false,
        Color barColor = const Color(0xffED9055),
        // Color todayColor= const Color(0xffE05067),
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
            y:2000,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  ///这里是每条数据的数值  等接口有了 可以从服务器获取每日卡路里  现在是假的
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, 1500, isTouched: i == touchedIndex,barColor: widget.isMondayDate?Color(0xffE05067):Color(0xffED9055));
      case 1:
        return makeGroupData(1, 650, isTouched: i == touchedIndex,barColor: widget.isTuesdayDate?Color(0xffE05067):Color(0xffED9055));
      case 2:
        return makeGroupData(2, 500, isTouched: i == touchedIndex,barColor: widget.isWednesdayDate?Color(0xffE05067):Color(0xffED9055));
      case 3:
        return makeGroupData(3, 750, isTouched: i == touchedIndex,barColor: widget.isThursdayDate?Color(0xffE05067):Color(0xffED9055));
      case 4:
        return makeGroupData(4, 900, isTouched: i == touchedIndex,barColor: widget.isFridayDate?Color(0xffE05067):Color(0xffED9055));
      case 5:
        return makeGroupData(5, 1150, isTouched: i == touchedIndex,barColor: widget.isSaturdayDate?Color(0xffE05067):Color(0xffED9055));
      case 6:
        return makeGroupData(6, 650, isTouched: i == touchedIndex,barColor: widget.isSundayDate?Color(0xffE05067):Color(0xffED9055));
      default:
        return null;
    }
  });


  ///按下时提示框里面的提示文字，可以显示 日期 + Kcal
  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
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

      ///这是横坐标的title文字相关
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
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
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CaloriesBarChart extends StatefulWidget {
  DateTime mealTime;
  ///今天的日期
  DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  String weekDayOfToday=DateFormat('EEEE').format(DateTime.now());

  bool isChangeColor=false;
  Plan p=User.getInstance().plan;

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
  int mondayValue=0; //测试
  int tuesdayValue=0;
  int wednesdayValue=0;
  int thursdayValue=0;
  int fridayValue=0;
  int saturdayValue=0;
  int sundayValue=0;

  ///每条柱状图的上限，超出也会显示
  int planLimitedCalories=2000;

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

  @override
  @mustCallSuper
  void initState() {
    print("initState 初始化数据方法被调用了！-------------");
    int mondayIndex;
    User u=User.getInstance();
    switch(widget.weekDayOfToday){
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
    widget.mondayDate=widget.today.add(Duration(days: mondayIndex));
    widget.tuesdayDate=widget.today.add(Duration(days: mondayIndex+1));
    widget.wednesdayDate=widget.today.add(Duration(days: mondayIndex+2));
    widget.thursdayDate=widget.today.add(Duration(days: mondayIndex+3));
    widget.fridayDate=widget.today.add(Duration(days: mondayIndex+4));
    widget.saturdayDate=widget.today.add(Duration(days: mondayIndex+5));
    widget.sundayDate=widget.today.add(Duration(days: mondayIndex+6));


    ///获取接口的数据 初始化
    this.getHistoryCalories();

    ///这里是初始化，weekDayOfToday的数据，如果今天是周四 那么周四这一天的数据应该是本地的 同时也要判断 thursdayDate 是否= today 日期要要一样才可以
    ///TODO:获取一周数据 然后给这些天去赋值，再判断是不是今天的数据 再判断一下今天的日期在不在这一周里面 如果在就修改为今天的数据
    // switch(widget.weekDayOfToday){
    //   case 'Monday':
    //     ///这里就获取一周数据 然后给这些天去赋值  。再判断是不是今天的数据
    //
    //     if(widget.mondayDate.compareTo(widget.today)==0){
    //       widget.mondayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Tuesday':
    //     if(widget.tuesdayDate.compareTo(widget.today)==0){
    //       widget.tuesdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Wednesday':
    //     if(widget.wednesdayDate.compareTo(widget.today)==0){
    //       widget.wednesdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Thursday':
    //     if(widget.thursdayDate.compareTo(widget.today)==0){
    //       widget.thursdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Friday':
    //     if(widget.fridayDate.compareTo(widget.today)==0){
    //       widget.fridayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Saturday':
    //     if(widget.saturdayDate.compareTo(widget.today)==0){
    //       widget.saturdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Sunday':
    //     if(widget.sundayDate.compareTo(widget.today)==0){
    //       widget.sundayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   default:
    //     print('初始化柱状图时 获取每一天卡路里数据失败');
    // }

  }

  ///时间选择按钮的配置函数，来设置新的日期并且刷新组件
  void judgeDate({DateTime time}){

    DateTime nowCurrent = DateTime.now();
    DateTime today = DateTime(nowCurrent.year,nowCurrent.month,nowCurrent.day);
    DateTime settingDay = DateTime(time.year,time.month,time.day);
    if(settingDay.compareTo(today) == 0){
      ///如果是选择了今天 那么什么也不用做  但是要刷新今天的数据颜色
      this.judgeWeekDay(widget.weekDayOfToday);
      setState(() {

      });
    }else{
      ///不一样再去修改
      this.calculateDate(settingDay);
    }


  }
  ///TODO:有一个bug 就是日期的刷新，点击18再转到19  19不会变红，应该在judge那里刷新一下
  ///TODO: Bug：刷新，有时候因为切换日期太快，导致柱状图数据还没有刷新 但是日期选择器的日期变了。
  ///这个问题应该在judge之后进行一次刷新  这些代码复用都要再精简 拿出去
  void judgeWeekDay(String weekDayOfSetting){
    switch(weekDayOfSetting){
      case 'Monday':
        widget.isMondayDate=true;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        // mondayIndex=1;
        break;

      case 'Tuesday':
        widget.isTuesdayDate=true;
        widget.isMondayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        // mondayIndex=-1;
        break;

      case 'Wednesday':
        widget.isWednesdayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        // mondayIndex=-2;
        break;

      case 'Thursday':
        widget.isThursdayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        // mondayIndex=-3;
        break;

      case 'Friday':
        widget.isFridayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isSaturdayDate=false;
        widget.isSundayDate=false;
        // mondayIndex=-4;
        break;

      case 'Saturday':
        widget.isSaturdayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSundayDate=false;
        // mondayIndex=-5;
        break;

      case 'Sunday':
        widget.isSundayDate=true;
        widget.isMondayDate=false;
        widget.isTuesdayDate=false;
        widget.isWednesdayDate=false;
        widget.isThursdayDate=false;
        widget.isFridayDate=false;
        widget.isSaturdayDate=false;
        // mondayIndex=-6;
        break;

      default:
        print('calculateDate  none');
    }

  }


  ///从服务器获取一周的卡路里记录，然后保存给widget的变量里
  void calculateDate(DateTime settingDay){
    String weekDayOfSetting=DateFormat('EEEE').format(settingDay);
    User u=User.getInstance();
    int mondayIndex;

    ///第一个switch 用来突出显示今天的柱状图 变红
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



    ///先从接口获取每一天的数据
    this.getHistoryCalories();
    ///这个switch是用来获取今天的数据，今天最好是本地的数值，其实也不是一定要,到时候和
    // switch(weekDayOfSetting){
    //   case 'Monday':
    //     ///首先判断设定的日期的这一天是不是就是今天，如果是就拿本地的数据(其实也不是一定要)，然后如果不是就去数据库里获取数据然后初始化，赋值应该在if上面
    //     this.getHistoryCalories(settingDay, "Monday");
    //     if(widget.mondayDate.compareTo(widget.today)==0){
    //       widget.mondayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Tuesday':
    //     this.getHistoryCalories(settingDay, "Tuesday");
    //     if(widget.tuesdayDate.compareTo(widget.today)==0){
    //       widget.tuesdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Wednesday':
    //     this.getHistoryCalories(settingDay, "Wednesday");
    //     if(widget.wednesdayDate.compareTo(widget.today)==0){
    //       widget.wednesdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Thursday':
    //     this.getHistoryCalories(settingDay, "Thursday");
    //     if(widget.thursdayDate.compareTo(widget.today)==0){
    //       widget.thursdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Friday':
    //
    //     if(widget.fridayDate.compareTo(widget.today)==0){
    //       widget.fridayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Saturday':
    //     this.getHistoryCalories();
    //     if(widget.saturdayDate.compareTo(widget.today)==0){
    //       widget.saturdayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   case 'Sunday':
    //     this.getHistoryCalories();
    //     if(widget.sundayDate.compareTo(widget.today)==0){
    //       widget.sundayValue=u.getTodayCaloriesIntake();
    //     }
    //     break;
    //
    //   default:
    //     print('初始化柱状图时 获取每一天卡路里数据失败');
    // }

  }

  ///根据指定的一天来获取一周卡路里的方法
  Future getHistoryCalories() async{

    print("调用了一次查询卡路里接口！---------------");
    DateTime beginDate=widget.mondayDate;
    DateTime endDate=widget.sundayDate;
    int beginTime;
    int endTime;
    List oneWeekCaloriesList=new List();

    beginTime = (DateTime(beginDate.year,beginDate.month,beginDate.day,0,0,0).millisecondsSinceEpoch/1000).floor();
    endTime = (DateTime(endDate.year,endDate.month,endDate.day,23,59,59).millisecondsSinceEpoch/1000).floor();

    Response res = await Requests.getCaloriesIntake({
        "begin": beginTime,
        "end": endTime,
        "uid": User.getInstance().uid,
        "token": User.getInstance().token,
      });
      if (res.data['code'] == 1) {
        this.clearValue();
        print("getCaloriesIntake 接口数据获取成功！----------");
        oneWeekCaloriesList=res.data['data'];
        this.assignValueBasedOnList(oneWeekCaloriesList);
        print("assignValueBasedOnList 执行完成--------");
      }else{
        print("getCaloriesIntake 的接口有bug");
      }

    ///执行完calculateDate  再刷新界面，处理完数据就可以刷新了。
    setState(() {

    });


  }

  ///处理接口返回的卡路里list
  void assignValueBasedOnList(List caloriesList ){

    caloriesList.forEach((element) {
      DateTime dateOfElement=DateTime.fromMillisecondsSinceEpoch(element["time"]*1000);
      DateTime formatedDate=DateTime.parse(formatDate(dateOfElement, [yyyy, '-', mm, '-', dd]));
      int isEqual=formatedDate.compareTo(widget.thursdayDate);
      double caloriesOfElement=element["calories"];
      if(formatedDate.compareTo(widget.mondayDate)==0){
        widget.mondayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(widget.tuesdayDate)==0){
        widget.tuesdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(widget.wednesdayDate)==0){
        widget.wednesdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(widget.thursdayDate)==0){
        widget.thursdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(widget.fridayDate)==0){
        widget.fridayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(widget.saturdayDate)==0){
        widget.saturdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(widget.sundayDate)==0){
        widget.sundayValue+=caloriesOfElement.toInt();

      }

    });

    print("caloriesList 遍历完成--------");

  }

  ///每次获取数据之前都清空之前的数据
  void clearValue(){
    widget.mondayValue=0;
    widget.tuesdayValue=0;
    widget.wednesdayValue=0;
    widget.thursdayValue=0;
    widget.fridayValue=0;
    widget.saturdayValue=0;
    widget.sundayValue=0;
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
        return makeGroupData(0, widget.mondayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isMondayDate?Color(0xffE05067):Color(0xffED9055));
      case 1:
        return makeGroupData(1, widget.tuesdayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isTuesdayDate?Color(0xffE05067):Color(0xffED9055));
      case 2:
        return makeGroupData(2, widget.wednesdayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isWednesdayDate?Color(0xffE05067):Color(0xffED9055));
      case 3:
        return makeGroupData(3, widget.thursdayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isThursdayDate?Color(0xffE05067):Color(0xffED9055));
      case 4:
        return makeGroupData(4, widget.fridayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isFridayDate?Color(0xffE05067):Color(0xffED9055));
      case 5:
        return makeGroupData(5, widget.saturdayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isSaturdayDate?Color(0xffE05067):Color(0xffED9055));
      case 6:
        return makeGroupData(6, widget.sundayValue.toDouble(), isTouched: i == touchedIndex,barColor: widget.isSundayDate?Color(0xffE05067):Color(0xffED9055));
      default:
        return null;
    }
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
            y:widget.planLimitedCalories.toDouble(),
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
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
  ///今天的日期
  DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  String weekDayOfToday=DateFormat('EEEE').format(DateTime.now());

  bool isChangeColor=false;
  User u=User.getInstance();

  ///每条柱状图的上限，超出也会显示
  // int planLimitedCalories=2000;
  int planLimitedCalories=User.getInstance().plan.dailyCaloriesUpperLimit.floor()??2000;

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
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex;




  Map<DateTime,double> localDateValueMap = new Map<DateTime,double>();
  Map<DateTime,double> offlineLocalDateValueMap = new Map<DateTime,double>();

  ///下面的三种会变化的属性都要放到State里面
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

///TODO:多注意刷新的问题 一般方法里在数据发生改变后都要去setstate一下


  void initialDate(){
    int mondayIndex;
    User u=User.getInstance();
    switch(widget.weekDayOfToday){
      case 'Monday':
        this.isMondayDate=true;
        mondayIndex=0;
        break;

      case 'Tuesday':
        this.isTuesdayDate=true;
        mondayIndex=-1;
        break;

      case 'Wednesday':
        this.isWednesdayDate=true;
        mondayIndex=-2;
        break;

      case 'Thursday':
        this.isThursdayDate=true;
        mondayIndex=-3;
        break;

      case 'Friday':
        this.isFridayDate=true;
        mondayIndex=-4;
        break;

      case 'Saturday':
        this.isSaturdayDate=true;
        mondayIndex=-5;
        break;

      case 'Sunday':
        this.isSundayDate=true;
        mondayIndex=-6;
        break;

      default:
        print('calculateDate  none');
    }
    ///计算其他六天的具体日期，比如2/13，这里用 setting的日期来算每个星期几的日期
    this.mondayDate=widget.today.add(Duration(days: mondayIndex));
    this.tuesdayDate=widget.today.add(Duration(days: mondayIndex+1));
    this.wednesdayDate=widget.today.add(Duration(days: mondayIndex+2));
    this.thursdayDate=widget.today.add(Duration(days: mondayIndex+3));
    this.fridayDate=widget.today.add(Duration(days: mondayIndex+4));
    this.saturdayDate=widget.today.add(Duration(days: mondayIndex+5));
    this.sundayDate=widget.today.add(Duration(days: mondayIndex+6));

    // ///get calories value调接口一次
    // this.getHistoryCalories();

    ///获取接口的数据 增加离线初始化  初始化  当用户离线才这样 否则去服务器获取数据
    if(u.isOffline){
       SharedPreferences pre = LocalDataManager.pre;
       String json = pre.getString("localCalories");
       List LocalOneWeekCaloriesList=new List();
       LocalOneWeekCaloriesList = jsonDecode(json);
       this.assignValueBasedOnList(LocalOneWeekCaloriesList);
       setState(() {});

     }else{

       this.getHistoryCalories();
     }


  }

  @override
  @mustCallSuper
  void initState() {
    this.initialDate();

  }

  ///父组件更新时，重新为监听器添加回调
  @override
  void didUpdateWidget(covariant CaloriesBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  ///这个方法是去根据日期匹配把今天的值本地化获取  如果设置的一周刚好在这一周的话
  void setTodayValueFromLocal(){

    switch(widget.weekDayOfToday){
      case 'Monday':
        if(this.mondayDate.compareTo(widget.today)==0){
          this.mondayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      case 'Tuesday':
        if(this.tuesdayDate.compareTo(widget.today)==0){
          this.tuesdayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      case 'Wednesday':
        if(this.wednesdayDate.compareTo(widget.today)==0){
          this.wednesdayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      case 'Thursday':
        if(this.thursdayDate.compareTo(widget.today)==0){
          this.thursdayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      case 'Friday':
        if(this.fridayDate.compareTo(widget.today)==0){
          this.fridayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      case 'Saturday':

        print("从本地更新了今天的数值");
        if(this.saturdayDate.compareTo(widget.today)==0){
          this.saturdayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      case 'Sunday':
        if(this.sundayDate.compareTo(widget.today)==0){
          this.sundayValue=widget.u.getTodayCaloriesIntake();
        }
        break;

      default:
        print('今天不在设置的一周里面，就没本地化');
    }
  }




  void judgeDate({DateTime time}){

    DateTime settingDay = DateTime(time.year,time.month,time.day);
    String weekDayOfsettingDay=DateFormat('EEEE').format(settingDay);

    if(settingDay.isBefore(this.sundayDate) || settingDay.compareTo(this.sundayDate) ==0 ){
        if(settingDay.isAfter(this.mondayDate)|| settingDay.compareTo(this.mondayDate) ==0){
          ///如果是选择了在目前的一周内 那么什么也不用做  只需要刷新今天的数据颜色
          this.changeWeekDayInOneWeek(weekDayOfsettingDay);
        }else{
          ///否者跳到另外一周 那么需要去服务器获取新的数据
          this.calculateDate(settingDay);
        }
    }else{
        this.calculateDate(settingDay);
      }
  }


  void readLocalValue(){
    ///先清空之前的数据
    ///另外如果设定的日期就是这一周，那么数据就根本不需要重新获取，只需要更新颜色就好了
    ///如果设定的日期在本地中，那么它所这在一周的数据肯定也被存在了本地了，就直接获取就好了
    ///这个函数主要是 根据目前一周的日期去读取本地的Value数据

    this.clearValue();
    this.localDateValueMap.forEach((date,value) {
      DateTime formatedDate=date;
      double caloriesOfElement=value;

      if(formatedDate.compareTo(this.mondayDate)==0){
        this.mondayValue=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.tuesdayDate)==0){
        this.tuesdayValue=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.wednesdayDate)==0){
        this.wednesdayValue=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.thursdayDate)==0){
        this.thursdayValue=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.fridayDate)==0){
        this.fridayValue=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.saturdayDate)==0){
        this.saturdayValue=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.sundayDate)==0){
        this.sundayValue=caloriesOfElement.toInt();

      }
    });
    print("读取本地化数据完成  ----------");
    setState(() {

    });

  }

  ///给定设定日期如星期一Monday 来突出今天的数据this.isMondayDate=true;  并且来计算其他六天的具体日期
  void changeWeekDayInOneWeek(String weekDayOfSetting ){
    // int mondayIndex=0;

    switch(weekDayOfSetting){
      case 'Monday':
        this.isMondayDate=true;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        // mondayIndex=0;
        break;

      case 'Tuesday':
        this.isTuesdayDate=true;
        this.isMondayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        // mondayIndex=-1;
        break;

      case 'Wednesday':
        this.isWednesdayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        // mondayIndex=-2;
        break;

      case 'Thursday':
        this.isThursdayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        // mondayIndex=-3;
        break;

      case 'Friday':
        this.isFridayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        // mondayIndex=-4;
        break;

      case 'Saturday':
        this.isSaturdayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSundayDate=false;
        // mondayIndex=-5;
        break;

      case 'Sunday':
        this.isSundayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        // mondayIndex=-6;
        break;

      default:
        print('calculateDate  none');

    }
    setState(() {
    });
  }


  ///根据设定日期所在一周的卡路里量  去服务器获取
  void calculateDate(DateTime settingDay){
    String weekDayOfSetting=DateFormat('EEEE').format(settingDay);
    this.judgeWeekDay(weekDayOfSetting,settingDay); ///先设定日期处理
    this.getHistoryCalories(); ///从接口获取每一天的数据,只有本地没有时 最后才去获取

  }

  ///给定设定日期如星期一Monday 来突出今天的数据this.isMondayDate=true;  并且来计算其他六天的具体日期
  void judgeWeekDay(String weekDayOfSetting ,DateTime settingDay){
    int mondayIndex=0;

    switch(weekDayOfSetting){
      case 'Monday':
        this.isMondayDate=true;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        mondayIndex=0;
        break;

      case 'Tuesday':
        this.isTuesdayDate=true;
        this.isMondayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        mondayIndex=-1;
        break;

      case 'Wednesday':
        this.isWednesdayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        mondayIndex=-2;
        break;

      case 'Thursday':
        this.isThursdayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        mondayIndex=-3;
        break;

      case 'Friday':
        this.isFridayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isSaturdayDate=false;
        this.isSundayDate=false;
        mondayIndex=-4;
        break;

      case 'Saturday':
        this.isSaturdayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSundayDate=false;
        mondayIndex=-5;
        break;

      case 'Sunday':
        this.isSundayDate=true;
        this.isMondayDate=false;
        this.isTuesdayDate=false;
        this.isWednesdayDate=false;
        this.isThursdayDate=false;
        this.isFridayDate=false;
        this.isSaturdayDate=false;
        mondayIndex=-6;
        break;

      default:
        print('calculateDate  none');

    }
    this.mondayDate = settingDay.add(Duration(days: mondayIndex));
    this.tuesdayDate = settingDay.add(Duration(days: mondayIndex + 1));
    this.wednesdayDate = settingDay.add(Duration(days: mondayIndex + 2));
    this.thursdayDate = settingDay.add(Duration(days: mondayIndex + 3));
    this.fridayDate = settingDay.add(Duration(days: mondayIndex + 4));
    this.saturdayDate = settingDay.add(Duration(days: mondayIndex + 5));
    this.sundayDate = settingDay.add(Duration(days: mondayIndex + 6));


    setState(() {

    });

  }




  ///服务器调接口的代码 并且把数据分配
  Future getHistoryCalories() async{
    DateTime beginDate=this.mondayDate;
    DateTime endDate=this.sundayDate;
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
        oneWeekCaloriesList=res.data['data'];
        this.assignValueBasedOnList(oneWeekCaloriesList);
      }else{
        print("getCaloriesIntake 的接口有bug");
      }

  }

  ///处理接口返回的卡路里数据 赋值
  void assignValueBasedOnList(List caloriesList ){

    ///一周的时间，挨个去添加数据
    caloriesList.forEach((element) {
      DateTime dateOfElement=DateTime.fromMillisecondsSinceEpoch(element["time"]*1000);
      DateTime formatedDate=DateTime.parse(formatDate(dateOfElement, [yyyy, '-', mm, '-', dd]));
      int isEqual=formatedDate.compareTo(this.thursdayDate);
      double caloriesOfElement=element["calories"];
      if(formatedDate.compareTo(this.mondayDate)==0){
        this.mondayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.tuesdayDate)==0){
        this.tuesdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.wednesdayDate)==0){
        this.wednesdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.thursdayDate)==0){
        this.thursdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.fridayDate)==0){
        this.fridayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.saturdayDate)==0){
        this.saturdayValue+=caloriesOfElement.toInt();

      }else if(formatedDate.compareTo(this.sundayDate)==0){
        this.sundayValue+=caloriesOfElement.toInt();
      }

    }
    );

    setState(() {
      ///把上限问题解决  超过上限就直接显示为上限

    });

    // print("caloriesList 本地化今天的数据完成--------");
    this.setTodayValueFromLocal();

    print("caloriesList 遍历完成--------");
    ///遍历完一周的数据并且累加后，再保存到本地
    this.localDateValueMap.addAll({this.mondayDate:this.mondayValue.toDouble()});
    this.localDateValueMap.addAll({this.tuesdayDate:this.tuesdayValue.toDouble()});
    this.localDateValueMap.addAll({this.wednesdayDate:this.wednesdayValue.toDouble()});
    this.localDateValueMap.addAll({this.thursdayDate:this.thursdayValue.toDouble()});
    this.localDateValueMap.addAll({this.fridayDate:this.fridayValue.toDouble()});
    this.localDateValueMap.addAll({this.saturdayDate:this.saturdayValue.toDouble()});
    this.localDateValueMap.addAll({this.sundayDate:this.sundayValue.toDouble()});

    print("caloriesList 数据添加到本地完成--------");
  }

  ///每次获取数据之前都清空之前的数据
  void clearValue(){
    this.mondayValue=0;
    this.tuesdayValue=0;
    this.wednesdayValue=0;
    this.thursdayValue=0;
    this.fridayValue=0;
    this.saturdayValue=0;
    this.sundayValue=0;
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
                        color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 18, fontFamily: 'Futura',fontWeight: FontWeight.bold,decoration: TextDecoration.none),
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
                      gap: 7,
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
  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, this.mondayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isMondayDate?Color(0xff72d8bf):Color(0xffED9055));
      case 1:
        return makeGroupData(1, this.tuesdayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isTuesdayDate?Color(0xff72d8bf):Color(0xffED9055));
      case 2:
        return makeGroupData(2, this.wednesdayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isWednesdayDate?Color(0xff72d8bf):Color(0xffED9055));
      case 3:
        return makeGroupData(3, this.thursdayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isThursdayDate?Color(0xff72d8bf):Color(0xffED9055));
      case 4:
        return makeGroupData(4, this.fridayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isFridayDate?Color(0xff72d8bf):Color(0xffED9055));
      case 5:
        return makeGroupData(5, this.saturdayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isSaturdayDate?Color(0xff72d8bf):Color(0xffED9055));
      case 6:
        return makeGroupData(6, this.sundayValue.toDouble(), isTouched: i == touchedIndex,barColor: this.isSundayDate?Color(0xff72d8bf):Color(0xffED9055));
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
                  weekDay=formatDate(this.mondayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 1:
                  weekDay=formatDate(this.tuesdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 2:
                  weekDay=formatDate(this.wednesdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 3:
                  weekDay=formatDate(this.thursdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 4:
                  weekDay=formatDate(this.fridayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 5:
                  weekDay=formatDate(this.saturdayDate, [yyyy, '-', mm, '-', dd]);
                  break;
                case 6:
                  weekDay=formatDate(this.sundayDate, [yyyy, '-', mm, '-', dd]);
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
            y:widget.planLimitedCalories.toDouble(),
            colors: [MyTheme.convert(ThemeColorName.PageBackground)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/food/DetailedMealList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailMealPage extends StatefulWidget {
  DateTime mealTime;

  DetailMealPage({@required this.mealTime}) : assert(mealTime != null);
  @override
  State<StatefulWidget> createState() {
    return DetailMealPageState();
  }
}

class DetailMealPageState extends State<DetailMealPage> {
  List<Meal> meal;
  User u;
  DateTime beginTime;
  DateTime endTime;
  Map<String, dynamic> localMealMap;
  @override
  void initState() {
    this.u = User.getInstance();
    DateTime now = DateTime.now();
    this.endTime = DateTime(now.year, now.month, now.day);
    this.beginTime = this.endTime.add(Duration(days: -1 * u.registerTime()));
    if (u.isOffline) {
      SharedPreferences pre = LocalDataManager.pre;
      int bg = pre.getInt("localBeginTime");
      int ed = pre.getInt("localEndTime");
      String json = pre.getString("localHistoryMeals");
      this.localMealMap = jsonDecode(json);
      if (bg != null) {
        this.beginTime = DateTime.fromMillisecondsSinceEpoch(bg);
      }
      if (ed != null) {
        this.endTime = DateTime.fromMillisecondsSinceEpoch(ed);
      }
    }
    this.judgeDate();
    super.initState();
  }

  void judgeDate({DateTime time}) {
    if (this.u.isOffline) {
      DateTime settingDay = time ??
          DateTime(this.endTime.year, this.endTime.month, this.endTime.day);
      String stringTime = settingDay.millisecondsSinceEpoch.toString();
      this.meal = [
        Meal(mealName: "breakfast"),
        Meal(mealName: "lunch"),
        Meal(mealName: "dinner")
      ];
      if (this.localMealMap.containsKey(stringTime)) {
        for (Map m in this.localMealMap[stringTime]) {
          if (m['type'] >= 1 && m['type'] <= 3) {
            this.meal[m['type'] - 1].addFood(new Food.fromJson(m));
          }
        }
      }
      if (mounted) {
        setState(() {});
      }
      return;
    }
    time = time ?? widget.mealTime;
    DateTime settingDay = DateTime(time.year, time.month, time.day);
    DateTime nowCurrent = DateTime.now();
    DateTime today =
        DateTime(nowCurrent.year, nowCurrent.month, nowCurrent.day);
    if (settingDay.compareTo(today) == 0) {
      this.meal = [];
      this.meal = u.meals.value;
      if (mounted) {
        setState(() {});
      }
    } else {
      getHistoryMeal(time);
    }
  }

  void getHistoryMeal(DateTime time) async {
    User u = User.getInstance();
    this.meal = null;
    setState(() {});
    Response res = await Requests.dailyMeal(context, {
      "uid": u.uid,
      "token": u.token,
      "begin": time.millisecondsSinceEpoch / 1000,
      "end": time.millisecondsSinceEpoch / 1000 + 3600 * 24 - 1
    });
    if (res == null) {
      this.meal = null;
    } else {
      if (res.data['code'] == 1) {
        this.meal = [
          Meal(mealName: "breakfast"),
          Meal(mealName: "lunch"),
          Meal(mealName: "dinner")
        ];

        for (Map m in res.data['data']['b']) {
          this.meal[0].time = m['time'] * 1000;
          this.meal[0].addFood(new Food.fromJson(m));
        }
        for (Map m in res.data['data']['l']) {
          this.meal[1].time = m['time'] * 1000;
          this.meal[1].addFood(new Food.fromJson(m));
        }
        for (Map m in res.data['data']['d']) {
          this.meal[2].time = m['time'] * 1000;
          this.meal[2].addFood(new Food.fromJson(m));
        }
      } else {
        this.meal = [];
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> col = [
      SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DateSelect(
                width: 0.5,
                height: 40,
                beginTime: this.beginTime,
                lastTime: this.endTime,
                onChangeDate: (int newDate) {
                  this.judgeDate(
                      time: DateTime.fromMillisecondsSinceEpoch(newDate));
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),
              CustomIconButton(
                icon: FontAwesomeIcons.times,
                iconSize: 20,
                buttonSize: 40,
                backgroundOpacity: 0,
                onClick: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: ScreenTool.partOfScreenWidth(0.025))
            ],
          )
        ],
      ),
      SizedBox(height: 20)
    ];
    if (this.meal == null) {
      col.add(Expanded(
          child: Center(
        child: TitleText(
          alignment: Alignment.center,
          text: CustomLocalizations.of(context).searchHistoryMeal,
          maxWidth: 0.9,
          maxHeight: 50,
          underLineLength: 0,
          fontSize: 16,
        ),
      )));
    } else if (this.meal.isEmpty ||
        (this.meal[0].foods.isEmpty &&
            this.meal[1].foods.isEmpty &&
            this.meal[2].foods.isEmpty)) {
      col.add(Expanded(
          child: Center(
        child: TitleText(
          alignment: Alignment.center,
          text: CustomLocalizations.of(context).noFoodSearch,
          maxWidth: 0.9,
          maxHeight: 50,
          underLineLength: 0,
          fontSize: 16,
        ),
      )));
    } else {
      int totalCal = 0;
      for (Meal m in this.meal) {
        totalCal += m.calculateTotalCalories();
      }
      col.add(Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(this.meal.length, (index) {
          return DetailedMealList(
            meal: this.meal[index],
            width: 0.95,
            height: ScreenTool.partOfScreenHeight(0.25),
            dragAreaHeight: 60,
          );
        }),
      )));
      col.addAll([
        SizedBox(height: 20),
        TitleText(
          text: "Total Calories: " + totalCal.toString() + " Kcal",
          maxWidth: 0.9,
        ),
        SizedBox(height: 20)
      ]);
    }
    return Container(
      color: MyTheme.convert(ThemeColorName.PageBackground),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: col),
    );
  }
}

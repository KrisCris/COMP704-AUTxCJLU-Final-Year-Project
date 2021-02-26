
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/MyTool/SoftwarePreference.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/MainPage.dart';

class CoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CoverState();
  }
}

class CoverState extends State<CoverPage> {
  User savedUser;
  ValueNotifier<int> loginProcess = new ValueNotifier(-1);
  String hintString="loginState";

  Widget getPage(String text) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ClipRRect(
          // make sure we apply clip it properly
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, //水平居中
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.lemon, color: Colors.black, size: 50),
                  SizedBox(height: 30),
                  Text(CustomLocalizations.of(context).slogan,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Futura",
                          color: Colors.black)),
                  SizedBox(height: 50),
                  Text(text,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Futura",
                          color: Colors.black))
                ],
              ))),
    );
  }
  @override
  void initState(){
    loginProcess.addListener(() {
      if(loginProcess.value == 0){
        hintString = "loginState";
      }else if(loginProcess.value == 1){
        hintString = "preference";
      }else if(loginProcess.value == 2){
        hintString = "foodRecognizer";
      }else if(loginProcess.value == 3){
        hintString = "welcome";
        Future.delayed(Duration(milliseconds: 1500),(){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context){return new Welcome();}),
                  (route){return route==null;}
          );
        });
      }else if(loginProcess.value == 4){
        hintString = "syncLocalData";
        this.updateLocalData();
      }else if(loginProcess.value == 5){
        hintString = "offlineLogin";
        Future.delayed(Duration(milliseconds: 1000),(){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context){
                User u = User.getInstance();
                u.isOffline = true;
                if(u.needGuide){
                  return GuidePage();
                }else{
                  return new MainPage(user: u);
                }
              }),
                  (route){return route==null;}
          );
        });
      }else if(loginProcess.value == 6){
        hintString = "autoLogin";
        Future.delayed(Duration(milliseconds: 500),(){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context){
                User u = User.getInstance();
                u.isOffline = false;
                if(u.needGuide){
                  return GuidePage();
                }else{
                  return new MainPage(user: u);
                }
              }),
                  (route){return route==null;}
          );
        });
      }
      setState(() {});
    });
    attemptLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(loginProcess.value == -1){
      return Container(decoration: BoxDecoration(color: Colors.white));
    }
    return this.getPage(CustomLocalizations.of(context).getContent(this.hintString));
  }

  Future<int> attemptLogin() async {
    await LocalDataManager.init();
    SoftwarePreference preference = SoftwarePreference.getInstance();
    this.loginProcess.value = 1;
    await Future.delayed(Duration(milliseconds: 300),(){});

    FoodRecognizer fd = FoodRecognizer.instance;
    this.loginProcess.value = 2;
    await Future.delayed(Duration(milliseconds: 300),(){});

    User u = User.getInstance();
    if(u.token == null){
      this.loginProcess.value = 3;
    }else{
      int userCode = await u.synchronize();
      this.loginProcess.value = userCode;
    }
  }
  Future<int> updateLocalData() async {
    SharedPreferences pre = LocalDataManager.pre;
    User u = User.getInstance();
    DateTime end = DateTime.now();
    DateTime begin = end.add(Duration(days: -30));
    int endTime = (end.millisecondsSinceEpoch/1000).floor();
    int beginTime = (begin.millisecondsSinceEpoch/1000).floor();
    pre.setInt("localBeginTime", beginTime*1000);
    pre.setInt("localEndTime", endTime*1000);
    Response res = await Requests.getCaloriesIntake({
      "begin": beginTime,
      "end": endTime,
      "uid": u.uid,
      "token": u.token,
    });
    if(res != null){
      String json = jsonEncode(res.data['data']);
      pre.setString("localCalories", json);
    }
    res = await Requests.historyMeal({
      'begin':beginTime,
      'end':endTime,
      "uid": u.uid,
      "token": u.token,
    });
    if(res != null){
      Map<String,List<Map>> timeMap = new Map<String,List<Map>>();
      for(Map m in res.data['data']){
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(m['time']*1000);
        dt = DateTime(dt.year,dt.month,dt.day);
        String stringTime = dt.millisecondsSinceEpoch.toString();
        if(timeMap.containsKey(stringTime)){
          timeMap[stringTime].add(m);
        }else{
          timeMap[stringTime] = [m];
        }
      }
      String json = jsonEncode(timeMap);
      pre.setString("localHistoryMeals", json);
    }
    res = await Requests.getWeightTrend({
      "uid":u.uid,
      "token":u.token,
      "begin": beginTime,
      "end":endTime
    });
    if(res != null && res.data['code'] == 1){
      List<BodyChangeLog> bodyChanges = [];
      DateTime oneDay;
      int oneWeight;
      for(Map m in res.data['data']['trend']){
        DateTime tm = DateTime.fromMillisecondsSinceEpoch(m['time']*1000);
        //保存某一天的数据
        if(oneDay == null){
          oneDay = tm;
          oneWeight = (m['weight'] as double).floor();
        }else{
          //如果这次获取到的时间和上次保存的是同一天
          if(oneDay.year == tm.year && oneDay.month == tm.month && oneDay.day == tm.day){
            //取同一天里靠后的那次数据
            if(tm.compareTo(oneDay) >= 0){
              oneDay = tm;
              oneWeight = (m['weight'] as double).floor();
            }
          }else{
            //如果不是同一天，将之前保存的那天的数据录入，然后更新保存的时间
            bodyChanges.add(BodyChangeLog(
                time: oneDay.millisecondsSinceEpoch,
                weight: oneWeight,
                height: 0
            ));
            oneDay = tm;
            oneWeight = (m['weight'] as double).floor();
          }
        }
      }
      //将最后保存的那天的数据录入
      if(oneDay != null && oneWeight != null){
        bodyChanges.add(BodyChangeLog(
            time: oneDay.millisecondsSinceEpoch,
            weight: oneWeight,
            height: 0
        ));
      }
      String json = jsonEncode(bodyChanges);
      pre.setString("localBodyChanges", json);
    }
    loginProcess.value = 6;
  }

}

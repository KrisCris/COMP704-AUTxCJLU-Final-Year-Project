
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/FoodRecognizer.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/WelcomePage.dart';

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
  String hintString="Checking login state...";

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
                  Text("Take a Picture of your food!",
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
        hintString = "welcome to here!";
        Future.delayed(Duration(milliseconds: 1500),(){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context){return new Welcome();}),
                  (route){return route==null;}
          );
        });
      }else if(loginProcess.value == 1){
        hintString = "Auto login...";
        Future.delayed(Duration(milliseconds: 1000),(){
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
      }else if(loginProcess.value == 2){
        hintString = "offline mode login...";
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
      }else{
        hintString = "Checking login state...";
      }
      setState(() {});
    });
    attemptLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return this.getPage(this.hintString);
  }

  Future<int> attemptLogin() async {
    await LocalDataManager.init();
    //init FoodRecognizer instance
    FoodRecognizer fd = FoodRecognizer.instance;
    //init User instance
    User u = User.getInstance();
    if(u.token == null){
      return 0;
    }else{
      Future<int> userCode = u.synchronize();
      userCode.then((value){
        this.loginProcess.value = value;
      });
    }
  }
}

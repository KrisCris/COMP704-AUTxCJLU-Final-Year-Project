import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/LocalDataManager.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/Req.dart';

import 'MainPage.dart';

class CoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CoverState();
  }
}

class CoverState extends State<CoverPage> {
  User savedUser;

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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.attemptLogin(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            int resCode = snapShot.data;
            if(resCode == 0){
              Future.delayed(Duration(milliseconds: 2500),(){
                Navigator.pushNamed(context, "welcome");
              });
              return this.getPage("welcome to here!");
            }else if(resCode == 1){
              Future.delayed(Duration(milliseconds: 1500),(){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context){return new MainPage(user: this.savedUser);}),
                    (route){return route==null;}
                );
              });
              return this.getPage("Auto login...");
            } else {
              return this.getPage("Checking login state...");
            }
          } else {
            return this.getPage("Checking login state...");
          }
        });
  }

  Future<int> attemptLogin() async {
    this.savedUser = await LocalDataManager.readUser();

    if(this.savedUser.token == null){
      return 0;
    }else{
      Response res = await Requests.getBasicInfo({
        'uid':this.savedUser.uid,
        'token':this.savedUser.token
      });
      if(res.data['code'] == 1){
        this.savedUser.age = res.data['data']['age'];
        this.savedUser.gender = res.data['data']['gender'];
        this.savedUser.userName = res.data['data']['nickname'];
        this.savedUser.avatar_remote = res.data['data']['avatar'];
        this.savedUser.email = res.data['data']['email'];
        this.savedUser.save();
        return 1;
      }else if(res.data['code'] == -1){
        return 0;
      }
    }
  }
}

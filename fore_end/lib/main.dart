import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/textButton.dart';

import 'Pages/LoginPage.dart';

///
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: mainBody,
      routes:{
        "login":(context)=>Login(),
      }
    );
  }

  Widget get mainBody{
    return new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("image/fruit-main.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          //背景滤镜
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), //背景模糊
          child: Container(
              alignment: Alignment.center,
              color: Colors.white.withOpacity(0.79),
              child: Column(
                  children: <Widget>[
                    Text(
                      "Welcome",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 50,
                          fontFamily: "Futura",
                          color: Colors.black),
                    ),
                    SizedBox(height:60),
                    MyButton(
                        text: "Sign up",
                        fontsize: 25,
                        width: 0.7,
                        height:55,
                        radius: 30,
                        isBold: true,
                        tapFunc: () {
                          print("click button!");
                        }),
                    SizedBox(height:20),
                    MyTextButton(
                        "Already have account?",
                        fontsize: 16,
                        textColor: Colors.black,
                        focusColor: Colors.blueAccent,
                        tapUpFunc: (){
                          print("click text button!");
                        },
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center)),
        ),
      ),
    );
  }
}

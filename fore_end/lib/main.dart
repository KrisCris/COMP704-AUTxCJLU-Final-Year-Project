import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/formatChecker.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/iconButton.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/Mycomponents/textButton.dart';
import 'package:fore_end/interface/Themeable.dart';

import 'MyTool/MyTheme.dart';
import 'MyTool/req.dart';
import 'MyTool/screenTool.dart';
import 'Pages/LoginPage.dart';
import 'Pages/RegisterPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return MaterialApp(
        home: FirstPage(),
        routes: <String, WidgetBuilder>{
          "login": (context) => Login(),
          "register": (context) => Register(),
        },
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cookie =  Requests.getCookies();
    print(cookie.toString());
    return new BackGround(
        sigmaX: 15,
        sigmaY: 15,
        backgroundImage: "image/fruit-main.jpg",
        color: Colors.white,
        opacity: 0.79,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            SizedBox(height: 60),
            MyButton(
                text: "Sign up",
                fontsize: 18,
                width: 0.7,
                height: 55,
                radius: 30,
                sizeChangeMode: 2,
                theme: MyTheme.blueStyle,
                isBold: true,
                tapFunc: () {
                  Navigator.pushNamed(context, "register");
                }),
            SizedBox(height: 20),
            MyTextButton(
              "Already have account?",
              fontsize: 16,
              theme: MyTheme.blueStyle,
              tapUpFunc: () {
                Navigator.pushNamed(context, "login");
              },
            ),
          ],
        ));
  }
}

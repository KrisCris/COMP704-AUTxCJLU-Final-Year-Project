import 'package:flutter/material.dart';
import 'package:fore_end/Pages/ComponentTestPage.dart';
import 'package:fore_end/Pages/CoverPage.dart';
import 'MyTool/User.dart';
import 'Pages/AccountPage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/MainPage.dart';
import 'Pages/RegisterPage.dart';
import 'Pages/WelcomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this._preCacheAllImage();
    return MaterialApp(
      home: CoverPage(),
      // home: AccountPage(),
      routes: <String, WidgetBuilder>{
        "login": (context) => Login(),
        "register": (context) => Register(),
        "welcome": (context) => Welcome(),
      },
    );
  }

  void _preCacheAllImage() {
    precacheImage(AssetImage("image/fruit-main.jpg"), context);
    precacheImage(AssetImage("image/food.jpg"), context);
  }
}

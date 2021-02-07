import 'package:flutter/material.dart';
import 'package:fore_end/Pages/ComponentTestPage.dart';
import 'package:fore_end/Pages/CoverPage.dart';
import 'MyTool/User.dart';
import 'Mycomponents/widgets/food/BarChartSample.dart';
import 'Pages/account/AccountPage.dart';
import 'Pages/GuidePage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/main/MainPage.dart';
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
      // home: BarChartSample1(),
      // home: ComponentTestPage(),

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
    precacheImage(AssetImage("image/defaultFood.png"), context);
  }
}

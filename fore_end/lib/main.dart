
import 'package:flutter/material.dart';
import 'Pages/LoginPage.dart';
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
    return MaterialApp(
        home: Welcome(),
        routes: <String, WidgetBuilder>{
          "login": (context) => Login(),
          "register": (context) => Register(),
        },
    );
  }
}

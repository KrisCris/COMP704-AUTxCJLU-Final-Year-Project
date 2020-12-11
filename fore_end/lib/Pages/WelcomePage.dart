import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/textButton.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Column col = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Welcome",
          textDirection: TextDirection.ltr,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 50.0,
              fontFamily: "Futura",
              color: Colors.black),
        ),
        SizedBox(height: 60.0),
        MyButton(
            text: "Sign up",
            fontsize: 18.0,
            width: 0.7,
            height: 55.0,
            radius: 30.0,
            sizeChangeMode: 2,
            theme: MyTheme.blueStyle,
            isBold: true,
            tapFunc: () {
              Navigator.pushNamed(context, "register");
            }),
        SizedBox(height: 20),
        MyTextButton(
          "Already have account?",
          fontsize: 16.0,
          theme: MyTheme.blueStyle,
          tapUpFunc: () {
            Navigator.pushNamed(context, "login");
          },
        ),
      ],
    );
    MyButton bt = MyButton(
        text: "Sign up",
        fontsize: 18.0,
        width: 0.7,
        height: 55.0,
        radius: 30.0,
        sizeChangeMode: 2,
        theme: MyTheme.blueStyle,
        isBold: true,
        tapFunc: () {
          Navigator.pushNamed(context, "register");
        });
    return new WillPopScope(
      onWillPop: ()async{
        return false;
      },
      child: BackGround(
          sigmaX: 15.0,
          sigmaY: 15.0,
          backgroundImage: "image/fruit-main.jpg",
          color: Colors.white,
          opacity: 0.79,
          child: col),
    );

  }
}
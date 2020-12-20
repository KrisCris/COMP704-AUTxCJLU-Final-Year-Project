import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/Background.dart';
import 'package:fore_end/Mycomponents/CustomButton.dart';
import 'package:fore_end/Mycomponents/CustomTextButton.dart';

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
        CustomButton(
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
        CustomTextButton(
          "Already have account?",
          fontsize: 16.0,
          theme: MyTheme.blueStyle,
          tapUpFunc: () {
            Navigator.pushNamed(context, "login");
          },
        ),
      ],
    );
    CustomButton bt = CustomButton(
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
    return  BackGround(
          sigmaX: 15.0,
          sigmaY: 15.0,
          backgroundImage: "image/fruit-main.jpg",
          color: Colors.white,
          opacity: 0.79,
          child: col);
  }
}
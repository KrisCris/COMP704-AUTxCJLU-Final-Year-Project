import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BackGround(
        sigmaY: 15,
        sigmaX: 15,
        color: Colors.white,
        opacity: 0.79,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,  //水平居中
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Create your\naccount",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: "Futura",
                    color: Colors.black),
              ),
              SizedBox(height:100),
              //上面是标题 下面准备写自己的输入框类
              MyButton(
                  text: "Sign up",
                  fontsize: 25,
                  width: 0.7,
                  height:55,
                  radius: 30,
                  isBold: true,
                  tapFunc: () {
                    print("click!");
                  }),
              SizedBox(height:20),
            ],
        )
    );
  }
}

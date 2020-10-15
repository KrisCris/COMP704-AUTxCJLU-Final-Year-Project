import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/screenTool.dart';
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
    return Scaffold(
        body: BackGround(
            sigmaY: 15,
            sigmaX: 15,
            color: Colors.white,
            opacity: 0.79,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: ScreenTool.partOfScreenHeight(0.15)),
                  width: ScreenTool.partOfScreenWidth(0.7),
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Color(0xFFF1F1F1), width: 5)),
                  child: Text(
                    "Create your\naccount",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: "Futura",
                        color: Colors.black),
                  ),
                ),
                SizedBox(height: 40),
                MyTextField(
                  placeholder: 'Email',
                  isPassword: false,
                  focusColor: Constants.FOCUSED_COLOR,
                  errorColor: Constants.ERROR_COLOR,
                  defaultColor: Constants.DEFAULT_COLOR,
                  // height: ScreenTool.partOfScreenHeight(20),
                  width: ScreenTool.partOfScreenWidth(0.7),
                  ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
                  ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,

                ),
                SizedBox(height: 45),
                MyTextField(
                  placeholder: 'Username',
                  isPassword: true,
                  focusColor: Constants.FOCUSED_COLOR,
                  errorColor: Constants.ERROR_COLOR,
                  defaultColor: Constants.DEFAULT_COLOR,
                  // height: ScreenTool.partOfScreenHeight(20),
                  width: ScreenTool.partOfScreenWidth(0.7),
                  ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
                  ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,

                ),
                SizedBox(height: 10),
                MyTextField(
                  placeholder: 'Password',
                  isPassword: true,
                  focusColor: Constants.FOCUSED_COLOR,
                  errorColor: Constants.ERROR_COLOR,
                  defaultColor: Constants.DEFAULT_COLOR,
                  // height: ScreenTool.partOfScreenHeight(55),
                  width: ScreenTool.partOfScreenWidth(0.7),
                  ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
                  ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,

                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center, //水平居中
              // mainAxisAlignment: MainAxisAlignment.center,
            )) ,
    );

  }
}

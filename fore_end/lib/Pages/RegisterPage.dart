// import 'dart:js';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/formatChecker.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyCounter c = new MyCounter(times: 10, duration: 1000);

    MyTextField emailTextFiled = MyTextField(
      placeholder: 'Email',
      inputType: InputFieldType.email,
      theme: MyTheme.blueStyle,
      errorText: "Wrong email address!",
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "Please input correct email!",
      maxlength: 30,
      isAutoFocus: true,
    );

    MyTextField verifyTextFiled = MyTextField(
      placeholder: 'Verify Code',
      inputType: InputFieldType.text,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.45),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      maxlength: null,
    );

    MyButton verifyButton = MyButton(
        text: "Acquire verify code",
        fontsize: 20,
        width: 0.7,
        height: 50,
        radius: 8,
        theme: MyTheme.blueStyle,
        sizeChangeMode: 2,
        tapFunc: () {},
        isBold: true);

    verifyButton.tapFunc = () {
      verifyButton.fontsize = 20;
      verifyButton.setDisable(true);
      verifyButton.setWidth(0.2);
      if (c.isStop()) {
        c.start();
      }
    };
    c.calling = () {
      verifyButton.text = c.getRemain().toString();
      verifyButton.refresh();
      if (c.isStop()) {
        verifyButton.text = "Acquire\nagain";
        verifyButton.fontsize = 13;
        verifyButton.setDisable(false);
      }
    };

    return Scaffold(
      body: BackGround(
          sigmaY: 15,
          sigmaX: 15,
          color: Colors.white,
          opacity: 0.79,
          child: KeyboardAvoider(
              autoScroll: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, //水平居中
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 80),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.7),
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
                  SizedBox(height: ScreenTool.partOfScreenHeight(0.08)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenTool.partOfScreenWidth(0.7),
                        child: emailTextFiled,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                      )
                    ],
                  ),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.7),
                    height: ScreenTool.partOfScreenHeight(0.1),
                    decoration: BoxDecoration(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                          left: 0,
                          top: 8,
                          child: verifyTextFiled,
                        ),
                        Positioned(
                          child: verifyButton,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MyButton(
                          text: "Back",
                          isBold: true,
                          leftMargin: 20,
                          bottomMargin: 20,
                          width: ScreenTool.partOfScreenWidth(0.20),
                          theme: MyTheme.blueStyle,
                          firstThemeState: ComponentThemeState.error,
                          tapFunc: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(child: Text("")),
                        MyButton(
                          text: "Next",
                          isBold: true,
                          rightMargin: 20,
                          bottomMargin: 20,
                          width: ScreenTool.partOfScreenWidth(0.20),
                          theme: MyTheme.blueStyle,
                          tapFunc: () {
                            // Navigator.pushNamed(context, "login");
                            bool iscorrect = FormatChecker.check(
                                emailTextFiled.inputType,
                                emailTextFiled.getInput());
                            if (iscorrect) {}
                          },
                        )
                      ]),
                ],
              ))),
    );
  }
}

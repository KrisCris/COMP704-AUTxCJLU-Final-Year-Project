// import 'dart:js';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/MyIcons.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {

  //Timer倒计时的属性定义





  @override
  Widget build(BuildContext context) {
    MyCounter c= new MyCounter(times:10, duration: 1000);

    MyTextField emailTextFiled = MyTextField(
      placeholder: 'Email',
      type: InputFieldType.email,
      focusColor: Constants.FOCUSED_COLOR,
      errorColor: Constants.ERROR_COLOR,
      defaultColor: Constants.DEFAULT_COLOR,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      // isAutoFocus: true,
    );

    MyTextField verifyTextFiled = MyTextField(
      //这个要在按下按钮之后显示,暂时隐藏掉
      placeholder: 'Verify Code',
      type:InputFieldType.text,
      focusColor: Constants.FOCUSED_COLOR,
      errorColor: Constants.ERROR_COLOR,
      defaultColor: Constants.DEFAULT_COLOR,
      width: ScreenTool.partOfScreenWidth(0.45),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      maxlength: 6,
      myIcon: Icons.check_circle_outline,
    );

    MyButton verifyButton = MyButton(
        text: "Acquire verify code",
        fontsize: 20,
        width: 0.7,
        height: 50,
        radius: 8,
        theme: MyTheme.blueStyle,
        sizeChangeMode:2,
        tapFunc: () {},
        isBold: true
    );

      //按钮按下的方法
      verifyButton.tapFunc = () {
        //调用计时器
        verifyButton.fontsize=20;
        verifyButton.setDisable(true);
        verifyButton.setWidth(0.2);
        if (c.isStop()) {
          c.start();
        }
      };

      c.calling = (){
        verifyButton.text= c.getRemain().toString();
        verifyButton.refresh();
        if(c.isStop()) {
          verifyButton.text="Acquire\nagain";
          verifyButton.fontsize = 13;
          verifyButton.setDisable(false);
        }
      };



    //   //调用函数修改某个textfield的数值
    //   // verifyTextFiled.name();
    //   verifyButton.setWidth(0.2);
    //   verifyButton.setDisable(true);
    //   verifyButton.text="Acquire\nagain";
    //   verifyButton.fontsize = 13;
    //   // Navigator.pushNamed(context, "register");
    //   // print(">>>>>>>>>>>>>>>>这里面就是监听到文本框里面的内容>>>>>>>>>>>>>>>>>");
    //   // //测试一下提示功能
    //   // if (testEmail(emailController.text)) {
    //   //   print(emailController.text + "  是正确的邮箱格式");
    //   // } else {
    //   //   print("未输入或者错误的邮箱格式");
    //   // }
    //   // print("<<<<<<<<<<<<<<<<这里面就是监听到文本框里面的内容<<<<<<<<<<<<<<<<<");
    // };

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
                    // margin: EdgeInsets.only(
                    // top: ScreenTool.partOfScreenHeight(0.01)),
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
                        // child: Icon(
                        //
                        //   MyIcons.icon_no,
                        //   size: 30,
                        //   color: Constants.ERROR_COLOR,
                        // ),
                      )
                    ],
                  ),

                  Container(
                    width: ScreenTool.partOfScreenWidth(0.7),
                    height: ScreenTool.partOfScreenHeight(0.1),
                    decoration: BoxDecoration(

                      // border: Border.all(color: Colors.blue, width: 1),
                    ),
                    child: Stack(
                        alignment:Alignment.center,
                        children: <Widget>[
                          Positioned(
                            left: 0,
                            child: verifyTextFiled,
                          ),
                          Positioned(
                            // right: 0,
                            child: verifyButton,

                          ),


                          ],
                    ) ,
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
                            Navigator.pushNamed(context, "login");
                          },
                        )
                        //this.nextButton,
                      ]),
                ],
              ))),
    );
  }

  bool testEmail(String input) {
    final String regexEmail =
        "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    if (input == null || input.isEmpty) return false;
    return (new RegExp(regexEmail)).hasMatch(input);
  }
}

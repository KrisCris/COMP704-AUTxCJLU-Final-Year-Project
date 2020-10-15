import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class MyTextField extends StatefulWidget {
  // final iconString;  //这里是放图表的，暂时用不到
  final String placeholder; //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  //final emailAddress;
  final bool isPassword; //判断是不是密码框
  double width;
  double height;
  Color originalColor;
  Color focusColor;
  Color errorColor;

  // final inputController;  //用来获取输入内容的

  MyTextField(
      {this.placeholder,
      this.isPassword = false,
      this.height,
      this.width,
      this.errorColor,
      this.focusColor,
      this.originalColor,
      Key key})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);
    this.height = ScreenTool.partOfScreenHeight(this.height);
  } //构造函数

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyTextFieldState();
  }
}

class MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(

        // margin: EdgeInsets.only(left: 15),

        child: (Expanded(
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.8, color: Colors.blue))),
                //底部border的宽度和颜色
                child: TextField(
                  decoration: InputDecoration(
                    hintText: widget.placeholder,

                    // contentPadding: EdgeInsets.fromLTRB(0, 17, 15, 15), //输入框内容部分设置padding，跳转跟icon的对其位置
                    border: InputBorder.none,
                  ),
                  obscureText: widget.isPassword, //是否切换到密码模式，是以星号*显示密码
                )))));
  }
}

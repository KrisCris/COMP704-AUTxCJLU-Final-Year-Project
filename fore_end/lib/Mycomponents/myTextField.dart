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
  double ulDefaultWidth;
  double ulFocusedWidth;

  // final inputController;  //用来获取输入内容的

  MyTextField(
      {this.placeholder,
      this.isPassword = false,
      this.height,
      this.width,
        this.ulFocusedWidth,
        this.ulDefaultWidth,
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

///ASDASDASD
class MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(  width: widget.ulDefaultWidth, color: widget.originalColor))),
        //底部border的宽度和颜色
        child: TextField(
          decoration: InputDecoration(
            hintText: widget.placeholder,

            border: InputBorder.none,
          ),
          obscureText: widget.isPassword, //是否切换到密码模式，是以星号*显示密码
        ));
  }
}

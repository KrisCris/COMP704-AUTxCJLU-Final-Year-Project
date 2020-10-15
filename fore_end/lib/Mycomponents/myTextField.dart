import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class MyTextField extends StatefulWidget {
  // final iconString;  //这里是放图表的，暂时用不到
  final String placeholder; //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  final bool isPassword; //判断是不是密码框
  double width;
  Color defaultColor;
  Color focusColor;
  Color errorColor;
  double ulDefaultWidth;
  double ulFocusedWidth;

  // final inputController;  //用来获取输入内容的

  MyTextField(
      {this.placeholder,
      this.isPassword = false,
      // this.height,
      this.width,
      this.ulFocusedWidth,
      this.ulDefaultWidth,
      this.errorColor,
      this.focusColor,
      this.defaultColor,
      Key key})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);
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
        width: widget.width,
        margin: new EdgeInsets.fromLTRB(5, 5, 5, 5),
        // //底部border的宽度和颜色
        child: TextField(
          decoration: new InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.focusColor, width: widget.ulFocusedWidth),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: widget.defaultColor, width: widget.ulDefaultWidth),
              ),
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: widget.ulDefaultWidth)
              ),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color:widget.errorColor,width:widget.ulDefaultWidth)
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color:widget.errorColor,width:widget.ulFocusedWidth)
              ),
              hintText: widget.placeholder,
              contentPadding: new EdgeInsets.fromLTRB(0, 0, 0, 6),
              isDense: true),
          obscureText: widget.isPassword, //是否切换到密码模式，是以星号*显示密码
        ));
  }
}

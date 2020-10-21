import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyIcons.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class MyTextField extends StatefulWidget {
  // final iconString;  //这里是放图表的，暂时用不到
  final String placeholder; //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  final bool isPassword; //判断是不是密码框
  final bool isEmail;   //判断邮箱格式
  final bool isAutoFocus;
  final inputController; //用来获取文本框内容
  double width;   //文本框的宽
  Color defaultColor;  //不点击的颜色  灰
  Color focusColor; //点击的颜色   蓝
  Color errorColor;  //报错的颜色  红
  double ulDefaultWidth;  //未点击的下划线厚度
  double ulFocusedWidth;  //点击的厚度

  // bool checkContent;
  // final inputController;  //用来获取输入内容的

  MyTextField(
      {this.placeholder,
      this.isPassword = false,
        this.isAutoFocus= false,
      this.width,
      this.ulFocusedWidth,
      this.ulDefaultWidth,
      this.errorColor,
      this.focusColor,
      this.defaultColor,
        this.isEmail=false,
        this.inputController,
      Key key})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);



  } //构造函数

  //测试逻辑方法
  bool testIsEmail(bool checkContent){
    if(checkContent){
      return true;
    }
    return false;

  }


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyTextFieldState();
  }
}

class MyTextFieldState extends State<MyTextField> {



  @override
  Widget build(BuildContext context) {

    return
         Container(
            width: widget.width,
            margin: new EdgeInsets.fromLTRB(5, 5, 5, 5),
            // //底部border的宽度和颜色
            child: TextField(

              // keyboardType: TextInputType.emailAddress,

              controller: widget.inputController,

              style: TextStyle(fontSize: 18),
              autofocus: widget.isAutoFocus,
              cursorColor: Colors.blue,
              cursorWidth: 2,


              decoration: new InputDecoration(   //下划线的设置
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
                  isDense: true,
                  // border: InputBorder.none,
                  // suffixIcon: Icon(MyIcons.icon_yes, color: Colors.green,size: 20,)

              ),
              // obscureText: widget.isPassword, //是否切换到密码模式，是以星号*显示密码
              obscureText: widget.testIsEmail(widget.isPassword),

              //

            )
    );

  }


}


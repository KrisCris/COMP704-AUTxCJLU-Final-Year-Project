import 'dart:ui';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  // final iconString;  //这里是放图表的，暂时用不到
  final placeholder;  //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  final emailAddress;
  final isPassword; //判断是不是密码框
  // final inputController;  //用来获取输入内容的

  MyTextField({this.placeholder,this.emailAddress,this.isPassword}); //构造函数




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 8.0), //往左边加8像素留白
          child: Container(
            margin: EdgeInsets.only(left: 15),
            decoration:BoxDecoration(
                border:Border(bottom: BorderSide(width: 0.8,color:Colors.blue))), //底部border的宽度和颜色

            child: TextField(   //输入框
              decoration: InputDecoration(
                hintText: placeholder,
                contentPadding: EdgeInsets.fromLTRB(0, 17, 15, 15), //输入框内容部分设置padding，跳转跟icon的对其位置
                border:InputBorder.none,
              ),
              obscureText: isPassword, //是否切换到密码模式，是以星号*显示密码
            ),

          ),
        ),
      ),
    );

  }
}


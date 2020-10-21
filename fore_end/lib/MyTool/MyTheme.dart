import 'dart:ui';
import 'package:flutter/material.dart';

class MyTheme {

  final Color unfocusedColor;
  final Color disabledColor;
  final Color errorColor;
  final Color focusedColor;
  final Color warningColor;
  final Color completeColor;
  final Color textColorDark;
  final Color textColorLight;

  const MyTheme._privateConstructor( {this.unfocusedColor,this.disabledColor,
    this.errorColor,this.focusedColor,this.warningColor,this.completeColor,
  this.textColorDark,this.textColorLight});

  static const MyTheme blueStyle = MyTheme._privateConstructor(
      unfocusedColor: Color(0xFF929497),
      focusedColor:  Color(0xFF0090FF),
      disabledColor: Color(0xFF929497),
      errorColor: Color(0xFFFF6060),
      warningColor: Color(0xFFFFC35F),
      completeColor: Color(0xFF0091EA),
      textColorDark: Colors.black,
      textColorLight: Colors.white,
  );
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/interface/Themeable.dart';

class MyTheme {

  // final Color unfocusedColor;
  // final Color disabledColor;
  // final Color errorColor;
  // final Color focusedColor;
  // final Color warningColor;
  // final Color completeColor;
  // final Color textColorDark;
  // final Color textColorLight;
  Map<ComponentThemeState,Color> themeMap;
  Map<ComponentReactState,Color> reactMap;
  Color darkTextColor;
  Color lightTextColor;
  MyTheme._privateConstructor( {final unfocusedColor, final disabledColor,
    final errorColor,final focusedColor,final warningColor,final correctColor,
    final normalColor, final textColorDark,final textColorLight}){
    this.themeMap =  {
      ComponentThemeState.correct : correctColor,
      ComponentThemeState.warning : warningColor,
      ComponentThemeState.error : errorColor,
      ComponentThemeState.normal : normalColor
    };
    this.reactMap = {
      ComponentReactState.focused : focusedColor,
      ComponentReactState.unfocused:unfocusedColor,
      ComponentReactState.disabled : disabledColor,
      ComponentReactState.able : focusedColor
    };
    this.darkTextColor = textColorDark;
    this.lightTextColor = textColorLight;
  }

  CalculatableColor getThemeColor(ComponentThemeState the){
    return CalculatableColor.transform( this.themeMap[the]);
  }
  CalculatableColor getReactColor(ComponentReactState rea){
    return CalculatableColor.transform(this.reactMap[rea]) ;
  }

  static final MyTheme blueStyle = MyTheme._privateConstructor(
      unfocusedColor: Color(0xFF929497),
      focusedColor:  Color(0xFF0090FF),
      disabledColor: Color(0xFF929497),
      errorColor: Color(0xFFFF6060),
      warningColor: Color(0xFFFFC35F),
      normalColor: Color(0xFF0091EA),
      correctColor: Color(0xFF4ED882),
      textColorDark: Colors.black,
      textColorLight: Colors.white,
  );
  static final MyTheme blueAndWhite = MyTheme._privateConstructor(
    unfocusedColor: Colors.white,
    focusedColor:  Color(0xFF0080E2),
    disabledColor: Color(0xFF929497),
    errorColor: Color(0xFFFF6060),
    warningColor: Color(0xFFFFC35F),
    normalColor: Color(0xFF0091EA),
    correctColor: Color(0xFF4ED882),
    textColorDark: Colors.black,
    textColorLight: Colors.black12,
  );
  static final MyTheme blackAndWhite = MyTheme._privateConstructor(
    unfocusedColor: Colors.white,
    focusedColor: Colors.black,
    disabledColor: Color(0xFFB5B5B5),
    errorColor: Colors.black,
    warningColor: Colors.black,
    normalColor: Colors.black,
    correctColor: Colors.black,
    textColorDark: Colors.black,
    textColorLight: Colors.white,
  );
  static final MyTheme WhiteAndBlack = MyTheme._privateConstructor(
    unfocusedColor: Color(0xFFEEEEEE),
    focusedColor: Colors.white,
    disabledColor: Color(0xFFB5B5B5),
    errorColor: Colors.white,
    warningColor: Colors.white,
    normalColor: Colors.white,
    correctColor: Colors.white,
    textColorDark: Colors.white,
    textColorLight: Colors.black,
  );
}

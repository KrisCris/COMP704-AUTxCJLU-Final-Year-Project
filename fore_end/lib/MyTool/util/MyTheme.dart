import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CalculatableColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User.dart';
import 'LocalDataManager.dart';
enum ThemeColorName {
  Warning,Success,Error,
  PageBackground,ComponentBackground,
  NormalText,HeaderText,HighLightText,DisableText,WithIconText,
  NormalIcon,HightLightIcon,DisableIcon,
  Button,HighLightButton,DisabledButton,
  TransparentShadow
}

class MyTheme {

  final Color warningColor;
  final Color successColor;
  final Color errorColor;

  final Color pageBackgroundColor;
  final Color componentBackgroundColor;

  final Color normalTextColor;
  final Color headerTextColor;
  final Color highLightTextColor;
  final Color disabledTextColor;
  final Color textWithIconColor;

  final Color normalIconColor;
  final Color highLightIconColor;
  final Color disabledIconColor;

  final Color buttonColor;
  final Color buttonHighLightColor;
  final Color buttonDisabledColor;

  final Color transparentShadowColor;

  const MyTheme(
      {this.warningColor,
      this.successColor,
      this.errorColor,
      this.pageBackgroundColor,
      this.componentBackgroundColor,
      this.normalTextColor,
      this.normalIconColor,
      this.headerTextColor,
      this.highLightIconColor,
      this.highLightTextColor,
      this.buttonHighLightColor,
      this.textWithIconColor,
      this.disabledIconColor,
      this.disabledTextColor,
      this.buttonDisabledColor,
      this.buttonColor,
      this.transparentShadowColor});

  static const AVAILABLE_THEME = [MyTheme.DARK_BLUE_THEME];
  static const DARK_BLUE_THEME = MyTheme(
      errorColor: CalculatableColor(0xFFA30D0D),
      successColor: CalculatableColor(0xFF099926),
      warningColor: CalculatableColor(0xFFCBBC01),
      pageBackgroundColor: CalculatableColor(0xFF172632),
      componentBackgroundColor: CalculatableColor(0xFF1F405A),
      normalTextColor: CalculatableColor(0xFFF1F1F1),
      headerTextColor: CalculatableColor(0xFFF1F1F1),
      highLightTextColor: CalculatableColor(0xFF266EC0),
      disabledTextColor: CalculatableColor(0xFF999999),
      textWithIconColor: CalculatableColor(0xFFF1F1F1),
      normalIconColor: CalculatableColor(0xFFF1F1F1),
      highLightIconColor: CalculatableColor(0xFF266EC0),
      disabledIconColor: CalculatableColor(0xFF999999),
      buttonColor: CalculatableColor(0xFF266EC0),
      buttonHighLightColor: CalculatableColor(0xFF4F8ED6),
      buttonDisabledColor: CalculatableColor(0xFF999999),
      transparentShadowColor: CalculatableColor(0x1AFFFFFF));
  static MyTheme getTheme({int themeCode}) {
    //不提供主题编号，则从当前用户信息中获取编号
    if(themeCode == null){
      if(User.isInit()){
        themeCode = User.getInstance().themeCode;
      }
    }
    //若用户未被初始化，则从本地文件中读取存储的编号
    if (themeCode == null) {
      SharedPreferences pre = LocalDataManager.pre;
      themeCode = pre.getInt("theme");
    }
    //若无存储的主题编号，则默认使用第一个主题
    if (themeCode == null) {
      themeCode = 0;
    }
    return MyTheme.AVAILABLE_THEME[themeCode];
  }
  static Color convert(ThemeColorName name, {Color color}){
    //颜色已经给定，则直接返回
    if(color != null){
      if(color is CalculatableColor){
        return color;
      }
      return CalculatableColor.transform(color);
    }
    //未给定颜色，返回主题色
    MyTheme theme = getTheme();
    switch(name){
      case ThemeColorName.Error:
        return theme.errorColor;

      case ThemeColorName.Success:
        return theme.successColor;

      case ThemeColorName.Warning:
        return theme.warningColor;

      case ThemeColorName.PageBackground:
        return theme.pageBackgroundColor;

      case ThemeColorName.ComponentBackground:
        return theme.componentBackgroundColor;

      case ThemeColorName.NormalText:
        return theme.normalTextColor;

      case ThemeColorName.HeaderText:
        return theme.headerTextColor;

      case ThemeColorName.HighLightText:
        return theme.highLightTextColor;

      case ThemeColorName.DisableText:
        return theme.disabledTextColor;

      case ThemeColorName.WithIconText:
        return theme.textWithIconColor;

      case ThemeColorName.NormalIcon:
       return theme.normalIconColor;

      case ThemeColorName.HightLightIcon:
       return theme.highLightIconColor;

      case ThemeColorName.DisableIcon:
        return theme.disabledIconColor;

      case ThemeColorName.Button:
        return theme.buttonColor;

      case ThemeColorName.HighLightButton:
        return theme.buttonHighLightColor;

      case ThemeColorName.DisabledButton:
        return theme.buttonDisabledColor;

      case ThemeColorName.TransparentShadow:
        return theme.transparentShadowColor;

      default:
        print("ThemeColorName error: "+ name.toString());
        return CalculatableColor(0xFFFFFFFF);
    }
  }
}

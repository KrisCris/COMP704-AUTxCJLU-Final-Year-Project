import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CalculatableColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User.dart';
import 'LocalDataManager.dart';
enum ThemeColorName {
  Warning,Success,Error,
  NormalBackground,PageBackground,ComponentBackground,
  NormalText,HeaderText,HighLightText,DisableText,WithIconText,
  NormalIcon,DarkIcon, HightLightIcon,DisableIcon,
  Textfield,HighLightTextField,
  Button,HighLightButton,DisabledButton,
  TransparentShadow,
  PickerToolBackground,PickerToolText,
}

class MyTheme {
  final String name;

  final Color warningColor;
  final Color successColor;
  final Color errorColor;

  final Color normalBackgroundColor;
  final Color pageBackgroundColor;
  final Color componentBackgroundColor;

  final Color normalTextColor;
  final Color headerTextColor;
  final Color highLightTextColor;
  final Color disabledTextColor;
  final Color textWithIconColor;

  final Color normalIconColor;
  final Color darkIconColor;
  final Color highLightIconColor;
  final Color disabledIconColor;

  final Color textFieldColor;
  final Color highLightTextFieldColor;

  final Color buttonColor;
  final Color buttonHighLightColor;
  final Color buttonDisabledColor;

  final Color transparentShadowColor;

  final Color pickerToolBackgroundColor;
  final Color pickerToolTextColor;

  const MyTheme(
      {this.name,
        this.warningColor,
      this.successColor,
      this.errorColor,
      this.pageBackgroundColor,
      this.componentBackgroundColor,
      this.normalTextColor,
      this.normalIconColor,
        this.darkIconColor,
      this.headerTextColor,
      this.highLightIconColor,
      this.highLightTextColor,
      this.buttonHighLightColor,
      this.textWithIconColor,
      this.disabledIconColor,
      this.disabledTextColor,
        this.highLightTextFieldColor,
        this.textFieldColor,
      this.buttonDisabledColor,
      this.buttonColor,
      this.transparentShadowColor,
      this.pickerToolBackgroundColor,
      this.pickerToolTextColor,
      this.normalBackgroundColor,

      });

  static const AVAILABLE_THEME = [MyTheme.DARK_BLUE_THEME,MyTheme.LIGHT_BLUE_THEME];
  static const DARK_BLUE_THEME = MyTheme(
    name: "dark blue",
    ///Color 代替CalculatableColor就是可以直接的显示颜色
      errorColor: CalculatableColor(0xFFA30D0D),  ///红
      successColor: CalculatableColor(0xFF099926),  ///绿
      warningColor: CalculatableColor(0xFFCBBC01),  ///黄
      pageBackgroundColor: CalculatableColor(0xFF172632),  ///深蓝
      componentBackgroundColor: CalculatableColor(0xFF1F405A),  ///浅蓝
      normalTextColor: CalculatableColor(0xFFF1F1F1),  ///白
      headerTextColor: CalculatableColor(0xFFF1F1F1),  ///白
      highLightTextColor: CalculatableColor(0xFF266EC0),  ///蓝
      disabledTextColor: CalculatableColor(0xFF999999),  ///灰色
      textWithIconColor: CalculatableColor(0xFFF1F1F1),  ///白
      normalIconColor: CalculatableColor(0xFFF1F1F1),  ///白
      darkIconColor: CalculatableColor(0xFF266EC0),  ///蓝
      highLightIconColor: CalculatableColor(0xFF266EC0),  ///蓝
      disabledIconColor: CalculatableColor(0xFF999999),  ///灰
      textFieldColor: CalculatableColor(0xFF999999),  ///灰
      highLightTextFieldColor: CalculatableColor(0xFF266EC0),  ///蓝
      buttonColor: CalculatableColor(0xFF266EC0),  ///蓝
      buttonHighLightColor: CalculatableColor(0xFF4F8ED6),  ///浅蓝
      buttonDisabledColor: CalculatableColor(0xFF999999),  ///灰
      transparentShadowColor: CalculatableColor(0x1AFFFFFF),  ///纯白半透明
      pickerToolBackgroundColor: CalculatableColor(0xFF057d9f),  ///青蓝
      pickerToolTextColor:CalculatableColor(0xFF323232),  ///黑
      normalBackgroundColor:CalculatableColor(0xFFF1F1F1),  ///白

  );
  static const LIGHT_BLUE_THEME = MyTheme(
    name:"light blue",
    errorColor: CalculatableColor(0xFFDF4444),  ///红
    successColor: CalculatableColor(0xFF37C674),  ///绿
    warningColor: CalculatableColor(0xFFDFD153),  ///黄
    pageBackgroundColor: CalculatableColor(0xFFAAC8E1),  ///浅蓝
    componentBackgroundColor: CalculatableColor(0xFF7FB1D8),  ///淡蓝
    normalTextColor: CalculatableColor(0xFF000000),  ///黑
    headerTextColor: CalculatableColor(0xFF000000),  ///黑
    highLightTextColor: CalculatableColor(0xFFD96235),  ///橘色
    disabledTextColor: CalculatableColor(0xFF606060),  ///灰色
    textWithIconColor: CalculatableColor(0xFF000000),  ///黑
    normalIconColor: CalculatableColor(0xFF000000),  ///黑色
    darkIconColor: CalculatableColor(0xFFFD6D37),  ///橘色
    highLightIconColor: CalculatableColor(0xFFFD6D37),  ///橘色
    disabledIconColor: CalculatableColor(0xFF606060),  ///灰
    textFieldColor: CalculatableColor(0xFF606060),  ///灰
    highLightTextFieldColor: CalculatableColor(0xFFD96235),  ///橘色
    buttonColor: CalculatableColor(0xFFFF7947),  ///蓝
    buttonHighLightColor: CalculatableColor(0xFFFA916A),  ///浅蓝
    buttonDisabledColor: CalculatableColor(0xFF999999),  ///灰
    transparentShadowColor: CalculatableColor(0x1AFFFFFF),  ///白色透明
    pickerToolBackgroundColor: CalculatableColor(0xFF057d9f),  ///青蓝
    pickerToolTextColor:CalculatableColor(0xFF323232),  ///黑
    normalBackgroundColor:CalculatableColor(0xFFF1F1F1),  ///白
  );

  static MyTheme getTheme({int themeCode}) {
    //不提供主题编号，则从当前用户信息中获取编号
    if(themeCode == null){
      if(User.isInit()){
        themeCode = User.getInstance().themeCode;
      }
    }
    //若用户未被初始化，则从本地文件中读取存储的编号
    if (themeCode == null) {
      if(LocalDataManager.isInit()){
        SharedPreferences pre = LocalDataManager.pre;
        themeCode = pre.getInt("theme");
      }
    }
    //若无存储的主题编号，则默认使用第一个主题
    if (themeCode == null) {
      themeCode = 0;
    }
    return MyTheme.AVAILABLE_THEME[themeCode];
  }
  static int getThemeIndex(MyTheme theme){
    int i=0;
    for(MyTheme the in MyTheme.AVAILABLE_THEME){
      if(the == theme){
        return i;
      }
      i++;
    }
    return -1;
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

      case ThemeColorName.Textfield:
        return theme.textFieldColor;

      case ThemeColorName.HighLightTextField:
        return theme.highLightTextFieldColor;

      case ThemeColorName.Button:
        return theme.buttonColor;

      case ThemeColorName.HighLightButton:
        return theme.buttonHighLightColor;

      case ThemeColorName.DisabledButton:
        return theme.buttonDisabledColor;

      case ThemeColorName.TransparentShadow:
        return theme.transparentShadowColor;

      case ThemeColorName.PickerToolBackground:
        return theme.pickerToolBackgroundColor;

      case ThemeColorName.PickerToolText:
        return theme.pickerToolTextColor;

      case ThemeColorName.NormalBackground:
        return theme.normalBackgroundColor;

      default:
        print("ThemeColorName error: "+ name.toString());
        return CalculatableColor(0xFFFFFFFF);
    }
  }
}

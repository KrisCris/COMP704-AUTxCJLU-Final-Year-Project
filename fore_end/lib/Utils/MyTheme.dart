import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/Models/SoftwarePreference.dart';
import 'package:fore_end/Utils/CalculatableColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    ///Color ??????CalculatableColor?????????????????????????????????
      errorColor: CalculatableColor(0xFFA30D0D),  ///???
      successColor: CalculatableColor(0xFF099926),  ///???
      warningColor: CalculatableColor(0xFFCBBC01),  ///???
      pageBackgroundColor: CalculatableColor(0xFF172632),  ///??????
      componentBackgroundColor: CalculatableColor(0xFF1F405A),  ///??????
      normalTextColor: CalculatableColor(0xFFF1F1F1),  ///???
      headerTextColor: CalculatableColor(0xFFF1F1F1),  ///???
      highLightTextColor: CalculatableColor(0xFF266EC0),  ///???
      disabledTextColor: CalculatableColor(0xFF999999),  ///??????
      textWithIconColor: CalculatableColor(0xFFF1F1F1),  ///???
      normalIconColor: CalculatableColor(0xFFF1F1F1),  ///???
      darkIconColor: CalculatableColor(0xFF266EC0),  ///???
      highLightIconColor: CalculatableColor(0xFF266EC0),  ///???
      disabledIconColor: CalculatableColor(0xFF999999),  ///???
      textFieldColor: CalculatableColor(0xFF999999),  ///???
      highLightTextFieldColor: CalculatableColor(0xFF266EC0),  ///???
      buttonColor: CalculatableColor(0xFF266EC0),  ///???
      buttonHighLightColor: CalculatableColor(0xFF4F8ED6),  ///??????
      buttonDisabledColor: CalculatableColor(0xFF999999),  ///???
      transparentShadowColor: CalculatableColor(0x1AFFFFFF),  ///???????????????
      pickerToolBackgroundColor: CalculatableColor(0xFF057d9f),  ///??????
      pickerToolTextColor:CalculatableColor(0xFF323232),  ///???
      normalBackgroundColor:CalculatableColor(0xFFF1F1F1),  ///???

  );
  static const LIGHT_BLUE_THEME = MyTheme(
    name:"light blue",
    errorColor: CalculatableColor(0xFFDF4444),  ///???
    successColor: CalculatableColor(0xFF37C674),  ///???
    warningColor: CalculatableColor(0xFFDFD153),  ///???
    pageBackgroundColor: CalculatableColor(0xFFAAC8E1),  ///??????
    componentBackgroundColor: CalculatableColor(0xFF7FB1D8),  ///??????
    normalTextColor: CalculatableColor(0xFF000000),  ///???
    headerTextColor: CalculatableColor(0xFF000000),  ///???
    highLightTextColor: CalculatableColor(0xFF266EC0),  ///??????
    disabledTextColor: CalculatableColor(0xFF606060),  ///??????
    textWithIconColor: CalculatableColor(0xFF000000),  ///???
    normalIconColor: CalculatableColor(0xFF000000),  ///??????
    darkIconColor: CalculatableColor(0xFF266EC0),  ///??????
    highLightIconColor: CalculatableColor(0xFF266EC0),  ///??????
    disabledIconColor: CalculatableColor(0xFF606060),  ///???
    textFieldColor: CalculatableColor(0xFF606060),  ///???
    highLightTextFieldColor: CalculatableColor(0xFF266EC0),  ///??????
    buttonColor: CalculatableColor(0xFF266EC0),  ///???
    buttonHighLightColor: CalculatableColor(0xFFFA916A),  ///??????
    buttonDisabledColor: CalculatableColor(0xFF999999),  ///???
    transparentShadowColor: CalculatableColor(0x1A000000),  ///????????????
    pickerToolBackgroundColor: CalculatableColor(0xFF057d9f),  ///??????
    pickerToolTextColor:CalculatableColor(0xFF323232),  ///???
    normalBackgroundColor:CalculatableColor(0xFFF1F1F1),  ///???
  );

  static MyTheme getTheme({int themeCode}) {
    //?????????????????????????????????????????????????????????????????????
    if(themeCode == null){
      if(SoftwarePreference.isInit()){
        themeCode = SoftwarePreference.getInstance().theme;
      }
    }
    //???????????????????????????????????????????????????????????????????????????
    if (themeCode == null) {
      if(LocalDataManager.isInit()){
        SharedPreferences pre = LocalDataManager.pre;
        themeCode = pre.getInt("theme");
      }
    }
    //????????????????????????????????????????????????????????????
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
    //????????????????????????????????????
    if(color != null){
      if(color is CalculatableColor){
        return color;
      }
      return CalculatableColor.transform(color);
    }
    //?????????????????????????????????
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

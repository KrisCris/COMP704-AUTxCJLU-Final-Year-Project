import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fore_end/MyTool/SoftwarePreference.dart';

class CustomLocalizations {
  final Locale locale;

  CustomLocalizations(this.locale);

  static const Map<String,Locale> supported = {
    "zh": const Locale('zh','CH'),
    "en": const Locale('en','US'),
  };

  static Map<String, Map<String, String>> _localizedValues = {
    "loginState":{
      "en":"checking login state...",
      "zh":"正在检测登录状态..."
    },
    "foodRecognizer":{
      "en":"init food recognizer...",
      "zh":"正在初始化食物识别器...",
    },
    "preference":{
      "en":"init preferences...",
      "zh":"正在初始化偏好设置...",
    },
    "welcome":{
      "en":"welcome to here!",
      "cn":"欢迎使用DietLens"
    },
    "autoLogin":{
      "en":"auto login...",
      "zh":"正在自动登录..."
    },
    "offlineLogin":{
      "en":"offline login...",
      "zh":"正在以离线模式登录..."
    }
  };
  static CustomLocalizations of(BuildContext context){
    return Localizations.of(context, CustomLocalizations);
  }
  String _getLanguageCode(){
    String languageCode;
    if(SoftwarePreference.isInit()){
      languageCode = SoftwarePreference.getInstance().languageCode;
    }
    if(languageCode == null){
      languageCode = "default";
    }
    if(languageCode == "default"){
      languageCode = locale.languageCode;
    }
    return languageCode;
  }
  String getContent(String key){
    if(!_localizedValues.containsKey(key)){
      return "no key named '"+key+"'";
    }
    String languageCode = this._getLanguageCode();
    if(!_localizedValues[key].containsKey(languageCode)){
      return key + " has not supported in "+ languageCode;
    }
    return _localizedValues[key][locale.languageCode];
  }

  get loginState{
    return getContent("loginState");
  }
  get welcome{
    return getContent("welcome");
  }
  get autoLogin{
    return getContent("autoLogin");
  }
}

class CustomLocalizationsDelegate extends LocalizationsDelegate<CustomLocalizations>{

  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return CustomLocalizations.supported.containsKey(locale.languageCode);
  }

  @override
  Future<CustomLocalizations> load(Locale locale) {
    return new SynchronousFuture<CustomLocalizations>(new CustomLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<CustomLocalizations> old) {
    return false;
  }

  static CustomLocalizationsDelegate delegate = const CustomLocalizationsDelegate();
}
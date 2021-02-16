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

    //主题色的多语言翻译-------起始
    "dark blue":{
      "en":"dark blue",
      "zh":"深蓝"
    },
    "light blue":{
      "en":"light blue",
      "zh":"浅蓝"
    },
    //主题色的多语言翻译-------结束

    "default":{
      "en":"default",
      "zh":"默认"
    },
    "languageName":{
      "en":"English",
      "zh":"简体中文"
    },
    "cancel":{
      "en":"Cancel",
      "zh":"取消",
    },
    "back":{
      "en":"Back",
      "zh":"返回"
    },
    "confirm":{
      "en":"Confirm",
      "zh":"确认"
    },
    "next":{
      "en":"Next",
      "zh":"下一步",
    },
    "slogan":{
      "en":"Take a Picture of your food!",
      "zh":"为你的食物拍张照吧!"
    },
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
      "zh":"欢迎使用DietLens"
    },
    "autoLogin":{
      "en":"auto login...",
      "zh":"正在自动登录..."
    },
    "offlineLogin":{
      "en":"offline login...",
      "zh":"正在以离线模式登录..."
    },
    "welcomeTitle":{
      "en":"Welcome",
      "zh":"欢迎使用"
    },
    "signUp":{
      "en":"Sign Up",
      "zh":"注册新账户"
    },
    "alreadyHave":{
      "en":"Already Have Account?",
      "zh":"已有账户，点击登录"
    },
    "createAccount":{
      "en":"Create Your\nAccount",
      "zh":"创建您的\n账户"
    },
    "acquireVerify":{
      "en":"Acquire Verify Code",
      "zh":"获取验证码"
    },
    "acquireAgain":{
      "en":"Acquire again",
      "zh":"再次获取"
    },
    "verifyCode":{
      "en":"input verify code",
      "zh":"输入验证码"
    },
    "nickName":{
      "en":"nick name",
      "zh":"昵称"
    },
    "nickNameHint":{
      "en":"Please input your nick name",
      "zh":"请输入您的昵称"
    },
    "password":{
      "en":"Password",
      "zh":"密码"
    },
    "passwordHint":{
      "en":"At lease 8 length, contain numbers and english characters",
      "zh":"密码至少需要8位长度，并且包含数字和英文字母"
    },
    "confirmPassword":{
      "en":"confirm password",
      "zh":"确认密码"
    },
    "confirmPasswordHint":{
      "en":"re-enter the password",
      "zh":"再次输入密码"
    },
    "email":{
      "en":"Email",
      "zh":"电子邮箱"
    },
    "emailHint":{
      "en":"Please input correct email",
      "zh":"请输入正确的邮箱地址"
    },
    "loginAccount":{
      "en":"Login Your\nAccount",
      "zh":"登录您的\n账户"
    },
    "resultPageTitle":{
      "en":"Your Foods Here",
      "zh":"您拍摄的食物"
    },
    "resultPageEmpty":{
      "en":"No Recognized Food Here",
      "zh":"暂未识别到任何食物"
    },
    "resultPageQuestion":{
      "en":"Add Foods To Meals?",
      "zh":"将食物添加到一日三餐"
    },
    "breakfast":{
      "en":"Breakfast",
      "zh":"早餐"
    },
    "lunch":{
      "en":"Lunch",
      "zh":"午餐"
    },
    "dinner":{
      "en":"Dinner",
      "zh":"晚餐"
    },
    "total":{
      "en":"Total",
      "zh":"合计"
    },
    "detail":{
      "en":"detail",
      "zh":"详情"
    },
    "searchFood":{
      "en":"Search foods",
      "zh":"搜索食物"
    },
    "planProgress":{
      "en":"Plan Progress",
      "zh":"计划进度"
    },
    "todayCalories":{
      "en":"Today's Calories",
      "zh":"今日摄入卡路里"
    },
    "todayMeal":{
      "en":"Today's Meal",
      "zh":"今日三餐"
    },
    "planType":{
      "en":"Plan Type",
      "zh":"计划类型"
    },
    "yourPlan":{
      "en":"Your Plan",
      "zh":"您的计划"
    },
    "changePlan":{
      "en":"change Plan",
      "zh":"更换计划"
    },
    "planKeep":{
      "en":"Plan Continues For ",
      "zh":"计划已经进行了 "
    },
    "days":{
      "en":"days",
      "zh":"天"
    },
    "weight":{
      "en":"Weight",
      "zh":"体重"
    },
    "height":{
      "en":"Height",
      "zh":"身高"
    },
    "currentWeight":{
      "en":"Current Weight",
      "zh":"当前体重"
    },
    "goalWeight":{
      "en":"Goal Weight",
      "zh":"目标体重"
    },
    "bodyWeightInfo":{
      "en":"Body Weight Info",
      "zh":"体重变化情况"
    },
    "updateWeight":{
      "en":"Update Weight",
      "zh":"更新体重"
    },
    "updateBodyTitle":{
      "en":"Update Your Weight and Height",
      "zh":"更新您的体重和身高"
    },
    "remainWeight":{
      "en":"Remain Weight",
      "zh":"剩余体重"
    },
    "shedWeight":{
      "en":"Shed Weight",
      "zh":"减肥"
    },
    "buildMuscle":{
      "en":"Build Muscle",
      "zh":"增肌"
    },
    "maintain":{
      "en":"maintain",
      "zh":"保持身材"
    },
    "registerDuration":{
      "en":"Registered For ",
      "zh":"已经注册了 ",
    },
    "drawerAccount":{
      "en":"ACCOUNT",
      "zh":"账户设置"
    },
    "drawerSetting":{
      "en":"SETTINGS",
      "zh":"偏好设置"
    },
    "drawerAbout":{
      "en":"ABOUT US",
      "zh":"关于我们"
    },
    "theme":{
      "en":"Theme",
      "zh":"主题色"
    },
    "language":{
      "en":"Language",
      "zh":"语言"
    },
  };

  static CustomLocalizations of(BuildContext context){
    return Localizations.of(context, CustomLocalizations);
  }
  static int getLanguageNum(){
    return CustomLocalizations.supported.length;
  }
  static List<Map<String,String>> getLanguages(BuildContext context){
    List<Map<String,String>> res = [{Localizations.of(context, CustomLocalizations).getContent("default"):"default"}];
    for(MapEntry entry in _localizedValues["languageName"].entries){
      Map<String,String> temp = {entry.value:entry.key};
      res.add(temp);
    }
    return res;
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
    return _localizedValues[key][languageCode];
  }

  get languageName{
    return getContent("languageName");
  }
  get slogan{
    return getContent("slogan");
  }
  get resultPageTitle{
    return getContent("resultPageTitle");
  }
  get resultPageEmpty{
    return getContent("resultPageEmpty");
  }
  get resultPageQuestion{
    return getContent("resultPageQuestion");
  }
  get breakfast{
    return getContent("breakfast");
  }
  get lunch{
    return getContent("lunch");
  }
  get dinner{
    return getContent("dinner");
  }
  get total{
    return getContent("total");
  }
  get detail{
    return getContent("detail");
  }
  get todayCal{
    return getContent("todayCalories");
  }
  get todayMeal{
    return getContent("todayMeal");
  }
  get searchFood{
    return getContent("searchFood");
  }
  get planProcess{
    return getContent("planProgress");
  }
  get planType{
    return getContent("planType");
  }
  get yourPlan{
    return getContent("yourPlan");
  }
  get changePlan{
    return getContent("changePlan");
  }
  get planKeep{
    return getContent("planKeep");
  }
  get days{
    return getContent("days");
  }
  get currentWeight{
    return getContent("currentWeight");
  }
  get goalWeight{
    return getContent("goalWeight");
  }
  get remainWeight{
    return getContent("remainWeight");
  }
  get bodyWeightInfo{
    return getContent("bodyWeightInfo");
  }
  get updateWeight{
    return getContent("updateWeight");
  }
  get updateBodyTitle{
    return getContent("updateBodyTitle");
  }
  get height{
    return getContent("height");
  }
  get weight{
    return getContent("weight");
  }
  get cancel{
    return getContent("cancel");
  }
  get back{
    return getContent("back");
  }
  get confirm{
    return getContent("confirm");
  }
  get next{
    return getContent("next");
  }
  get registerDuration{
    return getContent("registerDuration");
  }
  get drawerAccount{
    return getContent("drawerAccount");
  }
  get drawerSetting{
    return getContent("drawerSetting");
  }
  get drawerAbout{
    return getContent("drawerAbout");
  }
  get theme{
    return getContent("theme");
  }
  get language{
    return getContent("language");
  }
  get welcomeTitle{
    return getContent("welcomeTitle");
  }
  get signUp{
    return getContent("signUp");
  }
  get alreadyHave{
    return getContent("alreadyHave");
  }
  get createAccount{
    return getContent("createAccount");
  }
  get email{
    return getContent("email");
  }
  get emailHint{
    return getContent("emailHint");
  }
  get password{
    return getContent("password");
  }
  get passwordHint{
    return getContent("passwordHint");
  }
  get confirmPassword{
    return getContent("confirmPassword");
  }
  get confirmPasswordHint{
    return getContent("confirmPasswordHint");
  }
  get nickName{
    return getContent("nickName");
  }
  get nickNameHint{
    return getContent("nickNameHint");
  }

  get acquireVerify{
    return getContent("acquireVerify");
  }
  get acquireAgain {
    return getContent("acquireAgain");
  }
  get verifyCode{
    return getContent("verifyCode");
  }
  get loginAccount{
    return getContent("loginAccount");
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
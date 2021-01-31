import 'dart:convert';
import 'dart:typed_data';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/MyTool/util/LocalDataManager.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/MyTool/util/Req.dart';
import 'package:fore_end/Mycomponents/widgets/MealList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Food.dart';
import 'Meal.dart';
import 'Plan.dart';

class User {
  static const String defaultAvatar = "";
  static const String defaultUsername = "defaultUsername";
  static const List<Icon> genderIcons = [
    Icon(FontAwesomeIcons.horse, color: Colors.grey, size: 30),
    Icon(FontAwesomeIcons.male, color: Colors.lightBlueAccent, size: 30),
    Icon(FontAwesomeIcons.female, color: Colors.pinkAccent, size: 30),
  ];
  static User _instance;

  String _token;
  double _bodyWeight;
  double _bodyHeight;
  int _uid;
  int _age;
  //male - 1, female - 2, other - 0
  Plan _plan;
  int _gender;
  String _userName;
  String _email;
  String _avatar;
  bool _needGuide;

  ///下面是Simon新加的mealData属性，用来存放用户的一日三餐信息。
  ///计划是：每次启动程序时，先去服务器/数据库获取最新的用户添加的食物数据，然后更新本地的数据。
  ///通过今天的日期时间获取服务器的数据，这需要用户在每次添加一个食物时，上传数据库并且记录上传的日期。
  ValueNotifier<List<Meal>> meals;

  User._internal({
    String username = User.defaultUsername,
    int age,
    int gender,
    int uid,
    double bodyWeight,
    double bodyHeight,
    Plan plan,
    bool needGuide,
    String avatar = User.defaultAvatar,
    String token,
    String email,
  }) {
    this._userName = username;
    this._token = token;
    this._email = email;
    this._bodyWeight = bodyWeight;
    this._bodyHeight = bodyHeight;
    this._uid = uid;
    this._gender = gender;
    this._plan = plan;
    this._age = age;
    this._needGuide = needGuide;

    ///下面是Simon新加的mealData属性
    this.meals = new ValueNotifier<List<Meal>>([]);
    this.meals.value = [
      new Meal(mealName: "breakfast"),
      new Meal(mealName: "lunch"),
      new Meal(mealName: "dinner")
    ];
    this.meals.value.forEach((element) {element.read();});
    this.meals.addListener(() {

    });
    if (avatar == null) {
      this._avatar = User.defaultAvatar;
    } else {
      List<String> stringVal = avatar.split(',');
      if (stringVal.length == 2) {
        this._avatar = stringVal[1];
      } else if (stringVal.length == 1) {
        this._avatar = stringVal[0];
      } else {
        this._avatar = "";
      }
    }
  }
  int getTodayCaloriesIntake(){
    int cal = 0;
    for(Meal m in meals.value){
      cal += m.calculateTotalCalories();
    }
    return cal;
  }
  int getTodayProteinIntake(){
    int pro = 0;
    for(Meal m in meals.value){
      pro += m.calculateTotalCalories();
    }
    return pro;
  }
  void refreshMeal(){
    for(Meal m in meals.value){
      State st = m.key.currentState;
      if(st != null && st.mounted){
        st.setState(() {
        });
      }
    }
  }
  bool hasMealName(String s){
    for(Meal m in this.meals.value){
      if(s == m.mealName){
        return true;
      }
    }
    return false;
  }
  Meal getMealByName(String s){
    for(Meal m in this.meals.value){
      if(s == m.mealName){
        return m;
      }
    }
    return null;
  }

  ///从本地文件读取用户信息
  static User getInstance() {
    if (User._instance == null) {
      SharedPreferences pre = LocalDataManager.pre;
      User._instance = User._internal(
          token: pre.getString('token'),
          uid: pre.getInt('uid'),
          username: pre.getString("userName"),
          email: pre.getString('email'),
          gender: pre.getInt('gender'),
          bodyHeight: pre.getDouble("bodyHeight"),
          bodyWeight: pre.getDouble("bodyWeight"),
          age: pre.getInt('age'),
          plan: Plan.readLocal(),
          avatar: pre.getString("avatar"),
          needGuide: pre.getBool("needSetPlan"));
    }
    return User._instance;
  }

  double get bodyWeight => _bodyWeight;

  String get token => _token;
  bool get needGuide => _needGuide;
  set token(String value) {
    _token = value;
  }

  Plan get plan => _plan;

  Image getAvatar(double width, double height) {
    return Image.memory(
      base64Decode(this._avatar),
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Uint8List getAvatarBin() {
    return base64Decode(this._avatar);
  }

  ///与服务器上的用户数据同步
  Future<int> synchronize() async {
    Response res =
        await Requests.getBasicInfo({'uid': this._uid, 'token': this._token});
    if (res.data['code'] == 1) {
      this._age = res.data['data']['age'];
      this._gender = res.data['data']['gender'];
      this._userName = res.data['data']['nickname'];
      this._avatar = res.data['data']['avatar'];
      this._email = res.data['data']['email'];
      this._bodyHeight = res.data['data']['height'];
      this._bodyWeight = res.data['data']['weight'];
      this._needGuide = res.data['data']['needGuide'];
      res = await Requests.getPlan({"uid": this._uid, "token": this._token});
      if (res.data["code"] == -6) {
        //TODO:初始化用户，获取计划失败的情况
        print(res.data);
      } else if (res.data['code'] == 1) {
        this._plan = new Plan(
            id: res.data['data']['pid'],
            startTime: res.data['data']['begin'],
            endTime: res.data['data']['end'],
            planType: res.data['data']['type'],
            goalWeight: res.data['data']['goal'],
            dailyCaloriesLowerLimit:
                NumUtil.getNumByValueDouble(res.data['data']['cl'], 1),
            dailyCaloriesUpperLimit:
                NumUtil.getNumByValueDouble(res.data['data']['ch'], 1),
            dailyProteinLowerLimit:
                NumUtil.getNumByValueDouble(res.data['data']['pl'], 1),
            dailyProteinUpperLimit:
                NumUtil.getNumByValueDouble(res.data['data']['ph'], 1));
        this.save();
      }
      return 1;
    } else if (res.data['code'] == -1) {
      return 0;
    }
  }

  void setPlan(res) {
    this._plan = new Plan(
        id: res.data['data']['pid'],
        startTime: res.data['data']['begin'],
        endTime: res.data['data']['end'],
        planType: res.data['data']['type'],
        goalWeight: res.data['data']['goal'],
        dailyCaloriesLowerLimit: res.data['data']['cl'],
        dailyCaloriesUpperLimit: res.data['data']['ch'],
        dailyProteinLowerLimit: res.data['data']['pl'],
        dailyProteinUpperLimit: res.data['data']['ph']);
    this._plan.save();
  }
  void saveMeal(){
    this.meals.value.forEach((element) {
      element.save();
    });
  }
  void save() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.setString("token", _token);
    pre.setInt("uid", _uid);
    pre.setInt("gender", _gender);
    pre.setInt("age", _age);
    pre.setDouble("bodyHeight", this._bodyHeight);
    pre.setDouble("bodyWeight", this._bodyWeight);
    pre.setString("email", _email);
    pre.setString("userName", _userName);
    pre.setString("avatar", _avatar);
    pre.setBool("needSetPlan", _needGuide);
    this.saveMeal();
    if (this._plan != null) {
      this._plan.save();
    }
  }

  void logOut() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove("token");
    pre.remove("uid");
    pre.remove("gender");
    pre.remove("age");
    pre.remove("bodyHeight");
    pre.remove("bodyWeight");
    pre.remove("email");
    pre.remove("userName");
    pre.remove("avatar");
    pre.remove("needSetPlan");
    this.meals.value.forEach((element) {
      element.delete();
    });
    Plan.removeLocal();
  }

  Icon genderIcon() {
    return User.genderIcons[this._gender];
  }

  int get uid => _uid;

  set uid(int value) {
    _uid = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  int get gender => _gender;

  set gender(int value) {
    _gender = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get avatar => _avatar;

  set avatar(String value) {
    _avatar = value;
  }

  double get bodyHeight => _bodyHeight;
}

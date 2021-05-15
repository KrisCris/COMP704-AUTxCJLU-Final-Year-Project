import 'dart:convert';
import 'dart:typed_data';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';
import 'package:fore_end/Mycomponents/widgets/plan/ExtendTimeHint.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/account/UpdateBody.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _registerDate;
  //male - 1, female - 2, other - 0
  Plan _plan;
  int _gender;
  String _userName;
  String _email;
  String _avatar;
  bool _needGuide;
  bool _shouldUpdateWeight;
  bool _isOffline;
  bool stillHaveDialog;

  int _breakfastRatio;
  int _lunchRatio;
  int _dinnerRatio;

  ///下面是Simon新加的mealData属性，用来存放用户的一日三餐信息。
  ///计划是：每次启动程序时，先去服务器/数据库获取最新的用户添加的食物数据，然后更新本地的数据。
  ///通过今天的日期时间获取服务器的数据，这需要用户在每次添加一个食物时，上传数据库并且记录上传的日期。
  ValueNotifier<List<Meal>> meals;

  User._internal(
      {String username = User.defaultUsername,
      int age,
      int gender,
      int uid,
      int registerDate,
      double bodyWeight,
      double bodyHeight,
      Plan plan,
      bool needGuide,
      bool offline,
      String avatar = User.defaultAvatar,
      String token,
      String email,
      int breakfastRatio,
      int lunchRatio,
      int dinnerRatio}) {
    this._userName = username;
    this._token = token;
    this._email = email;
    this._bodyWeight = bodyWeight;
    this._bodyHeight = bodyHeight;
    this._uid = uid;
    this._gender = gender;
    this._plan = plan;
    this._age = age;
    this._registerDate = registerDate;
    this._needGuide = needGuide;
    this._isOffline = offline;
    this.stillHaveDialog = false;
    this._shouldUpdateWeight = false;
    this._breakfastRatio = breakfastRatio;
    this._lunchRatio = lunchRatio;
    this._dinnerRatio = dinnerRatio;

    ///下面是Simon新加的mealData属性
    this.meals = new ValueNotifier<List<Meal>>([]);
    this.meals.value = [
      new Meal(mealName: "breakfast"),
      new Meal(mealName: "lunch"),
      new Meal(mealName: "dinner")
    ];
    this.readLocalMeal();
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

  set bodyHeight(double value) {
    _bodyHeight = value;
  }

  ///从本地文件读取用户信息
  static User getInstance() {
    if (User._instance == null) {
      SharedPreferences pre = LocalDataManager.pre;
      if (pre == null) {
        print(
            "Local Data Manager has not been initialized yet! User info getting failed!");
        return null;
      }
      User._instance = User._internal(
          token: pre.getString('token'),
          uid: pre.getInt('uid'),
          username: pre.getString("userName"),
          email: pre.getString('email'),
          gender: pre.getInt('gender'),
          bodyHeight: pre.getDouble("bodyHeight"),
          bodyWeight: pre.getDouble("bodyWeight"),
          registerDate: pre.getInt("registerDate"),
          offline: false,
          age: pre.getInt('age'),
          plan: Plan.readLocal(),
          avatar: pre.getString("avatar"),
          needGuide: pre.getBool("needSetPlan"),
          breakfastRatio: pre.getInt("breakfastRatio"),
          lunchRatio: pre.getInt('lunchRatio'),
          dinnerRatio: pre.getInt("dinnerRatio"));
    }
    return User._instance;
  }

  static bool isInit() {
    return User._instance != null;
  }

  ///与服务器上的用户数据同步
  Future<int> synchronize() async {
    Response res = await Requests.getBasicInfo(
        null, {'uid': this._uid, 'token': this._token});
    if (res == null) {
      return 5;
    }

    if (res.data['code'] == 1) {
      this._age = res.data['data']['age'];
      this._gender = res.data['data']['gender'];
      this._userName = res.data['data']['nickname'];
      this._avatar = res.data['data']['avatar'];
      this._email = res.data['data']['email'];
      this._bodyHeight = res.data['data']['height'] / 100;
      this._bodyWeight = res.data['data']['weight'];
      this._needGuide = res.data['data']['needGuide'];
      this._registerDate = res.data['data']['register_date'];

      this._breakfastRatio = res.data['data']['breakfast_percent'];
      this._lunchRatio = res.data['data']['lunch_percent'];
      this._dinnerRatio = res.data['data']['dinner_percent'];

      DateTime nowDay = DateTime.now();
      nowDay = DateTime(nowDay.year, nowDay.month, nowDay.day);
      res = await Requests.dailyMeal(null, {
        "uid": this._uid,
        "token": this._token,
        "begin": nowDay.millisecondsSinceEpoch / 1000,
        "end": nowDay.add(Duration(days: 1)).millisecondsSinceEpoch / 1000 - 1
      });
      if (res != null) {
        if (res.data['code'] == 1) {
          this.meals.value = [
            new Meal(mealName: "breakfast"),
            new Meal(mealName: "lunch"),
            new Meal(mealName: "dinner")
          ];
          for (Map m in res.data['data']['b']) {
            this.meals.value[0].time = m['time'] * 1000;
            this.meals.value[0].addFood(new Food.fromJson(m));
          }

          for (Map m in res.data['data']['l']) {
            this.meals.value[1].time = m['time'] * 1000;
            this.meals.value[1].addFood(new Food.fromJson(m));
          }
          for (Map m in res.data['data']['d']) {
            this.meals.value[2].time = m['time'] * 1000;
            this.meals.value[2].addFood(new Food.fromJson(m));
          }
        }
      }
      res = await Requests.getPlan(
          null, {"uid": this._uid, "token": this._token});
      if (res.data["code"] == -6) {
        this._needGuide = true;
        print(res.data);
      } else if (res.data['code'] == 1) {
        this._plan = Plan.generatePlan(
          res.data['data']['type'],
          res.data['data']['pid'],
          res.data['data']['begin'],
          res.data['data']['end'],
          (res.data['data']['goal'] as double).floor(),
          res.data['data']['ext'] ?? 0,
          NumUtil.getNumByValueDouble(res.data['data']['ch'], 1),
          NumUtil.getNumByValueDouble(res.data['data']['cl'], 1),
          NumUtil.getNumByValueDouble(res.data['data']['ph'], 1),
          NumUtil.getNumByValueDouble(res.data['data']['pl'], 1),
        );
        //计算可能延期多久
        if (this._plan.pastDeadline) {
          await this._plan.calculateDelayDays();
        }
        res = await Requests.shouldUpdateWeight(null,
            {"uid": this._uid, "token": this._token, "pid": this._plan.id});
        if (res != null && res.data['code'] == 1) {
          this._shouldUpdateWeight = res.data['data']['shouldUpdate'];
        }
      }
      this.save();
      return 4;
    } else if (res.data['code'] == -1) {
      return 3;
    }
  }

  //meal相关
  bool hasMealName(String s) {
    for (Meal m in this.meals.value) {
      if (s == m.mealName) {
        return true;
      }
    }
    return false;
  }

  Meal getMealByName(String s) {
    for (Meal m in this.meals.value) {
      if (s == m.mealName) {
        return m;
      }
    }
    return null;
  }

  void saveMeal() {
    this.meals.value.forEach((element) {
      element.save();
    });
  }

  void readLocalMeal() {
    DateTime nowDay = DateTime.now();
    nowDay = DateTime(nowDay.year, nowDay.month, nowDay.day);
    for (Meal m in this.meals.value) {
      m.read();
      //m.delete();
      if (m.time == null) continue;

      if (m.time < nowDay.millisecondsSinceEpoch ||
          m.time >= nowDay.add(Duration(days: 1)).millisecondsSinceEpoch) {
        m.foods = [];
      }
    }
  }

  void refreshMeal() {
    for (Meal m in meals.value) {
      State st = m.key.currentState;
      if (st != null && st.mounted) {
        st.setState(() {});
      }
    }
  }

  //plan相关
  void setPlan(res) {
    this._plan = Plan.generatePlan(
      res.data['data']['type'],
      res.data['data']['pid'],
      res.data['data']['begin'],
      res.data['data']['end'],
      (res.data['data']['goal'] as double).floor(),
      res.data['data']['ext'] ?? 0,
      NumUtil.getNumByValueDouble(res.data['data']['ch'], 1),
      NumUtil.getNumByValueDouble(res.data['data']['cl'], 1),
      NumUtil.getNumByValueDouble(res.data['data']['ph'], 1),
      NumUtil.getNumByValueDouble(res.data['data']['pl'], 1),
    );
    this._plan.save();
  }

  void solvePastDeadline(BuildContext context) async {
    await this._plan.solvePastDeadLine(context);
  }

  void solveUpdateWeight(BuildContext context) {
    this._plan.solveUpdateWeight(context);
  }

  void remindUpdateWeight(BuildContext context) {
    if (this._shouldUpdateWeight) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        this._shouldUpdateWeight = false;
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: ScreenTool.partOfScreenHeight(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DotColumn(borderRadius: 5, children: [
                    SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
                    Container(
                      child: Text(
                        "1 week had passed since your last body weight updating. It's time to update!",
                        style: TextStyle(
                            fontFamily: "Futura",
                            fontSize: 15,
                            color: MyTheme.convert(ThemeColorName.NormalText)),
                      ),
                      width: ScreenTool.partOfScreenWidth(0.6),
                    ),
                    SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
                  ])
                ],
              ),
            );
          },
        );
      });
    }
  }

  int getTodayCaloriesIntake() {
    int cal = 0;
    for (Meal m in meals.value) {
      cal += m.calculateTotalCalories();
    }
    return cal;
  }

  int getTodayProteinIntake() {
    int pro = 0;
    for (Meal m in meals.value) {
      pro += m.calculateTotalProtein();
    }
    return pro;
  }

  double getRemainWeight() {
    double result = this._bodyWeight - this._plan.goalWeight;
    if (result < 0) result = 0;
    return result;
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
    pre.setInt("registerDate", _registerDate);
    pre.setInt("breakfastRatio", _breakfastRatio);
    pre.setInt("lunchRatio", _lunchRatio);
    pre.setInt("dinnerRatio", _dinnerRatio);
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
    pre.remove("localCalories");
    pre.remove("localHistoryMeals");
    pre.remove("localBodyChanges");
    pre.remove("localHistoryPlan");
    pre.remove("breakfastRatio");
    pre.remove("lunchRatio");
    pre.remove("dinnerRatio");
    this.meals.value.forEach((element) {
      element.delete();
    });
    Plan.removeLocal();
  }

  bool get isOffline => _isOffline;
  double get bodyWeight => _bodyWeight;
  String get token => _token;
  bool get needGuide => _needGuide;
  Plan get plan => _plan;
  int get uid => _uid;
  int get age => _age;
  int get gender => _gender;
  String get userName => _userName;
  String get email => _email;
  String get avatar => _avatar;
  double get bodyHeight => _bodyHeight;
  bool get shouldUpdateWeight {
    return this._shouldUpdateWeight;
  }

  int get breakfastRatio => _breakfastRatio;

  set breakfastRatio(int value) {
    _breakfastRatio = value;
  }

  set shouldUpdateWeight(bool value) {
    this._shouldUpdateWeight = value;
  }

  set bodyWeight(double weight) {
    this._bodyWeight = weight;
  }

  set isOffline(bool value) {
    _isOffline = value;
  }

  set token(String value) {
    _token = value;
  }

  set uid(int value) {
    _uid = value;
  }

  set age(int value) {
    _age = value;
  }

  set gender(int value) {
    _gender = value;
  }

  set userName(String value) {
    _userName = value;
  }

  set email(String value) {
    _email = value;
  }

  set avatar(String value) {
    _avatar = value;
  }

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

  Icon genderIcon() {
    return User.genderIcons[this._gender];
  }

  int registerTime() {
    DateTime registerDay =
        DateTime.fromMillisecondsSinceEpoch(this._registerDate * 1000);
    DateTime nowDay = DateTime.now();
    Duration duration = nowDay.difference(registerDay);
    return duration.inDays;
  }

  int get lunchRatio => _lunchRatio;

  int get dinnerRatio => _dinnerRatio;

  set lunchRatio(int value) {
    _lunchRatio = value;
  }

  set dinnerRatio(int value) {
    _dinnerRatio = value;
  }
}

class BodyChangeLog {
  int time;
  int weight;
  int height;

  BodyChangeLog({this.time, this.weight, this.height});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> res = {};
    res['time'] = this.time;
    res['weight'] = this.weight;
    res['height'] = this.height;
    return res;
  }

  String getTime() {
    return DateUtil.formatDate(DateTime.fromMillisecondsSinceEpoch(this.time),
        format: "MM-dd");
  }
}

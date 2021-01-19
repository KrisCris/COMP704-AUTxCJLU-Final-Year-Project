import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/LocalDataManager.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int _uid;
  int _age;
  //male - 1, female - 2, other - 0
  String _planType;
  int _gender;
  String _userName;
  String _email;
  String _avatar;
  bool _needSetPlanFirst;

  User._internal(
      {String username = User.defaultUsername,
      int planType = 0,
      int age,
      int gender,
      int uid,
        bool needSetPlan,
      String avatar = User.defaultAvatar,
      String token,
      String email}) {
    this._userName = username;
    this._token = token;
    this._email = email;
    this._uid = uid;
    this._gender = gender;
    this._age = age;
    this._needSetPlanFirst = needSetPlan;
    if (planType == null) {
      planType = 0;
    }
    this._planType = Plan.planType[planType];
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
  static User getInstance() {
    if (User._instance == null) {
      SharedPreferences pre = LocalDataManager.pre;
      User._instance = User._internal(
          token: pre.getString('token'),
          uid: pre.getInt('uid'),
          username: pre.getString("userName"),
          email: pre.getString('email'),
          gender: pre.getInt('gender'),
          age: pre.getInt('age'),
          avatar: pre.getString("avatar"),
          needSetPlan: pre.getBool("needSetPlan"));
    }
    return User._instance;
  }

  String get token => _token;

  set token(String value) {
    _token = value;
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

  Future<int> synchronize() async {
    Response res =
        await Requests.getBasicInfo({'uid': this._uid, 'token': this._token});
    if (res.data['code'] == 1) {
      this._age = res.data['data']['age'];
      this._gender = res.data['data']['gender'];
      this._userName = res.data['data']['nickname'];
      this._avatar = res.data['data']['avatar'];
      this._email = res.data['data']['email'];
      this._needSetPlanFirst = res.data['data']['needSetPlan'];
      this.save();
      return 1;
    } else if (res.data['code'] == -1) {
      return 0;
    }
  }

  void save() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.setString("token", _token);
    pre.setInt("uid", _uid);
    pre.setInt("gender", _gender);
    pre.setInt("age", _age);
    pre.setString("email", _email);
    pre.setString("userName", _userName);
    pre.setString("avatar", _avatar);
    pre.setBool("needSetPlan", _needSetPlanFirst);
  }

  void logOut() {
    SharedPreferences pre = LocalDataManager.pre;
    pre.remove("token");
    pre.remove("uid");
    pre.remove("gender");
    pre.remove("age");
    pre.remove("email");
    pre.remove("userName");
    pre.remove("avatar");
    pre.remove("needSetPlan");
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
}

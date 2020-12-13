import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';

class LocalDataManager {
  static SharedPreferences _pre;

  static void _init() async {
    if (LocalDataManager._pre == null) {
      LocalDataManager._pre = await SharedPreferences.getInstance();
    }
  }

  static void saveUser(User u) async {
    await _init();
    _pre.setString("token", u.token);
    _pre.setInt("uid", u.uid);
    _pre.setInt("gender", u.gender);
    _pre.setInt("age", u.age);
    _pre.setString("email", u.email);
    _pre.setString("userName", u.userName);
    _pre.setString("avatar", u.getRemoteAvatar());
  }
  static void deleteUser() async{
    await _init();
    _pre.remove("token");
    _pre.remove("uid");
    _pre.remove("gender");
    _pre.remove("age");
    _pre.remove("email");
    _pre.remove("userName");
    _pre.remove("avatar");
  }
  static Future<User> readUser() async {
    await _init();
    User u = new User(
        token: _pre.getString('token'),
        uid:_pre.getInt('uid'),
        gender:_pre.getInt('gender'),
        age:_pre.getInt('age'),
        email: _pre.getString('email'),
        username: _pre.getString("userName"),
        avatar: _pre.getString("avatar"));
    return u;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import 'User.dart';

class LocalDataManager{
  static SharedPreferences _pre;

  static void _init() async{
    if(LocalDataManager._pre == null){
      LocalDataManager._pre = await SharedPreferences.getInstance();
    }
  }

  static void saveUser(User u) async{
    await _init();
    _pre.setString("userName", u.userName);
    _pre.setString("avatar", u.getRemoteAvatar());
  }
  static Future<User> readUser() async {
    await _init();
    User u = new User(
        username: _pre.getString("userName"),
        avatar:_pre.getString("avatar"));
    return u;
  }
}
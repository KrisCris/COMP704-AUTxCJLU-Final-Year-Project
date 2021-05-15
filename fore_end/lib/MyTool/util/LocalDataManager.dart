import 'package:shared_preferences/shared_preferences.dart';

class LocalDataManager {
  static SharedPreferences pre;

  static void init() async {
    if (pre == null) {
      pre = await SharedPreferences.getInstance();
    }
  }

  static bool isInit() {
    return pre != null;
  }
}

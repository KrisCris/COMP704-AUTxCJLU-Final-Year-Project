import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoftwarePreference {
  static SoftwarePreference _instance;
  int _theme;

  ///zh -> 中文  cn -> English ... default -> 根据系统语言
  String _languageCode;

  int get theme => _theme;
  String get languageCode => _languageCode;
  set theme(int value) {
    _theme = value;
  }

  set languageCode(String value) {
    _languageCode = value;
  }

  SoftwarePreference._internal({int theme, String languageCode}) {
    this._theme = theme;
    this._languageCode = languageCode;
  }
  static SoftwarePreference getInstance() {
    if (_instance == null) {
      SharedPreferences pre = LocalDataManager.pre;
      if (pre == null) {
        print(
            "Local Data Manager has not been initialized yet! User info getting failed!");
        return null;
      }
      _instance = SoftwarePreference._internal(
          theme: pre.getInt("theme") ?? 0,
          languageCode: pre.getString("languageCode") ?? "default");
    }
    return _instance;
  }

  static bool isInit() {
    return _instance != null;
  }

  bool save() {
    SharedPreferences pre = LocalDataManager.pre;
    if (pre == null) {
      print(
          "Local Data Manager has not been initialized yet! User info getting failed!");
      return null;
    }
    pre.setInt("theme", _theme);
    pre.setString("languageCode", this._languageCode);
  }

  bool changeTheme(int themeCode) {
    if (themeCode == this._theme) return false;
    if (themeCode >= MyTheme.AVAILABLE_THEME.length) return false;

    SharedPreferences pre = LocalDataManager.pre;
    if (pre == null) return false;

    this._theme = themeCode;
    pre.setInt("theme", this._theme);
    return true;
  }

  bool changeLauguage(String languageCode) {
    if (languageCode == _languageCode) return false;
    SharedPreferences pre = LocalDataManager.pre;
    if (pre == null) return false;

    this._languageCode = languageCode;
    pre.setString("languageCode", this._languageCode);

    return true;
  }

  MyTheme getNowTheme() {
    return MyTheme.getTheme(themeCode: this._theme);
  }
}

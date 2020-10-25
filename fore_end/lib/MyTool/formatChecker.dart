import 'package:fore_end/Mycomponents/myTextField.dart';

class FormatChecker {
  Map<InputFieldType, Function(String)> mapper;
  factory FormatChecker() =>  _getInstance();
  static FormatChecker get instance => _getInstance();
  static FormatChecker _instance;
  FormatChecker._internal(){
      mapper = new Map<InputFieldType, Function(String)>();
      mapper.addAll({
        InputFieldType.email : (String s){
          String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
          if (s == null || s.isEmpty) return false;
          return (new RegExp(regexEmail)).hasMatch(s);},

        InputFieldType.text :(String s){return true;},

        InputFieldType.password : (String s){
          return s.length > 6;
        },
      });
  }

  static FormatChecker _getInstance(){
    if (_instance == null) {
      _instance = new FormatChecker._internal();
    }
    return _instance;
  }

  static bool check(InputFieldType tp, String text){
    return FormatChecker.instance.mapper[tp](text);
  }
}
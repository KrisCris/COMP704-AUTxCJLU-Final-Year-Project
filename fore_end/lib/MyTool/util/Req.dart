import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class Req {
  static Dio get instance => _getInstance();
  static Req _instance;
  static PersistCookieJar _cookieJar;
  static const String baseUrl = "http://connlost.online:23333/";
  static const int connectOut = 600000;
  static const int receiveOut = 600000;
  static const int maxRepeatTime = 3;
  static Map<String,int> repeatMap = {};
  static Dio dio;

  Req._internal() {
    dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectOut;
    dio.options.receiveTimeout = receiveOut;

  }
  static Dio _getInstance() {
    if (_instance == null) {
      _instance = new Req._internal();
    }
    return dio;
  }

  static initRepeat(String repeatKey){
    if(!Req.repeatMap.containsKey(repeatKey)){
      Req.repeatMap[repeatKey] = 0;
    }
  }
  static addRepeat(String repeatKey){
    if(!Req.repeatMap.containsKey(repeatKey))return;
    Req.repeatMap[repeatKey] += 1;
  }
  static resetRepeat(String repeatKey){
    if(!Req.repeatMap.containsKey(repeatKey))return;
    Req.repeatMap[repeatKey] =0;
  }
}

class Requests {
  static Future<Response> _errorSolve(DioError e,String repeatKey,{Map data,String info="",Function(Map) f}) async {
    String nline = "";
    for(int i=0;i<2;i++){
      nline +="\n";
    }
    print("**********************************************************");
    print(nline);

    int times = 0;
    if(Req.repeatMap.containsKey(repeatKey)){
      times = (Req.repeatMap[repeatKey] += 1);
      if(times >= Req.maxRepeatTime)return null;
    }

    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      print("连接超时 [ "+ info + "]");
      if(f != null){
        print("连接超时,第$times次重新请求 [ "+ info + "]");
        return f(data);
      }
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      print("请求超时 [ "+ info + "]");
      if(f != null){
        print("请求超时,第$times次重新请求 [ "+ info + "]");
        return f(data);
      }
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      print("响应超时 [ "+ info + "]");
      if(f != null){
        print("响应超时,第$times次重新请求 [ "+ info + "]");
        return f(data);
      }
    } else if (e.type == DioErrorType.RESPONSE) {
      print("接口请求出现异常 [ "+ info +" ]\n"+e.message);
    } else if (e.type == DioErrorType.CANCEL) {
      print("请求取消");
    } else {
      print("未知错误\n"+e.message);
    }
    print(nline);
    print("**********************************************************");
    return null;
  }
  static Future<Response> _postRequest(String interfaceKey,data,String url,String info,Function(Map) f)async{
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res;
    print(info+"is posting...");
    try{
      res = await dio.post(url, data: dt);
      Req.resetRepeat(interfaceKey);
      print(info+" done");
      return res;
    }on DioError catch(e){
      print(info+"solving error...");
      res =  await _errorSolve(e,interfaceKey,info: info,data:data,f:f);
      print(info+"error done");
      return res;
    }
  }
  ///POST
  ///param: food_b64 - String
  static Future<Response> foodDetect(data) async {
    return _postRequest("detect", data, "/food/detect", "food detect接口", foodDetect);
  }

  static Future<Response> sendRegisterEmail(data) async {
    return _postRequest("registerEmail", data, "/user/send_register_code", "send register email接口", sendRegisterEmail);
  }

  static Future<Response> checkVerifyCode(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/check_code", data: dt);
    return res;


  }

  static Future<Response> signUp(data) async {
    return _postRequest("signUp", data, "/user/signup", "signup接口", null);
    // Dio dio = Req.instance;
    // FormData dt = FormData.fromMap(data);
    // Response res = await dio.post("/user/signup", data: dt);
    // return res;
  }

  static Future<Response> login(data) async {
    return _postRequest("login", data, "/user/login", "login接口", login);
  }

  static Future<Response> getBasicInfo(data) async {
    return _postRequest("getBasicInfo", data, "/user/get_basic_info", "getBasicInfo接口", getBasicInfo);
  }
  static Future<Response> updateBody(data) async {
    return _postRequest("updateBody", data, "/plan/update_body_info", "updateBodyInfo接口", null);
  }
  static Future<Response> historyMeal(data) async {
    return _postRequest("historyMeal", data, "/food/get_daily_consumption", "historyMeal接口", null);
  }
  static Future<Response> previewPlan(Map data) async {
    Dio dio = Req.instance;
    String urlPara = _readUrlPara(data);
    Response res = await dio.get("/plan/query_plan" + urlPara);
    return res;
  }

  static Future<Response> setPlan(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/plan/set_plan", data: dt);
    return res;
  }

  static Future<Response> finishPlan(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/plan/finish_plan", data: dt);
    return res;
  }

  static Future<Response> getPlan(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/plan/get_current_plan", data: dt);
    return res;
  }

  static Future<Response> consumeFoods(data) async {
    return _postRequest("consumeFoods", data, "/food/consume_foods", "consume_foods接口", null);
  }

  static Future<Response> modifyBasicInfo(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/modify_basic_info", data: dt);
    return res;
  }
  static Future<Response> getWeightTrend(data) async {
    return _postRequest("get_weight_trend", data, "/plan/get_weight_trend", "get_weight_trend接口", null);
  }
  static Future<Response> modifyPassword(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/modify_password", data: dt);
    return res;
  }

  static Future<Response> sendSecurityCode(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/send_security_code", data: dt);
    return res;
  }

  static Future<Response> checkEmailRepeat(Map data) async {
    Dio dio = Req.instance;
    String urlPara = _readUrlPara(data);
    Response res = await dio.get("/user/is_new_email" + urlPara);
    return res;
  }

  static Future<Response> logout(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/logout", data: dt);
    return res;
  }

  static String _readUrlPara(Map data) {
    String urlPara = "?";
    data.forEach((key, value) {
      urlPara += key + "=" + value.toString() + "&";
    });
    return urlPara;
  }

  static Future<Response> getCaloriesIntake(data) async {
    return _postRequest("getCaloriesIntake", data, "/food/calories_intake", "getCaloriesIntake接口", null);
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/food/calories_intake", data: dt);
    return res;
  }

}

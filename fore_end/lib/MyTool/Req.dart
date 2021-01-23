
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
}

class Requests{
  ///POST
  ///param: food_b64 - String
  static Future<Response> foodDetect(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/food/detect",data: dt);
    return res;
  }

  static Future<Response> sendRegisterEmail(data) async {
      Dio dio = Req.instance;
      FormData dt = FormData.fromMap(data);
      Response res = await dio.post("/user/send_register_code",data: dt);
      return res;
  }
  static Future<Response> checkVerifyCode(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/check_code",data: dt);
    return res;
  }
  static Future<Response> signUp(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/signup",data: dt);
    return res;
  }

  static Future<Response> login(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/login",data: dt);
    return res;
  }

  static Future<Response> getBasicInfo(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/get_basic_info",data: dt);
    return res;
  }
  static Future<Response> previewPlan(Map data) async {
    Dio dio = Req.instance;
    String urlPara = _readUrlPara(data);
    Response res = await dio.get("/plan/query_plan"+urlPara);
    return res;
  }
  static Future<Response> setPlan(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/plan/set_plan",data: dt);
    return res;
  }

  static Future<Response> modifyBasicInfo(data) async{
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/modify_basic_info",data: dt);
    return res;
  }

  static Future<Response> modifyPassword(data) async{
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/modify_password",data: dt);
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
    Response res = await dio.get("/user/is_new_email"+urlPara);
    return res;
  }



  static Future<Response> logout(data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/logout",data:dt);
    return res;
  }

  static String _readUrlPara(Map data){
    String urlPara = "?";
    data.forEach((key, value) {
      urlPara+=key+"="+value+"&";
    });
    return urlPara;
  }
}

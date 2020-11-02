
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
  static void saveCookies(Map cookies) async {
    List<Cookie> ck = List<Cookie>();
    cookies.forEach((key, value){
      ck.add(new Cookie(key,value));
    });
    if(_cookieJar == null){
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath  = appDocDir.path;
      print('获取的文件系统目录 appDocPath： ' + appDocPath);
      _cookieJar = new PersistCookieJar(dir: appDocPath);
      Req.instance.interceptors.add(CookieManager(_cookieJar));
    }
    _cookieJar.saveFromResponse(Uri.parse(baseUrl), ck);
  }

  static Future<Map<String,String>> getCookies() async{
    if(_cookieJar == null){
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath  = appDocDir.path;
    print('获取的文件系统目录 appDocPath： ' + appDocPath);
    _cookieJar = new PersistCookieJar(dir: appDocPath);
    Req.instance.interceptors.add(CookieManager(_cookieJar));
    }
    List<Cookie> cookies = _cookieJar.loadForRequest(Uri.parse(baseUrl));
    Map<String,String> res = Map<String,String>();
    for(Cookie k in cookies){
      res.addAll({k.name:k.value});
    }
    return res;
  }

  static Dio _getInstance() {
    if (_instance == null) {
      _instance = new Req._internal();
    }
    return dio;
  }
}

class Requests{
  static void saveCookies(Map cookies){
    Req.saveCookies(cookies);
  }
  static Future<Map<String,String>> getCookies() async {
    return Req.getCookies();
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

  static Future<Response> checkEmailRepeat(Map data) async {
    Dio dio = Req.instance;
    String urlPara = "";
    data.forEach((key, value) {
      urlPara+=key+"="+value+"&";
    });
    Response res = await dio.get("/user/is_new_email?"+urlPara);
    return res;
  }
}
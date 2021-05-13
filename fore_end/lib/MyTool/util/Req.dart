
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Pages/WelcomePage.dart';

class Req {
  static Dio get instance => _getInstance();
  static Req _instance;
  static PersistCookieJar _cookieJar;
  static const String baseUrl = "http://connlost.online:2333/";
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
  static Future<Response> _errorSolve(DioError e,BuildContext context,String repeatKey,{Map data,String info="",Function(BuildContext, Map) f}) async {
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
        return f(context,data);
      }
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      print("请求超时 [ "+ info + "]");
      if(f != null){
        print("请求超时,第$times次重新请求 [ "+ info + "]");
        return f(context,data);
      }
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      print("响应超时 [ "+ info + "]");
      if(f != null){
        print("响应超时,第$times次重新请求 [ "+ info + "]");
        return f(context,data);
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
  static Future<Response> _postRequest(String interfaceKey,BuildContext context, data,String url,String info,Function(BuildContext,Map) f)async{
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res;
    print(info+"is posting...");
    try{
      res = await dio.post(url, data: dt);
      Req.resetRepeat(interfaceKey);
      print(info+" done");
      return _solveCommonCode(res,context);
    }on DioError catch(e){
      print(info+"solving error...");
      res =  await _errorSolve(e,context, interfaceKey,info: info,data:data,f:f);
      print(info+"error done");
      return res;
    }
  }
  static Future<Response> _solveCommonCode(Response res,BuildContext context)async{
    if(res == null){
      Fluttertoast.showToast(
        msg: "No Response got, Please Check Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.redAccent,
        fontSize: 13,
      );
    }else if(res.data['code'] == -1){
      Fluttertoast.showToast(
        msg: "Operation Requires Login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.redAccent,
        fontSize: 13,
      );
      User.getInstance().logOut();
      if(context != null){
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context){
              return Welcome();
            }), (route) => false
        );
      }

    }
    return res;
  }
  ///POST
  ///param: food_b64 - String
  static Future<Response> foodDetect(BuildContext context,data) async {
    return _postRequest("detect",context, data, "/food/detect", "food detect接口", foodDetect);
  }

  static Future<Response> sendRegisterEmail(BuildContext context, data) async {
    return _postRequest("registerEmail", context, data, "/user/send_register_code", "send register email接口", sendRegisterEmail);
  }

  static Future<Response> checkVerifyCode(BuildContext context, data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/check_code", data: dt);
    return res;


  }

  static Future<Response> signUp(BuildContext context, data) async {
    return _postRequest("signUp", context, data, "/user/signup", "signup接口", null);
    // Dio dio = Req.instance;
    // FormData dt = FormData.fromMap(data);
    // Response res = await dio.post("/user/signup", data: dt);
    // return res;
  }

  static Future<Response> login(BuildContext context, data) async {
    return _postRequest("login", context, data, "/user/login", "login接口", login);
  }

  static Future<Response> getBasicInfo(BuildContext context, data) async {
    return _postRequest("getBasicInfo", context, data, "/user/get_basic_info", "getBasicInfo接口", getBasicInfo);
  }
  static Future<Response> updateBody(BuildContext context, data) async {
    return _postRequest("updateBody", context, data, "/plan/update_body_info", "updateBodyInfo接口", null);
  }
  static Future<Response> dailyMeal(BuildContext context, data) async {
    return _postRequest("dailyMeal", context, data, "/food/get_daily_consumption", "get_daily_consumption接口", null);
  }
  static Future<Response> historyMeal(BuildContext context, data) async {
    return _postRequest("historyMeal", context, data, "/food/get_consume_history", "get_consume_history接口", null);
  }
  static Future<Response> recommandFood(BuildContext context, data) async {
    return _postRequest("recommandFood", context, data, "/food/recmd_food", "recmd_food接口", recommandFood);
  }
  static Future<Response> previewPlan(BuildContext context, Map data) async {
    Dio dio = Req.instance;
    String urlPara = _readUrlPara(data);
    Response res = await dio.get("/plan/query_plan" + urlPara);
    return res;
  }

  static Future<Response> setPlan(BuildContext context, data) async {
    return _postRequest("setPlan", context, data, "/plan/setPlan", "setPlan接口", null);
  }

  static Future<Response> finishPlan(BuildContext context, data) async {
    return _postRequest("finishPlan", context, data, "/plan/finishPlan", "finishPlan接口", null);
  }

  static Future<Response> getPlan(BuildContext context, data) async {
    return _postRequest("getPlan", context, data, "/plan/get_current_plan", "get_current_Plan接口", null);
  }

  static Future<Response> consumeFoods(BuildContext context, data) async {
    return _postRequest("consumeFoods", context, data, "/food/consume_foods", "consume_foods接口", null);
  }

  static Future<Response> modifyBasicInfo(BuildContext context, data) async {
    return _postRequest("modifyBasicInfo", context, data, "/user/modify_basic_info", "modify_basic_info接口", null);
  }
  static Future<Response> shouldUpdateWeight(BuildContext context, data) async {
    return _postRequest("shouldUpdateWeight", context, data, "/plan/should_update_weight", "should_update_weight接口", null);
  }
  static Future<Response> delayPlan(BuildContext context, data) async {
    return _postRequest("delayPlan", context, data, "/plan/extend_plan", "extend_plan接口", null);
  }
  static Future<Response> delayAndUpdatePlan(BuildContext context, data) async {
    return _postRequest("delayAndUpdatePlan", context, data, "/plan/extend_update_plan", "extend_update_plan接口", null);
  }
  static Future<Response> calculateDelayTime(BuildContext context, data) async {
    return _postRequest("calculateDelayTime", context, data, "/plan/estimate_extension", "estimate_extension接口", null);
  }
  static Future<Response> getWeightTrend(BuildContext context, data) async {
    return _postRequest("get_weight_trend", context, data, "/plan/get_weight_trend", "get_weight_trend接口", null);
  }
  static Future<Response>getHistoryPlan(BuildContext context, data) async {
    return _postRequest("getHistoryPlan", context, data, "/plan/get_past_plans","get_past_plans接口", null);
  }
  static Future<Response> setMealIntakeRatio(BuildContext context, data) async {
    return _postRequest("setMealIntakeRatio", context, data, "/user/set_meals_intake_ratio","set_meals_intake接口", null);
  }

  static Future<Response> modifyPassword(BuildContext context, data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/modify_password", data: dt);
    return res;
  }
  static Future<Response> sendSecurityCode(BuildContext context, data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/user/send_security_code", data: dt);
    return res;
  }

  static Future<Response> checkEmailRepeat(BuildContext context, Map data) async {
    Dio dio = Req.instance;
    String urlPara = _readUrlPara(data);
    Response res = await dio.get("/user/is_new_email" + urlPara);
    return res;
  }

  static Future<Response> logout(BuildContext context, data) async {
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

  static Future<Response> getCaloriesIntake(BuildContext context, data) async {
    return _postRequest("getCaloriesIntake", context, data, "/food/listed_calories_intake", "getCaloriesIntake接口", null);
  }

  static Future<Response> searchFood(BuildContext context, Map data) async {
    Dio dio = Req.instance;
    String name =  _readUrlPara(data);
    Response res = await dio.get("/food/search" + name);
    return res;
  }

  static Future<Response> getRecommandFood(BuildContext context, data) async {
    Dio dio = Req.instance;
    FormData dt = FormData.fromMap(data);
    Response res = await dio.post("/food/recmd_food_in_search", data: dt);
    return res;
  }

}

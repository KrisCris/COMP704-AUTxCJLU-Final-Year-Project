import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fore_end/Models/SoftwarePreference.dart';

class CustomLocalizations {
  final Locale locale;

  CustomLocalizations(this.locale);

  static const Map<String,Locale> supported = {
    "zh": const Locale('zh','CH'),
    "en": const Locale('en','US'),
  };

  static Map<String, Map<String, String>> _localizedValues = {

    //主题色的多语言翻译-------起始
    "dark blue":{
      "en":"Dark",
      "zh":"深蓝"
    },
    "light blue":{
      "en":"Light",
      "zh":"浅蓝"
    },
    //主题色的多语言翻译-------结束

    "default":{
      "en":"Default",
      "zh":"默认"
    },
    "languageName":{
      "en":"English",
      "zh":"简体中文"
    },
    "cancel":{
      "en":"Cancel",
      "zh":"取消",
    },
    "back":{
      "en":"Back",
      "zh":"返回"
    },
    "confirm":{
      "en":"Confirm",
      "zh":"确认"
    },
    "next":{
      "en":"Next",
      "zh":"下一步",
    },
    "male":{
      "en":"Male",
      "zh":"男性"
    },
    "female":{
      "en":"Female",
      "zh":"女性"
    },
    "age":{
      "en":"Age",
      "zh":"年龄"
    },
    "yearOld":{
      "en":"Years Old",
      "zh":"岁"
    },
    "veryLight":{
      "en":"Very Light",
      "zh":"非常少"
    },
    "veryLightInfo":{
      "en":"Sitting at the computer most of the day, or sitting at a desk. Almost no activity at all.",
      "zh":"一整天都坐在电脑或桌子前，几乎完全没有任何运动"
    },
    "light":{
      "en":"Light",
      "zh":"较少"
    },
    "lightInfo":{
      "en":"Light industrial work, sales or office work that comprises light activities. Walking, non-strenuous cycling or gardening approximately once a week.",
      "zh":"从事一些低运动量个人工作，例如销售或者办公室工作。每周可能会有一些例如散步，轻松骑行之类的轻量运动"
    },
    "moderate":{
      "en":"Moderate",
      "zh":"一般"
    },
    "moderateInfo":{
      "en":"Regular activity at least once a week. Cleaning, kitchen staff, or delivering mail on foot or by bicycle.",
      "zh":"每周都能保证有规律的运动。运动量相当于是做一次大扫除，徒步或骑行进行邮递工作"
    },
    "active":{
      "en":"Active",
      "zh":"较多"
    },
    "activeInfo":{
      "en":"Regular activities more than once a week, e.g., intense walking, bicycling or sports.",
      "zh":"能保证超过一周一次的规律性运动，运动量相当于是竞走，单车骑行或者其他运动量较大的运动"
    },
    "veryActive":{
      "en":"Very Active",
      "zh":"非常多"
    },
    "veryActiveInfo":{
      "en":"Strenuous activities several times a week",
      "zh":"每周都有多次运动量较大的活动"
    },
    "heavy":{
      "en":"Heavy",
      "zh":"难以复加"
    },
    "heavyInfo":{
      "en":"Heavy industrial work, construction work or farming.",
      "zh":"可能从事于繁重的体力工作，例如建筑行业或者农耕活动"
    },
    "setGoal":{
      "en":"Set Your Goal",
      "zh":"设置您的目标"
    },

    "littleMore":{
      "en":"A little More",
      "zh":"还剩一点了"
    },
    "genderQuestion":{
      "en":"Are You Male or Female?",
      "zh":"您的性别是?"
    },
    "bodyDataQuestion":{
      "en":"What is Your Stature And Weight?",
      "zh":"您的身高和体重数值是多少?"
    },
    "ageQuestion":{
      "en":"What is Your Age?",
      "zh":"您的年龄是?"
    },
    "exerciseQuestion":{
      "en":"How do Your Exercise?",
      "zh":"您的运动量如何?"
    },
    "slogan":{
      "en":"Take a Picture of your food!",
      "zh":"为你的食物拍张照吧!"
    },
    "logout":{
      "en":"Logout",
      "zh":"登出"
    },
    "loginState":{
      "en":"Checking login state",
      "zh":"正在检测登录状态..."
    },
    "foodRecognizer":{
      "en":"Initializing food recognizer",
      "zh":"正在初始化食物识别器...",
    },
    "preference":{
      "en":"Initializing preferences",
      "zh":"正在初始化偏好设置",
    },
    "syncLocalData":{
      "en":"Synchronizing local data",
      "zh":"正在更新本地数据..."
    },
    "welcome":{
      "en":"Welcome to here!",
      "zh":"欢迎使用DietLens"
    },
    "autoLogin":{
      "en":"Auto login...",
      "zh":"正在自动登录..."
    },
    "offlineLogin":{
      "en":"Offline login...",
      "zh":"正在以离线模式登录..."
    },
    "welcomeTitle":{
      "en":"Welcome",
      "zh":"欢迎使用"
    },
    "signUp":{
      "en":"Sign Up",
      "zh":"注册新账户"
    },
    "alreadyHave":{
      "en":"Already Have Account?",
      "zh":"已有账户，点击登录"
    },
    "createAccount":{
      "en":"Create Your\nAccount",
      "zh":"创建您的\n账户"
    },
    "acquireVerify":{
      "en":"Acquire Verify Code",
      "zh":"获取验证码"
    },
    "acquireAgain":{
      "en":"Re-Send",
      "zh":"再次获取"
    },
    "verifyCode":{
      "en":"Input verification code",
      "zh":"输入验证码"
    },
    "nickName":{
      "en":"Nick name",
      "zh":"昵称"
    },
    "nickNameHint":{
      "en":"Please input your nick name",
      "zh":"请输入您的昵称"
    },
    "password":{
      "en":"Password",
      "zh":"密码"
    },
    "passwordHint":{
      "en":"At lease 8 length, contain numbers and english characters",
      "zh":"密码至少需要8位长度，并且包含数字和英文字母"
    },
    "confirmPassword":{
      "en":"Confirm password",
      "zh":"确认密码"
    },
    "confirmPasswordHint":{
      "en":"Re-enter the password",
      "zh":"再次输入密码"
    },
    "differentPasswordHint":{
      "en":"Two passwords are different!",
      "zh":"两次密码不一致！"
    },
    "persent":{
      "en":"Persent",
      "zh":"百分比"
    },
    "email":{
      "en":"Email",
      "zh":"电子邮箱"
    },
    "emailHint":{
      "en":"Please input correct email",
      "zh":"请输入正确的邮箱地址"
    },
    "wrongEmail":{
      "en":"Wrong email address!",
      "zh":"错误的的邮箱地址"
    },
    "loginAccount":{
      "en":"Login Your\nAccount",
      "zh":"登录您的\n账户"
    },
    "resultPageTitle":{
      "en":"Your Foods Here",
      "zh":"您拍摄的食物"
    },
    "resultPageEmpty":{
      "en":"No Recognized Food Here",
      "zh":"暂未识别到任何食物"
    },
    "resultPageQuestion":{
      "en":"Add Foods To Meals?",
      "zh":"将食物添加到一日三餐"
    },
    "add":{
      "en":"Add",
      "zh":"添加"
    },
    "breakfast":{
      "en":"Breakfast",
      "zh":"早餐"
    },
    "lunch":{
      "en":"Lunch",
      "zh":"午餐"
    },
    "dinner":{
      "en":"Dinner",
      "zh":"晚餐"
    },
    "total":{
      "en":"Total",
      "zh":"合计"
    },
    "detail":{
      "en":"Detail",
      "zh":"详情"
    },
    "searchHistoryMeal":{
      "en":"Searching history meals...",
      "zh":"正在搜索历史三餐..."
    },
    "noFoodSearch":{
      'en':"No Food Intake",
      "zh":"没有进食记录"
    },
    "searchFood":{
      "en":"Search foods",
      "zh":"搜索食物"
    },
    "clickForDetail":{
      "en":"click Picture For Details",
      "zh":"点击图片查看详情"
    },
    "todayCalories":{
      "en":"Today's Calories",
      "zh":"今日摄入卡路里"
    },
    "todayMeal":{
      "en":"Today's Meal",
      "zh":"今日三餐"
    },
    "planShedWeightDayQuestion":{
      "en":"How Many Days Do You Want To Spend To Lose Your Weight?",
      "zh":"您希望花费几天的时间来达到您减肥的目标?"
    },
    "planShedWeightQuestion":{
      "en":"How Much Weight Do You Want To Lose (KG)?",
      "zh":"您希望减轻多少体重 (KG)?"
    },
    "planBuildMuscleDayQuestion":{
      "en":"How Many Days Do You Want To Spend To Build Your Muscle?",
      "zh":"您希望花费几天时间来达到您增肌的目标?"
    },
    "planDelayFor":{
      "en":"Your Plan will be delayed for ",
      "zh":"您的计划可能会延期"
    },
    "planDelayChoose":{
      "en":"Do you accept it or finish the plan?",
      "zh":"您选择接受延期或是终止计划?"
    },
    "planSuccessCreateNew":{
      "en":"Congratulations! Your Plan was completed!Create new plan in few seconds...",
      "zh":"恭喜您完成计划!将在数秒种之后创建新的计划..."
    },
    "planSuccessTwoChoise":{
      "en":"Congratulations! Your plan has completed! You can choose one of the following choise.",
      "zh":"恭喜您完成计划!您可以选择以下的其中一个选项来继续."
    },
    "planProgress":{
      "en":"Plan Progress",
      "zh":"计划进度"
    },
    "planType":{
      "en":"Plan Type",
      "zh":"计划类型"
    },
    "yourPlan":{
      "en":"Your Plan",
      "zh":"您的计划"
    },
    "hereYourPlan":{
      "en":"Here is Your Plan",
      "zh":"以下是为您创建的计划"
    },
    "choosePlan":{
      "en":"Choose Your Plan",
      "zh":"选择您的计划"
    },
    "createPlan":{
      "en":"Create Plan",
      "zh":"创建计划"
    },
    "changePlan":{
      "en":"Change Plan",
      "zh":"修改计划"
    },
    "planKeep":{
      "en":"Plan Continues For ",
      "zh":"计划已经进行了 "
    },
    "beforeChangePlan":{
      "en":"Before change your plan, please record your current weight",
      "zh":"在更改您的计划之前，请先记录您当前的体重"
    },
    "startPlan":{
      "en":"Plan Started",
      "zh":"计划开始"
    },
    "finishPlan":{
      "en":"Plan Finished",
      "zh":"计划完成"
    },
    "planDelayTimes":{
      "en":"Plan Delay Times",
      "zh":"计划延期次数"
    },
    "planExecution":{
      "en":"Plan Execution",
      "zh":"计划执行情况"
    },
    "continuePlanButton":{
      "en":"Continue Plan",
      "zh":"继续计划"
    },
    "finishPlanButton":{
      "en":"Finish Plan",
      "zh":"终止计划"
    },
    "changePlanButton":{
      "en":"Change Plan",
      "zh":"更改计划"
    },
    "acceptDelayButton":{
      "en":"Accept Delay",
      "zh":"延期计划"
    },
    "planDelayQuestion":{
      "en":"How many days do you want to do?",
      "zh":"您想要执行多久 (天)"
    },
    "collectBodyData":{
      "en":"We Need Collect Some Data",
      "zh":"我们需要收集一些您的身体数据"
    },
    "collectBodyDataInfo":{
      "en":"Please be relieved, these data will only be used as the figure calculation support of daily energy intake",
      "zh":"请您放心，我们收集的数据将仅用于计算适合您的每日营养摄入量"
    },
    "maintainFigureInfo":{
      "en":"After complete your goal, to maintian your weight, the recommended daily calories intake is around",
      "zh":"完成计划后，我们推荐您每天摄入的卡路里量不超过以下数值来保持您的体型"
    },
    "achieveCalInfo":{
      "en":"To achieve the goal, the recommended daily calories  intake is around",
      "zh":"为了完成您的计划，我们推荐您每天摄入的卡路里量不超过以下数值"
    },
    "achieveProteinInfo":{
      "en":"To achieve the goal, the recommended daily protein intake is around",
      "zh":"为了完成您的计划，我们推荐您每天摄入的蛋白质量大约保持在以下数值"
    },
    "achieveMaintainInfo":{
      "en":"To maintain your body shape, the recommended daily calories  intake is",
      "zh":"为了保持您当前的体型，我们推荐您每天摄入的卡路里量不超过以下数值"
    },
    "days":{
      "en":"days",
      "zh":"天"
    },
    "weight":{
      "en":"Weight",
      "zh":"体重"
    },
    "height":{
      "en":"Height",
      "zh":"身高"
    },
    "currentWeight":{
      "en":"Current Weight",
      "zh":"当前体重"
    },
    "goalWeight":{
      "en":"Goal Weight",
      "zh":"目标体重"
    },
    "bodyWeightInfo":{
      "en":"Body Weight Info",
      "zh":"体重变化情况"
    },
    "updateWeight":{
      "en":"Update Weight",
      "zh":"更新体重"
    },
    "updateBodyTitle":{
      "en":"Update Your Weight",
      "zh":"更新您的体重"
    },
    "remainWeight":{
      "en":"Remain Weight",
      "zh":"剩余体重"
    },
    "shedWeight":{
      "en":"Shed Weight",
      "zh":"减肥"
    },
    "shedWeightInfo":{
      "en":"Eating less food, reduce the amount of carbohydrate and fat in the food, keep exercises to burn the fat in the body",
      "zh":"这项计划要求您摄入更少的碳水化合物以及脂肪，并且您也要保证一定的运动量来消耗体内的脂肪"
    },
    "buildMuscle":{
      "en":"Build Muscle",
      "zh":"增肌"
    },
    "buildMuscleInfo":{
      "en":"Eating more food with more protein and less carbohydrate. Sufficient exercise is the guarantee of gaining muscle",
      "zh":"这项计划要求您食用更多包含蛋白质的食物，摄入更少的碳水化合物。 充足的运动量也是保证增肌成功的关键因素",
    },
    "maintain":{
      "en":"maintain",
      "zh":"保持身材"
    },
    "maintainInfo":{
      "en":"Eating as what general people eat, not eat less deliberately or eat too much",
      "zh":"和一般人一样正常进食，不刻意减少饭量，也不暴饮暴食"
    },
    "registerDuration":{
      "en":"Registered For ",
      "zh":"已经注册了 ",
    },
    "drawerAccount":{
      "en":"ACCOUNT",
      "zh":"账户设置"
    },
    "drawerSetting":{
      "en":"SETTINGS",
      "zh":"偏好设置"
    },
    "drawerAbout":{
      "en":"ABOUT US",
      "zh":"关于我们"
    },
    "theme":{
      "en":"Theme",
      "zh":"主题色"
    },
    "language":{
      "en":"Language",
      "zh":"语言"
    },
    "accountPageTitle":{
      "en":"ACCOUNT INFO",
      "zh":"账户信息页"
    },
    "basicInformation":{
      "en":"Basic information",
      "zh":"基本信息"
    },
    "changeSuccess":{
      "en":"Change success!",
      "zh":"修改成功！"
    },
    "accountInformation":{
      "en":"Account Information",
      "zh":"账号信息"
    },
    "profilePhoto":{
      "en":"Profile Photo",
      "zh":"头像"
    },
    "username":{
      "en":"Username",
      "zh":"用户名"
    },
    "gender":{
      "en":"Gender",
      "zh":"性别"
    },
    "save":{
      "en":"Save",
      "zh":"保存"
    },
    "changePasswordPageTitle":{
      "en":"Change Login PASSWORD",
      "zh":"修改登录密码页"
    },
    "newPassword":{
      "en":"New password",
      "zh":"新的密码"
    },
    "oldPassword":{
      "en":"old password",
      "zh":"旧的密码"
    },

    "caloriesChartTitle":{
      "en":"History Daily Calories",
      "zh":"历史卡路里"
    },
    "From":{
      "en":"From",
      "zh":"从"
    },
    "To":{
      "en":"To",
      "zh":"到"
    },
    "totalNutrition":{
      "en":"Nutrition Statistic ",
      "zh":"营养统计"
    },
    "caloriesTotal":{
      "en":"Total Calories",
      "zh":"卡路里总摄入"
    },
    "caloriesDaily":{
      "en":"Daily Calories",
      "zh":"卡路里日摄入"
    },
    "proteinTotal":{
      "en":"Total Protein",
      "zh":"蛋白质总摄入"
    },
    "proteinDaily":{
      "en":"Daily Protein",
      "zh":"蛋白质日摄入"
    },
    "weightStart":{
      "en":"Weight Started",
      "zh":"初始体重入"
    },
    "weightFinish":{
      "en":"Weight Finished",
      "zh":"完成体重"
    },
    "caloriesStandard":{
      "en":"Standard Days",
      "zh":"卡路里标准天数"
    },
    "caloriesOver":{
      "en":"Overload Days",
      "zh":"卡路里过量天数"
    },
    "caloriesInsufficient":{
      "en":"Insufficient Days",
      "zh":"卡路里不足天数"
    },
    "comment":{
      "en":"Plan Comment",
      "zh":"评价"
    },
    "commentFirst":{
      "en":"Plan worked well,no postponement record!",
      "zh":"减肥计划还不错，完成情况良好，未有延期记录!"
    },
    "no message":{
      "en":"No Messages",
      "zh":"无消息"
    },
    "offlineHint":{
      "en": "You are now in offline mode, most function is unavailable. Click to login.",
      'zh':"您正处于离线登录模式，部分功能无法使用。点击此处进行登录"
    },
    "weightUpdateHint":{
      "en":  "1 week had passed since your last body weight updating. It's time to update!",
      "zh":"距离您上次记录体重已经有一周的时间，点击此处进行记录操作"
    },
    "passDeadlineHint":{
      "en":    "Your Plan exceeded the deadline, click here for further operation",
      "zh": "您的计划已经到期，点击此处进行操作"
    },
    "foodDetailPageTitle":{
      "en":"Food's Detail Page",
      "zh":"食物营养信息页"
    },
    "calories":{
      "en":"Calories",
      "zh":"卡路里"
    },
    "carbohydrate":{
      "en":"Carbohydrate",
      "zh":"碳水化合物"
    },
    "cellulose":{
      "en":"Cellulose",
      "zh":"纤维素"
    },
    "cholesterol":{
      "en":"Cholesterol",
      "zh":"胆固醇"
    },
    "fat":{
      "en":"Fat",
      "zh":"脂肪"
    },
    "protein":{
      "en":"Protein",
      "zh":"蛋白质"
    },
    "recommendBoxTitle":{
      "en":"Food recommended list:",
      "zh":"更适合食物推荐列表："
    },
    "commentOfFoodOne":{
      "en":"Tips: ",
      "zh":"提醒: "
    },
    "commentOfFoodTwo":{
      "en":" may not suitable for your plan.",
      "zh":" 不适合您的饮食计划。"
    },
    "commentOfFoodThree":{
      "en":" seems suitable for your plan.",
      "zh":" 适合您的饮食计划。"
    },
    "commentOfAdviceOne":{
      "en":"\nRecommended foods are listed below:",
      "zh":"\n建议选择下面的替代食物："
    },
    "commentOfAdviceTwo":{
      "en":"\nSimilar foods are listed below:",
      "zh":"\n下面列出了相似的食物："
    },

    "recommendBoxHeader":{
      "en":"Food Nutrition Page",
      "zh":"食物营养信息页"
    },
    "planIsGoing":{
      "en":"Plan still going",
      "zh":"项目正在进行中"
    },



    "recommand meal":{
      "en":"recommand meal",
      "zh":"推荐餐食"
    },

    "recommand":{
      "en":"recommand",
      "zh":"推荐"
    }
};

  get createPlan => getContent("createPlan");

  static CustomLocalizations of(BuildContext context){
    return Localizations.of(context, CustomLocalizations);
  }
  static int getLanguageNum(){
    return CustomLocalizations.supported.length;
  }
  static List<Map<String,String>> getLanguages(BuildContext context){
    List<Map<String,String>> res = [{Localizations.of(context, CustomLocalizations).getContent("default"):"default"}];
    for(MapEntry entry in _localizedValues["languageName"].entries){
      Map<String,String> temp = {entry.value:entry.key};
      res.add(temp);
    }
    return res;
  }
  String _getLanguageCode(){
    String languageCode;
    if(SoftwarePreference.isInit()){
      languageCode = SoftwarePreference.getInstance().languageCode;
    }
    if(languageCode == null){
      languageCode = "default";
    }
    if(languageCode == "default"){
      languageCode = locale.languageCode;
    }
    return languageCode;
  }

  String nowLanguage(){
    return this._getLanguageCode();
  }
  String getContent(String key){
    if(!_localizedValues.containsKey(key)){
      return "no key named '"+key+"'";
    }
    String languageCode = this._getLanguageCode();
    if(!_localizedValues[key].containsKey(languageCode)){
      return key + " has not supported in "+ languageCode;
    }
    return _localizedValues[key][languageCode];
  }

  get shedWeight{
    return getContent("shedWeight");
  }
  get languageName{
    return getContent("languageName");
  }
  get slogan{
    return getContent("slogan");
  }
  get resultPageTitle{
    return getContent("resultPageTitle");
  }
  get resultPageEmpty{
    return getContent("resultPageEmpty");
  }
  get resultPageQuestion{
    return getContent("resultPageQuestion");
  }
  get breakfast{
    return getContent("breakfast");
  }
  get lunch{
    return getContent("lunch");
  }
  get dinner{
    return getContent("dinner");
  }
  get total{
    return getContent("total");
  }
  get detail{
    return getContent("detail");
  }
  get todayCal{
    return getContent("todayCalories");
  }
  get todayMeal{
    return getContent("todayMeal");
  }
  get searchFood{
    return getContent("searchFood");
  }
  get searchHistoryMeal{
    return getContent("searchHistoryMeal");
  }
  get noFoodSearch{
    return getContent("noFoodSearch");
  }
  get clickForDetail{
    return getContent("clickForDetail");
  }
  get planProcess{
    return getContent("planProgress");
  }
  get planType{
    return getContent("planType");
  }
  get yourPlan{
    return getContent("yourPlan");
  }
  get changePlan{
    return getContent("changePlan");
  }
  get planKeep{
    return getContent("planKeep");
  }
  get days{
    return getContent("days");
  }
  get currentWeight{
    return getContent("currentWeight");
  }
  get goalWeight{
    return getContent("goalWeight");
  }
  get remainWeight{
    return getContent("remainWeight");
  }
  get bodyWeightInfo{
    return getContent("bodyWeightInfo");
  }
  get updateWeight{
    return getContent("updateWeight");
  }
  get updateBodyTitle{
    return getContent("updateBodyTitle");
  }
  get height{
    return getContent("height");
  }
  get weight{
    return getContent("weight");
  }
  get cancel{
    return getContent("cancel");
  }
  get back{
    return getContent("back");
  }
  get confirm{
    return getContent("confirm");
  }
  get next{
    return getContent("next");
  }
  get registerDuration{
    return getContent("registerDuration");
  }
  get drawerAccount{
    return getContent("drawerAccount");
  }
  get drawerSetting{
    return getContent("drawerSetting");
  }
  get drawerAbout{
    return getContent("drawerAbout");
  }
  get theme{
    return getContent("theme");
  }
  get language{
    return getContent("language");
  }
  get welcomeTitle{
    return getContent("welcomeTitle");
  }
  get signUp{
    return getContent("signUp");
  }
  get alreadyHave{
    return getContent("alreadyHave");
  }
  get createAccount{
    return getContent("createAccount");
  }
  get email{
    return getContent("email");
  }
  get emailHint{
    return getContent("emailHint");
  }
  get password{
    return getContent("password");
  }
  get passwordHint{
    return getContent("passwordHint");
  }
  get confirmPassword{
    return getContent("confirmPassword");
  }
  get confirmPasswordHint{
    return getContent("confirmPasswordHint");
  }
  get nickName{
    return getContent("nickName");
  }
  get nickNameHint{
    return getContent("nickNameHint");
  }

  get acquireVerify{
    return getContent("acquireVerify");
  }
  get acquireAgain {
    return getContent("acquireAgain");
  }
  get verifyCode{
    return getContent("verifyCode");
  }
  get loginAccount{
    return getContent("loginAccount");
  }
  get logout{
    return getContent("logout");
  }
  get shedWeightInfo{
    return getContent("shedWeightInfo");
  }
  get buildMuscleInfo{
    return getContent("buildMuscleInfo");
  }
  get maintainInfo{
    return getContent("maintainInfo");
  }
  get choosePlan{
    return getContent("choosePlan");
  }
  get accountPageTitle{
    return getContent("accountPageTitle");
  }
  get basicInformation{
    return getContent("basicInformation");
  }
  get changeSuccess{
    return getContent("changeSuccess");
  }
  get accountInformation{
    return getContent("accountInformation");
  }
  get profilePhoto{
    return getContent("profilePhoto");
  }
  get username{
    return getContent("username");
  }
  get gender{
    return getContent("gender");
  }
  get save{
    return getContent("save");
  }
  get changePasswordPageTitle{
    return getContent("changePasswordPageTitle");
  }
  get differentPasswordHint{
    return getContent("differentPasswordHint");
  }
  get wrongEmail{
    return getContent("wrongEmail");
  }
  get newPassword{
    return getContent("newPassword");
  }
  get oldPassword{
    return getContent("oldPassword");
  }

  get caloriesChartTitle{
    return getContent("caloriesChartTitle");
  }

  get add=>getContent("add");
  get male => getContent("male");
  get female => getContent("female");
  get collectBodyData => getContent("collectBodyData");
  get collectBodyDataInfo => getContent("collectBodyDataInfo");
  get genderQuestion =>getContent("genderQuestion");
  get bodyDataQuestion => getContent("bodyDataQuestion");

  get ageQuestion => getContent("ageQuestion");
  get exerciseQuestion => getContent("exerciseQuestion");
  get age => getContent("age");
  get yearOld => getContent("yearOld");
  get littleMore => getContent("littleMore");

  get veryLight => getContent("veryLight");
  get light => getContent("light");
  get moderate => getContent("moderate");
  get active => getContent("active");
  get veryActive =>getContent("veryActive");
  get heavy => getContent("heavy");

  get veryLightInfo => getContent("veryLightInfo");
  get lightInfo => getContent("lightInfo");
  get moderateInfo => getContent("moderateInfo");
  get activeInfo => getContent("activeInfo");
  get veryActiveInfo =>getContent("veryActiveInfo");
  get heavyInfo => getContent("heavyInfo");

  get setGoal => getContent("setGoal");
  get planShedWeightDayQuestion => getContent("planShedWeightDayQuestion");
  get planBuildMuscleDayQuestion => getContent("planBuildMuscleDayQuestion");
  get planShedWeightQuestion => getContent("planShedWeightQuestion");
  get hereYourPlan => getContent("hereYourPlan");
  get  startPlan=> getContent("startPlan");
  get  finishPlan=> getContent("finishPlan");
  get  planExecution=> getContent("planExecution");
  get  planDelayTimes=> getContent("planDelayTimes");
  get planDelayFor => getContent("planDelayFor");
  get planDelayChoose => getContent("planDelayChoose");
  get planDelayQuestion => getContent("planDelayQuestion");
  get planSuccessCreateNew => getContent("planSuccessCreateNew");
  get planSuccessTwoChoise => getContent("planSuccessTwoChoise");
  get beforeChangePlan => getContent("beforeChangePlan");
  get continuePlanButton => getContent("continuePlan");
  get finishPlanButton => getContent("finishPlanButton");
  get changePlanButton => getContent("changePlanButton");
  get acceptDelayButton => getContent("acceptDelayButton");

  get maintainFigureInfo => getContent("maintainFigureInfo");
  get achieveCalInfo => getContent("achieveCalInfo");
  get activeProteinInfo => getContent("achieveProteinInfo");
  get achieveMaintainInfo => getContent("achieveMaintainInfo");

  get persent=>getContent("persent");
  get from => getContent("From");
  get  to => getContent("To");
  get  totalNutrition=> getContent("totalNutrition");
  get  caloriesTotal=> getContent("caloriesTotal");
  get caloriesDaily => getContent("caloriesDaily");
  get  proteinTotal=> getContent("proteinTotal");
  get  proteinDaily=> getContent("proteinDaily");
  get  weightStart=> getContent("weightStart");
  get  weightFinish=> getContent("weightFinish");
  get  caloriesStandard=> getContent("caloriesStandard");
  get  caloriesOver=> getContent("caloriesOver");
  get  caloriesInsufficient=> getContent("caloriesInsufficient");
  get  comment=> getContent("comment");
  get  commentFirst=> getContent("commentFirst");
  get  foodDetailPageTitle=> getContent("foodDetailPageTitle");
  get  calories=> getContent("calories");
  get  carbohydrate=> getContent("carbohydrate");
  get  cellulose=> getContent("cellulose");
  get  cholesterol=> getContent("cholesterol");
  get  fat=> getContent("fat");
  get  recommendBoxTitle => getContent("recommendBoxTitle");

  get  protein=> getContent("protein");
  get recommandMeal => getContent("recommand meal");
  get recommand => getContent("recommand");
  get commentOfFoodOne => getContent("commentOfFoodOne");
  get commentOfFoodTwo => getContent("commentOfFoodTwo");
  get commentOfFoodThree => getContent("commentOfFoodThree");
  get commentOfAdviceOne => getContent("commentOfAdviceOne");
  get commentOfAdviceTwo => getContent("commentOfAdviceTwo");

  get noMessage => getContent("no message");
  get offlineHint => getContent("offlineHint");
  get weightUpdateHint => getContent("weightUpdateHint");
  get passDeadlineHint => getContent("passDeadlineHint");
  get recommendBoxHeader => getContent("recommendBoxHeader");
  get planIsGoing => getContent("planIsGoing");

}

class CustomLocalizationsDelegate extends LocalizationsDelegate<CustomLocalizations>{

  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return CustomLocalizations.supported.containsKey(locale.languageCode);
  }

  @override
  Future<CustomLocalizations> load(Locale locale) {
    return new SynchronousFuture<CustomLocalizations>(new CustomLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<CustomLocalizations> old) {
    return false;
  }

  static CustomLocalizationsDelegate delegate = const CustomLocalizationsDelegate();
}
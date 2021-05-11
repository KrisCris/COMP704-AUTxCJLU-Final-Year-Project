import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/inputs/PaintedTextField.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/buildFloatingSearchBar.dart';
import 'package:fore_end/Mycomponents/widgets/food/CaloriesChart.dart';
import 'package:fore_end/Mycomponents/widgets/food/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanNotifier.dart';
import 'package:fore_end/Pages/detail/DetailMealPage.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../FoodDetailsPage.dart';
import '../FoodRecommandation.dart';

class DietPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return new DietPageState();
  }
}

class DietPageState extends State<DietPage> {
  int listIndex=0; //默认没有数据
  Map resultList=new Map();  //搜索返回的结果List，里面的每一个都是一个食物
  Map recmdList=new Map();
  bool isSuitable=false;



  List<Map> foodDetailInfoList=new List<Map>();
  List<Map> recmdFoodDetailInfoList=new List<Map>();

  List<String> foodNameList=new List<String>();  //
  List<int> foodCaloriesList=new List<int>();  //
  List<int> foodIdList=new List<int>();  //
  List<String> foodImagesList=new List<String>();  //

  void queryFoods(String foodName) async {
    Response res = await Requests.searchFood({
      "name":foodName,
    });
    if(res.data['code'] == 1){
      print("搜索食物成功！");
      resultList=res.data['data'];
      this.setValue();
    }else{
      print("搜索食物失败！");
    }
  }

  void getRecomFoods(String foodName,int foodId) async {
    User u= User.getInstance();
    Response res = await Requests.getRecommandFood({
      // "name":foodName,
      'uid':u.uid,
      'pid': u.plan.id,
      'fid': foodId,
      'token':u.token,
    });

    if(res.data['suitable'] == true){
      print("搜索similar food！");
      recmdList=res.data['recmdFoods'];
      this.isSuitable=true;
      this.setRecmdValue();
    }else{
      print("搜索alternative food！");
      recmdList=res.data['recmdFoods'];
      this.isSuitable=false;
      this.setRecmdValue();
    }


  }



  void setValue(){
    String foodNames;
    double foodCalorie;
    int foodId;
    // listIndex=resultList.length;
    resultList.forEach((key, value) {
      foodNames=key;
      Map info=value;

      foodCalorie=info["calories"];
      foodId=info["id"];
      print("返回结果赋值成功！");
      foodNameList.add(foodNames);
      foodCaloriesList.add(foodCalorie.toInt());
      foodDetailInfoList.add({key:value});
      foodIdList.add(foodId);
      foodImagesList.add(info["img"]);

    });


    print("返回结果赋值成功！");
    setState(() {});
  }

  void setRecmdValue(){
    recmdList.forEach((key, value) {
      recmdFoodDetailInfoList.add({key:value});
    });

    print("2返回结果赋值成功！");
    // setState(() {});
  }




  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      iconColor: MyTheme.convert(ThemeColorName.NormalIcon),
      queryStyle: TextStyle(color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 15),
      accentColor: MyTheme.convert(ThemeColorName.NormalText),
      border: BorderSide(color: MyTheme.convert(ThemeColorName.NormalText)),
      // backgroundColor: MyTheme.convert(ThemeColorName.PageBackground),
      backgroundColor: MyTheme.convert(ThemeColorName.ComponentBackground),
      hint: ' Search Foods...',
      hintStyle: TextStyle(color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 15),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 700),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 1000),
      clearQueryOnClose: true,
      onQueryChanged: (query) {
        print("onQueryChanged is clicked");
        ///因为用户比如搜索了一次ham  然后又打了bur变成hambur 这样原本上一次的结果未被清空
        this.foodNameList.clear();
        this.foodCaloriesList.clear();
        this.queryFoods(query);
        query="";
        ///TODO:可以展示一些历史记录
      },
      onSubmitted: (query) {
        this.foodNameList.clear();
        this.foodCaloriesList.clear();
        print("onSubmitted is clicked");
        this.queryFoods(query);

      },
      onFocusChanged: (bool isOpen){
        if(isOpen){
          //print("打开搜索框");
        }else {
          this.foodNameList.clear();
          this.foodCaloriesList.clear();
          setState(() {
          });
        }
      },

      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon:  Icon(
              Icons.search,
              color: MyTheme.convert(ThemeColorName.NormalIcon),
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
          color: MyTheme.convert(ThemeColorName.NormalIcon),
        ),
      ],
      builder: (context, transition) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            padding:EdgeInsets.only(top: 1) ,
            itemBuilder: (BuildContext context, int index) {
              String name="defaultName";
              int cal=666;
              int fid=0;

              if(foodNameList.isNotEmpty){
                name=foodNameList[index];
              }
              if(foodCaloriesList.isNotEmpty){
                cal=foodCaloriesList[index];
              }

              if(foodIdList.isNotEmpty){
                fid=foodIdList[index];
              }
              String imageBase64=foodImagesList[index];




              ///跳转到食物识别页的代码，先给一个静态页面
              // return GestureDetector(
              //   child: Card(
              //     color: MyTheme.convert(ThemeColorName.ComponentBackground),
              //     child: ListTile(
              //       leading: Icon(FontAwesomeIcons.hamburger,size: 56,color: MyTheme.convert(ThemeColorName.NormalText),),
              //       title: Text("TestFood",style: TextStyle(color:MyTheme.convert(ThemeColorName.NormalText) ),),
              //       subtitle: Text("100"+'  Kcal',style: TextStyle(color:MyTheme.convert(ThemeColorName.NormalText) )),
              //       trailing: Icon(Icons.more_vert,color: MyTheme.convert(ThemeColorName.NormalText)),
              //     ),
              //   ),
              //   onTap: ( ){
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => FoodDetails(foodName: 'TestFood')));
              //   },
              // );
              return GestureDetector(
                child: Card(
                  color: MyTheme.convert(ThemeColorName.ComponentBackground),
                  child: ListTile(
                    leading: Image.memory( base64.decode(imageBase64),height:45, width:45, fit: BoxFit.fill, gaplessPlayback:true, ),
                    ///Icon(FontAwesomeIcons.hamburger,size: 56,color: MyTheme.convert(ThemeColorName.NormalText),),
                    title: Text(name,style: TextStyle(color:MyTheme.convert(ThemeColorName.NormalText) ),),
                    subtitle: Text(cal.toString()+'  Kcal',style: TextStyle(color:MyTheme.convert(ThemeColorName.NormalText) )),
                    trailing: Icon(Icons.more_vert,color: MyTheme.convert(ThemeColorName.NormalText)),
                  ),
                ),
                onTap: ( ){
                  this.getRecomFoods(name,fid);


                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FoodDetails(foodName: name,foodInfoList: this.foodDetailInfoList,recomdFoodInfoList: this.recmdFoodDetailInfoList)));
                },
              );
            },
            itemCount: foodNameList.length,
          ),
        );
      },
    );
  }
  OpenContainer buildOpenContainer(){
    return OpenContainer(
      closedColor: Colors.transparent,
      closedBuilder: (context, action) {
        return PlanNotifier(
          width: 0.95,
          height: 100,
          effectColor: Colors.black12,
        );
      },
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 350),
      openBuilder: (context, action) {
        return FoodRecommandation(mealType:CustomLocalizations.of(context).lunch);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenTool.partOfScreenWidth(1),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenTool.partOfScreenHeight(0.11)),
                  SizedBox(height: ScreenTool.partOfScreenHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
                      TitleText(
                        text: CustomLocalizations.of(context).planProcess,
                        underLineLength: 0,
                        fontSize: 18,
                        maxWidth: 0.95,
                        maxHeight: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  buildOpenContainer(),
                  // Expanded(child:SizedBox()),
                  SizedBox(height: 10),
                  Container(
                    child: CaloriesBarChart(
                      width: 0.95,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
                      TitleText(
                        text: CustomLocalizations.of(context).todayMeal,
                        underLineLength: 0,
                        fontSize: 18,
                        maxWidth: 0.475,
                        maxHeight: 30,
                      ),
                      Expanded(child: SizedBox()),
                      CustomTextButton(
                        CustomLocalizations.of(context).detail,
                        autoReturnColor: true,
                        fontsize: 15,
                        tapUpFunc: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (ctx) {
                            return DetailMealPage(
                              mealTime: DateTime.now(),
                            );
                          }));
                        },
                      ),
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05))
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.95),
                    height: 220,
                    child: MealListUI(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            buildFloatingSearchBar(),
          ],
        ));
  }
}

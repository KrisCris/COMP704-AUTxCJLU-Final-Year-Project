import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Picker_Tool.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/NutritionBox.dart';
import 'package:fore_end/Mycomponents/widgets/basic/ExpandListView.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PersentBar.dart';
import 'package:fore_end/Mycomponents/widgets/food/FoodBox.dart';
import 'package:fore_end/Mycomponents/widgets/food/NutritionPieChart.dart';
import 'package:fore_end/Mycomponents/widgets/food/RecommendBox.dart';
import 'package:fore_end/Mycomponents/widgets/food/ValueAdjuster.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanListItem.dart';

class FoodDetails extends StatefulWidget {
  Food currentFood;
  bool isSuitable;
  GlobalKey<ValueAdjusterState> valueAdjusterKey;
  bool testExclamition;


  ///构建函数
  FoodDetails(
      { Key key,
        this.currentFood,
        this.testExclamition=true,
        this.isSuitable=false,
      }):super(key:key){

    this.isSuitable=isSuitable;
    this.valueAdjusterKey=new GlobalKey<ValueAdjusterState>();
    this.testExclamition=testExclamition;
  }

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  GlobalKey<PersentBarState> persentBar;
  List<Food> recommendFoods;
  int touchedIndex;


  @override
  void initState()  {
    this.recommendFoods = [];
    this.getRecomFoods(widget.currentFood.id);

  }

  double calculatePercent(String label){
    return widget.currentFood.calculatePercent(label);
  }


  void getRecomFoods(int foodId) async {
    User u= User.getInstance();
    Response res = await Requests.getRecommandFood({
      'uid':u.uid,
      'pid': u.plan.id,
      'fid': foodId,
      'token':u.token,
    });
    for(Map m in res.data['data']['recmdFoods']){
      Food f = Food.fromJson(m);
      this.recommendFoods.add(f);
    }
    if(res.data['data']['suitable'] == true) {
      widget.isSuitable = true;
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    List<String> mealsName = [
      CustomLocalizations.of(context).breakfast,
      CustomLocalizations.of(context).lunch,
      CustomLocalizations.of(context).dinner
    ];

    ValueAdjuster a = ValueAdjuster<double>(initValue:10.0,valueWeight: 10.0,key: this.widget.valueAdjusterKey);
    a.onValueChange = (){
      print("ValueAdjuster onValueChange");
      // this.totalProtein =  this.widget.valueAdjusterKey.currentState.getVal()*widget.protein/100;
    };

    return  Container(
        // padding: EdgeInsets.only(top: ScreenTool.partOfScreenHeight(0.05)),
        height: ScreenTool.partOfScreenHeight(1),
        width: ScreenTool.partOfScreenWidth(1),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          // borderRadius: BorderRadius.circular(5),
          color: MyTheme.convert(ThemeColorName.PageBackground),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:ScreenTool.partOfScreenHeight(0.05)),
              Container(
                height: ScreenTool.partOfScreenHeight(0.05),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    GestureDetector(
                      child: Icon(FontAwesomeIcons.arrowLeft,color:  MyTheme.convert(ThemeColorName.NormalIcon),size: 30,),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10,),

                    Text(CustomLocalizations.of(context).foodDetailPageTitle,style: TextStyle(color: MyTheme.convert(ThemeColorName.NormalText),fontSize: 25,fontFamily: 'Futura'),)
                  ],
                ),

              ),
              SizedBox(height:15),
              ///展示食物图片
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: MyTheme.convert(ThemeColorName.NormalText)),
                ),
                height: ScreenTool.partOfScreenHeight(0.2),
                width: ScreenTool.partOfScreenWidth(0.95),
                // child: Image.asset('image/fruit-main.jpg',fit: BoxFit.cover,),
                child: Image.memory(base64.decode(widget.currentFood.picture), height:50, width:50, fit: BoxFit.fitWidth, gaplessPlayback:true,),
              ),

              SizedBox(height:15),
              ///推荐食物可展开区域
              ///当拥有数据的时候再去生成
              RecommendBox(
                title:CustomLocalizations.of(context).recommendBoxTitle,
                foods: this.recommendFoods,
                isSuitable: this.widget.isSuitable,
                foodName: this.widget.currentFood.getName(context),),
              SizedBox(height:15),
              ///进度条
              PersentBar(key: persentBar,
                  width: 0.95,
                  height: 5,
                  sections: [
                    PersentSection(
                      normalColor:const Color(0xff09edfe),///碳水
                      persent: this.widget.currentFood.calculateThreeNutritionPercent("carbohydrate"),  ///这里的数字先暂时写死 来测试
                      name: "carbohydrate Persent",
                    ),
                    PersentSection(
                      normalColor: const Color(0xfff8b250),
                      persent: this.widget.currentFood.calculateThreeNutritionPercent("fat"),  ///这里的数字先暂时写死 来测试
                      name: "Fat Persent",
                    ),
                    PersentSection(
                      normalColor: const Color(0xffff5983),
                      persent: this.widget.currentFood.calculateThreeNutritionPercent("protein"),  ///这里的数字先暂时写死 来测试
                      name: "Protein Persent",
                    ),
                  ]),
              ///这个食物的营养信息详情
              Container(
                  padding: EdgeInsets.only(top: 10,),
                  decoration: BoxDecoration(
                    color:MyTheme.convert(ThemeColorName.ComponentBackground),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    // border: Border.all(color: MyTheme.convert(ThemeColorName.NormalText)),
                  ),
                  height: ScreenTool.partOfScreenHeight(0.6 ),
                  width: ScreenTool.partOfScreenWidth(0.95),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NutritionBox(
                            title: CustomLocalizations.of(context).carbohydrate,
                            value: widget.currentFood.carbohydrate,
                            color: const Color(0xff09edfe),///碳水
                          ),

                          NutritionBox(
                            title: CustomLocalizations.of(context).fat,
                            value: widget.currentFood.fat,
                            color: const Color(0xfff8b250),
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).protein,
                            value: widget.currentFood.protein,
                            color: const Color(0xffff5983),///蛋白质
                          ),
                        ],
                      ),

                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          NutritionBox(
                            title: CustomLocalizations.of(context).cellulose,
                            value:widget.currentFood.cellulose,
                            color: const Color(0xff13d38e),///纤维素
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).cholesterol,
                            value: widget.currentFood.cholesterol,
                            color: const Color(0xff845bef),  ///胆固醇
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).calories,
                            // value: 100.0,
                            value: widget.currentFood.calorie,
                            color: const Color(0xffa5ef00), ///卡路里
                            units: "ka",
                            // isUnSuitable: this.widget.testExclamition,
                          ),
                        ],
                      ),
                      // a,  ///这里是重量调整器
                      AspectRatio(  ///AspectRatio 是固定宽高比的组件
                        aspectRatio: 1/0.7,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                setState(() {
                                  final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                      pieTouchResponse.touchInput is! PointerUpEvent;
                                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                    touchedIndex = pieTouchResponse.touchedSectionIndex;
                                    // touchedIndex = pieTouchResponse.touchedSection.value.toInt();
                                    ///之前是会报错touchedSection.touchedSectionIndex
                                  } else {
                                    touchedIndex = -1;
                                  }
                                });
                              }),

                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 5,
                              centerSpaceRadius: 0,  ///改变饼图中间空白的大小
                              sections: showingSections()),
                        ),
                      ),

                    ],
                  )

              ),
              SizedBox(height:15),
              CustomButton(
                disabled: false,
                text: CustomLocalizations.of(context).resultPageQuestion,
                isBold: true,
                width: ScreenTool.partOfScreenWidth(0.95),
                tapFunc: () {

                  ///测试警示标志
                  // setState(() {
                  //   this.widget.testExclamition=!this.widget.testExclamition;
                  // });

                  ///点击展开添加食物计划
                  JhPickerTool.showStringPicker(context,
                      title: CustomLocalizations.of(context).total + '1200 Kcal',
                      normalIndex: 0,
                      isChangeColor: true,
                      data: mealsName, clickCallBack: (int index, var item) {
                        if(index == 0){
                          print("点击了早餐");
                          // FoodRecognizer.addFoodToMealName("breakfast");
                        }else if(index == 1){
                          print("点击了午餐");
                          // FoodRecognizer.addFoodToMealName("lunch");
                        }else if(index == 2){
                          print("点击了晚餐");
                          // FoodRecognizer.addFoodToMealName("dinner");
                        }
                      });
                },
              ),

              SizedBox(height:15),
              // a,


            ],
          ),
        ),
      );



  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 100 : 90;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff09edfe),///碳水
            value: this.widget.currentFood.carbohydrate,
            title: (calculatePercent('carbohydrate')*100).floor().toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),  ///脂肪
            value: this.widget.currentFood.fat,
            title: (calculatePercent('fat')*100).floor().toString().toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),  ///胆固醇
            value: this.widget.currentFood.cholesterol,
            title: (calculatePercent('cholesterol')*100).floor().toString().toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),///纤维素
            value: this.widget.currentFood.cellulose,
            title: (calculatePercent('cellulose')*100).floor().toString().toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 4:

          return PieChartSectionData(
            color: const Color(0xffff5983),///蛋白质
            value: this.widget.currentFood.protein,
            title: (calculatePercent('protein')*100).floor().toString().toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );

        default:
          return null;
      }
    });
  }



}

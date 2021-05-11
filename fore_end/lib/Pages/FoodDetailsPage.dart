import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Picker_Tool.dart';
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
  List<Map> foodInfoList=new List<Map>();
  Map<String,Map> foodsInfo=new Map<String,Map>();
  GlobalKey<ValueAdjusterState> valueAdjusterKey;
  String foodName;
  double calories;
  double carbohydrate;
  double cellulose;
  double cholesterol;
  double fat;
  double protein;
  Food basicFood;
  // double sumOfNutrition;


  bool testExclamition;


  ///构建函数
  FoodDetails(
      { Key key,
        this.foodInfoList,
        this.foodName="defaultFood",
        this.calories=100,
        this.fat=20,
        this.cholesterol=20,
        this.cellulose=20,
        this.carbohydrate=20,
        this.protein=20,
        // this.sumOfNutrition,
        this.testExclamition=true,

      }):super(key:key){
    this.foodInfoList=foodInfoList;
    this.foodName=foodName;
    this.calories=calories;
    this.protein=protein;
    this.carbohydrate=carbohydrate;
    this.cellulose=cellulose;
    this.cholesterol=cholesterol;
    this.fat=fat;
    this.valueAdjusterKey=new GlobalKey<ValueAdjusterState>();
    this.testExclamition=testExclamition;
  }

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  GlobalKey<PersentBarState> persentBar;
  int touchedIndex;


  int calculatePercent(double value){
    double sumOfNutrition=this.widget.calories+this.widget.cholesterol+this.widget.carbohydrate+this.widget.fat+this.widget.cellulose+this.widget.protein; ///把所有的营养元素加一起 然后当分母
    return value*100~/sumOfNutrition;  ///相除并且求出比例 用来生成饼图
  }

  void assignValue(){
    widget.foodInfoList.forEach((element) {
      element.forEach((key, value) {
          widget.foodName=key;
          widget.fat=value["fat"]??10;
          widget.cholesterol=value["cholesterol"]??10;
          widget.cellulose=value["cellulose"]??10;
          widget.carbohydrate=value["carbohydrate"]??10;
          widget.protein=value["protein"]??10;
          widget.calories=value["calories"]??10;
      });
    });
    print("success");
    setState(() {

    });
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
          borderRadius: BorderRadius.circular(10),
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
                height: ScreenTool.partOfScreenHeight(0.15),
                width: ScreenTool.partOfScreenWidth(0.95),
                child: Image.asset('image/fruit-main.jpg',fit: BoxFit.cover,),
              ),

              SizedBox(height:15),


              ///推荐食物可展开区域
              RecommendBox(title:CustomLocalizations.of(context).recommendBoxTitle ,),
              SizedBox(height:15),


              ///进度条
              PersentBar(key: persentBar,
                  width: 0.95,
                  height: 5,
                  sections: [
                    PersentSection(
                      normalColor: Colors.red,
                      persent: 1000/2000,  ///这里的数字先暂时写死 来测试
                      name: "Calorie Persent",
                    ),
                    PersentSection(
                      normalColor: Colors.yellow,
                      persent: 500/2000,  ///这里的数字先暂时写死 来测试
                      name: "Fat Persent",
                    ),
                    PersentSection(
                      normalColor: Colors.blue,
                      persent: 500/2000,  ///这里的数字先暂时写死 来测试
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
                  height: ScreenTool.partOfScreenHeight(0.57),
                  width: ScreenTool.partOfScreenWidth(0.95),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NutritionBox(
                            title: CustomLocalizations.of(context).calories,
                            // value: 100.0,
                            value: widget.calories,
                            color: const Color(0xffa5ef00), ///卡路里
                            // isUnSuitable: this.widget.testExclamition,
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).fat,
                            value: widget.fat,
                            color: const Color(0xfff8b250),
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).protein,
                            value: widget.protein,
                            color: const Color(0xffff5983),///蛋白质
                          ),
                        ],
                      ),

                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NutritionBox(
                            title: CustomLocalizations.of(context).carbohydrate,
                            value: widget.carbohydrate,
                            color: const Color(0xff09edfe),///碳水
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).cellulose,
                            value:widget.cellulose,
                            color: const Color(0xff13d38e),///纤维素
                          ),
                          NutritionBox(
                            title: CustomLocalizations.of(context).cholesterol,
                            value: widget.cholesterol,
                            color: const Color(0xff845bef),  ///胆固醇
                          ),
                        ],
                      ),
                      // a,  ///这里是重量调整器
                      AspectRatio(  ///AspectRatio 是固定宽高比的组件
                        aspectRatio: 1/0.8,
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

                      // PieChartSample2(),


                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     Text("选择食物重量(g):", style: TextStyle(color: MyTheme.convert(ThemeColorName.NormalText),fontSize: 18,fontFamily: 'Futura'),),
                      //     valueAdjuster,
                      //   ],
                      // )

                    ],
                  )
                // Column(
                //   // mainAxisAlignment: MainAxisAlignment.center,
                //   // crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     SizedBox(height: 5,),
                //     PlanTextItem(leftText: CustomLocalizations.of(context).calories, rightText: "Kcal/100g", rightValue: widget.calories.toInt(),),
                //     PlanTextItem(leftText: CustomLocalizations.of(context).protein, rightText: "g/100g", rightValue: widget.protein.toInt(),),
                //     PlanTextItem(leftText: CustomLocalizations.of(context).fat, rightText: "g/100g", rightValue: widget.fat.toInt(),),
                //     // PlanTextItem(leftText: CustomLocalizations.of(context).cellulose, rightText: "g/100g", rightValue: widget.cellulose.toInt(),),
                //     // PlanTextItem(leftText: CustomLocalizations.of(context).carbohydrate, rightText: "g/100g", rightValue: widget.carbohydrate.toInt(),),
                //     // PlanTextItem(leftText: CustomLocalizations.of(context).cholesterol, rightText: "g/100g", rightValue: widget.cholesterol.toInt(),),
                //     SizedBox(height: 25,),
                //
                //   ],
                // )
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
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 120 : 115;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xffa5ef00), ///卡路里
            value: this.widget.calories,
            title: calculatePercent(this.widget.calories).toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),

          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),  ///脂肪
            value: this.widget.fat,
            title: calculatePercent(this.widget.fat).toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),  ///胆固醇
            value: this.widget.cholesterol,
            title: calculatePercent(this.widget.cholesterol).toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),///纤维素
            value: this.widget.cellulose,
            title: calculatePercent(this.widget.cellulose).toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xff09edfe),///碳水
            value: this.widget.carbohydrate,
            title: calculatePercent(this.widget.carbohydrate).toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 5:
          return PieChartSectionData(
            color: const Color(0xffff5983),///蛋白质
            value: this.widget.protein,
            title: calculatePercent(this.widget.protein).toString()+'%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }


  @override
  void initState() {
    // this.assignValue();
  }
}

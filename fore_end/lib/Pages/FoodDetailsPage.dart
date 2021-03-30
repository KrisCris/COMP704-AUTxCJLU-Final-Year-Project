import 'package:flutter/cupertino.dart';
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


  bool testExclamition;


  ///构建函数
  FoodDetails(
      { Key key,
        this.foodInfoList,
        this.foodName="defaultFood",
        this.calories=100,
        this.fat=10,
        this.cholesterol=10,
        this.cellulose=10,
        this.carbohydrate=10,
        this.protein=10,
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

    ValueAdjuster a = ValueAdjuster<double>(valueWeight: 10.0,key: this.widget.valueAdjusterKey);
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
              RecommendBox(),
              SizedBox(height:15),


              ///进度条
              PersentBar(key: persentBar,
                  width: 0.95,
                  height: 5,
                  sections: [
                    PersentSection(
                      color: Colors.red,
                      persent: 1000/2000,  ///这里的数字先暂时写死 来测试
                      name: "Calorie Persent",
                    ),
                    PersentSection(
                      color: Colors.yellow,
                      persent: 500/2000,  ///这里的数字先暂时写死 来测试
                      name: "Fat Persent",
                    ),
                    PersentSection(
                      color: Colors.blue,
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
                  height: ScreenTool.partOfScreenHeight(0.3),
                  width: ScreenTool.partOfScreenWidth(0.95),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NutritionBox(
                            title: "卡路里",
                            value: 100.0,
                            color: Colors.red,
                            isUnSuitable: this.widget.testExclamition,
                          ),
                          NutritionBox(
                            title: "脂肪",
                            value: 50.0,
                            color: Colors.yellow,
                          ),
                          NutritionBox(
                            title: "蛋白质",
                            value: 50.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),

                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NutritionBox(
                            title: "碳水",
                            value: 50.0,
                            color: Colors.green,
                          ),
                          NutritionBox(
                            title: "纤维素",
                            value: 50.0,
                            color: Colors.deepOrange,
                          ),
                          NutritionBox(
                            title: "胆固醇",
                            value: 50.0,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      // a,
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
                text: "加入到一日三餐？",
                isBold: true,
                width: ScreenTool.partOfScreenWidth(0.95),
                tapFunc: () {

                  setState(() {
                    this.widget.testExclamition=!this.widget.testExclamition;
                  });

                  // JhPickerTool.showStringPicker(context,
                  //     title: CustomLocalizations.of(context).total + '1200 Kcal',
                  //     normalIndex: 0,
                  //     isChangeColor: true,
                  //     data: mealsName, clickCallBack: (int index, var item) {
                  //       if(index == 0){
                  //         print("点击了早餐");
                  //         // FoodRecognizer.addFoodToMealName("breakfast");
                  //       }else if(index == 1){
                  //         print("点击了午餐");
                  //         // FoodRecognizer.addFoodToMealName("lunch");
                  //       }else if(index == 2){
                  //         print("点击了晚餐");
                  //         // FoodRecognizer.addFoodToMealName("dinner");
                  //       }
                  //     });
                },
              ),

              SizedBox(height:15),




            ],
          ),
        ),
      );
  }

  @override
  void initState() {
    // this.assignValue();
  }
}

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
import 'package:fore_end/Mycomponents/widgets/basic/ExpandListView.dart';
import 'package:fore_end/Mycomponents/widgets/food/FoodBox.dart';
import 'package:fore_end/Mycomponents/widgets/food/RecommendBox.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanListItem.dart';

class FoodDetails extends StatefulWidget {
  List<Map> foodInfoList=new List<Map>();
  Map<String,Map> foodsInfo=new Map<String,Map>();
  String foodName;
  double calories;
  double carbohydrate;
  double cellulose;
  double cholesterol;
  double fat;
  double protein;
  Food basicFood;



  ///构建函数
  FoodDetails(
      { Key key,
        this.foodInfoList,
        this.foodName,
        this.calories,
        this.fat,
        this.cholesterol,
        this.cellulose,
        this.carbohydrate,
        this.protein,

      }):super(key:key){
    this.foodName="defaultFood";
    this.calories=100;
    this.protein=10;
    this.carbohydrate=10;
    this.cellulose=10;
    this.cholesterol=10;
    this.fat=10;

  }

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {



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
              // Container(
              //   // margin: EdgeInsets.only(left: 10,right: 10,),
              //   // padding: EdgeInsets.only(left: 20,right: 20,),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     // border: Border.all(color: MyTheme.convert(ThemeColorName.NormalText)),
              //   ),
              //   height: ScreenTool.partOfScreenHeight(0.2),
              //   width: ScreenTool.partOfScreenWidth(0.95),
              //
              //   child: Card(
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //     color: MyTheme.convert(ThemeColorName.ComponentBackground),
              //     child: Icon(FontAwesomeIcons.hamburger,size: 80,color: MyTheme.convert(ThemeColorName.NormalIcon),),
              //   ),
              //
              // ),
              SizedBox(height:15),


              ///推荐食物可展开区域
              RecommendBox(),
              SizedBox(height:15),


              ///这个食物的营养信息详情
              Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color:MyTheme.convert(ThemeColorName.ComponentBackground),
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color: MyTheme.convert(ThemeColorName.NormalText)),
                  ),
                  height: ScreenTool.partOfScreenHeight(0.3),
                  width: ScreenTool.partOfScreenWidth(0.95),
                  child:
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TitleText(
                            text: "卡路里",
                            underLineLength: 0.2,
                            dividerColor: Colors.red,
                            fontSize: 18,
                            maxWidth: 0.2,
                            maxHeight: 30,
                          ),
                          TitleText(
                            text: "脂肪",
                            underLineLength: 0.2,
                            dividerColor: Colors.yellow,
                            fontSize: 18,
                            maxWidth: 0.2,
                            maxHeight: 30,
                          ),
                          TitleText(
                            text: "蛋白质",
                            underLineLength: 0.2,
                            dividerColor: Colors.blue,
                            fontSize: 18,
                            maxWidth: 0.2,
                            maxHeight: 30,
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TitleText(
                            text: "碳水",
                            underLineLength: 0.2,
                            dividerColor: Colors.greenAccent,
                            fontSize: 18,
                            maxWidth: 0.2,
                            maxHeight: 30,
                          ),
                          TitleText(
                            text: "纤维素",
                            underLineLength: 0.2,
                            dividerColor: Colors.deepOrange,
                            fontSize: 18,
                            maxWidth: 0.2,
                            maxHeight: 30,
                          ),
                          TitleText(
                            text: "胆固醇",
                            underLineLength: 0.2,
                            dividerColor: Colors.purple,
                            fontSize: 18,
                            maxWidth: 0.2,
                            maxHeight: 30,
                          ),
                        ],
                      ),
                    ],
                  )
                // Column(
                //   // mainAxisAlignment: MainAxisAlignment.center,
                //   // crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //
                //
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

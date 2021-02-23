import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
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
    return Container(
      // padding: EdgeInsets.only(top: ScreenTool.partOfScreenHeight(0.05)),
      height: ScreenTool.partOfScreenHeight(1),
      width: ScreenTool.partOfScreenWidth(1),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(5),
        color: MyTheme.convert(ThemeColorName.ComponentBackground),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: ScreenTool.partOfScreenHeight(0.1),
            child: Text("Food's Detail Page",style: TextStyle(color: Colors.white,fontSize: 30),),

          ),
          Container(
              margin: EdgeInsets.only(left: 10,right: 10,),
              padding: EdgeInsets.only(left: 20,right: 20,),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              height: ScreenTool.partOfScreenHeight(0.7),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: MyTheme.convert(ThemeColorName.ComponentBackground),
                    child: Icon(FontAwesomeIcons.hamburger,size: 80,color: Colors.blue,),
                  ),
                  SizedBox(height: 40,),
                  TitleText(
                    text: widget.foodName,
                    underLineLength: 0.5,
                    fontSize: 18,
                    maxWidth: 0.8,
                    maxHeight: 30,
                  ),
                  SizedBox(height: 5,),
                  PlanTextItem(leftText: "卡路里", rightText: "千卡", rightValue: widget.calories.toInt(),),
                  PlanTextItem(leftText: "蛋白质", rightText: "克", rightValue: widget.protein.toInt(),),
                  PlanTextItem(leftText: "脂肪", rightText: "克", rightValue: widget.fat.toInt(),),
                  PlanTextItem(leftText: "纤维素", rightText: "克", rightValue: widget.cellulose.toInt(),),
                  PlanTextItem(leftText: "碳水化合物", rightText: "克", rightValue: widget.carbohydrate.toInt(),),
                  PlanTextItem(leftText: "胆固醇", rightText: "克", rightValue: widget.cholesterol.toInt(),),
                  SizedBox(height: 25,),
                  CustomButton(
                    disabled: false,
                    text: CustomLocalizations.of(context).back,
                    isBold: true,
                    width: ScreenTool.partOfScreenWidth(0.8),
                    tapFunc: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    this.assignValue();
  }
}

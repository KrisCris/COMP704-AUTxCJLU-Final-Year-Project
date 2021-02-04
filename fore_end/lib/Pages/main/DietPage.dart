import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/inputs/PaintedTextField.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/food/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanNotifier.dart';
import 'package:fore_end/Pages/detail/DetailMealPage.dart';

class DietPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
      return new DietPageState();
  }
  
}

class DietPageState extends State<DietPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaintedTextField(
                backgroundColor: Colors.white10,
                hint: "search foods",
                icon: FontAwesomeIcons.search,
                borderRadius: 5,
                paddingLeft: 10,
                width: 0.95,
              )
            ],
          ),
          SizedBox(height: ScreenTool.partOfScreenHeight(50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: "Plan Progress",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.95,
                maxHeight: 30,
              ),
            ],
          ),
          SizedBox(height: 5),
          PlanNotifier(width: 0.95, height: 100,backgroundColor: Color(0xFF1F405A),effectColor: Colors.black12,),
          Expanded(child:SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: "Today's Meal",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.475,
                maxHeight: 30,
              ),
              Expanded(child: SizedBox()),
              CustomTextButton(
                "detail",
                autoReturnColor: true,
                fontsize: 15,
                tapUpFunc: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (ctx) {
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
            child: MealListUI(
                backgroundColor:Color(0xFF1F405A),
                textColor:Color(0xFFD1D1D1),
                unitColor:Color(0xFFD1D1D1),
                iconColor:Color(0xFFD1D1D1)),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
  
}
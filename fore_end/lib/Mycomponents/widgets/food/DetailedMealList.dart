import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/food/SmallFoodBox.dart';

class DetailedMealList extends StatelessWidget{
  double width;
  double height;
  double dragAreaHeight;
  double paddingHorizontal;
  double paddingVertical;
  final Meal meal;
  DetailedMealList({this.meal,double width,double height,double dragAreaHeight=50, this.paddingHorizontal=10,this.paddingVertical=10})
  :assert(height==null?true:dragAreaHeight+paddingVertical < height){
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    this.dragAreaHeight = ScreenTool.partOfScreenHeight(dragAreaHeight);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: MyTheme.convert(ThemeColorName.ComponentBackground),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: this.paddingVertical),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: this.paddingHorizontal),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(this.meal.mealName,style: TextStyle(
                          fontSize: 16,
                          color: MyTheme.convert(ThemeColorName.HeaderText),
                          fontFamily: "Futura",
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold
                      )),
                      Expanded(child: SizedBox()),
                      Text("Total "+this.meal.calculateTotalCalories().toString()+" KCal",style: TextStyle(
                            fontSize: 16,
                            color: MyTheme.convert(ThemeColorName.HeaderText),
                            fontFamily: "Futura",
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold
                        )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: this.width-2*this.paddingHorizontal,
                    height: this.dragAreaHeight,
                    decoration: BoxDecoration(
                      color: MyTheme.convert(ThemeColorName.PageBackground),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListView.builder(
                      itemCount: this.meal.foods.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctx, int idx){
                        return SmallFoodBox(food: this.meal.foods[idx],pictureSize: this.dragAreaHeight-10,);
                      },
                    ),
                  )
                ],
              ))
              ,
              SizedBox(width: this.paddingHorizontal),
            ],
          ),
          SizedBox(height: this.paddingVertical),
        ],
      ),
    );
  }

}
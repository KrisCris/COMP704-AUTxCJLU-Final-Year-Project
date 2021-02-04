import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/food/DetailedMealList.dart';

class DetailMealPage extends StatefulWidget{
  DateTime mealTime;
  
  DetailMealPage({@required this.mealTime}):assert(mealTime != null);
  @override
  State<StatefulWidget> createState() {
    return DetailMealPageState();
  }
}

class DetailMealPageState extends State<DetailMealPage> {
  List<Meal> meal;

  @override
  void initState() {
    DateTime nowCurrent = DateTime.now();
    DateTime today = DateTime(nowCurrent.year,nowCurrent.month,nowCurrent.day);
    if(widget.mealTime.compareTo(today) == 0){
      User u = User.getInstance();
      this.meal = u.meals.value;
    }else{
      getHistoryMeal(widget.mealTime);
    }
    super.initState();
  }
  void getHistoryMeal(DateTime time) async {
    //TODO:后端接口获取历史三餐
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> col = [
      SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
      DateSelect(
        width: 0.5,
        beginTime: DateTime(2021,1,1),
        lastTime: DateTime.now(),
        onChangeDate: (int newDate){
          getHistoryMeal(DateTime.fromMillisecondsSinceEpoch(newDate));
        },
      ),
    ];
    if(this.meal == null || this.meal.length == 0){
      col.add(
        Expanded(
            child: Center(
              child: TitleText(
                alignment: Alignment.center,
                text: "Searching history meals...",
                maxWidth: 0.9,
                maxHeight: 50,
                underLineLength: 0,
                fontSize: 16,
              ),
            )

        )
      );
    }else{
      int totalCal = 0;
      for(Meal m in this.meal){
        totalCal += m.calculateTotalCalories();
      }
      col.addAll(List<Widget>.generate(this.meal.length, (index){
        return DetailedMealList(meal: this.meal[index],width: 0.9);
      }));
      col.addAll([
        Expanded(child: SizedBox()),
        TitleText(text: "Total Calories: "+totalCal.toString()+" Kcal",maxWidth: 0.9,),
        SizedBox(height: 20)
      ]);
    }
    return Container(
      color: MyTheme.convert(ThemeColorName.PageBackground),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: col
      ),
    );
  }
}
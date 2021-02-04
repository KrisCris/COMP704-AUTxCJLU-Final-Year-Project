import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';

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

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.convert(ThemeColorName.PageBackground),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
          DateSelect(
            width: 0.5,
            beginTime: DateTime(2021,1,1),
            lastTime: DateTime.now(),
            onChangeDate: (int newDate){
              getHistoryMeal(DateTime.fromMillisecondsSinceEpoch(newDate));
            },
          )
        ],
      ),
    );
  }
}
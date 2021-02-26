import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
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
    this.judgeDate();
    super.initState();
  }
  void judgeDate({DateTime time}){
    time = time ?? widget.mealTime;
    DateTime nowCurrent = DateTime.now();
    DateTime today = DateTime(nowCurrent.year,nowCurrent.month,nowCurrent.day);
    DateTime settingDay = DateTime(time.year,time.month,time.day);
    if(settingDay.compareTo(today) == 0){
      User u = User.getInstance();
      this.meal = u.meals.value;
      if(mounted){
        setState(() {});
      }
    }else{
      getHistoryMeal(time);
    }
  }
  void getHistoryMeal(DateTime time) async {
    User u = User.getInstance();
    this.meal = null;
    setState(() {});
    Response res = await Requests.dailyMeal({
      "uid":u.uid,
      "token":u.token,
      "begin":time.millisecondsSinceEpoch/1000,
      "end":time.millisecondsSinceEpoch/1000+ 3600*24 - 1
    });
    if(res == null){
      this.meal = null;
    }else{
      if(res.data['code'] == 1){
        this.meal = [
          Meal(mealName: "breakfast"),
          Meal(mealName: "lunch"),
          Meal(mealName: "dinner")
        ];
        for(Map m in res.data['data']['b']){
          this.meal[0].foods = [];
          this.meal[0].time = m['time']*1000;
          this.meal[0].addFood(new Food(
              name: m['name'],
              id: m['fid'],
              calorie: m['calories'],
              picture: m['img'],
              protein: m['protein'],
              weight: (m['weight'] as double).floor()
          ));
        }
        for(Map m in res.data['data']['l']){
          this.meal[1].foods = [];
          this.meal[1].time = m['time']*1000;
          this.meal[1].addFood(new Food(
              name: m['name'],
              id: m['fid'],
              calorie: m['calories'],
              picture: m['img'],
              protein: m['protein'],
              weight: (m['weight'] as double).floor()
          ));
        }
        for(Map m in res.data['data']['d']){
          this.meal[2].foods = [];
          this.meal[2].time = m['time']*1000;
          this.meal[2].addFood(new Food(
              name: m['name'],
              id: m['fid'],
              calorie: m['calories'],
              picture: m['img'],
              protein: m['protein'],
              weight: (m['weight'] as double).floor()
          ));
        }
      }else{
        this.meal = [];
      }
    }
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> col = [
      SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),

      Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [DateSelect(
              width: 0.5,
              height: 40,
              beginTime: DateTime(2021,1,1),
              lastTime: DateTime.now(),
              onChangeDate: (int newDate){
                this.judgeDate(time:DateTime.fromMillisecondsSinceEpoch(newDate));
              },
            ),],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),
              CustomIconButton(
                icon: FontAwesomeIcons.times,
                iconSize: 20,
                buttonSize: 40,
                backgroundOpacity: 0,
                onClick: (){
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: ScreenTool.partOfScreenWidth(0.025))
            ],
          )
        ],
      ),
      SizedBox(height:20)
    ];
    if(this.meal == null){
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
      col.add(
        Expanded(child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(this.meal.length, (index){
            return DetailedMealList(meal: this.meal[index],width: 0.95,height: 120,dragAreaHeight: 60,);
          }),
        ))
      );
      col.addAll([
        SizedBox(height: 20),
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
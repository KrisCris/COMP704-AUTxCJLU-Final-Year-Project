import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';



///statefulWidget组件可以随时更新变化的数据
class MealListUI extends StatefulWidget {
  Key key;
  MealListUI({GlobalKey<MealListUIState> key}):super(key:key){
    this.key = key;
  }
  @override
  MealListUIState createState() => MealListUIState();
}

class MealListUIState extends State<MealListUI> {

  @override
  void didUpdateWidget(covariant MealListUI oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    u.setMealKey(widget.key);
    return
      Container(
          height: 200,
          width: double.infinity,
          // decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 5),),
      child:
        ListView.builder(
          itemCount: u.meals.value.length,///一个listview里面item的个数，这里一日三餐有三个
          itemExtent: 150, ///itemExtent是设置每个item的在滚动方向上面的宽度，水平就是宽度，垂直就是高度
          scrollDirection: Axis.horizontal, ///滚动的方向为水平滚动
          itemBuilder: (BuildContext context, int index) {
            return MealView(
              mealsListData: u.meals.value[index], ///按list里的个数来构建，上面已经初始化了
            );
          }
          ),
    );
  }
}

class MealView extends StatelessWidget {
  final Meal mealsListData;

  const MealView({Key key, this.mealsListData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Padding(
              padding:
                  const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 0),  ///用来对其每个item与包裹着他们的大的ListView的内边距
              child:
              Container(
                  height: 190,  ///这是ListView里面每一个item的容器高度，宽度设置在上面listView.build的itemExtent是设置每个item的宽度
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    // border: Border.all(),
                    color: Color(0xFFF1F1F1),
                  ),
                  padding: const EdgeInsets.only(left: 20,top: 20,right: 20),  ///padding是控制内边距，对child有作用，这里是对里面的column起作用
                  // child: Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 20, left: 16, right: 16, bottom: 8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(mealsListData.getIcon(),size: 30,color: Colors.blue,),
                          SizedBox(height: 10,),

                          Text(  ///标题
                            mealsListData.mealName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Futura",
                              fontSize: 18,
                              letterSpacing: 0.2,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(  ///食物列表，一般只显示三个
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    mealsListData.listFoodsName(),
                                    overflow: TextOverflow.ellipsis,  ///设置文字溢出的处理方式，未验证有没有用
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Futura",
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 0, bottom: 5),
                                  child: Text(
                                    mealsListData.calculateTotalCalories().toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      fontFamily: "Futura",
                                      fontSize: 24,
                                      letterSpacing: 0.1,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, bottom: 7),
                                  child: Text(
                                    'kcal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      fontFamily: "Futura",
                                      fontSize: 15,
                                      letterSpacing: 0.2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ]
                    ),
                  )
              )
          // )
        ],
      );
  }
}

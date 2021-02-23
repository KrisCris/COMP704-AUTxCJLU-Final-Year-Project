import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/inputs/PaintedTextField.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/buildFloatingSearchBar.dart';
import 'package:fore_end/Mycomponents/widgets/food/CaloriesChart.dart';
import 'package:fore_end/Mycomponents/widgets/food/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanNotifier.dart';
import 'package:fore_end/Pages/detail/DetailMealPage.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class DietPage extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    return new DietPageState();
  }
}

class DietPageState extends State<DietPage> {
  int listIndex=0; //默认没有数据
  Map resultList=new Map();  //搜索返回的结果List，里面的每一个都是一个食物

  List<String> foodNameList=new List<String>();  //
  List<int> foodCaloriesList=new List<int>();  //


  void queryFoods(String foodName) async {
    Response res = await Requests.searchFood({
      "name":foodName,
    });
    if(res.data['code'] == 1){
      print("搜索食物成功！");
      resultList=res.data['data'];
      this.setValue();
    }else{
      print("搜索食物失败！");
    }
  }
  void setValue(){
    String foodNames;
    double foodCalorie;
    // listIndex=resultList.length;
    resultList.forEach((key, value) {
      foodNames=key;
      Map info=value;
      foodCalorie=info["calories"];
      print("返回结果赋值成功！");
      foodNameList.add(foodNames);
      foodCaloriesList.add(foodCalorie.toInt());

    });


    print("返回结果赋值成功！");
    setState(() {});
  }



  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      iconColor: Colors.white,
      queryStyle: TextStyle(color: Colors.white, fontSize: 15),
      accentColor: Colors.white,
      border: BorderSide(color: Colors.white),
      // backgroundColor: MyTheme.convert(ThemeColorName.PageBackground),
      backgroundColor: Color(0xFF172632),
      hint: ' Search Foods...',
      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 700),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 1000),
      clearQueryOnClose: true,
      onQueryChanged: (query) {
        print("onQueryChanged is clicked");
        ///因为用户比如搜索了一次ham  然后又打了bur变成hambur 这样原本上一次的结果未被清空
        this.foodNameList.clear();
        this.foodCaloriesList.clear();
        this.queryFoods(query);
        query="";
        ///TODO:可以展示一些历史记录
      },
      onSubmitted: (query) {
        this.foodNameList.clear();
        this.foodCaloriesList.clear();
        print("onSubmitted is clicked");
        this.queryFoods(query);

      },
      onFocusChanged: (bool isOpen){
        if(isOpen){
          //print("打开搜索框");
        }else {
          this.foodNameList.clear();
          this.foodCaloriesList.clear();
          setState(() {
          });
        }
      },

      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
          color: Colors.white,
        ),
      ],
      builder: (context, transition) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            padding:EdgeInsets.only(top: 1) ,
            itemBuilder: (BuildContext context, int index) {
              String name="defaultName";
              int cal=666;
              if(foodNameList.isNotEmpty){
                name=foodNameList[index];
              }
              if(foodCaloriesList.isNotEmpty){
                cal=foodCaloriesList[index];
              }

              return Card(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.hamburger,size: 56,color: Colors.blue,),
                  title: Text(name),
                  subtitle: Text(cal.toString()+'  Kcal'),
                  trailing: Icon(Icons.more_vert),
                ),
              );
            },
            itemCount: foodNameList.length,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenTool.partOfScreenWidth(1),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenTool.partOfScreenHeight(0.11)),
                  SizedBox(height: ScreenTool.partOfScreenHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
                      TitleText(
                        text: CustomLocalizations.of(context).planProcess,
                        underLineLength: 0,
                        fontSize: 18,
                        maxWidth: 0.95,
                        maxHeight: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  PlanNotifier(
                    width: 0.95,
                    height: 100,
                    effectColor: Colors.black12,
                  ),
                  // Expanded(child:SizedBox()),
                  SizedBox(height: 10),
                  Container(
                    child: CaloriesBarChart(
                      width: 0.95,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
                      TitleText(
                        text: CustomLocalizations.of(context).todayMeal,
                        underLineLength: 0,
                        fontSize: 18,
                        maxWidth: 0.475,
                        maxHeight: 30,
                      ),
                      Expanded(child: SizedBox()),
                      CustomTextButton(
                        CustomLocalizations.of(context).detail,
                        autoReturnColor: true,
                        fontsize: 15,
                        tapUpFunc: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (ctx) {
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
                    child: MealListUI(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            buildFloatingSearchBar(),
          ],
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
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

class DietPage extends StatefulWidget{

  int listIndex=1;

  @override
  State<StatefulWidget> createState() {
      return new DietPageState();
  }
  
}

class DietPageState extends State<DietPage>{


  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      iconColor: Colors.white,
      queryStyle: TextStyle(color: Colors.white,fontSize: 15),
      accentColor: Colors.white,
      border: BorderSide(color: Colors.white),
      // backgroundColor: MyTheme.convert(ThemeColorName.PageBackground),
      backgroundColor: Color(0xFF172632),
      hint: ' Search Foods...',
      hintStyle: TextStyle(color: Colors.white,fontSize: 15),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 700),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 700),

      ///目前可以通过这两个方法去改变要显示的内容，通过改变外部的list和数量
      ///现在差：1.服务器获取的接口   2.查询时的加载动画   3.放到主界面  4.每个item应该展示什么信息和设计  5.点击每个item进入的详细信息页的设计  。。。  6.检查当输入框为空的时候展示历史搜索，或者推荐列表
      ///6.根据数据多少来改变展开后的页面大小
      onQueryChanged: (query) {
        print("onQueryChanged is clicked");
        widget.listIndex=2;
        setState(() {

        });
      },
      onSubmitted: (query){
        print("onSubmitted is clicked");
        widget.listIndex=3;
        setState(() {

        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search,color: Colors.white,),
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
              return Card(
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.hamburger,size: 56,color: Colors.blue,),
                  title: Text('Hamburger $index'),
                  subtitle: Text('378.00 Kcal'),
                  trailing: Icon(Icons.more_vert),
                ),
              );
            },
            itemCount: widget.listIndex,
          ),

        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: ScreenTool.partOfScreenWidth(1),
        child: Stack(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: ScreenTool.partOfScreenHeight(0.11)),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     PaintedTextField(
                //       hint: CustomLocalizations.of(context).searchFood,
                //       icon: FontAwesomeIcons.search,
                //       borderRadius: 5,
                //       paddingLeft: 10,
                //       width: 0.95,
                //     )
                //   ],
                // ),

                // Container(
                //   height: 90,
                //   child: buildFloatingSearchBar(),
                // ),
                // CustomFloatingSearchBar(),
                // Opacity(
                //   opacity: 1,
                //   child:
                //   Container(
                //     height: 400,
                //
                //     child: CustomFloatingSearchBar(),
                //   ),
                // ),

                SizedBox(height: ScreenTool.partOfScreenHeight(50)),
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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleText(
                      text: CustomLocalizations.of(context).planProcess,
                      underLineLength: 0,
                      fontSize: 18,
                      maxWidth: 0.95,
                      maxHeight: 30,
                    ),
                  ],
                ),
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
                  child: MealListUI(),
                ),
                SizedBox(height: 20),
              ],
            ),
            Container(
              height: ScreenTool.partOfScreenHeight(1),
              color: Colors.transparent,
              child: buildFloatingSearchBar(),
            ),
          ],
        )
      ),
    );
  }
  
}
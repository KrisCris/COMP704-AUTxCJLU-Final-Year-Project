import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';




class CustomFloatingSearchBar extends StatefulWidget {



  @override
  _CustomFloatingSearchBarState createState() => _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
  int listIndex=0; //默认没有数据
  Map resultList=new Map();  //搜索返回的结果List，里面的每一个都是一个食物

  List<String> foodNameList=new List<String>();  //
  List<int> foodCaloriesList=new List<int>();  //
  @override
  void initState() {
    // this.historySearchMap={"hambur":1234,"chocolate":4321};
  }
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
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      onSubmitted: (query){
        this.queryFoods(query);
        // this.setValue();
        print("onSubmitted......");

      },

      onQueryChanged: (query)  {
        print("onQueryChanged......");
        ///检查用户输入的时候 可以展示一些历史记录
      },

      builder: (context, transition) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child:
          ListView.builder(
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
      onFocusChanged: (bool open){
        if(open){
          print("open is true----------");
        }else {
          print("open is false----------");
        }
        print("open is ----------");
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: buildFloatingSearchBar(),
    );
  }

}

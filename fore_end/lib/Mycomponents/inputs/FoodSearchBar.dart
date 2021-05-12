import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/Pages/FoodDetailsPage.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class FoodSearchBar extends StatefulWidget{
  FloatingSearchBar bar;

  @override
  State<StatefulWidget> createState() {
    return new FoodSearchBarState();
  }
}

class FoodSearchBarState extends State<FoodSearchBar>{
  List<Food> foods;
  @override
  void initState() {
    this.foods = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      iconColor: MyTheme.convert(ThemeColorName.NormalIcon),
      queryStyle: TextStyle(color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 15),
      accentColor: MyTheme.convert(ThemeColorName.NormalText),
      border: BorderSide(color: MyTheme.convert(ThemeColorName.NormalText)),
      // backgroundColor: MyTheme.convert(ThemeColorName.PageBackground),
      backgroundColor: MyTheme.convert(ThemeColorName.ComponentBackground),
      hint: ' Search Foods...',
      hintStyle: TextStyle(color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 15),
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
        this.foods.clear();
        this.queryFoods(query);
        query="";
        ///TODO:可以展示一些历史记录
      },
      onSubmitted: (query) {
        this.foods.clear();
        print("onSubmitted is clicked");
        this.queryFoods(query);

      },
      onFocusChanged: (bool isOpen){
        if(isOpen){
          //print("打开搜索框");
        }else {
          this.foods.clear();
          setState(() {
          });
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon:  Icon(
              Icons.search,
              color: MyTheme.convert(ThemeColorName.NormalIcon),
            ),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
          color: MyTheme.convert(ThemeColorName.NormalIcon),
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
              Food f = this.foods[index];
              return GestureDetector(
                child: Card(
                  color: MyTheme.convert(ThemeColorName.ComponentBackground),
                  child: ListTile(
                    leading: Image.memory( base64.decode(f.picture),height:45, width:45, fit: BoxFit.fill, gaplessPlayback:true, ),
                    ///Icon(FontAwesomeIcons.hamburger,size: 56,color: MyTheme.convert(ThemeColorName.NormalText),),
                    title: Text(f.getName(context),style: TextStyle(color:MyTheme.convert(ThemeColorName.NormalText) ),),
                    subtitle: Text(f.calorie.toString()+'  Kcal',style: TextStyle(color:MyTheme.convert(ThemeColorName.NormalText) )),
                    trailing: Icon(Icons.more_vert,color: MyTheme.convert(ThemeColorName.NormalText)),
                  ),
                ),
                onTap:  ( )  {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FoodDetails(currentFood: f,))); ///recomdFoodInfoList: this.recmdFoodDetailInfoList
                },
              );
            },
            itemCount:this.foods.length,
          ),
        );
      },
    );
  }

  void queryFoods(String foodName) async {
    Response res = await Requests.searchFood({
      "name":foodName,
    });
    if(res.data['code'] == 1){
      print("搜索食物成功！");
      for(Map f in (res.data['data'] as Map).values){
        this.foods.add(Food.fromJson(f));
      }
      setState((){});
    }else{
      print("搜索食物失败！");
    }
  }

}
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Models/Food.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/Req.dart';
import 'package:fore_end/Components/widgets/basic/CustomBadge.dart';
import 'package:fore_end/Pages/FoodDetailsPage.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class FoodSearchBar extends StatefulWidget {
  FloatingSearchBar bar;

  FoodSearchBar({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new FoodSearchBarState();
  }
}

class FoodSearchBarState extends State<FoodSearchBar> {
  List<Food> foods;
  GlobalKey<CustomBadgeState> badgeKey;

  @override
  void initState() {
    this.foods = [];
    this.badgeKey = GlobalKey<CustomBadgeState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        this.getSearchBar(),
        Transform.translate(
          offset: Offset(40, 25),
          child: CustomBadge(key: this.badgeKey),
        ),
      ],
    );
  }

  Widget getSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      iconColor: MyTheme.convert(ThemeColorName.NormalIcon),
      queryStyle: TextStyle(
          color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 15),
      accentColor: MyTheme.convert(ThemeColorName.NormalText),
      border: BorderSide(color: MyTheme.convert(ThemeColorName.NormalText)),
      // backgroundColor: MyTheme.convert(ThemeColorName.PageBackground),
      backgroundColor: MyTheme.convert(ThemeColorName.ComponentBackground),
      hint: CustomLocalizations.of(context).searchFood,
      hintStyle: TextStyle(
          color: MyTheme.convert(ThemeColorName.NormalText), fontSize: 15),
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

        ///?????????????????????????????????ham  ???????????????bur??????hambur ??????????????????????????????????????????
        this.foods.clear();
        this.queryFoods(query);
        query = "";

        ///TODO:??????????????????????????????
      },
      onSubmitted: (query) {
        this.foods.clear();
        print("onSubmitted is clicked");
        this.queryFoods(query);
      },
      onFocusChanged: (bool isOpen) {
        if (isOpen) {
          //print("???????????????");
        } else {
          this.foods.clear();
          setState(() {});
        }
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
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
            padding: EdgeInsets.only(top: 1),
            itemBuilder: (BuildContext context, int index) {
              Food f = this.foods[index];
              return GestureDetector(
                child: Card(
                  color: MyTheme.convert(ThemeColorName.ComponentBackground),
                  child: ListTile(
                    ///ClipOval????????????    ClipRRect???????????????
                    leading:
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   child: Image.memory( base64.decode(f.picture),height:45, width:45, fit: BoxFit.fill, gaplessPlayback:true, ),
                        // ),
                        ClipOval(
                      child: Image.memory(
                        base64.decode(f.picture),
                        height: 45,
                        width: 45,
                        fit: BoxFit.fill,
                        gaplessPlayback: true,
                      ),
                    ),

                    ///Icon(FontAwesomeIcons.hamburger,size: 56,color: MyTheme.convert(ThemeColorName.NormalText),),
                    title: Text(
                      f.getName(context),
                      style: TextStyle(
                          color: MyTheme.convert(ThemeColorName.NormalText)),
                    ),
                    subtitle: Text(f.calorie.toString() + '  Kcal',
                        style: TextStyle(
                            color: MyTheme.convert(ThemeColorName.NormalText))),
                    trailing: Icon(Icons.more_vert,
                        color: MyTheme.convert(ThemeColorName.NormalText)),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodDetails(
                                currentFood: f,
                              )));

                  ///recomdFoodInfoList: this.recmdFoodDetailInfoList
                },
              );
            },
            itemCount: this.foods.length,
          ),
        );
      },
    );
  }

  void queryFoods(String foodName) async {
    Response res = await Requests.searchFood(context, {
      "name": foodName,
    });
    if (res.data['code'] == 1) {
      print("?????????????????????");
      for (Map f in (res.data['data'] as Map).values) {
        this.foods.add(Food.fromJson(f));
      }
      setState(() {});
    } else {
      print("?????????????????????");
    }
  }
}

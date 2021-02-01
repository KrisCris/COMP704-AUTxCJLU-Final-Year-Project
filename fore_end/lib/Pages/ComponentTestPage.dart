import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/widgets/MealList.dart';
import 'dart:math' as math;

import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ComponentTestPage extends StatefulWidget {
  State state;
  int animateDuration = 800;

  @override
  State<StatefulWidget> createState() {
    this.state = ComponentTestState();
    return this.state;
  }
}

class ComponentTestState extends State<ComponentTestPage>
    with TickerProviderStateMixin {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: Container(
              width: ScreenTool.partOfScreenWidth(1),
              height: ScreenTool.partOfScreenHeight(1),
              color: Color(0xFF172632),
            ),
          ),

          buildFloatingSearchBar(),
          SizedBox(height: 111,),
          Container(
            margin: EdgeInsets.only(top: 200,left: 15,right: 15,bottom: 200),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Text("Test SearchBar"),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      backgroundColor: Colors.blue,
      hint: 'Search...',
      hintStyle: TextStyle(color: Colors.white,fontSize: 16),
      accentColor: Colors.white,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      automaticallyImplyDrawerHamburger: true,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 30, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }


// @override
  // Widget build(BuildContext context) {
  //  return  ListView(
  //    scrollDirection: Axis.vertical,
  //    children: <Widget>[
  //      SizedBox(height: 50,),
  //
  //    ],
  //
  //  );
  //
  // }
}

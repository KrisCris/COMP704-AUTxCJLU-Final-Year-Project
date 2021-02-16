import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class CustomFloatingSearchBar extends StatefulWidget {
  @override
  _CustomFloatingSearchBarState createState() => _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
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
          // buildMap(),
          // buildBottomNavigationBar(),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      queryStyle: TextStyle(color: Colors.white,fontSize: 15),
      accentColor: Colors.white,
      border: BorderSide(color: Colors.white),
      backgroundColor: MyTheme.convert(ThemeColorName.PageBackground),
      hint: ' Search Foods...',
      hintStyle: TextStyle(color: Colors.white,fontSize: 15),
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
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
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 20.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.hamburger,size: 56,color: Colors.blue,),
                    title: Text('Hamburger'),
                    subtitle: Text('Here is a second line'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                // SizedBox(height: 20,),
                Card(
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.hamburger,size: 56,color: Colors.blue,),
                    title: Text('Hamburger'),
                    subtitle: Text('Here is a second line'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.appleAlt,size: 56,color: Colors.blue,),
                    title: Text('Apple'),
                    subtitle: Text('Here is a second line'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: FlutterLogo(size: 56.0),
                    title: Text('Hamburger'),
                    subtitle: Text('Here is a second line'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
              ],
              // children: Colors.accents.map((color) {
              //   return Container(height: 50, color: color);
              // }).toList(),
            ),
          ),
        );
      },
    );
  }

}
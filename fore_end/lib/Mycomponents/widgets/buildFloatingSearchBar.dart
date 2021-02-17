import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';



///这三个List是假的静态数据
const searchList = [
  'apple-苹果',

];

const recentSuggest = [
  'apple-1',
  'apple-2',
];

const suggestionsList= [
  'apple-1',
  'apple-2',
];


class CustomFloatingSearchBar extends StatefulWidget {

  int listIndex=1;

  @override
  _CustomFloatingSearchBarState createState() => _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: buildFloatingSearchBar(),
      // Stack(
      //
      //   fit: StackFit.expand,
      //
      //   children: [
      //     // ClipRect(
      //     //   child: Container(
      //     //     width: ScreenTool.partOfScreenWidth(1),
      //     //     height: ScreenTool.partOfScreenHeight(1),
      //     //     // color: Color(0xFF172632),
      //     //     color: Colors.transparent,
      //     //   ),
      //     // ),
      //     // buildMap(),
      //     // buildBottomNavigationBar(),
      //     // Container(
      //     //   height: 250,
      //     //   color: Colors.transparent,
      //     //   child: buildFloatingSearchBar(),
      //     // ),
      //     buildFloatingSearchBar(),
      //   ],
      // ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
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
          height: 300,
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

}

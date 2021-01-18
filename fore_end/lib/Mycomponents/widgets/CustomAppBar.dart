import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/inputs/ExpandInputField.dart';
import 'package:fore_end/Mycomponents/widgets/ExpandListView.dart';

///自定义的AppBar，显示一些基本信息
class CustomAppBar extends StatefulWidget {

  ///用户头像的组件
  Widget userAvatarContainer;

  ///用户名
  String username;

  ///历史遗留问题，不推荐使用这种方式保存State的引用
  CustomAppBarState state;

  CustomAppBar({Key key, this.userAvatarContainer, this.username})
      : super(key: key) {}

  ///历史遗留问题，不推荐使用这种方式保存State的引用
  @override
  State<StatefulWidget> createState() {
    this.state = CustomAppBarState();
    return this.state;
  }

  ///历史遗留问题，不推荐使用这种方式调用State的函数
  ///开始播放透明度动画，使组件变得透明
  void startTransparency() {
    this.state.startTransparency();
  }

  ///历史遗留问题，不推荐使用这种方式调用State的函数
  ///反向播放透明度动画，使组件变得不透明
  void reverseTransparency() {
    this.state.reverseTransparency();
  }
}

///CustomAppBar的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///
class CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {

  ///控制透明度的动画
  TweenAnimation<double> headerTransparency;

  @override
  void initState() {
    this.headerTransparency = new TweenAnimation<double>();
    this.headerTransparency.initAnimation(1.0, 0.0, 300, this, () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExpandListView historySearch = new ExpandListView(
      width: 0.85,
      height: 200,
      open: false,
    );
    Widget container = Container(
      width: ScreenTool.partOfScreenWidth(0.85),
      height: 70,
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12, //阴影范围
              spreadRadius: 4, //阴影浓度
              color: Color(0x33000000), //阴影颜色
            ),
          ]),
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              if (this.headerTransparency.getValue() == 0) return;
              this.openDrawer(context);
            },
            child: widget.userAvatarContainer,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.username,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                fontFamily: "Futura",
                color: Colors.black),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: ExpandInputField(
              width: 0.4,
              disabled: this.headerTransparency.getValue() == 0,
              isFirstFocusDoFunction: true,
              onEmpty: () {
                historySearch.open();
              },
              onNotEmpty: () {
                historySearch.close();
              },
            ),
          ),
          SizedBox(width: 5)
        ],
      ),
    );
    container = Offstage(
      offstage:this.headerTransparency.getValue() == 0,
      child:container,
    );
    return AnimatedBuilder(
        animation: this.headerTransparency.ctl,
        builder: (BuildContext context, Widget child) {
          return Opacity(
              opacity: this.headerTransparency.getValue(),
              child: Column(
                children: [
                  container,
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      historySearch,
                    ],
                  )
                ],
              ));
        });
  }

  void startTransparency() {
    this.headerTransparency.beginAnimation();
  }

  void reverseTransparency() {
    this.headerTransparency.reverse();
  }

  ///打开侧边栏，前提是context中需要有侧边栏
  void openDrawer(BuildContext ctx) {
    Scaffold.of(ctx).openDrawer();
  }
}

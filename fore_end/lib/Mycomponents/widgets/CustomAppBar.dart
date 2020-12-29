import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/mySearchBarDelegate.dart';

class CustomAppBar extends StatefulWidget{
  Widget userAvatarContainer;
  String username;
  CustomAppBarState state;
  CustomAppBar({Key key, this.userAvatarContainer, this.username}):super(key:key){}
  @override
  State<StatefulWidget> createState() {
    this.state = CustomAppBarState();
    return this.state;
  }
  void startTransparency(){
    this.state.startTransparency();
  }
  void reverseTransparency(){
    this.state.reverseTransparency();
  }
}

class CustomAppBarState extends State<CustomAppBar> with TickerProviderStateMixin{
  TweenAnimation<double> headerTransparency;
  @override
  void initState() {
    this.headerTransparency = new TweenAnimation<double>();
    this.headerTransparency.initAnimation(1.0, 0.0, 300, this,
            () {setState(() {}); });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Container container = Container(
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
              if(this.headerTransparency.getValue() == 0)return;
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
          SizedBox(
            width: 70,

          ),
          InkWell(
              onTap: (){
                showSearch(context: context, delegate: MySearchBarDelegate());
              },
              child: Container(
                width: 30,
                height: 30,
                child: Icon(
                  FontAwesomeIcons.search,size: 25,

                ),

              )
          )

        ],
      ),
    );
    return AnimatedBuilder(
        animation: this.headerTransparency.ctl,
        child: container,
        builder: (BuildContext context, Widget child){
          return Opacity(
              opacity:this.headerTransparency.getValue(),
              child:child
          );
        });
  }
  void startTransparency(){
    this.headerTransparency.beginAnimation();
  }
  void reverseTransparency(){
    this.headerTransparency.reverse();
  }
  void openDrawer(BuildContext ctx) {
    Scaffold.of(ctx).openDrawer();
  }
}
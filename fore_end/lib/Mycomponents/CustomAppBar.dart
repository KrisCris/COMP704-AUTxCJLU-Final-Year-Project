import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';

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
  TweenAnimation headerTransparency;
  @override
  void initState() {
    this.headerTransparency = new TweenAnimation();
    this.headerTransparency.initAnimation(1.0, 0.0, 300, this,
            () {setState(() {}); });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity:this.headerTransparency.getValue(),
        child:Container(
          width: ScreenTool.partOfScreenWidth(0.85),
          height: 70,
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFF0091EA),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12, //阴影范围
                  spreadRadius: 3, //阴影浓度
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
            ],
          ),
        )
    );
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
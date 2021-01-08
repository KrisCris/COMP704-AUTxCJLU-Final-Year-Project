import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';

class ExpandListView extends StatefulWidget{
  double width;
  double height;
  List<Widget> children;
  Color backgroundColor;
  ExpandListView({this.width,this.height,this.children,this.backgroundColor = Colors.white});

  @override
  State<StatefulWidget> createState() {
    return new ExpandListViewState();
  }

}
class ExpandListViewState extends State<ExpandListView>
with TickerProviderStateMixin{
  TweenAnimation<double> clipAnimation;

  @override
  void initState() {
    super.initState();
    this.clipAnimation = new TweenAnimation();
    this.clipAnimation.initAnimation(0.0, widget.height, 2000, this, (){setState((){});});
    this.clipAnimation.beginAnimation();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: ListView(
        children: [
          ListTile(title: new Text("1"),),
          ListTile(title: new Text("2"),),
          ListTile(title: new Text("3"),),
          ListTile(title: new Text("4"),),
          ListTile(title: new Text("5"),),
          ListTile(title: new Text("6"),),
        ],
      )
    );
  }

}
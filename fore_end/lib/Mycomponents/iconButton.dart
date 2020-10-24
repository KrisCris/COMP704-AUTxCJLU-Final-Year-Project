import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/interface/Themeable.dart';

class MyIconButton extends StatefulWidget{
  MyTheme theme;
  IconData icon;
  double iconSize;
  double fontSize;
  double buttonRadius;
  String text;
  MyIconButtonState state;

  MyIconButton({@required this.theme, @required this.icon, this.text="",
    this.iconSize = 20, this.fontSize=14,this.buttonRadius=55,
    type=ComponentThemeState.normal,react = ComponentReactState.unfocused}):super(){
    this.state = new MyIconButtonState(type,react);
  }
  @override
  State<StatefulWidget> createState() {
    return this.state;
  }
}

class MyIconButtonState extends State<MyIconButton> with Themeable, TickerProviderStateMixin{
  ColorTweenAnimation backgroundColorAnimation = new ColorTweenAnimation();

  MyIconButtonState(ComponentThemeState the, ComponentReactState rea):super(){
    this.themeState = the;
    this.reactState = rea;
  }

  @override
  Widget build(BuildContext context) {
    return this.buttonUI;
  }
  @override
  initState(){
    super.initState();
    this.backgroundColorAnimation.initAnimation(this.getBackgroundColor(),
        this.getBackgroundColor(), 150, this, () { setState(() {});});
  }

  Widget get IconText{
    return Column(
      mainAxisAlignment:  MainAxisAlignment.center,
      children: <Widget>[
          Icon(widget.icon,color: widget.theme.getThemeColor(this.themeState),
            size: widget.iconSize),
        Text(
          widget.text,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: "Futura",
              color: widget.theme.darkTextColor),
        )
      ],
    );
  }
  Widget get buttonUI{
    return Container(
      width: widget.buttonRadius,
      height: widget.buttonRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: this.backgroundColorAnimation.getValue()
      ),
      child: this.IconText,
    );
  }

  Color getBackgroundColor(){
    return widget.theme.getReactColor(this.reactState);
  }
  Color getColor(){
    if(this.reactState == ComponentReactState.focused){
      return widget.theme.getThemeColor(this.themeState);
    }
    return Colors.black;
  }

  @override
  void setReactState(ComponentReactState rea) {

  }

  @override
  void setThemeState(ComponentThemeState the) {
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/CustomIconButton.dart';
import 'package:fore_end/interface/Themeable.dart';

class CustomNavigator extends StatefulWidget {
  double width;
  double height;
  double opacity;
  double edgeWidth;
  Color backgroundColor;
  CustomIconButton activateButton;
  List<CustomIconButton> buttons = const <CustomIconButton>[];
  TabController controller;
  CustomNavigatorState state;
  CustomNavigator(
      {this.width,
      this.height,
      this.edgeWidth = 1,
      this.opacity = 1,
      this.backgroundColor = Colors.white,
      this.controller,
      List<CustomIconButton> buttons,
      }) {
    this.buttons = buttons;
    for (CustomIconButton bt in this.buttons) {
      bt.setParentNavigator(this);
    }
    this.buttons[0].addDelayInit(() {
      this.activateButtonByIndex(0);
    });
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new CustomNavigatorState();
    return this.state;
  }

  bool isActivate(CustomIconButton bt) {
    return this.activateButton == bt;
  }
  void activateButtonByIndex(int i){
    for(int j=0;j<this.buttons.length;j++){
      if(j == i){
        this.buttons[i].setReactState(ComponentReactState.focused);
        this.activateButton = this.buttons[i];
      }else{
        this.buttons[j].setReactState(ComponentReactState.unfocused);
      }
    }
  }

  void activateButtonByObject(CustomIconButton button) {
    for (CustomIconButton bt in this.buttons) {
      if (bt == button) {
        bt.setReactState(ComponentReactState.focused);
        this.activateButton = bt;
      } else {
        bt.setReactState(ComponentReactState.unfocused);
      }
    }
  }

  int getActivatePageNo() {
    return this.controller.index;
  }

  TabController getController() {
    return this.controller;
  }

  void switchPageByObject(CustomIconButton button) {
    for (int i = 0; i < this.buttons.length; i++) {
      if (this.buttons[i] == button) {
        this.controller.animateTo(i);
        return;
      }
    }
  }

  void beginOpacity(){
    this.state.beginOpacity();
  }
  void reverseOpacity(){
    this.state.reverseOpacity();
  }
}

class CustomNavigatorState extends State<CustomNavigator> with TickerProviderStateMixin{
  TweenAnimation backgroundOpacity;
  TweenAnimation shadowSize;
  TweenAnimation shadowDense;
  TweenAnimation lengthChange;
  TweenAnimation positionChange;
  @override
  void initState() {
    this.backgroundOpacity = new TweenAnimation();
    this.shadowSize = new TweenAnimation();
    this.shadowDense = new TweenAnimation();
    this.lengthChange = new TweenAnimation();
    this.positionChange = new TweenAnimation();

    this.backgroundOpacity.initAnimation(1.0, 0.35,
        300, this, () {setState(() {});});
    this.shadowSize.initAnimation(10.0, 0.0, 300, this, () {setState(() {});});
    this.shadowDense.initAnimation(3.0, 0.0, 300, this, () {setState(() {});});
    this.lengthChange.initAnimation(
        widget.width, widget.width*0.9, 300, this,() {setState(() {});});
    this.positionChange.initAnimation(0.0, -65.0, 300, this, (){setState(() {});});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Transform.translate(
        offset: Offset(this.positionChange.getValue(),0),
      child: Container(
        width: this.lengthChange.getValue(),
        height: widget.height,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: new BoxDecoration(
            color: widget.backgroundColor.withOpacity(this.backgroundOpacity.getValue()),
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            boxShadow: [
              BoxShadow(
                blurRadius: this.shadowSize.getValue(), //阴影范围
                spreadRadius: this.shadowDense.getValue(), //阴影浓度
                color: Color(0x33000000), //阴影颜色
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.buttons,
        ),
      ),
    );
    return body;
  }

  void beginOpacity(){
    this.backgroundOpacity.beginAnimation();
    this.shadowSize.beginAnimation();
    this.shadowDense.beginAnimation();
    this.positionChange.beginAnimation();
    this.lengthChange.beginAnimation();
  }
  void reverseOpacity(){
    this.backgroundOpacity.reverse();
    this.shadowSize.reverse();
    this.shadowDense.reverse();
    this.positionChange.reverse();
    this.lengthChange.reverse();
  }
}

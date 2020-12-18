import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/iconButton.dart';
import 'package:fore_end/interface/Themeable.dart';

class MyNavigator extends StatefulWidget {
  double width;
  double height;
  double opacity;
  double edgeWidth;
  Color backgroundColor;
  MyIconButton activateButton;
  List<MyIconButton> buttons = const <MyIconButton>[];
  TabController controller;
  MyNavigatorState state;
  MyNavigator(
      {this.width,
      this.height,
      this.edgeWidth = 1,
      this.opacity = 1,
      this.backgroundColor = Colors.white,
      this.controller,
      List<MyIconButton> buttons,
      }) {
    this.buttons = buttons;
    for (MyIconButton bt in this.buttons) {
      bt.setParentNavigator(this);
    }
    this.buttons[0].addDelayInit(() {
      this.activateButtonByIndex(0);
    });
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new MyNavigatorState();
    return this.state;
  }

  bool isActivate(MyIconButton bt) {
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

  void activateButtonByObject(MyIconButton button) {
    for (MyIconButton bt in this.buttons) {
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

  void switchPageByObject(MyIconButton button) {
    for (int i = 0; i < this.buttons.length; i++) {
      if (this.buttons[i] == button) {
        this.controller.animateTo(i);
        return;
      }
    }
  }
}

class MyNavigatorState extends State<MyNavigator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: new BoxDecoration(
        color: widget.backgroundColor.withOpacity(widget.opacity),
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        border: new Border.all(width: widget.edgeWidth, color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.buttons,
      ),
    );
    return body;
  }
}

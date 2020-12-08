import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/iconButton.dart';
import 'package:fore_end/Mycomponents/switchPage.dart';
import 'package:fore_end/interface/Themeable.dart';

class MyNavigator extends StatefulWidget {
  double width;
  double height;
  MyIconButton activateButton;
  List<MyIconButton> buttons = const <MyIconButton>[];
  SwitchPage switchPages;
  State<MyNavigator> state;
  MyNavigator({this.width, this.height,
    List<Widget> switchPages, List<MyIconButton> buttons,
    int activateNum=0}) {

    this.buttons = buttons;
    for(MyIconButton bt in this.buttons){
      bt.setParentNavigator(this);
    }
    if(activateNum < 0){
      activateNum = 0;
    }else if(activateNum > this.buttons.length){
      activateNum = this.buttons.length;
    }

    this.switchPages = new SwitchPage(
      children: switchPages,
      initPosition: activateNum * ScreenTool.partOfScreenWidth(1),
    );
    this.buttons[activateNum].addDelayInit((){
      this.activateButtonByObject(this.buttons[activateNum]);
    });
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new MyNavigatorState();
    return this.state;
  }

  SwitchPage getPages(){
    return this.switchPages;
  }
  bool isActivate(MyIconButton bt){
    return this.activateButton == bt;
  }
  void activateButtonByObject(MyIconButton button){
    for(MyIconButton bt in this.buttons){
      if(bt == button){
        bt.setReactState(ComponentReactState.focused);
        this.activateButton = bt;
      }else{
        bt.setReactState(ComponentReactState.unfocused);
      }
    }
  }
  void switchPageByObject(MyIconButton button){
    if(this.switchPages == null)return;
    for(int i=0;i<this.buttons.length;i++){
      if(this.buttons[i] == button){
        this.switchPages.switchToPage(i);
        return;
      }
    }
  }
}

class MyNavigatorState extends State<MyNavigator> {

  @override
  void initState(){
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
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
        border: new Border.all(width: 1, color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.buttons,
      ),
    );
    return body;
  }
}

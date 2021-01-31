import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/painter/ColorPainter.dart';

class PaintedNavigator extends StatelessWidget {
  ///导航器的宽度
  double width;

  ///导航器的高度
  double height;

  double borderRadius;

  List<CustomIconButton> buttons;
  TabController controller;
  Color backgroundColor;
  ///当前被选中的标签按钮
  CustomIconButton activateButton;
  bool changing;

  PaintedNavigator(
      {double width,
      double height,
      this.buttons,
      this.controller,
        this.borderRadius,
      this.backgroundColor = Colors.white10}) {
    this.changing = false;
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    if(this.borderRadius ==null){
      this.borderRadius = this.height/2;
    }
    int idx=0;
    for (CustomIconButton bt in this.buttons) {
      bt.setParentNavigator(this);
      if(controller.index == idx){
        int selected = idx;
        this.buttons[idx].addDelayInit(() {
          this.activateButtonByIndex(selected);
        });
      }
      idx ++;
    }
    this.controller.addListener(() {
      if (this.controller.indexIsChanging) {
        this.changing = true;
      } else {
          this.changing = false;
          print("page animate done, now " + this.controller.index.toString());
          this.activateButtonByIndex(this.controller.index);
          //当切换标签页完毕时，执行回调
          if (this.activateButton.navigatorCallback != null)
            this.activateButton.navigatorCallback();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ColorPainter(
          color: this.backgroundColor,
          context: context,
          borderRadius: this.borderRadius
      ),
      child: Container(
        height: this.height,
        child: this.getNavigator(),
      ),
    );
  }
  bool replace(CustomIconButton original, CustomIconButton newone){
    for(int i=0;i< buttons.length;i++){
      if(buttons[i] == original){
        buttons[i] = newone;
        return true;
      }
    }
    return false;
  }
  Widget getNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  ///某个按钮是否为当前选中的按钮
  ///参数 [bt] 为想要判断的按钮实例
  bool isActivate(CustomIconButton bt) {
    return this.activateButton == bt;
  }

  ///根据按钮实例 [button] 选重某个按钮
  void activateButtonByObject(CustomIconButton button) {
    for (CustomIconButton bt in this.buttons) {
      if (bt == button) {
        bt.setFocus(true);
        this.activateButton = bt;
      } else {
        bt.setFocus(false);
      }
    }
  }
  ///根据索引 [i] 选中某个按钮
  void activateButtonByIndex(int i) {
    for (int j = 0; j < this.buttons.length; j++) {
      if (j == i) {
        this.buttons[i].setFocus(true);
        this.activateButton = this.buttons[i];
      } else {
        this.buttons[j].setFocus(false);
      }
    }
  }
  ///根据按钮实例 [button] 切换标签页
  void switchPageByObject(CustomIconButton button) {
    for (int i = 0; i < this.buttons.length; i++) {
      if (this.buttons[i] == button) {
        this.controller.animateTo(i);
        return;
      }
    }
  }
}

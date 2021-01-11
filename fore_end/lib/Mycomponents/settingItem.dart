import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Valueable.dart';

import 'inputs/CustomTextField.dart';

/// 个人信息设置页Item
class SettingItem extends StatefulWidget
with DisableWidgetMixIn,ValueableWidgetMixIn<String>{
  String leftText; //左侧显示文字
  double inputFieldWidth;

  final Widget leftIcon; //左侧图片

  Function onTap; //点击事件
  ItemState state;

  ValueableWidgetMixIn rightComponent;

  SettingItem({
    Key key,
    bool disabled = false,
    bool canChangeDisabled = true,
    this.leftText = "",
    this.leftIcon,
    String rightText = "",
    this.onTap,
    this.inputFieldWidth = 0.3,
    ValueableWidgetMixIn valueable,
  }) : super(key: key) {
    this.inputFieldWidth = ScreenTool.partOfScreenWidth(this.inputFieldWidth);
    this.canChangeDisable = canChangeDisabled;
    this.disabled = new ValueNotifier(disabled);
    if(valueable != null){
      this.rightComponent = valueable;
      if(this.rightComponent is DisableWidgetMixIn){
        (this.rightComponent as DisableWidgetMixIn)
          ..canChangeDisable = this.canChangeDisable
          ..disabled.value = disabled;
      }
    }else{
      this.rightComponent = CustomTextField(
        disabled: disabled,
        canChangeDisabled: canChangeDisabled,
        theme: MyTheme.blueStyle,
        defaultContent: "",
        ulDefaultWidth: 0,
        width: this.inputFieldWidth,
        helpText: "",
        errorText: "",
        disableSuffix: true,
        bottomPadding: -50,
        textAlign: TextAlign.right,
      );
    }
  }

  void refresh() {
    this.state.setState(() {});
  }

  CustomTextField getInpuitField() {
    return this.rightComponent;
  }

  @override
  State<StatefulWidget> createState() {
    this.state = new ItemState();
    return this.state;
  }

  @override
  getValue() {
    return this.rightComponent.getValue();
  }
}

class ItemState extends State<SettingItem>
with DisableStateMixIn{
  @override
  void initState() {
    this.initDisableListener(widget.disabled);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        child:Container(
      width: double.infinity,
      height: 60,
      color: Colors.white,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget.leftIcon,
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              widget.leftText,
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
            ),
          ),
          Expanded(child: SizedBox()),
          (widget.rightComponent as Widget),
        ],
      ),
    )
    );
  }

  @override
  void setDisabled() {
    if(widget.rightComponent is DisableWidgetMixIn){
      (widget.rightComponent as DisableWidgetMixIn).setDisabled(true);
    }
  }

  @override
  void setEnabled() {
    if(widget.rightComponent is DisableWidgetMixIn){
      (widget.rightComponent as DisableWidgetMixIn).setDisabled(false);
    }
  }
}

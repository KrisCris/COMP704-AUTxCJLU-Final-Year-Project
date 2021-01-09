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
  String rightText; //右侧显示文字
  final Widget leftIcon; //左侧图片
  final bool isRight; //是否显示右侧
  final bool isRightImage; //是否显示右侧图片
  final bool isRightText; //是否显示右侧文字
  bool isRightUneditText;
  final Widget rightImage;
  double inputFieldWidth;
  Image image;
  String imageBase64;
  Function onTap; //点击事件
  ItemState state;

  CustomTextField textField;

  SettingItem({
    Key key,
    bool disabled = false,
    bool canChangeDisabled = true,
    this.leftText = "",
    this.leftIcon,
    String rightText = "",
    this.isRight = true,
    this.isRightImage = false,
    this.isRightText = true,
    this.isRightUneditText=false,
    this.onTap,
    this.rightImage,
    this.image,
    this.imageBase64,
    this.inputFieldWidth = 0.3,
    state,
  }) : super(key: key) {
    this.rightText = rightText;
    this.inputFieldWidth = ScreenTool.partOfScreenWidth(this.inputFieldWidth);
    this.canChangeDisable = canChangeDisabled;
    this.disabled = new ValueNotifier(disabled);

    this.textField = CustomTextField(
      disabled: disabled,
      canChangeDisabled: canChangeDisabled,
      theme: MyTheme.blueStyle,
      defaultContent: this.rightText,
      ulDefaultWidth: 0,
      width: this.inputFieldWidth,
      helpText: "",
      errorText: "",
      disableSuffix: true,
      bottomPadding: -50,
      textAlign: TextAlign.right,
    );
  }

  void refresh() {
    this.state.setState(() {});
  }

  CustomTextField getInpuitField() {
    return this.textField;
  }

  @override
  State<StatefulWidget> createState() {
    this.state = new ItemState();
    return this.state;
  }

  @override
  getValue() {
      if(this.isRightUneditText){
        return this.rightText;
      }else if(this.isRightImage){
        return this.imageBase64;
      }else{
        return this.textField.getValue();
      }

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
          Offstage(
              offstage: !widget.isRightText,
              child: Transform.translate(
                  offset: Offset(57, 13), child: widget.textField)),
          //通过调整Offset的位置来和其他的text对其，因为本身这个textfield的文字是居中的。
          Offstage(
              offstage: !widget.isRightUneditText,
              child: Transform.translate(
                  offset: Offset(0, 3), child: Text(widget.rightText, style: TextStyle(
                  fontSize: 16.0, color: Colors.black),))),
          Offstage(
            offstage: !widget.isRightImage,
            child: widget.image,
          ),
        ],
      ),
    )
    );
  }

  @override
  void setDisabled() {
    widget.textField.setDisabled(true);
  }

  @override
  void setEnabled() {
    widget.textField.setDisabled(false);
  }
}

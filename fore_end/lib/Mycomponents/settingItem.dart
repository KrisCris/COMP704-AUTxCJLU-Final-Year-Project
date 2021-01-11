import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/widgets/ValueableImage.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Valueable.dart';

import 'inputs/CustomTextField.dart';

/// 个人信息设置页Item
class SettingItem extends StatefulWidget
    with DisableWidgetMixIn, ValueableWidgetMixIn<String> {
  final String leftText; //左侧显示文字
  final Widget leftIcon; //左侧图片

  double inputFieldWidth;
  Function onTap; //点击事件
  ValueableWidgetMixIn rightComponent;

  SettingItem({
    Key key,
    bool disabled = false,
    bool canChangeDisabled = true,
    bool couldInputByKeyBoard = false,
    this.leftText = "",
    this.leftIcon,
    String text = "",
    String base64,
    this.onTap,
    this.inputFieldWidth = 0.3,
  }) : super(key: key) {
    this.inputFieldWidth = ScreenTool.partOfScreenWidth(this.inputFieldWidth);
    this.canChangeDisable = canChangeDisabled;
    this.disabled = new ValueNotifier(disabled);
    if (base64 != null) {
      this.rightComponent = ValueableImage(
        base64: base64,
        disabled: disabled,
        canChangeDisable: canChangeDisable,
        behavior: HitTestBehavior.translucent,
        ignoreTap: true,
      );
    } else {
      if (couldInputByKeyBoard) {
        this.rightComponent = CustomTextField(
          disabled: disabled,
          canChangeDisabled: canChangeDisabled,
          theme: MyTheme.blueStyle,
          defaultContent: text,
          ulDefaultWidth: 0,
          width: this.inputFieldWidth,
          helpText: "",
          errorText: "",
          disableSuffix: true,
          bottomPadding: -50,
          textAlign: TextAlign.right,
        );
      } else {
        this.rightComponent = CustomTextButton(
          text,
          theme: MyTheme.blueStyle,
          disabled: disabled,
          canChangeDisable: canChangeDisable,
          ignoreTap: true,
          autoReturnColor: false,
        );
      }
    }
  }

  @override
  void setValue(String s) {
    this.rightComponent.setValue(s);
  }

  CustomTextField getInpuitField() {
    return this.rightComponent;
  }

  @override
  State<StatefulWidget> createState() {
    return new ItemState();
  }

  @override
  getValue() {
    return this.rightComponent.getValue();
  }
}

class ItemState extends State<SettingItem> with DisableStateMixIn {
  @override
  void initState() {
    this.initDisableListener(widget.disabled);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled.value?(){}:widget.onTap,
        child: Container(
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
        ));
  }

  @override
  void setDisabled() {
    setState(() {
      if (widget.rightComponent is DisableWidgetMixIn) {
        (widget.rightComponent as DisableWidgetMixIn).setDisabled(true);
      }
    });
  }

  @override
  void setEnabled() {
    setState(() {
      if (widget.rightComponent is DisableWidgetMixIn) {
        (widget.rightComponent as DisableWidgetMixIn).setDisabled(false);
      }
    });
  }
}

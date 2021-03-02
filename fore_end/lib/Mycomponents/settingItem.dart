
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
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
    ValueableWidgetMixIn rightComponent,
    String text,
    this.leftText = "",
    this.leftIcon,
    this.onTap,
    this.inputFieldWidth = 0.3,
  }) : super(key: key) {
    this.inputFieldWidth = ScreenTool.partOfScreenWidth(this.inputFieldWidth);
    this.canChangeDisable = canChangeDisabled;
    this.disabled = new ValueNotifier(disabled);
    if (rightComponent == null) {
      this.rightComponent = CustomTextField(
        disabled: disabled,
        canChangeDisabled: canChangeDisabled,
        defaultContent: text,
        ulDefaultWidth: 0,
        width: this.inputFieldWidth,
        helpText: "",
        errorText: "",
        disableSuffix: true,
        isAutoCheck: false,
        bottomPadding: -10,
        textAlign: TextAlign.right,
      );
    }else{
      this.rightComponent = rightComponent;
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
        onTap: widget.disabled.value ? () {} : widget.onTap,
        child: Container(
          width: double.infinity,
          height: 60,
          color: MyTheme.convert(ThemeColorName.ComponentBackground),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.leftIcon,
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  widget.leftText,
                  style: TextStyle(fontSize: 15.0, color: MyTheme.convert(ThemeColorName.NormalText)),
                ),
              ),
              Expanded(child: SizedBox()),
              // (widget.rightComponent as Widget),
              Container(
                margin: EdgeInsets.only(top:10,left: 10 ),
                child: (widget.rightComponent as Widget),
              ),
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

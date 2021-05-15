import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Valueable.dart';

class ValueableImage extends StatefulWidget
    with ValueableWidgetMixIn<String>, DisableWidgetMixIn {
  bool ignoreTap;
  Function onTap;
  HitTestBehavior behavior;

  ValueableImage(
      {Key key,
      String base64,
      this.ignoreTap = false,
      this.behavior = HitTestBehavior.deferToChild,
      Function onTap,
      bool disabled = false,
      bool canChangeDisable = true}) {
    this.onTap = onTap;
    this.disabled = new ValueNotifier<bool>(disabled);
    this.widgetValue = new ValueNotifier<String>(base64);
    this.canChangeDisable = canChangeDisable;
  }

  @override
  State<StatefulWidget> createState() {
    return ValueableImageState();
  }
}

class ValueableImageState extends State<ValueableImage>
    with DisableStateMixIn, ValueableStateMixIn<String> {
  @override
  void initState() {
    super.initState();
    this.initDisableListener(widget.disabled);
    this.initValueListener(widget.widgetValue);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabled.value || widget.ignoreTap || widget.onTap == null) {
      return Image.memory(base64Decode(widget.widgetValue.value));
    } else {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: widget.behavior,
        child: Image.memory(base64Decode(widget.widgetValue.value)),
      );
    }
  }

  @override
  void setDisabled() {
    //如果没有点击事件，则不需要处理disable状态变化
    if (widget.onTap == null) return;

    setState(() {});
  }

  @override
  void setEnabled() {
    //如果没有点击事件，则不需要处理disable状态变化
    if (widget.onTap == null) return;
    setState(() {});
  }

  @override
  void onChangeValue() {
    setState(() {});
  }
}

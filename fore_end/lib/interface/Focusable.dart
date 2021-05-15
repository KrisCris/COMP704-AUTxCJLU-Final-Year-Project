import 'package:flutter/cupertino.dart';

abstract class FocusableWidgetMixIn {
  ValueNotifier<bool> focus;
  bool lastFocusState;

  void setFocus(bool t) {
    if (this.focus == null) {
      print("try to set focus state when ValueNotifier is null\n");
      return;
    }
    if (this.focus.value == t) return;
    this.lastFocusState = this.focus.value;
    this.focus.value = t;
  }
}

abstract class FocusableStateMixIn {
  bool lastFocusState;

  ///As the callback of valueNotifier<bool>
  void setFocus();
  void setUnFocus();
}

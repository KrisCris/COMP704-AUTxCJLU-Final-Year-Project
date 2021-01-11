import 'package:flutter/cupertino.dart';

abstract class ValueableWidgetMixIn<T>{
  ValueNotifier<T> widgetValue;

  T getValue(){
    return widgetValue.value;
  }
  void setValue(T t){
    this.widgetValue.value = t;
  }
  Map<String, T> getValueWithKey(String key){
    return {key: this.getValue()};
  }
}

abstract class ValueableStateMixIn<T>{
  void initValueListener(ValueNotifier<T> dis) {
    dis.addListener(this.onChangeValue);
  }
  void onChangeValue();
}
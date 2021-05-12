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

abstract class ValueableStatelessWidgetMixIn<T>{
  ValueNotifier<T> widgetValue;
  List<Function> onChangeValue;

  T getValue(){
    return widgetValue.value;
  }
  void setValue(T t){
    this.widgetValue.value = t;
  }
  void addValueChangeListener(f){
    widgetValue.addListener(f);
  }
  Map<String, T> getValueWithKey(String key){
    return {key: this.getValue()};
  }
  void initValueListener() {
    for(Function f in onChangeValue){
      widgetValue.addListener(f);
    }
  }
}

abstract class ValueableStateMixIn<T>{
  void initValueListener(ValueNotifier<T> dis) {
    dis.addListener(this.onChangeValue);
  }

  void onChangeValue();
}
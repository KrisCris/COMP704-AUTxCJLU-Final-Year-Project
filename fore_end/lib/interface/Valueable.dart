abstract class ValueableWidgetMixIn<T>{

  T getValue();
  Map<String, T> getValueWithKey(String key){
    return {key: this.getValue()};
  }
}
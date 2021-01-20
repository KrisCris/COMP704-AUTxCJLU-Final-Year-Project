import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/interface/Valueable.dart';

class ValueBar<T> extends StatefulWidget
with ValueableWidgetMixIn<T>{
  double width;
  double barThickness;
  double minVal;
  double maxVal;

  ValueBar({double width=100, this.barThickness,this.minVal,this.maxVal,T initVal}){
    this.width = ScreenTool.partOfScreenWidth(width);
    this.widgetValue = ValueNotifier(initVal);
  }
  @override
  State<StatefulWidget> createState() {

  }
}

class ValueBarState extends State<ValueBar>{

  @override
  Widget build(BuildContext context) {

  }

}
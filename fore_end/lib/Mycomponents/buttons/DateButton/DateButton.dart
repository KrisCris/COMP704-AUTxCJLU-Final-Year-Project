import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/interface/Valueable.dart';

class DateButton extends StatefulWidget with ValueableWidgetMixIn<int> {
  double width;
  double height;
  double paddingHorizontal;
  DateTime lastTime;
  DateTime beginTime;
  TextStyle style;
  BoxDecoration decoration;
  Function onChangeDate;
  DateButton(
      {double width,
      double height,
        this.paddingHorizontal=0,
        this.onChangeDate,
      TextStyle style,
      BoxDecoration decoration,
      DateTime lastTime, DateTime beginTime,
        Key key
      }):super(key:key) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    this.widgetValue = new ValueNotifier<int>(DateTime.now().millisecondsSinceEpoch);
    this.style = style ??
        TextStyle(
            fontFamily: "Futura",
            fontSize: 12,
            decoration: TextDecoration.none,
            color: MyTheme.convert(ThemeColorName.NormalText));
    this.decoration = decoration ??
        BoxDecoration(
            color: MyTheme.convert(ThemeColorName.TransparentShadow),
            borderRadius: BorderRadius.circular(5));
    this.beginTime = beginTime ?? DateTime(2021, 1, 1);
    this.lastTime = lastTime ?? DateTime(2021, 12, 1);
  }

  @override
  State<StatefulWidget> createState() {
    return new DateButtonState();
  }
}

class DateButtonState extends State<DateButton> with ValueableStateMixIn {
  @override
  void didUpdateWidget(covariant DateButton oldWidget) {
    widget.widgetValue = oldWidget.widgetValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    this.initValueListener(widget.widgetValue);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final DateTime date = await showDatePicker(
            context: context,
            initialDate: DateTime.fromMillisecondsSinceEpoch(widget.widgetValue.value),
            firstDate: widget.beginTime,
            lastDate: widget.lastTime,
          );
          if (date == null) return;
          widget.widgetValue.value = date.millisecondsSinceEpoch;
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.fromLTRB(widget.paddingHorizontal, 0, widget.paddingHorizontal, 0),
          decoration: widget.decoration,
          alignment: Alignment.center,
          child: Text(this.convertToStr(), style: widget.style),
        ));
  }
  void _modifyDat({int day=1}){
    DateTime dt =DateTime.fromMillisecondsSinceEpoch(widget.widgetValue.value).add(Duration(days: day));
    if(dt.compareTo(widget.lastTime)<=0 && dt.compareTo(widget.beginTime)>=0){
      widget.widgetValue.value = dt.millisecondsSinceEpoch;
    }
  }
  void addDay(){
    this._modifyDat(day: 1);
  }
  void minusDay(){
    this._modifyDat(day: -1);
  }
  @override
  void onChangeValue() {
    if(widget.onChangeDate != null){
      widget.onChangeDate();
    }
    setState(() {});
  }

  String convertToStr() {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(widget.widgetValue.value);
    return dt.year.toString() +
        "-" +
        dt.month.toString() +
        "-" +
        dt.day.toString();
  }
}

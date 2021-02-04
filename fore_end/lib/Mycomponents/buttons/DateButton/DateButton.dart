import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/interface/Valueable.dart';

import '../CustomIconButton.dart';

class DateSelect extends StatefulWidget with ValueableWidgetMixIn<int> {
  ///宽度
  double width;
  ///高度
  double height;
  ///按钮的边界大小
  double buttonMargin;
  ///文字部分距离按钮左右边界的距离
  double paddingHorizontal;
  ///时间选择范围的最后一天
  DateTime lastTime;
  ///时间选择范围的第一天
  DateTime beginTime;
  ///文字样式,不设置则使用默认配置
  TextStyle style;
  ///按钮样式，不设置则使用默认配置
  BoxDecoration decoration;
  ///当日期变化时触发的回调函数
  Function(int newDate) onChangeDate;

  DateSelect(
      {double width,
      double height,
        this.paddingHorizontal=0,
        this.onChangeDate,
        this.buttonMargin = 55,
      TextStyle style,
      BoxDecoration decoration,
      DateTime lastTime, DateTime beginTime,
        Key key
      }):super(key:key) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    this.widgetValue = new ValueNotifier<int>(DateTime.now().millisecondsSinceEpoch);
    //style为null,则使用后面的默认项目，否则使用style
    this.style = style ??
        TextStyle(
            fontFamily: "Futura",
            fontSize: 12,
            decoration: TextDecoration.none,
            color: MyTheme.convert(ThemeColorName.NormalText));

    //decoration为null,则使用后面的默认项目,否则使用decoration
    this.decoration = decoration ??
        BoxDecoration(
            color: MyTheme.convert(ThemeColorName.TransparentShadow),
            borderRadius: BorderRadius.circular(5));

    //开始时间和结束时间若为null，使用默认项目
    this.beginTime = beginTime ?? DateTime(2021, 1, 1);
    this.lastTime = lastTime ?? DateTime(2021, 12, 1);
  }

  @override
  State<StatefulWidget> createState() {
    return new DateSelectState();
  }
}

class DateSelectState extends State<DateSelect> with ValueableStateMixIn {
  @override
  void didUpdateWidget(covariant DateSelect oldWidget) {
    widget.widgetValue = oldWidget.widgetValue;
    super.didUpdateWidget(oldWidget);
  }

  int getTime(){
    return widget.widgetValue.value;
  }

  @override
  void initState() {
    this.initValueListener(widget.widgetValue);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            icon: FontAwesomeIcons.chevronLeft,
            buttonSize: widget.buttonMargin,
            backgroundOpacity: 0,
            onClick: (){
              this.minusDay();
            },
          ),
          GestureDetector(
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
                width: widget.width-2*widget.buttonMargin,
                height: widget.height,
                padding: EdgeInsets.fromLTRB(widget.paddingHorizontal, 0, widget.paddingHorizontal, 0),
                decoration: widget.decoration,
                alignment: Alignment.center,
                child: Text(this.convertToStr(), style: widget.style),
              )),
          CustomIconButton(
            icon: FontAwesomeIcons.chevronRight,
            buttonSize: widget.buttonMargin,
            backgroundOpacity: 0,
            onClick: (){
              this.addDay();
            },
          ),
        ],
      ),
    );
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
      widget.onChangeDate(widget.widgetValue.value);
    }
    setState(() {});
  }

  ///将时间戳转为日期字符串格式
  String convertToStr() {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(widget.widgetValue.value);
    return dt.year.toString() +
        "-" +
        dt.month.toString() +
        "-" +
        dt.day.toString();
  }
}

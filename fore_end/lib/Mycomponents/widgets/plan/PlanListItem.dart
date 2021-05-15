import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:fore_end/MyTool/util/MyTheme.dart';

class PlanTextItem extends StatefulWidget {
  String leftText; //左侧显示文字
  String rightText; //右侧显示文字
  String rightValue; //右侧显示数值
  double textSize;
  bool isShowRightValue;
  bool isShowRightText;

  PlanTextItem({
    Key key,
    this.leftText = "",
    this.rightText = "",
    this.rightValue,
    this.textSize = 15,
    this.isShowRightValue = true,
    this.isShowRightText = true,
  }) : super(key: key);

  @override
  _PlanTextItemState createState() => _PlanTextItemState();
}

class _PlanTextItemState extends State<PlanTextItem> {
  String toThousands(int value) {
    String stringValue = value.toString();
    if (value >= 1000) {
      var format = NumberFormat('0,000');
      return format.format(value);
    }
    return stringValue;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              " " + widget.leftText,
              style: TextStyle(
                  fontSize: widget.textSize,
                  color: MyTheme.convert(ThemeColorName.NormalText),
                  fontFamily:
                      'Futura'), //color: MyTheme.convert(ThemeColorName.NormalText)
            ),
          ),
          Expanded(child: SizedBox()),
          // (widget.rightComponent as Widget),
          Container(
            child: Text(
              widget.isShowRightValue
                  ? widget.rightValue + " " + widget.rightText
                  : widget.rightText,
              style: TextStyle(
                  fontSize: widget.textSize,
                  color: MyTheme.convert(ThemeColorName.NormalText),
                  fontFamily: 'Futura'),
            ),
          ),
        ],
      ),
    );
  }
}

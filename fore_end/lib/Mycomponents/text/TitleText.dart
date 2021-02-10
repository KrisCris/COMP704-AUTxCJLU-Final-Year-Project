import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/painter/UnderLinePainter.dart';

class TitleText extends StatelessWidget {
  String text;
  double fontSize;
  double lineWidth;
  double maxWidth;
  double maxHeight;
  double underLineDistance;
  double underLineLength;
  Alignment alignment;
  Color fontColor;
  Color dividerColor;
  TitleText(
      {this.text = "",
      this.alignment,
      this.underLineDistance = 5,
      double underLineLength,
      this.fontSize = 14,
      this.lineWidth = 3,
      double maxWidth = 100,
      double maxHeight = 20,
      Color fontColor,
      Color dividerColor,}) {
    this.maxWidth = ScreenTool.partOfScreenWidth(maxWidth);
    this.maxHeight = ScreenTool.partOfScreenHeight(maxHeight);
    if (underLineLength == null) {
      this.underLineLength = this.maxWidth;
    } else {
      underLineLength = ScreenTool.partOfScreenWidth(underLineLength);
      this.underLineLength = underLineLength;
    }
    if(fontColor == null){
      fontColor = MyTheme.convert(ThemeColorName.NormalText);
    }
    if(dividerColor == null){
      dividerColor = MyTheme.convert(ThemeColorName.NormalText);
    }
    this.fontColor = fontColor;
    this.dividerColor = dividerColor;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: UnderLinePainter(
          bottomDistance: this.underLineDistance,
          lineLength: this.underLineLength,
          width: this.lineWidth,
          color: dividerColor),
      child: Container(
        width: maxWidth,
        height: maxHeight,
        alignment: this.alignment,
        child: Text(this.text,
            style: TextStyle(
                fontSize: this.fontSize,
                color: this.fontColor,
                fontFamily: "Futura",
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

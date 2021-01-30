import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/painter/UnderLinePainter.dart';

class TitleText extends StatelessWidget {
  String text;
  double fontSize;
  double lineWidth;
  double maxWidth;
  double maxHeight;
  double underLineDistance;
  double underLineLength;
  Color fontColor;
  Color dividerColor;
  TitleText({this.text="", this.underLineDistance=5,double underLineLength, this.fontSize=14,this.lineWidth=3,double maxWidth=100,double maxHeight=20, this.fontColor=Colors.white, this.dividerColor=Colors.white}){
    this.maxWidth = ScreenTool.partOfScreenWidth(maxWidth);
    this.maxHeight = ScreenTool.partOfScreenHeight(maxHeight);
    if(underLineLength == null){
      this.underLineLength = this.maxWidth;
    }else{
      underLineLength = ScreenTool.partOfScreenWidth(underLineLength);
      this.underLineLength = underLineLength;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter:
          UnderLinePainter(bottomDistance: this.underLineDistance,lineLength: this.underLineLength,  width: this.lineWidth, color: dividerColor),
      child: Container(
        width: maxWidth,
        height: maxHeight,
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

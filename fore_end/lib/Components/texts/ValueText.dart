import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValueText<T extends num> extends StatelessWidget {
  T _numUpper;
  T _numLower;
  String unit;
  double roundNum;
  double valueFontSize;
  MainAxisAlignment rowMainAxisAlignment;
  double unitFontSize;
  Color fontColor;
  double gap;

  ValueText(
      {T numUpper,
      @required T numLower,
      this.rowMainAxisAlignment = MainAxisAlignment.start,
      this.unit = "",
      this.roundNum = 1,
      this.valueFontSize = 16,
      this.unitFontSize = 13,
      this.gap = 10,
      this.fontColor = Colors.white}) {
    this._numUpper = numUpper;
    this._numLower = numLower;
  }
  @override
  Widget build(BuildContext context) {
    List<TextSpan> res = [];
    res.addAll([]);
    if (this._numUpper != null) {
      res.addAll([
        TextSpan(
            text: " - ",
            style: TextStyle(
              color: this.fontColor,
              fontSize: this.valueFontSize + 3,
              fontFamily: "Futura",
              decoration: TextDecoration.none,
            )),
        TextSpan(
            text: this._numUpper.toString(),
            style: TextStyle(
              color: this.fontColor,
              fontWeight: FontWeight.bold,
              fontSize: this.valueFontSize,
              fontFamily: "Futura",
              decoration: TextDecoration.none,
            )),
      ]);
    }
    res.add(TextSpan(
        text: " " + unit,
        style: TextStyle(
          color: this.fontColor,
          fontSize: this.unitFontSize,
          fontFamily: "Futura",
          decoration: TextDecoration.none,
        )));
    return RichText(
      text: TextSpan(
          text: this._numLower.toString(),
          style: TextStyle(
            color: this.fontColor,
            fontSize: this.valueFontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "Futura",
            decoration: TextDecoration.none,
          ),
          children: res),
      textDirection: TextDirection.ltr,
    );
  }
}

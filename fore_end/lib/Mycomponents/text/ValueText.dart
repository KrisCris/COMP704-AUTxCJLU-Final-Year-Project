import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValueText<T extends num> extends StatelessWidget{
  T _numUpper;
  T _numLower;
  String unit;
  double roundNum;
  double valueFontSize;
  MainAxisAlignment rowMainAxisAlignment;
  double unitFontSize;
  Color fontColor;
  double gap;

  ValueText({@required T numUpper, T numLower, this.rowMainAxisAlignment = MainAxisAlignment.start, this.unit = "", this.roundNum = 1,this.valueFontSize=16, this.unitFontSize = 13, this.gap = 10, this.fontColor = Colors.white}){
    this._numUpper = numUpper;
    this._numLower = numLower;
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> res = [];
    if(this._numLower != null){
      res.addAll([
        Text(this._numLower.toString(),style: TextStyle(
          color: this.fontColor,
          fontSize: this.valueFontSize,
          fontFamily: "Futura",
          decoration: TextDecoration.none,
        )),
        Text(" - ",style: TextStyle(
          color: this.fontColor,
          fontSize: this.valueFontSize+3,
          fontFamily: "Futura",
          decoration: TextDecoration.none,
        ))
      ]);
    }
    res.addAll([
      Text(this._numUpper.toString(),style: TextStyle(
        color: this.fontColor,
        fontSize: this.valueFontSize,
        fontFamily: "Futura",
        decoration: TextDecoration.none,
      )),
      SizedBox(width: this.gap),
      Text(this.unit,style: TextStyle(
        color: this.fontColor,
        fontSize: this.unitFontSize,
        fontFamily: "Futura",
        decoration: TextDecoration.none,
      ))
    ]);
    return Row(
      mainAxisAlignment: this.rowMainAxisAlignment,
      children: res
    );
  }

}
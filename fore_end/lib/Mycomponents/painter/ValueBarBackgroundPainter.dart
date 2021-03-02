
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';

class ValueBarBackgroundPainter extends CustomPainter {
  List<double> radius;
  Color color;
  Color fontColor;
  ValuePosition position;
  String str;
  bool showAdjustButton;
  bool showNumber;
  Paint pen;
  ValueBarBackgroundPainter(
      {@required this.radius,
      this.color = Colors.black38,
      this.showAdjustButton = true,
        this.position = ValuePosition.center,
        @required this.fontColor,
        this.str="",
        this.showNumber = true,
      })
      : assert(radius != null) {
    this.pen = new Paint();
    this.pen.color = this.color;
    this.pen.style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect minusRect = Rect.fromLTWH(-ValueBar.buttonSize-ValueBar.buttonGap, 0, ValueBar.buttonSize, size.height);
    Rect addRect = Rect.fromLTWH(size.width+ValueBar.buttonGap, 0,  ValueBar.buttonSize, size.height);

    RRect rrect, mRrect, aRrect;
    if (this.showAdjustButton) {
      mRrect = RRect.fromRectAndCorners(minusRect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(radius[2]),
          bottomRight: Radius.circular(radius[3]));
      aRrect = RRect.fromRectAndCorners(addRect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(radius[2]),
          bottomRight: Radius.circular(radius[3]));
      TextPainter minusPainter = TextPainter(
          maxLines: 1,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: "-",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Futura",
                color: this.fontColor,
              )))..layout(minWidth: 0.0,maxWidth: double.infinity);
      TextPainter addPainter = TextPainter(
          maxLines: 1,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: "+",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Futura",
                color: this.fontColor,
              )))..layout(minWidth: 0.0,maxWidth: double.infinity);
      double extraHor = (ValueBar.buttonSize-minusPainter.width)/2;
      double extraVer = (size.height-minusPainter.height)/2;
      minusPainter.paint(canvas, Offset(-ValueBar.buttonSize-ValueBar.buttonGap+extraHor,extraVer));
      extraHor = (ValueBar.buttonSize-addPainter.width)/2;
      extraVer = (size.height-addPainter.height)/2;
      addPainter.paint(canvas, Offset(size.width+ValueBar.buttonGap+extraHor,extraVer));
      canvas.drawRRect(mRrect, this.pen);
      canvas.drawRRect(aRrect, this.pen);
    }
    if(this.showNumber){
      TextPainter painter = TextPainter(
          maxLines: 1,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: this.str,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: "Futura",
                color: this.fontColor,
              )))..layout(minWidth: 0.0,maxWidth: double.infinity);
      double textWidth = painter.width;
      double spareSpace = 10;
      double borderWidth = textWidth+2*spareSpace;
      double borderStartX;
      if(this.position == ValuePosition.center){
         borderStartX = size.width / 2 - textWidth / 2 -spareSpace;
      }else if(this.position == ValuePosition.left){
        borderStartX = 0;
      }else{
        borderStartX = size.width - borderWidth;
      }

      painter.paint(canvas, Offset(borderStartX+spareSpace,-19));
      Rect numberRect =
      Rect.fromLTWH(borderStartX, -20, borderWidth, 20);
      RRect numberRrect = RRect.fromRectAndCorners(numberRect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0));
      canvas.drawRRect(numberRrect, this.pen);
    }
     if(this.showNumber){
      if(this.position == ValuePosition.left){
        rrect = RRect.fromRectAndCorners(rect,
            topLeft: Radius.circular(0),
            topRight: Radius.circular(radius[1]),
            bottomLeft: Radius.circular(radius[2]),
            bottomRight: Radius.circular(radius[3]));
      }else if(this.position == ValuePosition.right){
        rrect = RRect.fromRectAndCorners(rect,
            topLeft: Radius.circular(radius[0]),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(radius[2]),
            bottomRight: Radius.circular(radius[3]));
      }else{
        rrect = RRect.fromRectAndCorners(rect,
            topLeft: Radius.circular(radius[0]),
            topRight: Radius.circular(radius[1]),
            bottomLeft: Radius.circular(radius[2]),
            bottomRight: Radius.circular(radius[3]));
      }
    }else{
      rrect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(radius[2]),
          bottomRight: Radius.circular(radius[3]));
    }
    canvas.drawRRect(rrect, this.pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

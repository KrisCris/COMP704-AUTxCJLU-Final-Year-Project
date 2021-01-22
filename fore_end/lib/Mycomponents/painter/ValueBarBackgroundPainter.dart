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
    Rect minusRect = Rect.fromLTWH(0, -20, 30, 20);
    Rect addRect = Rect.fromLTWH(size.width - 30, -20, 30, 20);

    RRect rrect, mRrect, aRrect;
    //TODO: 数字显示左右端 和 显示加减按钮冲突，需要修改按钮的渲染方式，目前暂时采用不显示按钮来解决
    if (this.showAdjustButton && this.position == ValuePosition.center) {
      mRrect = RRect.fromRectAndCorners(minusRect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0));
      aRrect = RRect.fromRectAndCorners(addRect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0));
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

      painter.paint(canvas, Offset(borderStartX+spareSpace,-15));
      Rect numberRect =
      Rect.fromLTWH(borderStartX, -20, borderWidth, 20);
      RRect numberRrect = RRect.fromRectAndCorners(numberRect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0));
      canvas.drawRRect(numberRrect, this.pen);
    }
    if(this.showAdjustButton){
      rrect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(radius[2]),
          bottomRight: Radius.circular(radius[3]));
    }else if(this.showNumber){
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ValueBarBackgroundPainter extends CustomPainter {
  List<double> radius;
  Color color;
  String str;
  bool showAdjustButton;
  bool showNumber;
  Paint pen;
  ValueBarBackgroundPainter(
      {@required this.radius,
      this.color = Colors.black38,
      this.showAdjustButton = true,
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
    if (this.showAdjustButton) {
      rrect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(radius[2]),
          bottomRight: Radius.circular(radius[3]));
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
    } else {
      rrect = RRect.fromRectAndCorners(rect,
          topLeft: Radius.circular(radius[0]),
          topRight: Radius.circular(radius[1]),
          bottomLeft: Radius.circular(radius[2]),
          bottomRight: Radius.circular(radius[3]));
    }
    if(this.showNumber){

      TextPainter painter = TextPainter(
          maxLines: 1,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: this.str,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              )))..layout(minWidth: 0.0,maxWidth: double.infinity);
      double textWidth = painter.width;
      double spareSpace = 10;
      double borderWidth = textWidth+2*spareSpace;
      double borderStartX = size.width / 2 - textWidth / 2 -spareSpace;
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
    canvas.drawRRect(rrect, this.pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

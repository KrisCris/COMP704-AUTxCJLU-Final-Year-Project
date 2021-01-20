import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class LinePainter extends CustomPainter {
  Paint pen;
  double k;
  double lineGap;
  double lineWidth;
  double moveVal;
  double xBias;

  LinePainter(
      {@required Color color,
        double k = 1,
        double lineWidth = 8,
        double lineGap = 15,
        double moveVal=0})
      : assert(color != null) {
    this.lineWidth = lineWidth;
    this.lineGap = lineGap;
    this.k = k;
    this.moveVal = moveVal;
    this.pen = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = this.lineWidth;
  }
  @override
  void paint(Canvas canvas, Size size) {
    if(k > 0){
      for(double x = -(size.height/this.k + this.lineWidth) + this.moveVal;(x-size.height/k)<=size.width;x+=this.lineGap){
        Offset startPoint = Offset(x,0);
        Offset endPoint = Offset(x-size.height/k,size.height);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    }else if(k < 0){
      for(double x = (size.height/this.k  + this.lineWidth) + this.moveVal;(x + size.height/k)<=size.width;x+=this.lineGap){
        Offset startPoint = Offset(x,size.height);
        Offset endPoint = Offset(x+size.height/k,0);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    }else if(k == 0){
      for(double y = 0; y<=size.height;y+=lineGap){
        Offset startPoint = Offset(0,y);
        Offset endPoint = Offset(size.width,y);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    }else if(k >= 10000000){
      for(double x = -this.lineGap - this.lineWidth + this.moveVal; x <= size.width;x += this.lineGap){
        Offset startPoint = Offset(x,0);
        Offset endPoint = Offset(x,size.height);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
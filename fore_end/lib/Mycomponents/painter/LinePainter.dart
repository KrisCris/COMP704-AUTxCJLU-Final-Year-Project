import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contextPainter.dart';

class LinePainter extends ContextPainter {
  Paint pen;
  double k;
  double lineGap;
  double lineWidth;
  double moveVal;
  double xBias;
  bool clip;
  LinePainter(
      {Color color,
      double k = 1,
      double lineWidth = 8,
      double lineGap = 15,
      BuildContext context,
      bool clip = false,
      double moveVal = 0}) {
    if (color == null) {
      color = Colors.black12;
    }
    this.lineWidth = lineWidth;
    this.lineGap = lineGap;
    this.context = context;
    this.k = k;
    this.moveVal = moveVal;
    this.clip = clip;
    this.pen = Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = this.lineWidth;
  }
  @override
  void paint(Canvas canvas, Size size) {
    double angle = math.atan(k);
    double extraHeight = math.sin(angle) * this.lineWidth / k;
    size = this.adjustSize(size);
    if (k > 0) {
      for (double x = -(size.height / this.k + this.lineWidth) + this.moveVal;
          (x - size.height / k) <= size.width;
          x += this.lineGap) {
        Offset startPoint = Offset(x, 0 - extraHeight);
        Offset endPoint =
            Offset(x - size.height / k, size.height + extraHeight);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    } else if (k < 0) {
      for (double x = (size.height / this.k + this.lineWidth) + this.moveVal;
          (x + size.height / k) <= size.width;
          x += this.lineGap) {
        Offset startPoint = Offset(x, size.height + extraHeight);
        Offset endPoint = Offset(x + size.height / k, 0 - extraHeight);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    } else if (k == 0) {
      for (double y = 0; y <= size.height; y += lineGap) {
        Offset startPoint = Offset(0, y);
        Offset endPoint = Offset(size.width, y);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    } else if (k >= 10000000) {
      for (double x = -this.lineGap - this.lineWidth + this.moveVal;
          x <= size.width;
          x += this.lineGap) {
        Offset startPoint = Offset(x, 0);
        Offset endPoint = Offset(x, size.height);
        canvas.drawLine(startPoint, endPoint, this.pen);
      }
    }
    if (this.clip) {
      canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

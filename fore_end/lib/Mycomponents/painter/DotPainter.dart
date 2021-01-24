import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DotPainter extends CustomPainter {
  Paint pen;
  double k;
  double b;
  double dotGap;
  double moveVal;

  DotPainter(
      {Color color=Colors.black12,
      double k = 1,
      double b = 0,
      double dotSize = 8,
      double dotGap = 15,
      double moveVal=0}) {
    this.dotGap = dotGap;
    this.k = k;
    this.b = b;
    this.moveVal = moveVal;
    this.pen = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = dotSize;
  }
  @override
  void paint(Canvas canvas, Size size) {
    List<Offset> points = [];
    double angle = math.atan(this.k);
    double xGap = this.dotGap * math.cos(angle);
    double yGap = this.dotGap * math.sin(angle);
    double xMove = this.moveVal * math.cos(angle);
    double yMove = this.moveVal * math.sin(angle);
    for (double xbias = 0; xbias < size.width; xbias += 2 * xGap) {
      for (double x = -xGap + xbias + xMove, y = -yGap + yMove;
          x <= size.width && y <= size.height;
          x += xGap, y += yGap) {
        points.add(Offset(x, size.height - y));
      }
    }
    canvas.drawPoints(PointMode.points, points, this.pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

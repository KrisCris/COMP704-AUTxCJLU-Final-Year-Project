import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';

class DotPainter extends CustomPainter {
  Paint pen;
  double k;
  double b;
  double dotGap;
  double moveVal;
  BuildContext context;

  DotPainter(
      {Color color=Colors.black12,
      double k = 1,
      double b = 0,
      double dotSize = 8,
      double dotGap = 15,
        this.context,
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
    Size configuredSize;
    double width = size.width;
    double height = size.height;
    if(width == 0){
      if(this.context != null){
        width = context.size.width;
      }else{
        width = ScreenTool.partOfScreenWidth(1);
      }
    }
    if(height == 0){
      if(this.context != null){
        height = context.size.height;
      }else{
        height = width;
      }

    }
    configuredSize = new Size(width,height);

    double angle = math.atan(this.k);
    double xGap = this.dotGap * math.cos(angle);
    double yGap = this.dotGap * math.sin(angle);
    double xMove = this.moveVal * math.cos(angle);
    double yMove = this.moveVal * math.sin(angle);
    for (double xbias = 0; xbias < configuredSize.width; xbias += 2 * xGap) {
      for (double x = -xGap + xbias + xMove, y = -yGap + yMove;
          x <= configuredSize.width && y <= configuredSize.height;
          x += xGap, y += yGap) {
        points.add(Offset(x, configuredSize.height - y));
      }
    }
    canvas.drawPoints(PointMode.points, points, this.pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

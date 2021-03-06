import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Utils/MyAnimation.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/painters/contextPainter.dart';

class DotPainter extends ContextPainter {
  Paint pen;
  double k;
  double b;
  double dotGap;
  final TweenAnimation<double> moveAnimation;

  DotPainter(
      {Color color = Colors.black12,
      double k = 1,
      double b = 0,
      double dotSize = 8,
      double dotGap = 15,
      BuildContext context,
      this.moveAnimation})
      : super(repaint: moveAnimation) {
    this.dotGap = dotGap;
    this.k = k;
    this.b = b;
    this.context = context;
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
    if (this.context != null) {
      width = context.size.width;
    } else {
      if (width == 0) width = ScreenTool.partOfScreenWidth(1);
    }
    if (this.context != null) {
      height = context.size.height;
    } else {
      if (height == 0) height = width;
    }
    configuredSize = new Size(width, height);
    double moveVal = 0;
    if (this.moveAnimation != null) {
      moveVal = moveAnimation.value;
    }
    double angle = math.atan(this.k);
    double xGap = this.dotGap * math.cos(angle);
    double yGap = this.dotGap * math.sin(angle);
    double xMove = moveVal * math.cos(angle);
    double yMove = moveVal * math.sin(angle);
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
  bool shouldRepaint(covariant DotPainter oldDelegate) {
    if (oldDelegate.moveAnimation == null) {
      return false;
    }
    return oldDelegate.moveAnimation.value != this.moveAnimation.value;
  }
}

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropLinePainter extends CustomPainter {
  Paint painter;
  double radians;
  double yOffset;
  int lineNum;
  double heightPercent;

  DropLinePainter(
      {Color color = Colors.blueGrey,
      double radians = math.pi / 4,
      double yOffset = 0,
      int lineNum = 6,
      double strokeWidth = 8,
      double heightPercent = 0.75}) {
    // dropping line properties
    this.radians = radians;
    this.lineNum = lineNum;
    this.yOffset = yOffset;
    this.heightPercent = heightPercent;

    // painter properties
    this.painter = Paint();
    this.painter.color = color;
    this.painter.strokeCap = StrokeCap.round;
    this.painter.isAntiAlias = true;
    this.painter.strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    double gap =
        (width - this.lineNum * this.painter.strokeWidth) / (this.lineNum + 1);
    double slope = math.tan(this.radians);
    if (slope > 0) {
      double xPos = gap + this.painter.strokeWidth / 2;
      for (int ln = 0; ln < lineNum; ln++) {
        // print a line
        double baseY = -slope * xPos + yOffset;
        Offset topPoint = Offset(xPos, baseY - this.heightPercent * height);
        Offset bottomPoint = Offset(xPos, baseY);
        canvas.drawLine(bottomPoint, topPoint, this.painter);
        // move to the next one
        xPos += this.painter.strokeWidth + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

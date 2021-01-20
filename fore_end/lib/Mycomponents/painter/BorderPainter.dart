import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';

class BorderPainter extends CustomPainter {
  double leftEdgeEmptySize;
  double rightEdgeEmptySize;
  double topEdgeEmptySize;
  double bottomEdgeEmptySize;
  List<double> borderRadius;
  Paint pen;
  BorderPainter(
      {@required List<double> borderRadius_LT_LB_RT_RB,
      List<double> edgeEmptySize,
      Color color = Colors.white,
      double borderWidth = 3.0}) {
    if (edgeEmptySize == null) {
      edgeEmptySize = [0, 0, 0, 0];
    }
    this.leftEdgeEmptySize = edgeEmptySize[0];
    this.topEdgeEmptySize = edgeEmptySize[1];
    this.rightEdgeEmptySize = edgeEmptySize[2];
    this.bottomEdgeEmptySize = edgeEmptySize[3];
    this.borderRadius = borderRadius_LT_LB_RT_RB;
    this.pen = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = borderWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.leftEdgeEmptySize = this.leftEdgeEmptySize < 1
        ? this.leftEdgeEmptySize * size.height
        : this.leftEdgeEmptySize;
    this.topEdgeEmptySize = this.topEdgeEmptySize < 1
        ? this.topEdgeEmptySize * size.width
        : this.topEdgeEmptySize;
    this.rightEdgeEmptySize = this.rightEdgeEmptySize < 1
        ? this.rightEdgeEmptySize * size.height
        : this.rightEdgeEmptySize;
    this.bottomEdgeEmptySize = this.bottomEdgeEmptySize < 1
        ? this.bottomEdgeEmptySize * size.width
        : this.bottomEdgeEmptySize;

    Rect rectLT = Rect.fromCircle(
        center: Offset(borderRadius[0], borderRadius[0]),
        radius: borderRadius[0]);
    Rect rectLB = Rect.fromCircle(
        center: Offset(borderRadius[1], size.height - borderRadius[1]),
        radius: borderRadius[1]);
    Rect rectRT = Rect.fromCircle(
        center: Offset(size.width - borderRadius[2], borderRadius[2]),
        radius: borderRadius[2]);
    Rect rectRB = Rect.fromCircle(
        center:
            Offset(size.width - borderRadius[3], size.height - borderRadius[3]),
        radius: borderRadius[3]);
    canvas.drawArc(rectLT, pi, pi / 2, false, pen);
    canvas.drawArc(rectLB, pi / 2, pi / 2, false, pen);
    canvas.drawArc(rectRT, -pi / 2, pi / 2, false, pen);
    canvas.drawArc(rectRB, pi / 2, -pi / 2, false, pen);
    double leftLine = size.height - borderRadius[0] - borderRadius[1];
    double rightLine = size.height - borderRadius[2] - borderRadius[3];
    double topLine = size.width - borderRadius[0] - borderRadius[2];
    double bottomLine = size.width - borderRadius[1] - borderRadius[3];

    //绘制左边框
    canvas.drawLine(
        Offset(0, borderRadius[0]),
        Offset(0, borderRadius[0] + (leftLine / 2) - (leftEdgeEmptySize / 2)),
        pen);
    canvas.drawLine(
        Offset(0, borderRadius[0] + leftLine / 2 + (leftEdgeEmptySize / 2)),
        Offset(0, borderRadius[0] + leftLine),
        pen);

    //绘制右边框
    canvas.drawLine(
        Offset(size.width, borderRadius[2]),
        Offset(size.width,
            borderRadius[2] + (rightLine / 2) - (rightEdgeEmptySize / 2)),
        pen);
    canvas.drawLine(
        Offset(size.width,
            borderRadius[2] + rightLine / 2 + (rightEdgeEmptySize / 2)),
        Offset(size.width, borderRadius[2] + rightLine),
        pen);

    //绘制上边框
    canvas.drawLine(Offset(borderRadius[0], 0),
        Offset(borderRadius[0] + topLine / 2 - topEdgeEmptySize / 2, 0), pen);
    canvas.drawLine(
        Offset(borderRadius[0] + topLine / 2 + topEdgeEmptySize / 2, 0),
        Offset(size.width - borderRadius[2], 0),
        pen);

    //绘制下边框
    canvas.drawLine(
        Offset(borderRadius[1], size.height),
        Offset(borderRadius[1] + bottomLine / 2 - bottomEdgeEmptySize / 2,
            size.height),
        pen);
    canvas.drawLine(
        Offset(borderRadius[1] + bottomLine / 2 + bottomEdgeEmptySize / 2,
            size.height),
        Offset(size.width - borderRadius[3], size.height),
        pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

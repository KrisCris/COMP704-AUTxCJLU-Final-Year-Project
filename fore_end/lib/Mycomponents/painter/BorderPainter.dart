import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';

class BorderPainter extends CustomPainter {
  double leftEdgeEmptySize;
  double rightEdgeEmptySize;
  double topEdgeEmptySize;
  double bottomEdgeEmptySize;
  double borderDistance;
  bool showBorder;
  List<double> borderRadius;
  Paint pen;
  BorderPainter(
      {@required List<double> borderRadius_LT_LB_RT_RB,
      List<double> edgeEmptySize,
      Color color = Colors.white,
        this.showBorder=true,
        double borderDistance = 0,
      double borderWidth = 3.0}) {
    if (edgeEmptySize == null) {
      edgeEmptySize = [0, 0, 0, 0];
    }
    this.leftEdgeEmptySize = edgeEmptySize[0];
    this.topEdgeEmptySize = edgeEmptySize[1];
    this.rightEdgeEmptySize = edgeEmptySize[2];
    this.bottomEdgeEmptySize = edgeEmptySize[3];
    this.borderRadius = borderRadius_LT_LB_RT_RB;
    this.borderDistance = borderDistance;
    this.pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = borderWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(!this.showBorder)return;

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
        center: Offset(borderRadius[0]-borderDistance, borderRadius[0]-borderDistance),
        radius: borderRadius[0]);
    Rect rectLB = Rect.fromCircle(
        center: Offset(borderRadius[1]-borderDistance, size.height - borderRadius[1]+borderDistance),
        radius: borderRadius[1]);
    Rect rectRT = Rect.fromCircle(
        center: Offset(size.width - borderRadius[2]+borderDistance, borderRadius[2]-borderDistance),
        radius: borderRadius[2]);
    Rect rectRB = Rect.fromCircle(
        center:
            Offset(size.width - borderRadius[3]+borderDistance, size.height - borderRadius[3]+borderDistance),
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
        Offset(0-borderDistance, borderRadius[0]-borderDistance),
        Offset(0-borderDistance, borderRadius[0] + (leftLine / 2) - (leftEdgeEmptySize / 2)),
        pen);
    canvas.drawLine(
        Offset(0-borderDistance, borderRadius[0] + leftLine / 2 + (leftEdgeEmptySize / 2)),
        Offset(0-borderDistance, borderRadius[0] + leftLine+borderDistance),
        pen);

    //绘制右边框
    canvas.drawLine(
        Offset(size.width+borderDistance, borderRadius[2]-borderDistance),
        Offset(size.width+borderDistance,
            borderRadius[2] + (rightLine / 2) - (rightEdgeEmptySize / 2)),
        pen);
    canvas.drawLine(
        Offset(size.width+borderDistance,
            borderRadius[2] + rightLine / 2 + (rightEdgeEmptySize / 2)),
        Offset(size.width+borderDistance, borderRadius[2] + rightLine+borderDistance),
        pen);

    //绘制上边框
    canvas.drawLine(Offset(borderRadius[0]-borderDistance, 0-borderDistance),
        Offset(borderRadius[0] + topLine / 2 - topEdgeEmptySize / 2, 0-borderDistance), pen);
    canvas.drawLine(
        Offset(borderRadius[0] + topLine / 2 + (topEdgeEmptySize / 2), 0-borderDistance),
        Offset(size.width - borderRadius[2]+borderDistance, 0-borderDistance),
        pen);

    //绘制下边框
    canvas.drawLine(
        Offset(borderRadius[1]-borderDistance, size.height+borderDistance),
        Offset(borderRadius[1] + bottomLine / 2 - bottomEdgeEmptySize / 2,
            size.height+borderDistance),
        pen);
    canvas.drawLine(
        Offset(borderRadius[1] + bottomLine / 2 + bottomEdgeEmptySize / 2,
            size.height+borderDistance),
        Offset(size.width - borderRadius[3]+borderDistance, size.height+borderDistance ),
        pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this.showBorder;
  }
}

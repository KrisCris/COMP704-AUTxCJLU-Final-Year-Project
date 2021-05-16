import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnderLinePainter extends CustomPainter {
  double bottomDistance;
  double lineLength;
  Paint pen;

  UnderLinePainter(
      {this.bottomDistance = 0,
      this.lineLength = 0,
      double width = 3,
      Color color = Colors.white}) {
    this.pen = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (lineLength == 0) return;
    Offset startPoint = Offset(0, size.height + this.bottomDistance);
    Offset endPoint =
        Offset(this.lineLength, size.height + this.bottomDistance);
    canvas.drawLine(startPoint, endPoint, pen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

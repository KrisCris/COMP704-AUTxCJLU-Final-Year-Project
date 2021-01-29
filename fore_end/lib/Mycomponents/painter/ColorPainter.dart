import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/rendering/custom_paint.dart';
import 'package:fore_end/Mycomponents/painter/contextPainter.dart';

class ColorPainter extends ContextPainter {
  Paint pen;
  ContextPainter nextPainter;
  double borderRadius;
  double leftExtra;
  double rightExtra;
  double topExtra;
  double bottomExtra;

  ColorPainter(
      {Color color,
      this.borderRadius,
      this.bottomExtra = 0,
      this.rightExtra = 0,
      this.topExtra = 0,
      this.leftExtra = 0,
      BuildContext context,
      ContextPainter contextPainter}) {
    this.context = context;
    this.nextPainter = contextPainter;
    if (this.nextPainter != null) {
      this.nextPainter.setContext(context);
    }
    this.pen = Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    size = adjustSize(size);
    if (this.borderRadius != null) {
      RRect rect = RRect.fromLTRBR(
          0 - leftExtra,
          0 - topExtra,
          size.width + rightExtra,
          size.height + bottomExtra,
          Radius.circular(this.borderRadius));
      canvas.drawRRect(rect, pen);
    } else {
      Rect rect = Rect.fromLTRB(0 - leftExtra, 0 - topExtra,
          size.width + rightExtra, size.height + bottomExtra);
      canvas.drawRect(rect, pen);
    }
    if (this.nextPainter != null) {
      this.nextPainter.paint(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

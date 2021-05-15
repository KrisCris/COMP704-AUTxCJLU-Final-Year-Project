import 'package:flutter/cupertino.dart';

abstract class ContextPainter extends CustomPainter {
  BuildContext context;

  ContextPainter({Listenable repaint, this.context}) : super(repaint: repaint);

  void setContext(BuildContext ctx) {
    this.context = ctx;
  }

  Size adjustSize(Size size) {
    double height = size.height;
    double width = size.width;
    if (height == 0) {
      if (context != null) {
        height = context.size.height;
      }
    }
    if (width == 0) {
      if (context != null) {
        width = context.size.width;
      }
    }
    return new Size(width, height);
  }
}

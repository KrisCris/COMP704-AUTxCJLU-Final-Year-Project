import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';

import 'contextPainter.dart';

class CirclePainter extends ContextPainter{
  TweenAnimation animation;
  Paint pen;
  CirclePainter({this.animation,BuildContext context,Color color=Colors.blueAccent,double width=5}):super(repaint: animation,context: context){
    this.pen = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    size = this.adjustSize(size);
    double percent = this.animation?.value ?? 0;
    canvas.drawArc(new Rect.fromCircle(
        center: Offset(size.width/2,size.height/2),
        radius: size.width / 2
    ), pi/2, 2*pi*percent, false, this.pen);
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    if (oldDelegate.animation == null) {
      return false;
    }
    return oldDelegate.animation.value != this.animation.value;
  }
}
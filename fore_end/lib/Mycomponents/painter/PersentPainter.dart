import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/Mycomponents/painter/contextPainter.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PersentBar.dart';
import 'package:image/image.dart';

class PersentPainter extends ContextPainter {
  TweenAnimation<PersentSection> animation;
  List<PersentSection> sections;
  int changingIndex;
  Paint pen;
  PersentPainter(
      {BuildContext context,
      TweenAnimation animation,
      this.changingIndex,
      List<PersentSection> sections})
      : super(context: context, repaint: animation) {
    this.animation = animation;
    this.sections = sections;
    pen = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
  }
  @override
  void paint(Canvas canvas, Size size) {
    size = adjustSize(size);
    pen.strokeWidth = context.size.height;
    double lastPersent = 0;
    int idx = 0;
    for (PersentSection sec in sections) {
      ///对正在变化的进度条做动态绘制
      if (idx == changingIndex) {
        if (animation.value.persent <= 0) continue;

        ///此进度条section的开始位置
        double startPos = lastPersent * size.width + pen.strokeWidth / 2;

        ///此进度条section的结束位置
        double endPersent = animation.value.persent;

        ///判断是否超过了此进度条。若超过，不绘制超出部分的长度
        if (endPersent + lastPersent > 1) {
          endPersent = 1 - lastPersent;
        }

        double endPos =
            (lastPersent + endPersent) * size.width - pen.strokeWidth / 2;
        if (endPos < startPos) endPos = startPos;

        this.pen.color = animation.value.color;
        canvas.drawLine(Offset(startPos, size.height / 2),
            Offset(endPos, size.height / 2), pen);
        lastPersent += endPersent;
      } else {
        ///绘制没有变化的进度条section
        if (sec.persent <= 0) continue;

        ///此进度条section的开始位置
        double startPos = lastPersent * size.width + pen.strokeWidth / 2;

        ///此进度条section的结束位置
        double endPersent = sec.persent;

        ///计算是否超过了此进度条。若超过，不绘制超出部分的长度
        if (endPersent + lastPersent > 1) {
          endPersent = 1 - lastPersent;
        }
        double endPos =
            (lastPersent + endPersent) * size.width - pen.strokeWidth / 2;
        if (endPos < startPos) endPos = startPos;
        this.pen.color = sec.color;
        canvas.drawLine(Offset(startPos, size.height / 2),
            Offset(endPos, size.height / 2), pen);
        lastPersent += endPersent;
      }
      idx++;
    }
  }

  @override
  bool shouldRepaint(covariant PersentPainter oldDelegate) {
    if (oldDelegate.animation == null) {
      return false;
    }

    return oldDelegate.animation.value != this.animation.value;
  }
}

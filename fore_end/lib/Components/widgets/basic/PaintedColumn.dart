import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/painters/ColorPainter.dart';
import 'package:fore_end/Components/painters/contextPainter.dart';

class PaintedColumn extends StatelessWidget {
  ///宽度
  double width;

  ///背景颜色
  Color backgroundColor;

  ///圆角半径
  double borderRadius;

  ///子组件
  List<Widget> children;

  ///主轴对齐方式
  MainAxisAlignment mainAxisAlignment;

  ///绘制类
  ContextPainter forePainter;
  PaintedColumn(
      {@required this.children,
      @required this.forePainter,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.borderRadius = 5,
      Color backgroundColor,
      double width = 0.7}) {
    if (backgroundColor == null) {
      backgroundColor = Colors.white;
    }
    this.backgroundColor = backgroundColor;
    this.width = ScreenTool.partOfScreenWidth(width);
  }
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.borderRadius),
        child: Stack(
          children: [
            CustomPaint(
              painter: ColorPainter(
                  color: this.backgroundColor,
                  context: context,
                  contextPainter: this.forePainter),
              child: Container(
                width: this.width,
                child: Column(
                  mainAxisAlignment: this.mainAxisAlignment,
                  children: this.children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

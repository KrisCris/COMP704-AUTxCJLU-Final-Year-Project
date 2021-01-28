import 'package:flutter/cupertino.dart';
import 'package:fore_end/Mycomponents/painter/contextPainter.dart';

class PaintedColumn extends StatelessWidget{
  ///宽度
  double _width;

  ///背景颜色
  Color _backgroundColor;

  ///圆角半径
  double _borderRadius;

  ///子组件
  List<Widget> children;

  ///主轴对齐方式
  MainAxisAlignment mainAxisAlignment;

  ///绘制类
  ContextPainter forePainter;

  @override
  Widget build(BuildContext context) {
    forePainter.setContext(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(this._borderRadius),
      child: Stack(
        children: [
          Container(
            width: this._width,
            color: _backgroundColor,
            child: Column(
              mainAxisAlignment: this.mainAxisAlignment,
              children: this.children,
            ),
          ),
          CustomPaint(
            foregroundPainter: forePainter,
            child: Container(),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/painter/ColorPainter.dart';
import 'package:fore_end/Mycomponents/painter/DotPainter.dart';

class DotColumn extends StatefulWidget{
  ///卡片的宽度
  double _width;

  ///卡片的高度
  double _height;

  ///背景颜色
  Color _backgroundColor;

  ///绘制色
  Color _paintColor;

  ///圆角半径
  double _borderRadius;

  ///斑点移动动画的持续时间
  int _dotAnimationDuration;

  ///距离卡片左边的额外间距
  double _paddingLeft;

  ///距离卡片右边的额外间距
  double _paddingRight;

  ///前景的斑点间距
  double _dotGap;

  ///子组件
  List<Widget> children;

  ///主轴对齐方式
  MainAxisAlignment mainAxisAlignment;

  ///被选中时执行的函数
  List<Function> _onTap;

  DotColumn(
      {double width = 300,
        double height = 200,
        Color backgroundColor,
        Color paintColor = Colors.black12,
        int dotAnimationDuration = 800,
        double dotGap = 15,
        this.children,
        this.mainAxisAlignment = MainAxisAlignment.center,
        double paddingLeft = 0,
        double paddingRight = 0,
        double borderRadius = 0,
        Function onTap}) {
    this._width = ScreenTool.partOfScreenWidth(width);
    this._height = ScreenTool.partOfScreenHeight(height);
    if(backgroundColor == null){
      backgroundColor = Color(0xFFF1F1F1);
    }
    this._dotAnimationDuration = dotAnimationDuration;
    this._paddingLeft = paddingLeft;
    this._paddingRight = paddingRight;
    this._paintColor = paintColor;
    this._backgroundColor = backgroundColor;
    if(onTap != null){
      this._onTap = [onTap];
    }else{
      this._onTap = [];
    }
    this._dotGap = dotGap;
    this._borderRadius = borderRadius;
  }
  @override
  State<StatefulWidget> createState() {
    return new DotColumnState();
  }
}

class DotColumnState extends State<DotColumn>
with TickerProviderStateMixin{
  TweenAnimation<double> dotMoveAnimation;

  @override
  void didUpdateWidget(covariant DotColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    dotMoveAnimation.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    dotMoveAnimation = new TweenAnimation();

    dotMoveAnimation.initAnimation(
        0.0, widget._dotGap, widget._dotAnimationDuration, this, null);
    dotMoveAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        dotMoveAnimation.initAnimation(
            0.0, widget._dotGap, widget._dotAnimationDuration, this, null);
        dotMoveAnimation.forward();
      }
    });
    dotMoveAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowContent = [];
    rowContent.add(SizedBox(width: widget._paddingLeft));
    rowContent.add(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: widget.children,
    ));
    rowContent.add(SizedBox(width: widget._paddingRight));
    Widget res = ClipRRect(
          borderRadius: BorderRadius.circular(widget._borderRadius),
            child: Stack(
              children: [
                CustomPaint(
                  foregroundPainter: ColorPainter(
                      color: widget._backgroundColor,
                      context:context,
                      animation: this.dotMoveAnimation,
                      contextPainter: DotPainter(
                          color: widget._paintColor,
                          dotGap: widget._dotGap,
                          context: context,
                          moveAnimation: this.dotMoveAnimation),
                  ),
                  child: Container(
                    width: widget._width,
                  ),
                ),
                Container(
                  // alignment: Alignment.center,
                  // color: widget._backgroundColor,
                  width: widget._width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: rowContent,
                  ),
                ),
              ],
            ),
        );

    return Column(
      children: [res],
    );
  }
}
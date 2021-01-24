import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/painter/DotPainter.dart';
import 'package:fore_end/interface/Valueable.dart';

///卡片选择器，功能类似于方框勾选组件
class CardChooser<T> extends StatefulWidget
with ValueableWidgetMixIn<T>{
  ///卡片的宽度
  double _width;

  ///卡片的高度
  double _height;

  ///圆角边框半径
  double _borderRadius;

  ///卡片左边显示的icon,若设置为null,将不显示icon
  IconData _icon;

  ///卡片上的文字
  String _text;

  ///背景颜色
  Color _backgroundColor;

  ///绘制色
  Color _paintColor;

  ///文字颜色
  Color _textColor;

  ///文字尺寸
  double _textSize;

  ///斑点移动动画的持续时间
  int _dotAnimationDuration;

  ///尺寸变化动画持续时间
  int _sizeChangeAnimationDuration;

  ///监听是否被选中
  ValueNotifier<bool> _chosen;

  ///文字和icon距离卡片左边的额外间距
  double _paddingLeft;

  ///文字和icon距离卡片右边的额外间距
  double _paddingRight;

  ///文字和icon之间的间距，若 [_icon] 设置为null, 该属性将不起作用
  double _gapBetweenIconAndText;

  ///前景的斑点间距
  double _dotGap;

  ///被选中时执行的函数
  List<Function> _onTap;

  CardChooser(
      {double width = 300,
      double height = 200,
        T value,
      IconData icon,
      @required String text,
      Color backgroundColor = Colors.white,
      Color paintColor = Colors.black26,
      Color textColor = Colors.black,
      double textSize = 12,
      int dotAnimationDuration = 800,
      int sizeChangeAnimationDuration = 70,
      double dotGap = 15,
      double paddingLeft = 0,
      double paddingRight = 0,
      double borderRadius = 0,
      double gapBetweenIconAndText = 50,
      Function onTap})
      : assert(text != null) {
    this._width = ScreenTool.partOfScreenWidth(width);
    this._height = ScreenTool.partOfScreenHeight(height);
    this._icon = icon;
    this._text = text;
    this._dotAnimationDuration = dotAnimationDuration;
    this._paddingLeft = paddingLeft;
    this._paddingRight = paddingRight;
    this._paintColor = paintColor;
    this._textColor = textColor;
    this._textSize = textSize;
    this._backgroundColor = backgroundColor;
    this._gapBetweenIconAndText = gapBetweenIconAndText;
    this._sizeChangeAnimationDuration = sizeChangeAnimationDuration;
    if(onTap != null){
      this._onTap = [onTap];
    }else{
      this._onTap = [];
    }
    this._dotGap = dotGap;
    this._borderRadius = borderRadius;
    this._chosen = ValueNotifier<bool>(false);
    this.widgetValue = ValueNotifier<T>(value);
  }
  @override
  State<StatefulWidget> createState() {
    return new CardChooserState();
  }

  void setOnTap(Function f) {
    this._onTap.add(f);
  }

  void setChosen() {
    this._chosen.value = true;
  }

  void setUnChosen() {
    this._chosen.value = false;
  }
}

class CardChooserState extends State<CardChooser>
    with TickerProviderStateMixin, ValueableStateMixIn {
  TweenAnimation<double> dotMoveAnimation;
  TweenAnimation<double> sizeChangeAnimation;
  TweenAnimation<double> fontSizeAnimation;
  TweenAnimation<double> shadowSizeAnimation;

  @override
  void didUpdateWidget(covariant CardChooser oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.initChosenNotifier();
  }

  @override
  void dispose() {
    dotMoveAnimation.dispose();
    sizeChangeAnimation.dispose();
    fontSizeAnimation.dispose();
    shadowSizeAnimation.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    fontSizeAnimation = new TweenAnimation();
    dotMoveAnimation = new TweenAnimation();
    shadowSizeAnimation = new TweenAnimation();
    sizeChangeAnimation = new TweenAnimation();

    fontSizeAnimation.initAnimation(widget._textSize, widget._textSize + 6,
        widget._sizeChangeAnimationDuration, this, () {
      setState(() {});
    });
    sizeChangeAnimation
        .initAnimation(1.0, 0.9, widget._sizeChangeAnimationDuration, this, () {
      setState(() {});
    });
    dotMoveAnimation.initAnimation(
        0.0, widget._dotGap, widget._dotAnimationDuration, this, () {
      setState(() {});
    });
    dotMoveAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        dotMoveAnimation.initAnimation(
            0.0, widget._dotGap, widget._dotAnimationDuration, this, () {
          setState(() {});
        });
        dotMoveAnimation.forward();
      }
    });
    this.initChosenNotifier();
  }

  void initChosenNotifier() {
    widget._chosen.addListener(() {
      if (widget._chosen.value == false) {
        dotMoveAnimation.stop();
        fontSizeAnimation.reverse();
      } else {
        fontSizeAnimation.beginAnimation();
        dotMoveAnimation.beginAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rowContent = [];
    rowContent.add(SizedBox(width: widget._paddingLeft));
    if (widget._icon != null) {
      rowContent.add(Icon(widget._icon, color: Colors.black));
      rowContent.add(SizedBox(width: widget._gapBetweenIconAndText));
    }
    rowContent.add(Text(widget._text,
        textDirection: TextDirection.ltr,
        style: TextStyle(
            fontSize: fontSizeAnimation.getValue(),
            color: widget._textColor,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.bold)));

    rowContent.add(SizedBox(width: widget._paddingRight));
    Widget res = GestureDetector(
        onTapDown: (TapDownDetails dt) {
          this.sizeChangeAnimation.beginAnimation();
        },
        onTapUp: (TapUpDetails dt) {
          widget._chosen.value = true;
          if (widget._onTap.isNotEmpty) {
            for(Function f in widget._onTap){
              f();
            }
          }
          this.sizeChangeAnimation.reverse();
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget._borderRadius),
          child: Container(
            width: widget._width * sizeChangeAnimation.getValue(),
            height: widget._height * sizeChangeAnimation.getValue(),
            color: widget._backgroundColor,
            child: Stack(
              children: [
                CustomPaint(
                  foregroundPainter: DotPainter(
                      color: widget._paintColor,
                      dotGap: widget._dotGap,
                      moveVal: this.dotMoveAnimation.getValue()),
                  child: Container(
                    width: widget._width * sizeChangeAnimation.getValue(),
                    height: widget._height * sizeChangeAnimation.getValue(),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: rowContent,
                  ),
                )
              ],
            ),
          ),
        ));

    return res;
  }

  @override
  void onChangeValue() {
    return;
  }
}

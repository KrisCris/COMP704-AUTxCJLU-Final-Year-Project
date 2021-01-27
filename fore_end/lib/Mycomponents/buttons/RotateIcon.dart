import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'dart:math' as math;

///简化版的IconButton,专门用于需要旋转的图标，没有很复杂的功能
///
class RotateIcon extends StatefulWidget {
  ///旋转角度
  double angle;

  ///icon图标
  IconData icon;

  ///旋转动画的持续时间
  int rotateTime;

  ///icon的尺寸
  double iconSize;

  ///icon的颜色
  Color iconColor;

  ///点击事件
  Function onTap;

  ///是否旋转
  ValueNotifier<bool> isRotate;

  RotateIcon(
      {Key key,
      this.onTap,
      this.angle = math.pi,
      @required this.icon,
      this.rotateTime = 150,
      this.iconSize = 12,
      this.iconColor = Colors.blue})
      : super(key: key){
    this.isRotate = ValueNotifier(false);
  }

  void rotate(){
    this.isRotate.value = !this.isRotate.value;
  }

  @override
  State<StatefulWidget> createState() {
    return new RotateIconState();
  }
}

///RotateIcon的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///
class RotateIconState extends State<RotateIcon> with TickerProviderStateMixin {
  TweenAnimation<double> angleAnimation = new TweenAnimation<double>();
  bool fowardRotating = false;

  @override
  void didUpdateWidget(covariant RotateIcon oldWidget) {
    // TODO: implement didUpdateWidget
    widget.isRotate = oldWidget.isRotate;
  }
  @override
  void initState() {
    super.initState();
    widget.isRotate.addListener(() {
      this.rotate();
    });
    //初始化动画
    this.angleAnimation.initAnimation(0, widget.angle, widget.rotateTime, this,
        () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this._innerOnTap,
        child: Transform.rotate(
          angle: this.angleAnimation.getValue(),
          child: Icon(
            widget.icon,
            color: Colors.blue,
          ),
        ));
  }

  ///当按钮被点击的时候执行动画效果，以及设定的 [onTap] 函数
  void _innerOnTap() {
    if (this.fowardRotating) {
      this.fowardRotating = false;
      this.angleAnimation.reverse();
    } else {
      this.fowardRotating = true;
      this.angleAnimation.forward();
    }
    if(widget.onTap != null){
      widget.onTap();
    }
  }

  void rotate(){
    if (this.fowardRotating) {
      this.fowardRotating = false;
      this.angleAnimation.reverse();
    } else {
      this.fowardRotating = true;
      this.angleAnimation.forward();
    }
  }
}

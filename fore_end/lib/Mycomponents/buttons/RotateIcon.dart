import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'dart:math' as math;

import 'package:fore_end/MyTool/util/MyTheme.dart';

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

  bool autoPlay;
  bool recycle;

  ///是否旋转
  ValueNotifier<bool> isRotate;

  RotateIcon(
      {Key key,
      this.onTap,
      this.angle = math.pi,
      this.autoPlay = false,
      this.recycle = false,
      @required this.icon,
      this.rotateTime = 150,
      this.iconSize = 12,
      Color iconColor})
      : super(key: key) {
    this.isRotate = ValueNotifier(false);
    this.iconColor =
        MyTheme.convert(ThemeColorName.NormalIcon, color: iconColor);
  }

  void rotate() {
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
  void dispose() {
    this.angleAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RotateIcon oldWidget) {
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
    if (this.widget.recycle) {
      this.angleAnimation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          this
              .angleAnimation
              .initAnimation(0, widget.angle, widget.rotateTime, this, () {
            setState(() {});
          });
          this.angleAnimation.forward();
        }
      });
    }
    if (this.widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        this.rotate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this._innerOnTap,
        child: Transform.rotate(
          angle: this.angleAnimation.value,
          child: Icon(
            widget.icon,
            color: this.widget.iconColor,
          ),
        ));
  }

  ///当按钮被点击的时候执行动画效果，以及设定的 [onTap] 函数
  void _innerOnTap() {
    if (this.widget.autoPlay) return;

    if (this.fowardRotating) {
      this.fowardRotating = false;
      this.angleAnimation.reverse();
    } else {
      this.fowardRotating = true;
      this.angleAnimation.forward();
    }
    if (widget.onTap != null) {
      widget.onTap();
    }
  }

  void rotate() {
    if (this.fowardRotating) {
      this.fowardRotating = false;
      this.angleAnimation.reverse();
    } else {
      this.fowardRotating = true;
      this.angleAnimation.forward();
    }
  }
}

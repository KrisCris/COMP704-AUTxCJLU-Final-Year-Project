import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/util/CalculatableColor.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/painter/ColorPainter.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Themeable.dart';

class CustomButton extends StatefulWidget with DisableWidgetMixIn {
  ///The radius of border
  final double radius;

  ///The background color of button
  CalculatableColor bgColor;

  ///The text color of button
  CalculatableColor textColor;

  ///Function to be executed when button being
  ///clicked
  Function tapFunc;

  ///Function to be executed when button being
  ///double clicked
  Function doubleTapFunc;

  ///Text displayed on button
  String text;

  ///Text font size
  double fontsize;

  ///whether text is bold or not
  final bool isBold;

  ///width of the button. When this value <=1
  ///it will be regard as the ratio of screen
  ///width. When this value > 1, it will be
  ///regard as pixel number of button width
  double width;

  ///height of the button. Same as width
  double height;

  double leftMargin;
  double rightMargin;
  double topMargin;
  double bottomMargin;

  ///when length change, button fix at center(0),left(1) or right(2)
  ///有时候表现会出现错误，不推荐大量使用
  int sizeChangeMode;

  /// the opacity that flash animation start at
  double startOpac;

  ///the opacity that flash animation end at
  double endOpac;

  ///does the button have shadow
  bool hasShadow;

  ///fluctuate duration
  int flucDura;

  ///color change duration
  int colorDura;

  ///duration of flash animation, use millionSecond
  int flashDura;

  ///duration of length change animation
  int lengthDura;

  ///该组件的State,供外部调用state的方法. 历史遗留问题，不推荐通过这种方式调用state方法
  CustomButtonState state;

  CustomButton(
      {this.text = "Button",
      this.fontsize = 18.0,
      this.sizeChangeMode = 0,
      this.isBold = false,
      bool disabled = false,
      bool canChangeDisabled = true,
      this.radius = 30.0,
      this.hasShadow = false,
      this.width = 120.0,
      this.height = 40.0,
      this.leftMargin = 0.0,
      this.rightMargin = 0.0,
      this.topMargin = 0.0,
      this.bottomMargin = 0.0,
      this.startOpac = 0.0,
      this.endOpac = 0.5,
      this.flashDura = 200,
      this.flucDura = 150,
      this.colorDura = 200,
      this.lengthDura = 200,
      Color bgColor,
      Color textColor,
      Color flashColor,
      ThemeColorName firstColorName,
      this.tapFunc,
      this.doubleTapFunc,
      Key key})
      : super(key: key) {
    this.bgColor = MyTheme.convert(ThemeColorName.Button, color: bgColor);
    this.textColor =
        MyTheme.convert(ThemeColorName.NormalText, color: textColor);

    if (firstColorName != null) {
      this.bgColor = MyTheme.convert(firstColorName);
    }

    this.canChangeDisable = canChangeDisabled;
    this.width = ScreenTool.partOfScreenWidth(this.width);
    this.height = ScreenTool.partOfScreenHeight(this.height);
    this.disabled = ValueNotifier<bool>(disabled);
  }

  ///创建State,并将S状态保存到私有变量. 历史遗留问题, 不推荐用这种方式保存state的引用
  @override
  State<StatefulWidget> createState() {
    this.state = CustomButtonState();
    return this.state;
  }

  ///设置按钮的宽度，并播放宽度变化动画
  ///参数 [len] 用于设定变化后的新宽度
  void setWidth(double len) {
    double newWidth = ScreenTool.partOfScreenWidth(len);
    this
        .state
        .lengthAnimation
        .initAnimation(this.width, newWidth, this.lengthDura, this.state, () {
      this.state.setState(() {});
    });
    this.state.lengthAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.width = newWidth;
      }
    });
    this.state.lengthAnimation.beginAnimation();
  }

  ///供外部调用State实例的setState()方法,刷新组件
  ///历史遗留问题，不推荐用这种方式调用state方法
  void refresh() {
    this.state.refresh();
  }

  ///获取Mounted状态
  bool isMounted() {
    return this.state.mounted;
  }

  ///按钮是否可以点击
  bool isEnable() {
    return !this.disabled.value;
  }
}

///CustomButton的State
///混入了用于动画效果的 [TickerProviderStateMixin]
///混入了用于控制主题颜色的 [ThemeStateMixIn]
///混入了用于控制Disable状态的 [DisableStateMixIn]
///
class CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin, DisableStateMixIn {
  ///控制按钮长度变化的动画
  TweenAnimation<double> lengthAnimation = new TweenAnimation<double>();

  ///控制disable状态下, 点击按钮后的抖动动画
  TweenAnimation<double> fluctuateAnimation = new TweenAnimation<double>();

  TweenAnimation<double> transparentAnimation = new TweenAnimation<double>();

  ///控制颜色变化的动画
  TweenAnimation<CalculatableColor> colorAnimation =
      new TweenAnimation<CalculatableColor>();

  ///是否被点击
  bool isTap = false;

  bool disableChangeDone = true;

  ///初次渲染组件时的宽度
  double firstWidth;

  @override
  void didUpdateWidget(covariant CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.disabled = oldWidget.disabled;
    this.initBgColor();
  }

  ///在initState中调用. 初始化按钮的背景颜色
  void initBgColor() {
    //as button, only disabled state need set color
    if (widget.disabled.value) {
      Color color = MyTheme.convert(ThemeColorName.DisabledButton);
      this.colorAnimation.initAnimation(color, color, widget.colorDura, this,
          () {
        if (mounted) setState(() {});
      });
    } else {
      this.colorAnimation.initAnimation(
          widget.bgColor, widget.bgColor, widget.colorDura, this, () {
        if (mounted) setState(() {});
      });
    }
    this.transparentAnimation.initAnimation(0, 0.5, widget.colorDura, this, () {
      setState(() {});
    });
    //闪烁动画执行到最高亮度后，若放开手指，就反向播放闪烁动画
    this.transparentAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isTap) {
          this.transparentAnimation.reverseAnimation();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    //初始化按钮背景颜色
    this.initBgColor();
    //初始化disable状态监听器, 函数实现在DisableStateMixIn中
    this.initDisableListener(widget.disabled);

    this.firstWidth = widget.width;

    //各种动画的初始化
    this
        .fluctuateAnimation
        .initAnimation(0.0, 5.0, (widget.flucDura / 4).round(), this, null);
    this.lengthAnimation.initAnimation(
        widget.width, widget.width, widget.lengthDura, this, (){setState(() {

        });});
    //控制抖动动画次数，每次抖动的偏移量
    this.fluctuateAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.fluctuateAnimation.reverseAnimation();
      } else if (status == AnimationStatus.dismissed) {
        double newEnd = 5.0;
        if (this.fluctuateAnimation.completeTime % 2 == 1) {
          newEnd = -5.0;
        }
        this.fluctuateAnimation.setNewEnd(newEnd);
        if (this.fluctuateAnimation.completeTime < 4) {
          this.fluctuateAnimation.beginAnimation();
        } else {
          this.fluctuateAnimation.completeTime = 0;
        }
      }
    });
  }

  @override
  void dispose() {
    this.colorAnimation.dispose();
    this.lengthAnimation.dispose();
    this.fluctuateAnimation.dispose();
    this.transparentAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GestureDetector gesture = GestureDetector(
        onDoubleTap: () {
          if (widget.disabled.value) return;

          if (widget.doubleTapFunc != null) {
            widget.doubleTapFunc();
          } else if (widget.tapFunc != null) {
            this.transparentAnimation.beginAnimation();
            widget.tapFunc();
          }
        },
        onTapDown: (TapDownDetails tpd) {
          if (widget.disabled.value) {
            this.fluctuateAnimation.forward();
          } else if (this.disableChangeDone) {
            this.isTap = true;
            this.transparentAnimation.beginAnimation();
          }
        },
        onTapUp: (TapUpDetails tpu) {
          if (widget.disabled.value) {
            return;
          }
          this.isTap = false;
          this.transparentAnimation.reverseAnimation();
          if (widget.tapFunc != null) {
            widget.tapFunc();
          }
        },
        onTapCancel: () {
          if (widget.disabled.value) return;

          this.isTap = false;
          this.transparentAnimation.reverseAnimation();
        },
        child: this.buttonShape);
    AnimatedBuilder offset = AnimatedBuilder(
        animation: this.fluctuateAnimation.ctl,
        child: gesture,
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
              offset: Offset(
                  this.fluctuateAnimation.value + this.calculatePosition(), 0),
              child: child);
        });
    return offset;
  }

  Widget get buttonShape {
    return CustomPaint(
      foregroundPainter: ColorPainter(
          borderRadius: widget.radius,
          leftExtra: -widget.leftMargin,
          rightExtra: -widget.rightMargin,
          topExtra: -widget.topMargin,
          bottomExtra: -widget.bottomMargin,
          animation: this.transparentAnimation,
          color: MyTheme.convert(ThemeColorName.TransparentShadow)
              .withOpacity(this.transparentAnimation.value)),
      child: Container(
        width: this.lengthAnimation.value,
        height: widget.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            color: this.colorAnimation.value,
            boxShadow: [
              widget.hasShadow
                  ? BoxShadow(
                      blurRadius: 12, //阴影范围
                      spreadRadius: 3, //阴影浓度
                      color: Color(0x33000000), //阴影颜色
                    )
                  : BoxShadow(
                      blurRadius: 0, //阴影范围
                      spreadRadius: 0, //阴影浓度
                      color: Color(0x33000000), //阴影颜色
                    )
            ]
        ),
        margin: EdgeInsets.only(
            left: widget.leftMargin,
            right: widget.rightMargin,
            top: widget.topMargin,
            bottom: widget.bottomMargin),
        child: Center(
          child: Text(
            widget.text,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontSize: widget.fontsize,
                color: widget.textColor,
                fontFamily: "Futura",
                decoration: TextDecoration.none,
                fontWeight:
                widget.isBold ? FontWeight.bold : FontWeight.normal),
          ),
        )
      ),
    );
  }

  ///用以计算长度变化后的按钮位置
  ///根据 [sizeChangeMode] 的不同就行调整
  ///有时候计算出来的坐标偏移量是错误的，不建议大量使用
  double calculatePosition() {
    if (widget.sizeChangeMode == 0)
      return 0;
    else if (widget.sizeChangeMode == 1) {
      double gap = this.firstWidth - this.lengthAnimation.value;
      return -(gap / 2);
    } else if (widget.sizeChangeMode == 2) {
      double gap = this.firstWidth - this.lengthAnimation.value;
      return gap / 2;
    }
  }

  void refresh() {
    if (this.mounted) this.setState(() {});
  }

  ///设置变成disable状态时播放的动画
  @override
  void setDisabled() {
    this.colorAnimation.initAnimation(
        widget.bgColor,
        MyTheme.convert(ThemeColorName.DisabledButton),
        widget.colorDura,
        this, () {
      if (mounted) setState(() {});
    });
    this.colorAnimation.beginAnimation();
  }

  ///设置变成Enable状态时播放的动画
  @override
  void setEnabled() {
    this.colorAnimation.initAnimation(
        MyTheme.convert(ThemeColorName.DisabledButton),
        widget.bgColor,
        widget.colorDura,
        this, () {
      if (mounted) setState(() {});
    });
    this.colorAnimation.beginAnimation();
  }

  @override
  void initDisabled() {
    this.setDisabled();
  }

  @override
  void initEnabled() {
   this.setEnabled();
  }
}

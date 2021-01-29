import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Themeable.dart';

class CustomButton extends StatefulWidget with ThemeWidgetMixIn,DisableWidgetMixIn {
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

  ///the color of flash cover
  CalculatableColor flashColor;

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

  ///第一次渲染组件时的主题状态
  ComponentThemeState firstThemeState;

  CustomButton(
      {this.text = "Button",
      @required MyTheme theme,
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
      this.flashColor = CalculatableColor.white,
      this.tapFunc = null,
      this.doubleTapFunc = null,
      this.firstThemeState = ComponentThemeState.normal,
      Key key})
      : super(key: key) {
    this.theme = theme;
    this.canChangeDisable = canChangeDisabled;
    this.width = ScreenTool.partOfScreenWidth(this.width);
    this.height = ScreenTool.partOfScreenHeight(this.height);
    this.textColor = CalculatableColor.transform(this.theme.lightTextColor);
    this.disabled = ValueNotifier<bool>(disabled);
  }

  ///创建State,并将S状态保存到私有变量. 历史遗留问题, 不推荐用这种方式保存state的引用
  @override
  State<StatefulWidget> createState() {
    this.state = CustomButtonState(this.firstThemeState);
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
    with TickerProviderStateMixin, ThemeStateMixIn, DisableStateMixIn {

  ///控制按钮点击后的闪烁动画
  TweenAnimation<double> flashAnimation = new TweenAnimation<double>();

  ///控制按钮长度变化的动画
  TweenAnimation<double> lengthAnimation = new TweenAnimation<double>();

  ///控制disable状态下, 点击按钮后的抖动动画
  TweenAnimation<double> fluctuateAnimation = new TweenAnimation<double>();

  ///控制颜色变化的动画
  TweenAnimation<CalculatableColor> colorAnimation =
      new TweenAnimation<CalculatableColor>();

  ///是否被点击
  bool isTap = false;

  ///初次渲染组件时的宽度
  double firstWidth;

  CustomButtonState(ComponentThemeState the)
      : super() {
    this.themeState = the;
  }
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
      widget.bgColor = widget.theme.getDisabledColor();
    } else {
      //if not disabled state, just get the theme color
      widget.bgColor = widget.theme.getThemeColor(this.themeState);
    }
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
        widget.width, widget.width, widget.lengthDura, this, null);
    this.flashAnimation.initAnimation(
        widget.startOpac, widget.endOpac, widget.flashDura, this, null);

    this.colorAnimation.initAnimation(
        widget.bgColor, widget.bgColor, widget.colorDura, this, () {
      if(mounted)setState(() {});
    });

    //颜色动画执行完毕后，更新当前的背景色。
    //历史遗留问题，不建议在State中更改Widget的某些属性
    this.colorAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.bgColor = widget.theme.getThemeColor(this.themeState);
      }
    });
    //闪烁动画执行到最高亮度后，若放开手指，就反向播放闪烁动画
    this.flashAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isTap) {
          this.flashAnimation.reverseAnimation();
        }
      }
    });
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
    this.flashAnimation.dispose();
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
            this.flashAnimation.beginAnimation();
            widget.tapFunc();
          }
        },
        onTapDown: (TapDownDetails tpd) {
          if (widget.disabled.value) {
            this.fluctuateAnimation.forward();
          } else {
            this.isTap = true;
            this.flashAnimation.beginAnimation();
          }
        },
        onTapUp: (TapUpDetails tpu) {
          if (widget.disabled.value) {
            return;
          }

          this.isTap = false;
          this.flashAnimation.reverseAnimation();
          if (widget.tapFunc != null) {
            widget.tapFunc();
          }
        },
        onTapCancel: () {
          if (widget.disabled.value) return;

          this.isTap = false;
          this.flashAnimation.reverseAnimation();
        },
        child: this.buttonUI);
    AnimatedBuilder offset = AnimatedBuilder(
        animation: this.fluctuateAnimation.ctl,
        child: gesture,
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
              offset: Offset(
                  this.fluctuateAnimation.value + this.calculatePosition(),
                  0),
              child: child);
        });
    return offset;
  }

  Widget get buttonUI {
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[this.buttonShape, this.buttonCover]);
  }

  Widget get buttonShape {
    return AnimatedBuilder(
        animation: this.lengthAnimation.ctl,
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
        ),
        builder: (BuildContext context, Widget child) {
          return Container(
            width: this.lengthAnimation.value,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: this.colorAnimation.value,
                boxShadow: [
                  widget.hasShadow?BoxShadow(
                    blurRadius: 12, //阴影范围
                    spreadRadius: 3, //阴影浓度
                    color: Color(0x33000000), //阴影颜色
                  ):BoxShadow(
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
            child: child,
          );
        });
  }

  Widget get buttonCover {
    AnimatedBuilder container = AnimatedBuilder(
        animation: this.lengthAnimation.ctl,
        builder: (BuildContext context, Widget child) {
          return Container(
            width: this.lengthAnimation.value,
            height: widget.height,
            margin: EdgeInsets.only(
                left: widget.leftMargin,
                right: widget.rightMargin,
                top: widget.topMargin,
                bottom: widget.bottomMargin),
            decoration: new BoxDecoration(
              color: widget.flashColor,
              borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
            ),
          );
        });
    AnimatedBuilder opacity = AnimatedBuilder(
        animation: this.flashAnimation.ctl,
        child: container,
        builder: (BuildContext context, Widget child) {
          return Opacity(
            opacity: this.flashAnimation.value,
            child: child,
          );
        });
    return opacity;
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

  ///设置correct状态的动画效果，并返回旧的状态
  @override
  ComponentThemeState setCorrect() {
    ComponentThemeState stt = super.setCorrect();
    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){if(mounted)setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  ///设置error状态的动画效果，并返回旧的状态
  @override
  ComponentThemeState setError() {
    ComponentThemeState stt = super.setError();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){if(mounted)setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  ///设置normal状态的动画效果，并返回旧的状态
  @override
  ComponentThemeState setNormal() {
    ComponentThemeState stt = super.setNormal();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){if(mounted)setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  ///设置warning状态的动画效果，并返回旧的状态
  @override
  ComponentThemeState setWarning() {
    ComponentThemeState stt = super.setWarning();
    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){if(mounted)setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  ///设置变成disable状态时播放的动画
  @override
  void setDisabled() {
    this.colorAnimation.initAnimation(
        widget.bgColor,
        widget.theme.getDisabledColor(),
        widget.colorDura, this, (){if(mounted)setState(() {});});
    this.colorAnimation.beginAnimation();
  }

  ///设置变成Enable状态时播放的动画
  @override
  void setEnabled() {
    this.colorAnimation.initAnimation(
        widget.bgColor,
        widget.theme.getThemeColor(this.themeState),
        widget.colorDura, this,(){if(mounted)setState(() {});});
    this.colorAnimation.beginAnimation();
  }
}

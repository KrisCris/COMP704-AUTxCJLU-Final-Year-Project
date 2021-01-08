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
  int sizeChangeMode;

  /// the opacity that flash animation start at
  double startOpac;

  ///the opacity that flash animation end at
  double endOpac;

  ///the color of flash cover
  CalculatableColor flashColor;

  ///fluctuate duration
  int flucDura;

  ///color change duration
  int colorDura;

  ///duration of flash animation, use millionSecond
  int flashDura;

  ///duration of length change animation
  int lengthDura;

  CustomButtonState state;
  ComponentThemeState firstThemeState;

  CustomButton(
      {this.text,
      @required MyTheme theme,
      this.fontsize = 18.0,
      this.sizeChangeMode = 0,
      this.isBold = false,
        bool disabled = false,
        bool canChangeDisabled = true,
      this.radius = 30.0,
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
    // if (this.disabled) this.firstDisabled = true;
  }
  @override
  State<StatefulWidget> createState() {
    this.state = CustomButtonState(this.firstThemeState);
    return this.state;
  }

  bool isMonted() {
    return this.state.mounted;
  }

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

  void refresh() {
    this.state.refresh();
  }

  bool isMounted() {
    return this.state.mounted;
  }

  bool isEnable() {
    return !this.disabled.value;
  }
}

class CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin, ThemeStateMixIn, DisableStateMixIn {
  TweenAnimation<double> flashAnimation = new TweenAnimation<double>();
  TweenAnimation<double> lengthAnimation = new TweenAnimation<double>();
  TweenAnimation<double> fluctuateAnimation = new TweenAnimation<double>();
  TweenAnimation<CalculatableColor> colorAnimation =
      new TweenAnimation<CalculatableColor>();
  bool isTap = false;
  double firstWidth;

  CustomButtonState(ComponentThemeState the)
      : super() {
    this.themeState = the;
  }
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
    this.initBgColor();
    widget.disabled.addListener(() {
      if(widget.disabled.value){
        this.setDisabled();
      }else{
        this.setEnabled();
      }
    });

    this.firstWidth = widget.width;
    this
        .fluctuateAnimation
        .initAnimation(0.0, 5.0, (widget.flucDura / 4).round(), this, null);
    this.lengthAnimation.initAnimation(
        widget.width, widget.width, widget.lengthDura, this, null);
    this.flashAnimation.initAnimation(
        widget.startOpac, widget.endOpac, widget.flashDura, this, null);

    this.colorAnimation.initAnimation(
        widget.bgColor, widget.bgColor, widget.colorDura, this, () {
      setState(() {});
    });
    this.colorAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.bgColor = widget.theme.getThemeColor(this.themeState);
      }
    });
    this.flashAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isTap) {
          this.flashAnimation.reverseAnimation();
        }
      }
    });
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
                  this.fluctuateAnimation.getValue() + this.calculatePosition(),
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
                decoration: TextDecoration.none,
                fontWeight:
                    widget.isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return Container(
            width: this.lengthAnimation.getValue(),
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: this.colorAnimation.getValue()),
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
            width: this.lengthAnimation.getValue(),
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
            opacity: this.flashAnimation.getValue(),
            child: child,
          );
        });
    return opacity;
  }

  double calculatePosition() {
    if (widget.sizeChangeMode == 0)
      return 0;
    else if (widget.sizeChangeMode == 1) {
      double gap = this.firstWidth - this.lengthAnimation.getValue();
      return -(gap / 2);
    } else if (widget.sizeChangeMode == 2) {
      double gap = this.firstWidth - this.lengthAnimation.getValue();
      return gap / 2;
    }
  }

  void refresh() {
    if (this.mounted) this.setState(() {});
  }

  @override
  ComponentThemeState setCorrect() {
    // TODO: implement setCorrect
    ComponentThemeState stt = super.setCorrect();
    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  @override
  ComponentThemeState setError() {
    // TODO: implement setError
    ComponentThemeState stt = super.setError();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  @override
  ComponentThemeState setNormal() {
    // TODO: implement setNormal
    ComponentThemeState stt = super.setNormal();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  @override
  ComponentThemeState setWarning() {
    // TODO: implement setWarning
    ComponentThemeState stt = super.setWarning();
    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(
        widget.bgColor, newColor, widget.colorDura, this, (){setState(() {});});
    this.colorAnimation.beginAnimation();
    return stt;
  }

  @override
  void setDisabled() {
    this.colorAnimation.initAnimation(
        widget.bgColor,
        widget.theme.getDisabledColor(),
        widget.colorDura, this, (){setState(() {});});
    this.colorAnimation.beginAnimation();
  }

  @override
  void setEnabled() {
    this.colorAnimation.initAnimation(
        widget.bgColor,
        widget.theme.getThemeColor(this.themeState),
        widget.colorDura, this,(){setState(() {});});
    this.colorAnimation.beginAnimation();
  }
}

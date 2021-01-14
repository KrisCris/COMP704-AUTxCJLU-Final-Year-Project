
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/widgets/CustomNavigator.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Focusable.dart';

import 'package:fore_end/interface/Themeable.dart';

class CustomIconButton extends StatefulWidget
    with ThemeWidgetMixIn, DisableWidgetMixIn, FocusableWidgetMixIn{
  IconData icon;
  double iconSize;
  double fontSize;
  double buttonRadius;
  double borderRadius;
  double backgroundOpacity;
  int angleDuration;
  double adjustHeight;
  String text;
  CustomIconButtonState state;
  List<Function> delayInit = <Function>[];
  Function onClick;
  Function navigatorCallback;
  CustomNavigator navi;
  List<BoxShadow> shadows;
  bool sizeChangeWhenClick;

  CustomIconButton(
      {
        @required MyTheme theme,
      @required this.icon,
      this.text = "",
        this.sizeChangeWhenClick = false,
      this.iconSize = 20,
      this.fontSize = 12,
      this.buttonRadius = 55,
      this.borderRadius = 1000,
      this.backgroundOpacity = 1,
        this.angleDuration = 200,
        this.adjustHeight = 0,
      this.shadows,
      this.onClick,
        bool disabled = false,
        bool focus = false,
        Key key,
      this.navigatorCallback})
      : super(key:key) {
    this.theme = theme;
    this.disabled = new ValueNotifier<bool>(disabled);
    this.focus = new ValueNotifier<bool>(focus);
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new CustomIconButtonState(
        ComponentThemeState.normal,
        this.shadows
    );
    return this.state;
  }
  void changeIcon(IconData icon){
    this.icon = icon;
    this.state.setState(() {});
  }
  void addDelayInit(Function f) {
    this.delayInit.add(f);
  }

  void setParentNavigator(CustomNavigator nv) {
    this.navi = nv;
  }

}

class CustomIconButtonState extends State<CustomIconButton>
    with ThemeStateMixIn, TickerProviderStateMixin,DisableStateMixIn,FocusableStateMixIn {
  TweenAnimation<CalculatableColor> backgroundColorAnimation =
      TweenAnimation<CalculatableColor>();
  TweenAnimation<CalculatableColor> iconAndTextColorAnimation =
      TweenAnimation<CalculatableColor>();
  TweenAnimation<double> iconSizeAnimation = TweenAnimation<double>();
  List<BoxShadow> shadow;
  bool disabled = false;

  CustomIconButtonState(
      ComponentThemeState the, List<BoxShadow> shadow)
      : super() {
    this.themeState = the;
    this.shadow = shadow;
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    return this.buttonUI;
  }

  @override
  initState() {
    super.initState();
    widget.disabled.addListener(() {
        if(widget.disabled.value){
          this.setDisabled();
        }else{
          this.setEnabled();
        }
    });
    widget.focus.addListener(() {
      if(widget.focus.value){
        this.setFocus();
      }else{
        this.setUnFocus();
      }
    });
    for (Function f in widget.delayInit) {
      f();
    }
    this.backgroundColorAnimation.initAnimation(
        this.getBackgroundColor(widget.focus.value),
        this.getBackgroundColor(widget.focus.value), 150, this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.initAnimation(
        this.getIconAndTextColor(widget.focus.value,null),
        this.getIconAndTextColor(widget.focus.value,null),
        150,
        this, () {
      setState(() {});
    });
    double res = widget.iconSize;
    if(widget.sizeChangeWhenClick){
      res -= 5;
    }
    this.iconSizeAnimation.initAnimation(widget.iconSize, res, 100, this, () {setState(() {});});
  }

  Widget get IconText {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
            animation: this.iconAndTextColorAnimation.ctl,
            builder: (BuildContext context, Widget child) {
              return Icon(widget.icon,
                  color: this.iconAndTextColorAnimation.getValue(),
                  size: this.iconSizeAnimation.getValue());
            }),
        Offstage(
            offstage: widget.text == "" || widget.text == null,
            child: AnimatedBuilder(
                animation: this.iconAndTextColorAnimation.ctl,
                builder: (BuildContext context, Widget child) {
                  return Text(
                    widget.text,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Futura",
                        color: this.iconAndTextColorAnimation.getValue()),
                  );
                })),
        SizedBox(height: widget.adjustHeight)
      ],
    );
  }

  Widget get buttonUI {
    return GestureDetector(
        onTap: () {
          if (widget.onClick != null) {
            if (widget.navi == null) {
              if(!this.disabled){
                widget.onClick();
              }
            } else {
              if (!widget.navi.isActivate(widget)) {
                widget.onClick();
              }
            }
          }
          if (widget.navi != null && !this.disabled) {
            widget.navi.activateButtonByObject(widget);
            widget.navi.switchPageByObject(widget);
          }
        },
        onTapDown: (TapDownDetails details){
          this.iconSizeAnimation.forward();
        },
        onTapUp: (TapUpDetails details){
          this.iconSizeAnimation.reverse();
        },
        child: AnimatedBuilder(
          animation: this.backgroundColorAnimation.ctl,
          child: this.IconText,
          builder: (BuildContext context, Widget child) {
            return Container(
              width: widget.buttonRadius,
              height: widget.buttonRadius,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: this.backgroundColorAnimation.getValue(),
                  boxShadow: this.shadow),
              child: child,
            );
          },
        ));
  }

  CalculatableColor getBackgroundColor(bool isFocus) {
    double opacity = widget.backgroundOpacity;
    if (isFocus) {
      opacity = 1.0;
      return widget.theme.getFocusedColor().withOpacity(opacity);
    }
    return widget.theme.getThemeColor(this.themeState).withOpacity(opacity);
  }

  CalculatableColor getIconAndTextColor(bool isFocus, bool isDisabled) {
    // TODO: 处理focus和disable的关系
    if (isFocus) {
      return widget.theme.getThemeColor(this.themeState);
    }else{
      return widget.theme.getFocusedColor();
    }
  }

  @override
  ComponentThemeState setCorrect() {
    // TODO: implement setCorrect
  }

  @override
  ComponentThemeState setError() {
    // TODO: implement setError
  }

  @override
  ComponentThemeState setNormal() {
    // TODO: implement setNormal
  }

  @override
  ComponentThemeState setWarning() {
    // TODO: implement setWarning
  }

  @override
  void setEnabled() {
    // TODO: implement setEnabled
  }
  void setDisabled(){
    // TODO: implement setEnabled
  }

  @override
  void setFocus() {
    // TODO: implement setFocus
    this.backgroundColorAnimation.initAnimation(
        this.getBackgroundColor(false),
        this.getBackgroundColor(true),
        200,
        this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.initAnimation(
        getIconAndTextColor(false,null),
        getIconAndTextColor(true,null),
        200,
        this, () {
      setState(() {});
    });
    this.backgroundColorAnimation.beginAnimation();
    this.iconAndTextColorAnimation.beginAnimation();
  }

  @override
  void setUnFocus() {
    // TODO: implement setUnFocus
    this.backgroundColorAnimation.initAnimation(
        this.getBackgroundColor(true),
        this.getBackgroundColor(false),
        200,
        this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.initAnimation(
        getIconAndTextColor(true,null),
        getIconAndTextColor(false,null),
        200,
        this, () {
      setState(() {});
    });
    this.backgroundColorAnimation.beginAnimation();
    this.iconAndTextColorAnimation.beginAnimation();
  }
}

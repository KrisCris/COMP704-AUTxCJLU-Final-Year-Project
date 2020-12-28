import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/widgets/CustomNavigator.dart';

import 'package:fore_end/interface/Themeable.dart';

class CustomIconButton extends StatefulWidget {
  MyTheme theme;
  IconData icon;
  double iconSize;
  double fontSize;
  double buttonRadius;
  double borderRadius;
  double backgroundOpacity;
  String text;
  CustomIconButtonState state;
  List<Function> delayInit = <Function>[];
  Function onClick;
  Function navigatorCallback;
  CustomNavigator navi;
  List<BoxShadow> shadows;

  bool _disabled;

  CustomIconButton(
      {@required this.theme,
      @required this.icon,
      this.text = "",
      this.iconSize = 20,
      this.fontSize = 12,
      this.buttonRadius = 55,
      this.borderRadius = 1000,
      this.backgroundOpacity = 1,
      this.shadows,
      this.onClick, disabled = false,
      this.navigatorCallback})
      : super() {this._disabled = disabled;}
  @override
  State<StatefulWidget> createState() {
    this.state = new CustomIconButtonState(
        ComponentThemeState.normal,
        this._disabled? ComponentReactState.disabled: ComponentReactState.unfocused,
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
  void setDisabled(bool dis){
    this.state.setDisabled(dis);
  }
  void setReactState(ComponentReactState rea) {
    if (this.state == null) {
      this.delayInit.add(() {
        this.state.setReactState(rea);
      });
    } else {
      this.state.setReactState(rea);
    }
  }
}

class CustomIconButtonState extends State<CustomIconButton>
    with Themeable, TickerProviderStateMixin {
  TweenAnimation<CalculatableColor> backgroundColorAnimation =
      TweenAnimation<CalculatableColor>();
  TweenAnimation<CalculatableColor> iconAndTextColorAnimation =
      TweenAnimation<CalculatableColor>();
  List<BoxShadow> shadow;
  bool disabled = false;

  CustomIconButtonState(
      ComponentThemeState the, ComponentReactState rea, List<BoxShadow> shadow)
      : super() {
    this.themeState = the;
    this.reactState = rea;
    this.shadow = shadow;
    if(rea == ComponentReactState.disabled)
      this.disabled = true;
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    return this.buttonUI;
  }

  @override
  initState() {
    super.initState();
    for (Function f in widget.delayInit) {
      f();
    }
    this.backgroundColorAnimation.initAnimation(
        this.getBackgroundColor(), this.getBackgroundColor(), 150, this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.initAnimation(
        this.getIconAndTextColor(this.reactState),
        this.getIconAndTextColor(this.reactState),
        150,
        this, () {
      setState(() {});
    });
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
                  size: widget.iconSize);
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
                }))
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
        child: AnimatedBuilder(
          animation: this.backgroundColorAnimation.ctl,
          child: this.IconText,
          builder: (BuildContext context, Widget child) {
            return Container(
              width: widget.buttonRadius,
              height: widget.buttonRadius,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: this.backgroundColorAnimation.getValue(),
                  boxShadow: this.shadow),
              child: child,
            );
          },
        ));
  }

  CalculatableColor getBackgroundColor() {
    double opacity = widget.backgroundOpacity;
    if (this.reactState == ComponentReactState.focused) {
      opacity = 1.0;
    }
    return widget.theme.getReactColor(this.reactState).withOpacity(opacity);
  }

  CalculatableColor getIconAndTextColor(ComponentReactState rea) {
    if (rea == ComponentReactState.focused) {
      return widget.theme.getReactColor(ComponentReactState.unfocused);
    }else if(rea == ComponentReactState.unfocused){
      return widget.theme.getReactColor(ComponentReactState.focused);
    }else{
      return widget.theme.getReactColor(rea);
    }

  }


  void setDisabled(bool dis){
    this.disabled = dis;
    if(dis){
      this.setReactState(ComponentReactState.disabled);
    }else{
      this.setReactState(ComponentReactState.able);
    }
  }
  @override
  void setReactState(ComponentReactState rea) {
    if (this.reactState == rea) return;

    double AfterOpacity = widget.backgroundOpacity;
    if (rea == ComponentReactState.focused) {
      AfterOpacity = 1.0;
    }
    this.backgroundColorAnimation.initAnimation(
        this.getBackgroundColor(),
        widget.theme.getReactColor(rea).withOpacity(AfterOpacity),
        200,
        this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.initAnimation(
        getIconAndTextColor(this.reactState),
        getIconAndTextColor(rea),
        200,
        this, () {
      setState(() {});
    });
    this.backgroundColorAnimation.beginAnimation();
    this.iconAndTextColorAnimation.beginAnimation();
    this.reactState = rea;
  }
  @override
  void setThemeState(ComponentThemeState the) {}
}

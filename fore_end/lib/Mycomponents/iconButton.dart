import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/myNavigator.dart';
import 'package:fore_end/interface/Themeable.dart';

class MyIconButton extends StatefulWidget {
  MyTheme theme;
  IconData icon;
  double iconSize;
  double fontSize;
  double buttonRadius;
  double borderRadius;
  double backgroundOpacity;
  String text;
  MyIconButtonState state;
  List<Function> delayInit = <Function>[];
  Function onClick;
  MyNavigator navi;

  MyIconButton(
      {@required this.theme,
      @required this.icon,
      this.text = "",
      this.iconSize = 20,
      this.fontSize = 14,
      this.buttonRadius = 55,
      this.borderRadius = 1000,
      this.backgroundOpacity = 1,
      this.onClick})
      : super() {}
  @override
  State<StatefulWidget> createState() {
    this.state = new MyIconButtonState(
        ComponentThemeState.normal, ComponentReactState.unfocused);
    return this.state;
  }

  void addDelayInit(Function f) {
    this.delayInit.add(f);
  }

  void setParentNavigator(MyNavigator nv) {
    this.navi = nv;
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

class MyIconButtonState extends State<MyIconButton>
    with Themeable, TickerProviderStateMixin {
  ColorTweenAnimation backgroundColorAnimation = new ColorTweenAnimation();
  ColorTweenAnimation iconAndTextColorAnimation = new ColorTweenAnimation();

  MyIconButtonState(ComponentThemeState the, ComponentReactState rea)
      : super() {
    this.themeState = the;
    this.reactState = rea;
  }

  @override
  Widget build(BuildContext context) {
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
        Icon(widget.icon,
            color: this.iconAndTextColorAnimation.getValue(),
            size: widget.iconSize),
        Text(
          widget.text,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: "Futura",
              color: this.iconAndTextColorAnimation.getValue()),
        )
      ],
    );
  }

  Widget get buttonUI {
    return GestureDetector(
        onTap: () {
          if (widget.onClick != null && !widget.navi.isActivate(widget)) {
            widget.onClick();
          }
          if (widget.navi != null) {
            widget.navi.activateButtonByObject(widget);
            widget.navi.switchPageByObject(widget);
          }
        },
        child: Container(
          width: widget.buttonRadius,
          height: widget.buttonRadius,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: this.backgroundColorAnimation.getValue()),
          child: this.IconText,
        ));
  }

  Color getBackgroundColor() {
    double opacity;
    if (this.reactState == ComponentReactState.focused) {
      opacity = 1.0;
    } else if (this.reactState == ComponentReactState.unfocused) {
      opacity = widget.backgroundOpacity;
    }
    return widget.theme.getReactColor(this.reactState).withOpacity(opacity);
  }

  Color getIconAndTextColor(ComponentReactState rea) {
    if (rea == ComponentReactState.focused) {
      return widget.theme.getReactColor(ComponentReactState.unfocused);
    }
    return widget.theme.getReactColor(ComponentReactState.focused);
  }

  @override
  void setReactState(ComponentReactState rea) {
    if(this.reactState == rea)return;

    double AfterOpacity;
    if (rea == ComponentReactState.focused) {
      AfterOpacity = 1.0;
    } else if (rea == ComponentReactState.unfocused) {
      AfterOpacity = widget.backgroundOpacity;
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

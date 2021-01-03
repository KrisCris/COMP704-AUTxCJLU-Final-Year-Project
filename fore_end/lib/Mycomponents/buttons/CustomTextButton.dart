import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/interface/Themeable.dart';

class CustomTextButton extends StatefulWidget with ThemeWidgetMixIn{
  String text;
  double fontsize;
  Color textColor;
  Color clickColor;
  Function tapUpFunc;
  int colorChangeDura;
  bool isTap = false;



  CustomTextButton(this.text,
      {this.fontsize = 16,
      this.tapUpFunc,
        @required MyTheme theme,
      this.colorChangeDura = 300,
      Key key})
      : super(key: key) {
      this.theme = theme;
      this.textColor = this.theme.darkTextColor;
      this.clickColor = this.theme.getReactColor(ComponentReactState.focused);
  }

  @override
  State<StatefulWidget> createState() {
    return new CustomTextButtonState();
  }
}

class CustomTextButtonState extends State<CustomTextButton>
    with TickerProviderStateMixin, ThemeStateMixIn {
  TweenAnimation<CalculatableColor> animation = new TweenAnimation<CalculatableColor>();
  TapGestureRecognizer recognizer = new TapGestureRecognizer();

  @override
  void initState() {
    super.initState();

    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        widget.theme.getReactColor(ComponentReactState.focused),
        widget.colorChangeDura, this, null);
    //点击完毕后，颜色从高亮恢复正常
    this.animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(!widget.isTap){
          this.animation.reverseAnimation();
        }
      }
    });
    //状态变化后，重置点击变色动画
    this.animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.textColor = widget.theme.getThemeColor(this.themeState);
        this.animation.initAnimation(widget.textColor, widget.clickColor,
            widget.colorChangeDura, this, () { setState(() {});});
      }
    });
  }
  @override
  void dispose() {
    this.animation.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextBUttonUI;
  }

  Widget get TextBUttonUI {
    return AnimatedBuilder(
        animation: this.animation.ctl,
        builder: (BuildContext context, Widget child){
          return RichText(
              text: TextSpan(
                  text: widget.text,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: widget.fontsize,
                      fontFamily: "Futura",
                      color: this.animation.getValue()),
                  recognizer: TapGestureRecognizer()
                    ..onTapUp = (TapUpDetails tpd) {
                      widget.isTap = false;
                      print("tapUp");
                      this.animation.reverseAnimation();
                      widget.tapUpFunc();
                    }
                    ..onTapDown = (TapDownDetails details) {
                      widget.isTap = true;
                      print("tapDown");
                      this.animation.beginAnimation();
                    }
                    ..onTapCancel= (){
                      widget.isTap = false;
                      print("tapCancel");
                      this.animation.reverseAnimation();
                    }
              ));
        });
  }

  @override
  void setReactState(ComponentReactState rea) {
    //textButton don't have focus/disable state, so do nothing
  }


  @override
  ComponentThemeState setCorrect() {
    // TODO: implement setCorrect
    ComponentThemeState stt = super.setCorrect();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        newColor,
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
    return stt;
  }

  @override
  ComponentThemeState setError() {
    // TODO: implement setError
    ComponentThemeState stt =super.setError();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        newColor,
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
    return stt;
  }

  @override
  ComponentThemeState setNormal() {
    // TODO: implement setNormal
    ComponentThemeState stt =super.setNormal();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        newColor,
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
    return stt;
  }

  @override
  ComponentThemeState setWarning() {
    // TODO: implement setWarning
    ComponentThemeState stt =super.setWarning();

    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        newColor,
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
    return stt;
  }
}

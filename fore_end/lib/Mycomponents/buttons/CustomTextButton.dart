import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:fore_end/interface/Valueable.dart';

class CustomTextButton extends StatefulWidget
    with ThemeWidgetMixIn, DisableWidgetMixIn, ValueableWidgetMixIn<String>{

  double fontsize;
  Color textColor;
  Color clickColor;
  Function tapUpFunc;
  int colorChangeDura;
  bool isTap = false;
  bool ignoreTap;
  bool autoReturnColor;

  CustomTextButton(
      String text,
      {this.fontsize = 16,
        bool disabled = false,
        bool canChangeDisable = true,
        this.ignoreTap = false,
        this.autoReturnColor = true,
        Function tapUpFunc,
        @required MyTheme theme,
      this.colorChangeDura = 300,
      Key key})
      : super(key: key) {
      this.theme = theme;
      this.tapUpFunc = tapUpFunc==null?(){}:tapUpFunc;
      this.widgetValue = ValueNotifier<String>(text);
      this.disabled = ValueNotifier(disabled);
      this.canChangeDisable = canChangeDisable;
      this.textColor = this.theme.darkTextColor;
      this.clickColor = this.theme.getReactColor(ComponentReactState.focused);
  }

  @override
  State<StatefulWidget> createState() {
    return new CustomTextButtonState();
  }
}

class CustomTextButtonState extends State<CustomTextButton>
    with TickerProviderStateMixin, ThemeStateMixIn, DisableStateMixIn,ValueableStateMixIn<String> {
  TweenAnimation<CalculatableColor> animation = new TweenAnimation<CalculatableColor>();
  TapGestureRecognizer recognizer = new TapGestureRecognizer();
  CustomTextButtonState(){
    this.themeState = ComponentThemeState.normal;
  }
  @override
  void initState() {
    super.initState();

    this.initValueListener(widget.widgetValue);
    this.initDisableListener(widget.disabled);

    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        widget.theme.getReactColor(ComponentReactState.focused),
        widget.colorChangeDura, this, null);
    //点击完毕后，颜色从高亮恢复正常
    if(widget.autoReturnColor) {
      this.animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (!widget.isTap) {
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
    }else{
      widget.textColor = widget.theme.getThemeColor(this.themeState);
    }
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
    TapGestureRecognizer recog = TapGestureRecognizer()
      ..onTapUp = (TapUpDetails tpd) {
        if(widget.disabled.value)return;
        widget.isTap = false;
        print("tapUp");
        this.animation.reverseAnimation();
        widget.tapUpFunc();
      }
      ..onTapDown = (TapDownDetails details) {
        if(widget.disabled.value)return;
        widget.isTap = true;
        print("tapDown");
        this.animation.beginAnimation();
      }
      ..onTapCancel= (){
        if(widget.disabled.value)return;
        widget.isTap = false;
        print("tapCancel");
        this.animation.reverseAnimation();
      };
    if(widget.ignoreTap){
      recog = null;
    }
    return AnimatedBuilder(
        animation: this.animation.ctl,
        builder: (BuildContext context, Widget child){
          return RichText(
              text: TextSpan(
                  text: widget.widgetValue.value,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: widget.fontsize,
                      fontFamily: "Futura",
                      color: this.animation.getValue()),
                  recognizer: recog
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

  @override
  void onChangeValue() {
    setState(() {});
  }

  @override
  void setDisabled() {
    this.animation.initAnimation(
        CalculatableColor.transform(widget.textColor),
        widget.theme.getDisabledColor(),
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
  }

  @override
  void setEnabled() {
    this.animation.initAnimation(
        widget.theme.getDisabledColor(),
        CalculatableColor.transform(widget.textColor),
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
  }
}

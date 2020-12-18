import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/interface/Themeable.dart';

class CustomTextButton extends StatefulWidget {
  MyTheme theme;
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
        @required this.theme,
      this.colorChangeDura = 300,
      Key key})
      : super(key: key) {

      this.textColor = this.theme.darkTextColor;
      this.clickColor = this.theme.getReactColor(ComponentReactState.focused);
  }

  @override
  State<StatefulWidget> createState() {
    return new CustomTextButtonState();
  }
}

class CustomTextButtonState extends State<CustomTextButton>
    with TickerProviderStateMixin, Themeable {
  ColorTweenAnimation animation = new ColorTweenAnimation();
  TapGestureRecognizer recognizer = new TapGestureRecognizer();

  @override
  void initState() {
    super.initState();

    this.animation.initAnimation(widget.textColor, widget.theme.getReactColor(ComponentReactState.focused),
        widget.colorChangeDura, this, () {setState(() {});});
    this.animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(!widget.isTap){
          this.animation.reverseAnimation();
        }
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
  }

  @override
  void setReactState(ComponentReactState rea) {
    //textButton don't have focus/disable state, so do nothing
  }

  @override
  void setThemeState(ComponentThemeState the) {
    //do nothing when state not change
    if(this.themeState == the)return;
    //update the state
    this.themeState = the;
    //if button disabled, don't update color animation
    if(this.reactState == ComponentReactState.disabled)return;
    //update color animation
    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.animation.initAnimation(widget.textColor, newColor, widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.textColor = newColor;
        this.animation.initAnimation(widget.textColor, widget.clickColor,
            widget.colorChangeDura, this, () { setState(() {});});
      }
    });
    this.animation.beginAnimation();
  }
}

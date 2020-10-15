import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';

class MyTextButton extends StatefulWidget {
  String text;
  double fontsize;
  Color textColor;
  Color focusColor;
  Function tapUpFunc;
  int colorChangeDura;
  bool isTap = false;



  MyTextButton(this.text,
      {this.fontsize = 16,
      this.textColor = Colors.black,
      this.focusColor = Colors.blue,
      this.tapUpFunc,
      this.colorChangeDura = 300,
      Key key})
      : super(key: key) {
  }

  @override
  State<StatefulWidget> createState() {
    return new MyTextButtonState();
  }
}

class MyTextButtonState extends State<MyTextButton>
    with TickerProviderStateMixin {

  ColorTweenAnimation animation = new ColorTweenAnimation();
  TapGestureRecognizer recognizer = new TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    this.animation.initAnimation(widget.textColor, widget.focusColor,
        widget.colorChangeDura, this, () {setState(() {});});
    this.animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(!widget.isTap){
          this.animation.reverseFlash();
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
              this.animation.reverseFlash();
              widget.tapUpFunc();
            }
            ..onTapDown = (TapDownDetails details) {
              widget.isTap = true;
              print("tapDown");
              this.animation.beginFlash();
            }
            ..onTapCancel= (){
              widget.isTap = false;
              print("tapCancel");
              this.animation.reverseFlash();
            }
        ));
  }
}

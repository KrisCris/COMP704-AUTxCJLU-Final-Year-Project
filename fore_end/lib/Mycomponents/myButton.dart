import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class MyButton extends StatefulWidget {
  ///The radius of border
  final double radius;

  ///The background color of button
  final Color bgColor;

  ///The text color of button
  final Color textColor;

  ///Function to be executed when button being
  ///clicked
  final Function tapFunc;

  ///Function to be executed when button being
  ///double clicked
  final Function doubleTapFunc;

  ///Text displayed on button
  final String text;

  ///Text font size
  final double fontsize;

  ///whether text is bold or not
  final bool isBold;

  ///width of the button. When this value <=1
  ///it will be regard as the ratio of screen
  ///width. When this value > 1, it will be
  ///regard as pixel number of button width
  double width;

  ///height of the button. Same as width
  double height;

  ///if the button is disabled
  bool disabled;

  /// the opacity that flash animation start at
  double startOpac;

  ///the opacity that flash animation end at
  double endOpac;

  ///duration of flash animation, use millionSecond
  int flashDura;

  ///the color of flash cover
  Color flashColor;

  ///fluctuate duration
  int flucDura;

  MyButton(
      {this.text,
      this.fontsize = 18,
      this.isBold = false,
      this.radius = 0,
      this.textColor = Colors.white,
      this.bgColor = Colors.blue,
      this.width = 120,
      this.height = 40,
        this.disabled = false,
        this.startOpac=0,
        this.endOpac=0.5,
        this.flashDura=200,
        this.flucDura=300,
        this.flashColor=Colors.white,
      this.tapFunc = null,
      this.doubleTapFunc = null,
      Key key})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);
    this.height = ScreenTool.partOfScreenHeight(this.height);
  }

  @override
  State<StatefulWidget> createState() {
    return new MyButtonState();
  }
}

class MyButtonState extends State<MyButton> with TickerProviderStateMixin{

  TweenAnimation flashAnimation = new TweenAnimation();
  FluctuateTweenAnimation fluctuateAnimation = new FluctuateTweenAnimation();

  bool isTap = false;

  @override
  void initState() {
    super.initState();
    this.fluctuateAnimation.initAnimation(null, null, widget.flashDura, this,
        () {
      setState(() {});
    });
    this.flashAnimation.initAnimation(
        widget.startOpac, widget.endOpac, widget.flashDura, this, () {
      setState(() {});
    });
    this.flashAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isTap) {
          this.flashAnimation.reverseFlash();
        }
      }
    });
  }

  @override
  void dispose() {
    this.flashAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(this.fluctuateAnimation.getValue(),0),
        child: GestureDetector(
            onTapDown: (TapDownDetails tpd){
              if(widget.disabled){
                this.fluctuateAnimation.forward();
              } else {
                this.isTap = true;
                this.flashAnimation.beginFlash();
              }
            },
            onTapUp: (TapUpDetails tpu) {
              if (widget.disabled) return;

              this.isTap = false;
              this.flashAnimation.reverseFlash();
              widget.tapFunc();
            },
            onTapCancel: () {
              if (widget.disabled) return;

              this.isTap = false;
              this.flashAnimation.reverseFlash();
            },
            child: this.buttonUI));
  }
  Widget get buttonUI{
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                color: widget.bgColor),
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
          Opacity(
            opacity: this.flashAnimation.getValue(),
            child:Container(
              width: widget.width,
              height: widget.height,
              decoration: new BoxDecoration(
                color: widget.flashColor,
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
              ),
            ),
          )
        ]
    );
  }
}

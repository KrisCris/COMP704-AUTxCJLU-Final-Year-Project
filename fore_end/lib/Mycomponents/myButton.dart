import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/screenTool.dart';


class MyButton extends StatefulWidget {
  final double radius;
  final Color bgColor;
  final Color textColor;
  final Function tapFunc;
  final Function doubleTapFunc;
  final String text;
  final double fontsize;
  final bool isBold;
  bool disabled;
  double width;
  double height;

  //flash animation parameter
  double startOpac;
  double endOpac;
  int flashDura;
  int flucDura;
  Color flashColor;

  MyButton(
      {this.text,
      this.fontsize = 18,
      this.isBold = false,
      this.radius = 0,
      this.textColor = Colors.white,
      this.bgColor = Colors.blue,
      this.width = 120,
      this.height = 40,
        this.disabled = true,
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

  DoubleTweenAnimation flashAnimation = new DoubleTweenAnimation();
  FluctuateTweenAnimation fluctuateAnimation = new FluctuateTweenAnimation();

  bool isTap=false;

  @override
  void initState() {
    super.initState();
    this.fluctuateAnimation.initAnimation(null, null, widget.flashDura, this, () { setState(() {});});
    this.flashAnimation.initAnimation(widget.startOpac, widget.endOpac, widget.flashDura, this,(){setState(() {});});
    this.flashAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        if(!isTap){
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
        offset: Offset(this.fluctuateAnimation.value,0),
        child: GestureDetector(
            onTapDown: (TapDownDetails tpd){
              if(widget.disabled){
                print("click disabled");
                print(this.fluctuateAnimation.value);
                this.fluctuateAnimation.forward();
              }else{
                this.isTap = true;
                this.flashAnimation.beginFlash();
              }
            },
            onTapUp: (TapUpDetails tpu){
              if(widget.disabled)return;

              this.isTap = false;
              this.flashAnimation.reverseFlash();
              widget.tapFunc();
            },
            onTapCancel: (){
              if(widget.disabled)return;

              this.isTap = false;
              this.flashAnimation.reverseFlash();
            },
            child: this.buttonUI
    )
    );
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
                    fontWeight:
                    widget.isBold ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ),
          Opacity(
            opacity: this.flashAnimation.value,
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
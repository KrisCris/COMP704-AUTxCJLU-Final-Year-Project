import 'dart:ui';
import 'package:flutter/material.dart';
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
  double width;
  double height;

  //flash animation parameter
  double startOpac;
  double endOpac;
  int flashDura;
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
        this.startOpac=0,
        this.endOpac=0.5,
        this.flashDura=200,
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

class MyButtonState extends State<MyButton> with SingleTickerProviderStateMixin{
  Tween tw;
  AnimationController ctl;
  Animation animation;
  bool isFinish=false;
  bool isTap=false;

  @override
  void initState() {
    super.initState();
    this.tw = new Tween<double>(begin: widget.startOpac,end: widget.endOpac);
    this.ctl = new AnimationController(duration: Duration(milliseconds:widget.flashDura),vsync:this)
      ..addListener(() {setState(() {});})
      ..addStatusListener((status) {
        if(status == AnimationStatus.completed){
          this.isFinish = true;
          if(!isTap){
            this.ctl.reverse();
          }
        }else if(status == AnimationStatus.dismissed){
          this.isFinish=false;
        }
      });
    this.animation = this.tw.animate(this.ctl);
  }

  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails tpd){
        this.beginFlash();
      },
      onTapUp: (TapUpDetails tpu){
        this.reverseFlash();
        widget.tapFunc();
      },
        onTapCancel: (){
         this.reverseFlash();
        },
      child: this.buttonUI
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
            opacity: this.animation.value,
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
  void reverseFlash(){
    isTap = false;
    if(this.isFinish){
      this.ctl.reverse();
    }
  }
  void beginFlash(){
    this.isTap = true;
    this.isFinish = false;
    this.ctl.forward();
  }
}
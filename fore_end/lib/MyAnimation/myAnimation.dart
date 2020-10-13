

import 'package:flutter/material.dart';

class FlashCover extends StatefulWidget{
  double startOpac;
  double endOpac;
  double radius;
  double width;
  double height;
  int flashDura;
  Color flashColor;
  Function tapFunc;

  FlashCover({this.startOpac,this.endOpac,this.flashDura,this.flashColor=Colors.white,this.radius,this.width,this.height,this.tapFunc});

  @override
  State<StatefulWidget> createState() {
    return new FlashState();
  }
}



class FlashState extends State<FlashCover> with SingleTickerProviderStateMixin{

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
      behavior: HitTestBehavior.translucent,
      onTapDown: (TapDownDetails tpd){
        this.isTap = true;
        this.isFinish = false;
        this.ctl.forward();
        },
      onTapUp: (TapUpDetails tpu){
          isTap = false;
          if(this.isFinish){
            this.ctl.reverse();
          }
          widget.tapFunc();
        },
      child: Opacity(
        opacity: this.animation.value,
        child:Container(
          width: widget.width,
          height: widget.height,
          decoration: new BoxDecoration(
            color: widget.flashColor,
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
        ),
      ),
    );
  }
}
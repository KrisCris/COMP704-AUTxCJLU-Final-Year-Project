import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/FluctuateTween.dart';

abstract class MyAnimation<T>{
  AnimationController ctl;
  Animation animation;
  bool isFinish;
  T getValue() => animation.value;
  MyAnimation(){}
  void initAnimation(T Start, T tweenEnd, int duration, TickerProvider tk,VoidCallback listener);
  void addListener(VoidCallback listener);
  void addStatusListener(AnimationStatusListener listener) ;
  void forward();
  void reverse();
  void dispose();
}

class TweenAnimation<T> implements MyAnimation<T>{
  Tween tween;
  @override
  Animation animation;
  @override
  AnimationController ctl;
  bool isFinish = false;
  int completeTime;

  TweenAnimation():super() {}
  void initAnimation(T tweenStart, T tweenEnd, int duration, TickerProvider tk,VoidCallback listener) {
    this.completeTime = 0;
    this.tween = new Tween<T>(begin: tweenStart, end: tweenEnd);
    this.ctl = new AnimationController(
        duration: Duration(milliseconds: duration), vsync: tk
    );
    if(listener != null){
      this.ctl.addListener(listener);
    }
    this.ctl.removeStatusListener(this.basicStaticListener);
    this.ctl.addStatusListener(this.basicStaticListener);
    this.animation = this.tween.animate(this.ctl);
  }
  void expandNewEnd(T end){
    this.tween.begin = this.tween.end;
    this.tween.end = end;
    this.animation = this.tween.animate(this.ctl);
  }
  void setNewEnd(T end){
    this.tween.end = end;
    this.animation = this.tween.animate(this.ctl);
  }
  void basicStaticListener(AnimationStatus status){
    if (status == AnimationStatus.completed) {
      this.isFinish = true;
      this.completeTime +=1;
    } else if (status == AnimationStatus.dismissed) {
      this.isFinish = false;
    }
  }
  void addListener(VoidCallback listener) {
    this.ctl.addListener(listener);
    this.animation = this.tween.animate(this.ctl);
  }

  void addStatusListener(AnimationStatusListener listener) {
    this.ctl.addStatusListener(listener);
    this.animation = this.tween.animate(this.ctl);
  }

  void forward() {
    this.ctl.forward();
  }
  void beginAnimation(){
    this.isFinish = false;
    this.ctl.forward();
  }
  void reverse() {
    this.ctl.reverse();
  }
  void reverseAnimation(){
    if (this.isFinish) {
      this.ctl.reverse();
    }
  }
  void dispose(){
    this.ctl.dispose();
  }
  T getValue() {
    return animation.value;
  }
}
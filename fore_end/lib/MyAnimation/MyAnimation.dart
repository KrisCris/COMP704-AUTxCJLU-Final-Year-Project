import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/fluctuateTween.dart';

abstract class MyAnimation{
  AnimationController ctl;
  Animation animation;
  bool isFinish;
  double get value => animation.value;
  MyAnimation(){}
  void initAnimation(Object Start, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener);
  void addListener(VoidCallback listener);
  void addStatusListener(AnimationStatusListener listener) ;
  void forward();
  void reverse();
  void dispose();
}

class DoubleTweenAnimation implements MyAnimation{
  Tween tween;
  @override
  Animation animation;

  @override
  AnimationController ctl;
  bool isFinish = false;

  DoubleTweenAnimation():super() {}
  void initAnimation(Object tweenStart, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener) {
    this.tween = new Tween<double>(begin: tweenStart, end: tweenEnd);
    this.ctl = new AnimationController(
        duration: Duration(milliseconds: duration), vsync: tk
    );
    this.ctl.addListener(listener);
    this.ctl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.isFinish = true;
      } else if (status == AnimationStatus.dismissed) {
        this.isFinish = false;
    }});
    this.animation = this.tween.animate(this.ctl);
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
  void beginFlash(){
    this.isFinish = false;
    this.ctl.forward();
  }
  void reverse() {
    this.ctl.reverse();
  }
  void reverseFlash(){
    if (this.isFinish) {
      this.ctl.reverse();
    }
  }
  void dispose(){
    this.ctl.dispose();
  }
  double get value => animation.value;

}




class FluctuateTweenAnimation implements MyAnimation{
  FluctuateTween tween;
  bool isFinish;
  @override
  Animation animation;

  @override
  AnimationController ctl;

  @override
  void initAnimation(Object tweenStart, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener) {
    this.tween = new FluctuateTween(waveHigh: 7, loop: 2);
    this.ctl = new AnimationController(
        duration: Duration(milliseconds: duration), vsync: tk
    );
    this.ctl.addListener(listener);
    this.ctl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.isFinish = true;
        this.ctl.reset();
      } else if (status == AnimationStatus.dismissed) {
        this.isFinish = false;
      }});
    this.animation = this.tween.animate(this.ctl);
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
  void beginFlash(){
    this.isFinish = false;
    this.ctl.forward();
  }
  void reverse() {
    this.ctl.reverse();
  }
  void reverseFlash(){
    if (this.isFinish) {
      this.ctl.reverse();
    }
  }
  void dispose(){
    this.ctl.dispose();
  }
  double get value {
    double t = this.animation.value;
    print(t);
    return this.tween.lerp(t);
  }
}
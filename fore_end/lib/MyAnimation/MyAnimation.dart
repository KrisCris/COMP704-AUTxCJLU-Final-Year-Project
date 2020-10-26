import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/fluctuateTween.dart';

abstract class MyAnimation<T>{
  AnimationController ctl;
  Animation animation;
  bool isFinish;
  T getValue() => animation.value;
  MyAnimation(){}
  void initAnimation(Object Start, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener);
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

  TweenAnimation():super() {}
  TweenAnimation.pre(Object tweenStart, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener):super(){
    this.initAnimation(tweenStart, tweenEnd, duration, tk, listener);
  }
  void initAnimation(Object tweenStart, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener) {
    this.tween = new Tween<T>(begin: tweenStart, end: tweenEnd);
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

class ColorTweenAnimation implements MyAnimation<Color>{
  ColorTween tween;
  @override
  Animation animation;

  @override
  AnimationController ctl;
  bool isFinish = false;

  ColorTweenAnimation():super() {}
  ColorTweenAnimation.pre(Object tweenStart, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener):super(){
    this.initAnimation(tweenStart, tweenEnd, duration, tk, listener);
  }

  void initAnimation(Object tweenStart, Object tweenEnd, int duration, TickerProvider tk,VoidCallback listener) {
    this.tween = new ColorTween(begin: tweenStart, end: tweenEnd);
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
  Color getValue() {
    return animation.value;
  }
}


class FluctuateTweenAnimation implements MyAnimation<double>{
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
  double getValue() {
    double t = this.animation.value;
    return this.tween.lerp(t);
  }
}
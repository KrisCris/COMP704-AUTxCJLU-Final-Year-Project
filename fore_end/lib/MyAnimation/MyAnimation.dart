import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/FluctuateTween.dart';

abstract class MyAnimation<T> implements ValueListenable<T>{
  AnimationController ctl;
  Animation animation;
  bool isFinish;

  @override
  T get value => animation.value;
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
  List<Function> listenerList = new List<Function>();
  List<AnimationStatusListener> statusListenerList = new List<AnimationStatusListener>();
  TweenAnimation():super() {}
  void initAnimation(T tweenStart, T tweenEnd, int duration, TickerProvider tk,VoidCallback listener) {
    this.isFinish = false;
    this.completeTime = 0;
    this.tween = new Tween<T>(begin: tweenStart, end: tweenEnd);
    this.ctl = new AnimationController(
        duration: Duration(milliseconds: duration), vsync: tk
    );
    if(listener != null){
      this.ctl.addListener(listener);
    }
    for(Function f in this.listenerList){
      this.ctl.addListener(f);
    }
    this.ctl.addStatusListener(this.basicStaticListener);
    for(AnimationStatusListener f in this.statusListenerList){
      this.ctl.addStatusListener(f);
    }
    this.animation = this.tween.animate(this.ctl);
  }
  void expandNewEnd(T end){
    this.tween.begin = this.tween.end;
    this.tween.end = end;
    this.animation = this.tween.animate(this.ctl);
  }
  bool isDismissed(){
    return this.animation.status == AnimationStatus.dismissed;
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
    this.listenerList.add(listener);
    this.ctl.addListener(listener);
    this.animation = this.tween.animate(this.ctl);
  }
  void popListener(){
    Function f = this.listenerList.removeLast();
    this.animation.removeListener(f);
  }
  Function popStatusListener(){
    Function f = this.statusListenerList.removeLast();
    this.animation.removeStatusListener(f);
    return f;
  }
  void addStatusListener(AnimationStatusListener listener) {
    this.statusListenerList.add(listener);
    this.ctl.addStatusListener(listener);
    this.animation = this.tween.animate(this.ctl);
  }

  void forward() {
    this.ctl.forward();
  }
  void stop(){
    this.ctl.stop();
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
    if(this.ctl == null)return;
    this.ctl.dispose();
  }
  @override
  T get value {
    return animation.value;
  }

  @override
  void removeListener(void Function() listener) {
  }
}
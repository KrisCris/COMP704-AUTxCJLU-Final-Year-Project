import 'dart:async';

import 'package:flutter/cupertino.dart';

class MyCounter {
  Timer _tm;
  bool _isRun;
  bool _callWhenStart;
  int _temp;
  int times;
  int duration;
  Function calling;

  MyCounter({this.times = -1,bool callWhenStart = true, this.calling=null, this.duration=0}){
    this._isRun = false;
    this._callWhenStart = callWhenStart;
  }

  void stop(){
    if(this._tm != null){
      this._tm.cancel();
    }
    this._isRun = false;
  }
  bool isStop(){
    return !this._isRun;
  }
  void start(){
    if(this.calling == null)return;
    if(this._isRun)return;
    this._isRun = true;
    this._temp = this.times;
    if(this._callWhenStart){
      this.calling();
      this._temp = this.times-1;
    }
    this._tm = Timer.periodic(Duration(milliseconds: duration), (timer) {
      if(this._temp == 0){
        timer.cancel();
        this._isRun = false;
      }
      this.calling();
      if(this._temp >=0)this._temp--;
    });
  }

  void setCall(Function f){
    this.calling = f;
  }
  void reset(){
    this.stop();
    this.start();
  }
  void setDuration(int d){
    this.duration = d;
  }

  int getRemain(){
    return this._temp;
  }
}
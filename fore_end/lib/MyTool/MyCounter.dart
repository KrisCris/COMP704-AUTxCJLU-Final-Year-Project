import 'dart:async';

import 'package:flutter/cupertino.dart';

class MyCounter {
  Timer _tm;
  bool _isRun;
  int times;
  int duration;
  Function calling;

  MyCounter({this.times = -1, this.calling=null, this.duration=0}){
    this._isRun = false;
  }

  void stop(){
    this._tm.cancel();
    this._isRun = false;
  }
  bool isStop(){
    return !this._isRun;
  }
  void start(){
    if(this.calling == null)return;
    if(this._isRun)return;

    this._isRun = true;
    this._tm = Timer.periodic(Duration(milliseconds: duration), (timer) {
      if(times == 1){
        timer.cancel();
        this._isRun = false;
      }

      this.calling();

      if(times >0)times--;
    });
  }

  void setCall(Function f){
    this.calling = f;
  }

  void setDuration(int d){
    this.duration = d;
  }
}
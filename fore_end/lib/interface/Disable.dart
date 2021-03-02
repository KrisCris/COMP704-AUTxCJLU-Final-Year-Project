import 'package:flutter/cupertino.dart';

abstract class DisableWidgetMixIn{
  ValueNotifier<bool> disabled;
  bool lastDisabledState;
  bool canChangeDisable=true;

  void setDisabled(bool t){
    if(this.disabled == null){
      print("try to set disable status when ValueNotifier is null\n");
      return;
    }
    if(!canChangeDisable)return;

    if(this.disabled.value == t)return;
    this.lastDisabledState = this.disabled.value;
    this.disabled.value = t;
  }
}

abstract class DisableStateMixIn{
  ///As the callback of valueNotifier<bool>
  void setDisabled();
  void setEnabled();
  void initDisabled(){setDisabled();}
  void initEnabled(){setEnabled();}
  void initDisableListener(ValueNotifier<bool> dis){
    if(dis.value){
      this.initDisabled();
    }else{
      this.initEnabled();
    }
    dis.addListener((){
      if(dis.value){
        this.setDisabled();
      }else{
        this.setEnabled();
      }
    });
  }
}
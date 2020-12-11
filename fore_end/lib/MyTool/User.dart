import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/LocalDataManager.dart';

class User{
  String _userName;
  String _avatar_local;
  String _avatar_remote;

  User({ String username, String avatar=""}){
    this._userName = username;
    List<String> stringVal = avatar.split(',');
    if(stringVal.length == 2){
      this._avatar_remote = stringVal[1];
    }else if(stringVal.length == 1){
      this._avatar_remote = stringVal[0];
    }else{
      this._avatar_remote = "";
    }
    this.dataSynchornize();
  }

  String get userName => _userName;
  String getRemoteAvatar(){
    return _avatar_remote;
  }
  String getLocalAvatar(){
    return _avatar_local;
  }
  MemoryImage getAvatar(){
    this.dataSynchornize();
    return MemoryImage(base64Decode(this._avatar_remote));
  }
  void dataSynchornize(){
  }
  void save(){
    LocalDataManager.saveUser(this);
  }
}
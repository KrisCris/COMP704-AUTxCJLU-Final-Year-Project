import 'package:flutter/cupertino.dart';

class Hint{
  String hintContent;
  bool instanceClose;
  Function() onClick;

  Hint({@required this.hintContent, @required this.onClick, this.instanceClose=true});
  void close(){

  }
}
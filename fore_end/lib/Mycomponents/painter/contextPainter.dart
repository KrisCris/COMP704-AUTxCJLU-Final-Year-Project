import 'package:flutter/cupertino.dart';

abstract class ContextPainter extends CustomPainter{
  BuildContext context;

  void setContext(BuildContext ctx){
    this.context = context;
  }
}
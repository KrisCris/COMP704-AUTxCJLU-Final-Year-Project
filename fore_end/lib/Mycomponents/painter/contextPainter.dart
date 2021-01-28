import 'package:flutter/cupertino.dart';

abstract class ContextPainter extends CustomPainter{
  BuildContext context;

  void setContext(BuildContext ctx){
    this.context = ctx;
  }

  Size adjustSize(Size size){
    double height = size.height;
    double width = size.width;
    if(height == 0){
      height = context.size.height;
    }
    if(width == 0){
      width = context.size.width;
    }
    return new Size(width,height);
  }
}
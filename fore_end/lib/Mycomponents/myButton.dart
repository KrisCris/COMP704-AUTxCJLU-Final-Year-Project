import 'dart:ui';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final double radius;
  final Color bgColor;
  final Color textColor;
  final Function tapFunc;
  final Function doubleTapFunc;
  final String text;
  final double fontsize;
  double width;
  double height;
  final bool isBold;

  MyButton(
      {this.text,
      this.fontsize = 18,
      this.isBold = false,
      this.radius = 0,
      this.textColor = Colors.white,
      this.bgColor = Colors.blue,
      this.width = 120,
      this.height = 40,
      this.tapFunc = null,
      this.doubleTapFunc = null,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var s = window.physicalSize;
    var rp =  window.devicePixelRatio;
    print(s);
    if (this.width <= 1) {
      this.width = (s.width * this.width)/rp;
    }
    if (this.height <= 1) {
      this.height = (s.height * this.height)/rp;
    }
    return GestureDetector(
        onTap: this.tapFunc,
        onDoubleTap: this.doubleTapFunc,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Container(
              width: width,
              height: height,
              color: this.bgColor,
              child: Center(
                child: Text(
                  text,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: this.fontsize,
                      color: this.textColor,
                      fontWeight:
                          this.isBold ? FontWeight.bold : FontWeight.normal),
                ),
              )),
        ));
  }
}

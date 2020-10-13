import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/myAnimation.dart';

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
      : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    var s = window.physicalSize;
    var rp = window.devicePixelRatio;
    print(s);
    if (this.width <= 1) {
      this.width = (s.width * this.width) / rp;
    }
    if (this.height <= 1) {
      this.height = (s.height * this.height) / rp;
    }
    return Container(
      child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
              Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(this.radius),
                        color: this.bgColor),
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
                    ),
              ),
            FlashCover(
                startOpac: 0,
                endOpac: 0.5,
                width: this.width,
                height: this.height,
                flashDura: 200,
                flashColor: Colors.white,
                tapFunc: this.tapFunc,
                radius: this.radius),
          ]
      ),
    );
  }
}

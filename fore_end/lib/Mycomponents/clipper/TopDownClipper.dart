import 'package:flutter/cupertino.dart';

class TopDownClipper extends CustomClipper<Rect>{
  final double height;

  TopDownClipper(this.height);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width, height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }

}
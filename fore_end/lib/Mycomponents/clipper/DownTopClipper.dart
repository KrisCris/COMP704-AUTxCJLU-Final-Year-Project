import 'package:flutter/cupertino.dart';

class DownTopClipper extends CustomClipper<Rect>{
  final double height;

  DownTopClipper(this.height);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, size.height-height, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }

}
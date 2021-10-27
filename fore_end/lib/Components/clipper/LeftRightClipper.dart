import 'package:flutter/cupertino.dart';

///用于从左往右执行剪切的矩形clipper
class LeftRightClipper extends CustomClipper<Rect> {
  final double width;

  LeftRightClipper(this.width);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

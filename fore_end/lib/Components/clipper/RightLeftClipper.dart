import 'package:flutter/cupertino.dart';

///用于从右往左执行剪切的矩形clipper
class RightLeftClipper extends CustomClipper<Rect> {
  final double width;

  RightLeftClipper(this.width);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width - width, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

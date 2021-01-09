import 'package:flutter/cupertino.dart';

class RightLeftClipper extends CustomClipper<Rect>{
  final double width;

  RightLeftClipper(this.width);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width-width, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }

}
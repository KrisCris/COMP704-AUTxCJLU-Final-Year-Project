import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'dart:math' as math;

class RotateIcon extends StatefulWidget {
  double angle;
  IconData icon;
  int rotateTime;
  double iconSize;
  Color iconColor;
  Function onTap;

  RotateIcon(
      {Key key,
      this.onTap,
      this.angle = math.pi,
      @required this.icon,
      this.rotateTime = 150,
      this.iconSize = 12,
      this.iconColor = Colors.blue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RotateIconState();
  }
}

class RotateIconState extends State<RotateIcon> with TickerProviderStateMixin {
  TweenAnimation<double> angleAnimation = new TweenAnimation<double>();
  bool fowardRotating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.angleAnimation.initAnimation(0, widget.angle, widget.rotateTime, this,
        () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: this._innerOnTap,
        child: Transform.rotate(
          angle: this.angleAnimation.getValue(),
          child: Icon(
            widget.icon,
            color: Colors.blue,
          ),
        ));
  }

  void _innerOnTap() {
    if (this.fowardRotating) {
      this.fowardRotating = false;
      this.angleAnimation.reverse();
    } else {
      this.fowardRotating = true;
      this.angleAnimation.forward();
    }
    widget.onTap();
  }
}

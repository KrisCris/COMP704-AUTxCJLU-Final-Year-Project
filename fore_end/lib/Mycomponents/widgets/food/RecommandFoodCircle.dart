import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/painter/CirclePainter.dart';

class RecommandFoodCircle extends StatefulWidget {
  Food food;
  double pictureSize;
  Function onClick;
  Function onCheck;
  Function onUnCheck;

  RecommandFoodCircle(
      {Key key,
      this.food,
      this.pictureSize,
      this.onClick,
      this.onUnCheck,
      this.onCheck})
      : super(key: key);

  @override bool get wantKeepAlive =>true;
  @override
  State<StatefulWidget> createState() {
    return RecommandFoodCircleState();
  }
}

class RecommandFoodCircleState extends State<RecommandFoodCircle>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isCheck = false;
  bool checkStateWhenTap = false;
  bool tapStart = false;
  TweenAnimation<double> circleAnimation;

  @override
  void initState() {
    this.circleAnimation = new TweenAnimation<double>();
    this.circleAnimation.initAnimation(0.0, 1.0, 500, this, null);
    this.circleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.isCheck = true;
        if (widget.onCheck != null) {
          widget.onCheck();
        }
        setState(() {});
      } else if (status == AnimationStatus.dismissed) {
        this.isCheck = false;
        if (widget.onUnCheck != null) {
          widget.onUnCheck();
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!this.tapStart) {
          this.tapStart = true;
          this.checkStateWhenTap = this.isCheck;
        }
        if (this.isCheck != this.checkStateWhenTap) return;

        if (this.isCheck) {
          this.circleAnimation.reverse();
        } else {
          this.circleAnimation.forward();
        }
      },
      onTapUp: (TapUpDetails details) {
        if (this.isCheck) {
          this.circleAnimation.forward();
        } else {
          this.circleAnimation.reverse();
        }
        this.tapStart = false;
      },
      onTapCancel: () {
        if (this.isCheck) {
          this.circleAnimation.forward();
        } else {
          this.circleAnimation.reverse();
        }
        this.tapStart = false;
      },
      child: Stack(
        children: [foodCircle(context), checkCover()],
      ),
    );
  }

  Widget foodCircle(BuildContext context) {
    Image img = widget.food.picture == null
        ? Image.asset(
            Food.defaultPicturePath,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            width: widget.pictureSize,
            height: widget.pictureSize,
          )
        : Image.memory(
            base64Decode(widget.food.picture),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            width: widget.pictureSize,
            height: widget.pictureSize,
          );
    return CustomPaint(
      painter: CirclePainter(context: context, animation: this.circleAnimation),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.pictureSize), child: img),
    );
  }

  Widget checkCover() {
    if (this.isCheck) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(widget.pictureSize),
          child: Container(
            width: widget.pictureSize,
            height: widget.pictureSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: MyTheme.convert(ThemeColorName.TransparentShadow)),
            child: Icon(
              FontAwesomeIcons.check,
              color: MyTheme.convert(ThemeColorName.NormalIcon),
              size: widget.pictureSize * 0.7,
            ),
          ));
    }
    return SizedBox();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';

class FoodBox extends StatefulWidget {
  static const String defaultPicturePath = "image/defaultFood.png";

  Food food;
  String picture;
  double height;
  double width;
  double detailedPaddingLeft;
  double paddingLeft;
  double paddingBottom;
  double paddingTop;
  double paddingRight;
  double borderRadius;
  int expandDuration;

  FoodBox(
      {@required String picture = "",
      @required Food food,
      double height = 70,
      double detailedPaddingLeft = 30,
      double paddingLeft = 10,
      double paddingBottom = 50,
      double paddingTop = 0,
      double paddingRight = 30,
      int expandDuration = 150,
        double borderRadius = 35,
      double width = 1})
      : assert(food != null) {
    this.food = food;
    this.picture = picture;
    this.height = ScreenTool.partOfScreenHeight(height);
    this.width = ScreenTool.partOfScreenWidth(width);
    this.detailedPaddingLeft = detailedPaddingLeft;
    this.paddingLeft = paddingLeft;
    this.paddingTop = paddingTop;
    this.paddingBottom = paddingBottom;
    this.paddingRight = paddingRight;
    this.expandDuration = expandDuration;
    this.borderRadius = borderRadius;
  }

  @override
  State<StatefulWidget> createState() {
    return new FoodBoxState();
  }
}

class FoodBoxState extends State<FoodBox> with TickerProviderStateMixin {
  TweenAnimation<double> expandAnimation = TweenAnimation<double>();
  TweenAnimation<double> iconAngleAnimation = TweenAnimation<double>();
  bool isTurningUp = false;
  double expandedHeight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.expandAnimation.initAnimation(
        widget.height, widget.height, widget.expandDuration, this, () {
      setState(() {});
    });
    this.iconAngleAnimation.initAnimation(0.0, pi, widget.expandDuration, this,
        () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.getBorderBox();
  }

  Widget getBorderBox() {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: widget.expandDuration),
      width: widget.width,
      child: this.getContainer(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12, //阴影范围
              spreadRadius: 4, //阴影浓度
              color: Color(0x33000000), //阴影颜色
            )
          ]),
    );
  }

  Widget getContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.paddingTop,
        ),
        this.getHeader(),
        AnimatedCrossFade(
            firstChild: Container(
              height: 0.0,
            ),
            secondChild: this.getDetailedProperty(),
            crossFadeState: this.isTurningUp
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: widget.expandDuration))
      ],
    );
  }

  Widget getHeader() {
    return Container(
      height: widget.height,
      child: Row(children: [
        SizedBox(width: widget.paddingLeft),
        getFoodPic(),
        SizedBox(width: 20),
        Expanded(child: getFoodName()),
        getExpandIcon(),
        SizedBox(width: widget.paddingRight)
      ]),
    );
  }

  Widget getFoodPic() {
    ImageProvider img = AssetImage(FoodBox.defaultPicturePath);

    if (widget.picture != "" && widget.picture != null) {
      img = MemoryImage(base64Decode(widget.picture));
    }
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(

        color: Colors.yellow,
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: img,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget getFoodName() {
    return Text(
      widget.food.name,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: "Futura",
          color: Colors.black),
    );
  }

  Widget getExpandIcon() {
    return GestureDetector(
        onTap: expandIconTap,
        child: Transform.rotate(
          angle: this.iconAngleAnimation.getValue(),
          child: Icon(
            FontAwesomeIcons.chevronDown,
            color: Colors.blue,
          ),
        ));
  }

  Widget getDetailedProperty() {
    return Column(
      children: [
        this.propertyLine("calorie", widget.food.getCalorie()),
        this.propertyLine("VC", "61mg"),
        this.propertyLine("VD", "39mg"),
        this.propertyLine("VD", "39mg"),
        this.propertyLine("water", "721mg"),
        SizedBox(
          height: widget.paddingBottom,
        )
      ],
    );
  }

  Widget propertyLine(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.detailedPaddingLeft,
        ),
        Expanded(
          child: Text(name,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Futura",
                  color: Colors.black)),
        ),
        Text(
          value,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black),
        ),
        SizedBox(
          width: widget.paddingRight,
        )
      ],
    );
  }

  void expandIconTap() {
    if (this.isTurningUp) {
      this.isTurningUp = false;
      widget.borderRadius = 50;
      this.iconAngleAnimation.reverse();
    } else {
      this.isTurningUp = true;
      widget.borderRadius = 35;
      this.iconAngleAnimation.forward();
    }
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';

class SmallFoodBox extends StatefulWidget {
  double pictureSize;
  TextStyle style;
  TextStyle figureStyle;
  Food food;
  Function(Food f) onclick;
  SmallFoodBox(
      {@required this.food,
      this.onclick,
      this.pictureSize = 40,
      TextStyle style,
      Key key})
      : assert(food != null),
        super(key: key) {
    this.style = style ??
        TextStyle(
            fontFamily: "Futura",
            fontSize: 15,
            decoration: TextDecoration.none,
            color: MyTheme.convert(ThemeColorName.NormalText));
    this.figureStyle = TextStyle(
        fontFamily: "Futura",
        fontSize: this.style.fontSize * 0.8,
        decoration: TextDecoration.none,
        color: MyTheme.convert(ThemeColorName.NormalText));
  }
  @override
  State<StatefulWidget> createState() {
    return SmallFoodBoxState();
  }
}

class SmallFoodBoxState extends State<SmallFoodBox> {
  bool showDetail = false;
  @override
  Widget build(BuildContext context) {
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
    return GestureDetector(
      onTap: () {
        if (this.widget.onclick != null) {
          this.widget.onclick(this.widget.food);
        } else {
          setState(() {
            showDetail = !showDetail;
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 5),
          ClipRRect(
              borderRadius: BorderRadius.circular(widget.pictureSize),
              child: img),
          SizedBox(width: 5),
          AnimatedCrossFade(
            firstChild: SizedBox(width: 0),
            secondChild: Container(
                height: widget.pictureSize,
                width: 80,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    Text(widget.food.getName(context), style: widget.style),
                    Text(
                        "Calorie: " +
                            widget.food.getCalories().toString() +
                            "Kcal",
                        style: widget.figureStyle),
                    Text(
                        "Protein: " +
                            widget.food.getProtein().toString() +
                            "mg",
                        style: widget.figureStyle),
                  ],
                )),
            crossFadeState: this.showDetail
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 100),
          )
        ],
      ),
    );
  }
}

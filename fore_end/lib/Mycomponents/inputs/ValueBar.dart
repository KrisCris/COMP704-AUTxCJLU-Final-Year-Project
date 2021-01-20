import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/painter/BorderPainter.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/interface/Valueable.dart';

class ValueBar<T> extends StatefulWidget with ValueableWidgetMixIn<T> {
  double width;
  double barThickness;
  List<double> edgeEmpty;
  bool showValue;
  double borderThickness;
  double minVal;
  double maxVal;
  double blockWidth;
  Color borderColor;
  Color barColor;
  Color effectColor;

  ValueBar(
      {double width = 100,
      this.barThickness = 10,
      this.borderThickness = 3,
      this.edgeEmpty,
      this.showValue = true,
      this.borderColor = Colors.black,
      this.barColor = Colors.green,
      this.effectColor = Colors.greenAccent,
      this.blockWidth = 10,
      this.minVal = 0,
      this.maxVal = 100,
      @required T initVal})
      : assert(initVal != null) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.widgetValue = ValueNotifier(initVal);
  }
  @override
  State<StatefulWidget> createState() {
    return ValueBarState();
  }
}

class ValueBarState extends State<ValueBar>
    with ValueableStateMixIn, TickerProviderStateMixin {
  TweenAnimation<double> moveAnimation;
  TweenAnimation<double> barWidthAnimation;
  bool needBarAnimation = true;
  double startDragX;
  @override
  void didUpdateWidget(covariant ValueBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.widgetValue = oldWidget.widgetValue;
  }

  @override
  void initState() {
    this.initValueListener(widget.widgetValue);

    this.moveAnimation = TweenAnimation<double>();
    this.barWidthAnimation = TweenAnimation<double>();

    this
        .barWidthAnimation
        .initAnimation(widget.blockWidth, widget.blockWidth, 200, this, () {
      setState(() {});
    });
    this.moveAnimation.initAnimation(0.0, widget.barThickness, 800, this, () {
      setState(() {});
    });
    this.moveAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.moveAnimation.initAnimation(0.0, widget.barThickness, 800, this,
            () {
          setState(() {});
        });
        this.moveAnimation.forward();
      }
    });
    this.moveAnimation.forward();
    this.onChangeValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dragHead = GestureDetector(
        onPanStart: (DragStartDetails dt) {
          print("drag start");
          this.needBarAnimation = false;
          this.startDragX = dt.localPosition.dx;
        },
        onPanUpdate: (DragUpdateDetails dt) {
          print("dragging");
          this.solveDragSpace(dt.localPosition.dx);
        },
        onPanEnd: (DragEndDetails dt) {
          this.needBarAnimation = true;
        },
        child: Container(
          width: widget.blockWidth,
          height: widget.barThickness,
          margin: EdgeInsets.only(
              left: this.barWidthAnimation.getValue() + widget.borderThickness,
              top: 5),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 4, spreadRadius: 4)
          ]),
        ));

    Widget bar = CustomPaint(
        foregroundPainter: BorderPainter(
          borderRadius_LT_LB_RT_RB: [2, 2, 2, 2],
          edgeEmptySize: widget.edgeEmpty,
          color: widget.borderColor,
          borderWidth: widget.borderThickness,
        ),
        child: Container(
          width: widget.width,
          height: widget.barThickness + 10,
          color: Color(0x55AAAAAA),
          child: Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(widget.borderThickness, 5),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: CustomPaint(
                    foregroundPainter: LinePainter(
                        color: widget.effectColor,
                        lineWidth: 4,
                        lineGap: 10,
                        moveVal: this.moveAnimation.getValue()),
                    child: Container(
                      width: this.barWidthAnimation.getValue(),
                      height: widget.barThickness,
                      color: widget.barColor,
                    ),
                  )),
            ),
          ),
        ));
    if (widget.showValue) {
      return Container(
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("-"),
                Expanded(child:SizedBox()),
                Text(widget.widgetValue.value.toString()),
                Expanded(child:SizedBox()),
                Text("+"),
              ],
            ),
            SizedBox(height: 10),
            Stack(
              children: [bar, dragHead],
            )
          ],
        ),
      );
    } else {
      return Stack(
        children: [bar, dragHead],
      );
    }
  }

  @override
  void onChangeValue() {
    if (!this.needBarAnimation) return;

    double persent = widget.widgetValue.value / widget.maxVal;
    double firstVal = this.barWidthAnimation.getValue();
    this.barWidthAnimation.initAnimation(
        firstVal,
        (widget.width - 2 * widget.borderThickness - widget.blockWidth) *
            persent,
        200,
        this, () {
      setState(() {});
    });
    this.barWidthAnimation.forward();
  }

  void solveDragSpace(double dx) {
    if (dx > widget.width - 2 * widget.borderThickness - widget.blockWidth){
      dx=widget.width - 2 * widget.borderThickness - widget.blockWidth;
    }else if(dx < 0){
     dx=0;
    }

    double persentage = dx / (widget.width - 2 * widget.borderThickness - widget.blockWidth);
    double value = NumUtil.getNumByValueDouble(persentage * widget.maxVal, 2);
    widget.widgetValue.value = value;
    this.barWidthAnimation.initAnimation(dx, dx, 200, this, () {});
    setState(() {});
  }
}

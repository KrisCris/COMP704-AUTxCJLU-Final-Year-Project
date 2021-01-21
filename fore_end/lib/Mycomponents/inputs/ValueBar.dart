import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/painter/BorderPainter.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/painter/ValueBarBackgroundPainter.dart';
import 'package:fore_end/interface/Valueable.dart';

class ValueBar<T> extends StatefulWidget with ValueableWidgetMixIn<T> {
  double width;
  double barThickness;
  List<double> edgeEmpty;
  List<double> borderRadius_LT_LB_RT_RB;
  bool showBorder;
  bool showValue;
  bool showAdjustButton;
  double borderDistance;
  double borderThickness;
  double effectThickness;
  double effectGap;
  double minVal;
  double maxVal;
  double blockWidth;
  Color borderColor;
  Color barColor;
  Color effectColor;

  ValueBar(
      {double width = 100,
      this.barThickness = 10,
      this.borderThickness = 2,
      List<double> borderRadius_RT_RB_RT_RB,
      this.showBorder = true,
      this.effectThickness = 20,
      this.effectGap = 45,
      this.edgeEmpty,
      this.showValue = false,
      this.showAdjustButton = false,
      this.borderColor = Colors.black,
      this.borderDistance = 0,
      Color barColor,
      Color effectColor,
      this.blockWidth = 10,
      this.minVal = 0,
      this.maxVal = 100,
      @required T initVal})
      : assert(initVal != null) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.widgetValue = ValueNotifier(initVal);
    if (barColor == null) {
      barColor = Color(0xFF50DC96);
    }
    if (effectColor == null) {
      effectColor = Color(0xFF37BC79);
    }
    if (borderRadius_RT_RB_RT_RB == null) {
      borderRadius_RT_RB_RT_RB = [0, 0, 0, 0];
    }
    this.borderRadius_LT_LB_RT_RB = borderRadius_RT_RB_RT_RB;
    this.barColor = barColor;
    this.effectColor = effectColor;
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
    this.moveAnimation.initAnimation(0.0, widget.effectGap, 800, this, () {
      setState(() {});
    });
    this.moveAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.moveAnimation.initAnimation(0.0, widget.effectGap, 800, this, () {
          setState(() {});
        });
        this.moveAnimation.forward();
      }
    });
    // this.moveAnimation.forward();
    this.onChangeValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dragHead = GestureDetector(
        onPanStart: (DragStartDetails dt) {
          this.needBarAnimation = false;
          this.startDragX = dt.localPosition.dx;
        },
        onPanUpdate: (DragUpdateDetails dt) {
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
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: Colors.black38, blurRadius: 4, spreadRadius: 4)
              ]),
        ));

    Widget bar = CustomPaint(
        painter: ValueBarBackgroundPainter(
            radius: widget.borderRadius_LT_LB_RT_RB,
            showAdjustButton: widget.showAdjustButton,
            showNumber: widget.showValue,
            color: Color(0x77AAAAAA)),
        foregroundPainter: BorderPainter(
            borderRadius_LT_LB_RT_RB: widget.borderRadius_LT_LB_RT_RB,
            edgeEmptySize: widget.edgeEmpty,
            color: widget.borderColor,
            showBorder: widget.showBorder,
            borderWidth: widget.borderThickness,
            borderDistance: widget.borderDistance),
        child: Container(
          width: widget.width,
          height: widget.barThickness + 10,
          child: Align(
            alignment: Alignment.topLeft,
            child: Transform.translate(
              offset: Offset(widget.borderThickness, 5),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft:
                          Radius.circular(widget.borderRadius_LT_LB_RT_RB[0]),
                      bottomLeft:
                          Radius.circular(widget.borderRadius_LT_LB_RT_RB[1]),
                      topRight: Radius.circular(0),
                      bottomRight: Radius.circular(0)),
                  child: CustomPaint(
                    foregroundPainter: LinePainter(
                        color: widget.effectColor,
                        lineWidth: widget.effectThickness,
                        lineGap: widget.effectGap,
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
    Widget number = Transform.translate(
        offset: Offset(widget.width / 2 - calculateTextOffset(), -17),
        child: Text(
          widget.widgetValue.value.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));

    List<Widget> res = [];
    List<Widget> barInfo = [bar, dragHead];
    if (widget.showValue) barInfo.add(number);
    res.add(Positioned(left: 0, bottom: 0, child: Stack(children: barInfo)));

    if (widget.showAdjustButton) {
      Widget minusButton = Positioned(
          left: 6,
          top: 4,
          child: CustomIconButton(
            theme: MyTheme.blackAndWhite,
            icon: FontAwesomeIcons.minus,
            iconSize: 12,
            backgroundOpacity: 1,
            borderRadius: 2,
            buttonSize: 17,
            onClick: () {
              addValue(-1);
            },
          ));
      Widget addButton = Positioned(
          right: 6,
          top: 4,
          child: CustomIconButton(
            theme: MyTheme.blackAndWhite,
            icon: FontAwesomeIcons.plus,
            iconSize: 12,
            backgroundOpacity: 1,
            borderRadius: 2,
            buttonSize: 17,
            onClick: () {
              addValue(1);
            },
          ));
      res.add(minusButton);
      res.add(addButton);
    }
    return Container(
      width: widget.width,
      height: widget.barThickness + 30,
      child: Stack(
        children: res
      ),
    );
    Stack(
      children: res,
    );
  }
  void addValue(double delta){
    double after = widget.widgetValue.value + delta;
    if(after < widget.minVal){
      after = widget.minVal;
    }else if(after > widget.maxVal){
      after = widget.maxVal;
    }
    if(widget.widgetValue.value is double){
      widget.widgetValue.value = NumUtil.getNumByValueDouble(after, 1);
    }else if(widget.widgetValue.value is int){
      widget.widgetValue.value = after.round();
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
    this.moveAnimation.forward();
  }

  double calculateTextOffset() {
    if (widget.widgetValue.value < 10) {
      if (widget.widgetValue.value is double) {
        return 10;
      } else if (widget.widgetValue.value is int) {
        return 5;
      }
    } else if (widget.widgetValue.value < 100) {
      if (widget.widgetValue.value is double) {
        return 15;
      } else if (widget.widgetValue.value is int) {
        return 10;
      }
    }else {
      if (widget.widgetValue.value is double) {
        return 20;
      } else if (widget.widgetValue.value is int) {
        return 15;
      }
    }
  }

  void solveDragSpace(double dx) {
    if (dx > widget.width - 2 * widget.borderThickness - widget.blockWidth) {
      dx = widget.width - 2 * widget.borderThickness - widget.blockWidth;
    } else if (dx < 0) {
      dx = 0;
    }

    double persentage =
        dx / (widget.width - 2 * widget.borderThickness - widget.blockWidth);
    double value = NumUtil.getNumByValueDouble(persentage * widget.maxVal, 1);
    if(widget.widgetValue.value is double){
      widget.widgetValue.value = value;
    }else if (widget.widgetValue.value is int){
      widget.widgetValue.value = value.round();
    }
    this.barWidthAnimation.initAnimation(dx, dx, 200, this, () {});
    setState(() {});
  }
}

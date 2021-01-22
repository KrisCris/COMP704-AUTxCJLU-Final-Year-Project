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

enum ValuePosition { left, center, right }

class ValueBar<T> extends StatefulWidget with ValueableWidgetMixIn<T> {
  double width;
  double barThickness;
  int roundNum;
  double adjustVal;
  Function onChange;
  List<double> edgeEmpty;
  List<double> borderRadius_LT_LB_RT_RB;
  bool showBorder;
  bool showValue;
  bool showDragHead;
  ValuePosition valuePosition;
  bool showAdjustButton;
  double borderDistance;
  double borderThickness;
  double effectThickness;
  double effectGap;
  ValueNotifier<double> minVal;
  double maxVal;
  double blockWidth;
  String valueName;
  String unit;
  Color borderColor;
  Color barColor;
  Color effectColor;
  Color fontColor;

  ValueBar(
      {double width = 100,
      this.barThickness = 10,
      this.borderThickness = 2,
      this.onChange,
      List<double> borderRadius_RT_RB_RT_RB,
      this.showBorder = true,
      this.roundNum = 1,
      this.adjustVal = 1.0,
      this.effectThickness = 20,
      this.valueName = "",
      ValuePosition valuePosition = ValuePosition.center,
      this.unit = "",
      this.effectGap = 45,
      this.edgeEmpty,
      this.showValue = false,
      bool showAdjustButton = false,
      this.showDragHead = true,
      this.borderColor = Colors.black,
      this.borderDistance = 0,
      Color barColor,
      Color effectColor,
      Color fontColor,
      this.blockWidth = 10,
      double minVal = 0,
      this.maxVal = 100,
      @required T initVal})
      : assert(initVal != null) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.widgetValue = ValueNotifier(initVal);
    this.minVal = ValueNotifier(minVal);
    this.valuePosition = valuePosition;
    if (valuePosition != ValuePosition.center) {
      showAdjustButton = false;
    }
    this.showAdjustButton = showAdjustButton;
    if (barColor == null) {
      barColor = Color(0xFF50DC96);
    }
    if (effectColor == null) {
      effectColor = Color(0xFF37BC79);
    }
    if (fontColor == null) {
      fontColor = Colors.white;
    }
    if (borderRadius_RT_RB_RT_RB == null) {
      borderRadius_RT_RB_RT_RB = [0, 0, 0, 0];
    }
    this.borderRadius_LT_LB_RT_RB = borderRadius_RT_RB_RT_RB;
    this.barColor = barColor;
    this.effectColor = effectColor;
    this.fontColor = fontColor;
  }
  void setOnChange(Function f) {
    this.onChange = f;
  }
  void changeMin(double min){
    this.minVal.value = min;
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
  void dispose() {
    moveAnimation.dispose();
    barWidthAnimation.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ValueBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.widgetValue = oldWidget.widgetValue;
    widget.minVal = oldWidget.minVal;
    widget.onChange = oldWidget.onChange;
  }

  @override
  void initState() {
    this.initValueListener(widget.widgetValue);
    widget.minVal.addListener(() {
      if(widget.widgetValue.value < widget.minVal.value){
        if(widget.widgetValue.value is int){
          widget.widgetValue.value = widget.minVal.value.ceil();
        }else{
          widget.widgetValue.value = widget.minVal.value ;
        }
      }else{
        onChangeValue();
      }
    });
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
    this.onChangeValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bar = CustomPaint(
        painter: ValueBarBackgroundPainter(
            radius: widget.borderRadius_LT_LB_RT_RB,
            showAdjustButton: widget.showAdjustButton,
            showNumber: widget.showValue,
            position: widget.valuePosition,
            str: widget.valueName +
                " " +
                widget.widgetValue.value.toString() +
                " " +
                widget.unit,
            fontColor: widget.fontColor,
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
                      topRight: widget.showDragHead?Radius.circular(0):Radius.circular(widget.borderRadius_LT_LB_RT_RB[2]),
                      bottomRight: widget.showDragHead?Radius.circular(0):Radius.circular(widget.borderRadius_LT_LB_RT_RB[3])),
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

    List<Widget> res = [];
    List<Widget> barInfo = [bar];
    if (widget.showDragHead) {
      barInfo.add(GestureDetector(
          onPanStart: (DragStartDetails dt) {
            this.needBarAnimation = false;
            this.startDragX = dt.localPosition.dx;
          },
          onPanUpdate: (DragUpdateDetails dt) {
            this.solveDragSpace(dt.localPosition.dx,dt.delta.dx >0?1:-1);
          },
          onPanEnd: (DragEndDetails dt) {
            this.needBarAnimation = true;
          },
          child: Container(
            width: widget.blockWidth,
            height: widget.barThickness,
            margin: EdgeInsets.only(
                left:
                    this.barWidthAnimation.getValue() + widget.borderThickness,
                top: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38, blurRadius: 4, spreadRadius: 4)
                ]),
          )));
    }
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
              addValue(-1 * widget.adjustVal);
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
              addValue(widget.adjustVal);
            },
          ));
      res.add(minusButton);
      res.add(addButton);
    }
    return Container(
      width: widget.width,
      height: widget.barThickness + 30,
      child: Stack(children: res),
    );
    Stack(
      children: res,
    );
  }

  void addValue(double delta) {
    double after = widget.widgetValue.value + delta;
    if (after < widget.minVal.value) {
      after = widget.minVal.value;
    } else if (after > widget.maxVal) {
      after = widget.maxVal;
    }
    if (widget.widgetValue.value is double) {
      widget.widgetValue.value =
          NumUtil.getNumByValueDouble(after, widget.roundNum);
    } else if (widget.widgetValue.value is int) {
      widget.widgetValue.value = after.floor();
    }
  }

  @override
  void onChangeValue() {
    if (widget.onChange != null) {
      widget.onChange();
    }
    if (!this.needBarAnimation) return;

    double persent = (widget.widgetValue.value - widget.minVal.value) /
        (widget.maxVal - widget.minVal.value);
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

  void solveDragSpace(double dx,int addOrMinus) {
    dx = dx- widget.blockWidth/2;
    if (dx > widget.width - 2 * widget.borderThickness - widget.blockWidth) {
      dx = widget.width - 2 * widget.borderThickness - widget.blockWidth;
    } else if (dx < 0) {
      dx = 0;
    }

    double persentage =
        dx / (widget.width - 2 * widget.borderThickness - widget.blockWidth);
    if(persentage < 0)persentage = 0;
    else if(persentage > 100)persentage = 100;

    double value = NumUtil.getNumByValueDouble(
        widget.minVal.value + persentage * (widget.maxVal - widget.minVal.value),
        widget.roundNum);
    if (widget.widgetValue.value is double) {
      widget.widgetValue.value = value;
    } else if (widget.widgetValue.value is int) {
      widget.widgetValue.value = value.floor();
    }
    this.barWidthAnimation.initAnimation(dx, dx, 200, this, () {});
    setState(() {});
  }
}

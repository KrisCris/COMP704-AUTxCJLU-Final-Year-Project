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

class ValueBar<T extends num> extends StatefulWidget
    with ValueableWidgetMixIn<T> {
  static const double buttonSize = 20;
  static const double buttonGap = 10;

  double width;
  double barThickness;
  int roundNum;
  T adjustVal;
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
  ValueNotifier<T> minVal;
  T maxVal;
  Map<T, String> mapper;
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
      this.mapper,
      List<double> borderRadius_RT_RB_RT_RB,
      this.showBorder = true,
      this.roundNum = 1,
      @required this.adjustVal,
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
      Color effectColor = Colors.black12,
      Color fontColor,
      this.blockWidth = 10,
      @required T minVal,
      @required T maxVal,
      @required T initVal})
      : assert(initVal != null),
        assert(minVal != null),
        assert(maxVal != null),
        assert(adjustVal != null) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.widgetValue = ValueNotifier(initVal);
    this.minVal = ValueNotifier(minVal);
    this.maxVal = maxVal;
    this.valuePosition = valuePosition;
    if (valuePosition != ValuePosition.center) {
      showAdjustButton = false;
    }
    this.showAdjustButton = showAdjustButton;
    if (this.showAdjustButton) {
      this.width -= (ValueBar.buttonSize + ValueBar.buttonGap) * 2;
    }
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

  void changeMin(T min) {
    if (min > maxVal) {
      min = maxVal;
    }
    this.minVal.value = min;
  }

  @override
  State<StatefulWidget> createState() {
    return ValueBarState<T>();
  }
}

class ValueBarState<T extends num> extends State<ValueBar<T>>
    with ValueableStateMixIn, TickerProviderStateMixin {
  TweenAnimation<double> moveAnimation;
  TweenAnimation<double> barWidthAnimation;
  bool needBarAnimation = true;
  double startDragX;
  int nowIndex;

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
    if (widget.mapper != null) {
      widget.widgetValue.value = widget.mapper.keys.first;
      this.nowIndex = 0;
    }
    this.initValueListener(widget.widgetValue);
    widget.minVal.addListener(() {
      if (widget.widgetValue.value < widget.minVal.value) {
        widget.widgetValue.value = widget.minVal.value;
      } else {
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

  String getDisplayValue() {
    if (widget.mapper == null) {
      return widget.valueName +
          " " +
          widget.widgetValue.value.toString() +
          " " +
          widget.unit;
    } else {
      return widget.valueName +
          " " +
          widget.mapper[widget.widgetValue.value] +
          " " +
          widget.unit;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bar = CustomPaint(
        painter: ValueBarBackgroundPainter(
            radius: widget.borderRadius_LT_LB_RT_RB,
            showAdjustButton: widget.showAdjustButton,
            showNumber: widget.showValue,
            position: widget.valuePosition,
            str: this.getDisplayValue(),
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
                      topRight: widget.showDragHead
                          ? Radius.circular(0)
                          : Radius.circular(widget.borderRadius_LT_LB_RT_RB[2]),
                      bottomRight: widget.showDragHead
                          ? Radius.circular(0)
                          : Radius.circular(
                              widget.borderRadius_LT_LB_RT_RB[3])),
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

    List<Widget> barInfo = [bar];
    if (widget.showDragHead) {
      barInfo.add(GestureDetector(
          onPanStart: (DragStartDetails dt) {
            this.needBarAnimation = false;
            this.startDragX = dt.localPosition.dx;
          },
          onPanUpdate: (DragUpdateDetails dt) {
            this.solveDragSpace(dt.localPosition.dx, dt.delta.dx > 0 ? 1 : -1);
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

    if (widget.showAdjustButton) {
      double extra = widget.showAdjustButton
          ? (ValueBar.buttonSize + ValueBar.buttonGap) * 2
          : 0;
      // return GestureDetector(
      //     behavior: HitTestBehavior.translucent,
      //     onTapDown: (TapDownDetails dt) {
      //       if (dt.localPosition.dx >= 0 &&
      //           dt.localPosition.dx <= ValueBar.buttonSize &&
      //           dt.localPosition.dy >= 10 &&
      //           dt.localPosition.dy <= (widget.barThickness + 20)) {
      //         this.addValue(-1 * widget.adjustVal);
      //       } else if (dt.localPosition.dx >=
      //               extra / 2 + widget.width + ValueBar.buttonGap &&
      //           dt.localPosition.dx <= extra + widget.width &&
      //           dt.localPosition.dy >= 10 &&
      //           dt.localPosition.dy <= (widget.barThickness + 20)) {
      //         this.addValue(widget.adjustVal);
      //       }
      //     },
      return  Container(
              width: widget.width + extra,
              height: widget.barThickness + 30,
              child: Row(
                children: [
                   GestureDetector(
                     behavior: HitTestBehavior.translucent,
                      onTap: (){
                        this.addValue(-1 * widget.adjustVal);
                      },
                      child: Container(
                        width: ValueBar.buttonSize,
                        height: widget.barThickness+10,
                      ),
                  ),
                  SizedBox(width: ValueBar.buttonGap),
                  Stack(children: barInfo),
                  SizedBox(width: ValueBar.buttonGap),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      this.addValue( widget.adjustVal);
                    },
                    child: Container(
                      width: ValueBar.buttonSize,
                      height: widget.barThickness+10,
                    ),
                  ),
                ],
              ));
    } else {
      return Container(
        width: widget.width,
        height: widget.barThickness + 30,
        child: Stack(children: barInfo),
      );
    }
  }

  void addValue(T delta) {
    if (widget.mapper != null) {
      bool isNext = false;
      int idx = -1;
      T last;
      for (T val in widget.mapper.keys) {
        idx++;
        if (isNext) {
          this.nowIndex = idx;
          widget.widgetValue.value = val;
          break;
        }
        if (val == widget.widgetValue.value) {
          if (delta < 0) {
            if (last != null) {
              this.nowIndex = idx - 1;
              widget.widgetValue.value = last;
              break;
            }
          } else {
            isNext = true;
          }
        }
        last = val;
      }
      return;
    }

    T after = widget.widgetValue.value + delta;
    if (after < widget.minVal.value) {
      after = widget.minVal.value;
    } else if (after > widget.maxVal) {
      after = widget.maxVal;
    }
    if (widget.widgetValue.value is double) {
      widget.widgetValue.value =
          NumUtil.getNumByValueDouble((after as double), widget.roundNum);
    } else if (widget.widgetValue.value is int) {
      widget.widgetValue.value = after;
    }
  }

  @override
  void onChangeValue() {
    if (widget.onChange != null) {
      widget.onChange();
    }
    if (!this.needBarAnimation) return;
    double persent = 0.0;
    if (widget.mapper != null) {
      int mapSize = widget.mapper.length;
      persent = this.nowIndex / (mapSize - 1);
    } else {
      T denominator = widget.maxVal - widget.minVal.value;
      if (denominator == 0) {
        persent = 1;
      } else {
        persent = (widget.widgetValue.value - widget.minVal.value) /
            (widget.maxVal - widget.minVal.value);
      }
    }
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

  void solveDragSpace(double dx, int addOrMinus) {
    dx = dx - widget.blockWidth / 2;
    if (dx > widget.width - 2 * widget.borderThickness - widget.blockWidth) {
      dx = widget.width - 2 * widget.borderThickness - widget.blockWidth;
    } else if (dx < 0) {
      dx = 0;
    }

    double persentage =
        dx / (widget.width - 2 * widget.borderThickness - widget.blockWidth);
    if (persentage < 0)
      persentage = 0;
    else if (persentage > 100) persentage = 100;

    T value = widget.widgetValue.value;
    if (widget.mapper != null) {
      int mapSize = widget.mapper.length;
      int idx = 0, min = 0;
      T minVal = widget.mapper.keys.first;
      for (T val in widget.mapper.keys) {
        double persentage_circle = idx / mapSize;
        double persentage_min = min / mapSize;
        if ((persentage - persentage_circle).abs() <
            (persentage - persentage_min).abs()) {
          min = idx;
          minVal = val;
        }
        idx++;
      }
      value = minVal;
    } else {
      if (value is int) {
        value = widget.minVal.value +
            (persentage * (widget.maxVal - widget.minVal.value)).floor();
      } else {
        value = NumUtil.getNumByValueDouble(
            widget.minVal.value +
                persentage * (widget.maxVal - widget.minVal.value),
            widget.roundNum);
      }
    }
    widget.widgetValue.value = value;
    this.barWidthAnimation.initAnimation(dx, dx, 200, this, () {});
    setState(() {});
  }
}

import 'package:flutter/cupertino.dart';
import 'package:fore_end/Utils/MyAnimation.dart';
import 'package:fore_end/Utils/CalculatableColor.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/painters/PersentPainter.dart';

class PersentBar extends StatefulWidget {
  final List<PersentSection> sections;
  double width;
  double height;

  PersentBar(
      {@required this.sections,
      @required double width,
      @required double height,
      Key key})
      : super(key: key) {
    this.height = ScreenTool.partOfScreenHeight(height);
    this.width = ScreenTool.partOfScreenWidth(width);
  }

  @override
  State<StatefulWidget> createState() {
    return PersentBarState();
  }
}

class PersentBarState extends State<PersentBar> with TickerProviderStateMixin {
  TweenAnimation<PersentSection> changes;
  List<PersentSection> sections;
  PersentPainter painter;
  int changingIndex = -1;
  @override
  void initState() {
    this.changes = TweenAnimation<PersentSection>();
    this.sections = widget.sections;
    this.changes.initAnimation(null, null, 200, this, null);
    this.changes.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.sections[changingIndex] = this.changes.value;
        changingIndex = -1;
      }
    });
    super.initState();
  }

  void changePersentByIndex(int index, double persent) {
    this.changingIndex = index;
    this.painter.changingIndex = this.changingIndex;
    Color newColor = sections[index].normalColor;
    if (sections[index].warningPersent != null &&
        persent > sections[index].warningPersent) {
      newColor = sections[index].highColor;
    } else if (sections[index].minPersent != null &&
        persent < sections[index].minPersent) {
      newColor = sections[index].lowColor;
    }
    PersentSection nowSection = sections[index];
    if (this.changes.isForward() || this.changes.isReverse()) {
      nowSection = this.changes.currentValue();
    }
    this.changes.initAnimation(
        nowSection,
        PersentSection(
          color: newColor,
          lowColor: sections[index].lowColor,
          highColor: sections[index].highColor,
          normalColor: sections[index].normalColor,
          name: sections[index].name,
          persent: persent,
          maxPersent: sections[index].warningPersent,
          minPersent: sections[index].minPersent,
        ),
        200,
        this,
        null);
    this.changes.forward();
  }

  @override
  Widget build(BuildContext context) {
    this.painter = PersentPainter(
        context: context,
        animation: changes,
        sections: this.sections,
        changingIndex: this.changingIndex);
    return CustomPaint(
      foregroundPainter: painter,
      child: Container(width: widget.width, height: widget.height),
    );
  }
}

class PersentSection {
  ///当前显示的颜色
  CalculatableColor color;

  ///TODO: 低于阈值时显示的颜色
  CalculatableColor lowColor;

  ///高于阈值时显示的颜色
  CalculatableColor highColor;

  ///正常情况显示的颜色
  CalculatableColor normalColor;

  ///用于辅助计算颜色渐变动画，使用PersentSection时，不需要为此属性赋值
  ColorChannel supportColorChannel;

  String name;
  double persent;

  ///达到偏高提醒的百分比
  double warningPersent;

  ///TODO： 达到偏低提醒的百分比
  double minPersent;

  PersentSection(
      {Color color,
      Color lowColor,
      Color highColor,
      ColorChannel channel,
      @required Color normalColor,
      String name,
      double persent,
      double maxPersent = 1.0,
      double minPersent}) {
    if (normalColor == null) {
      throw FormatException(
          "normalColor is required argument in PersentSection");
    }
    this.normalColor = CalculatableColor.transform(normalColor);
    this.color = CalculatableColor.transform(color ?? normalColor);
    this.lowColor = CalculatableColor.transform(lowColor ?? normalColor);
    this.highColor = CalculatableColor.transform(highColor ?? normalColor);
    this.name = name;
    this.persent = persent ?? 0;
    this.warningPersent = maxPersent;
    this.minPersent = minPersent;
    this.supportColorChannel = channel;
  }

  PersentSection operator +(PersentSection another) {
    return PersentSection(
      color: this.color + another.supportColorChannel,
      lowColor: this.lowColor,
      highColor: this.highColor,
      normalColor: this.normalColor,
      name: this.name,
      persent: this.persent + another.persent,
      maxPersent: this.warningPersent,
      minPersent: this.minPersent,
    );
  }

  PersentSection operator -(PersentSection another) {
    return PersentSection(
      color: null,
      channel: this.color - another.color,
      lowColor: another.lowColor,
      highColor: another.highColor,
      normalColor: another.normalColor,
      name: another.name,
      persent: this.persent - another.persent,
      maxPersent: another.warningPersent,
      minPersent: another.minPersent,
    );
  }

  PersentSection operator *(double t) {
    return PersentSection(
      color: null,
      channel: this.supportColorChannel * t,
      lowColor: this.lowColor,
      highColor: this.highColor,
      normalColor: this.normalColor,
      name: this.name,
      persent: this.persent * t,
      maxPersent: this.warningPersent,
      minPersent: this.minPersent,
    );
  }
}

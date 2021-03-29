import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/util/CalculatableColor.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/painter/PersentPainter.dart';

class PersentBar extends StatefulWidget {
  final List<PersentSection> sections;
  double width;
  double height;

  PersentBar({@required this.sections, @required double width, @required double height,Key key}) : super(key: key){
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
  int changingIndex=-1;
  @override
  void initState() {
    this.changes = TweenAnimation<PersentSection>();
    this.sections = widget.sections;
    this.changes.initAnimation(null, null, 200, this, null);
    this.changes.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        this.sections[changingIndex] = this.changes.value;
        changingIndex = -1;
      }
    });
    super.initState();
  }

  void changePersentByIndex(int index, double persent) {
    this.changingIndex = index;
    this.painter.changingIndex = this.changingIndex;
    this.changes.initAnimation(
        sections[index],
        PersentSection(
            color: sections[index].color,
            name: sections[index].name,
            persent: persent),
        200,
        this,
        null);
    this.changes.forward();
  }

  @override
  Widget build(BuildContext context) {
    this.painter = PersentPainter(
        context: context, animation: changes, sections: this.sections, changingIndex: this.changingIndex);
    return CustomPaint(
      foregroundPainter: painter,
      child: Container(width: widget.width,height: widget.height),
    );
  }
}

class PersentSection {
  CalculatableColor color;
  String name;
  double persent;
  PersentSection({Color color, String name, double persent}) {
    this.color = CalculatableColor.transform(color);
    this.name = name;
    this.persent = persent ?? 0;
  }

  PersentSection operator +(PersentSection another) {
    return PersentSection(
        color: this.color + another.color,
        name: this.name,
        persent: this.persent + another.persent);
  }

  PersentSection operator -(PersentSection another) {
    return PersentSection(
        color: this.color - another.color,
        name: this.name,
        persent: this.persent - another.persent);
  }

  PersentSection operator *(double t) {
    return PersentSection(
        color: this.color * t, name: this.name, persent: this.persent * t);
  }
}

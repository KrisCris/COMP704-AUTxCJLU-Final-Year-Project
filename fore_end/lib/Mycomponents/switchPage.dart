import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class SwitchPage extends StatefulWidget {
  List<Widget> children = const <Widget>[];
  SwitchPageState state;
  ScrollController ctl;
  int currentPage = 0;
  SwitchPage({this.children, double initPosition=0, Key key}) : super(key: key) {
    this.ctl = new ScrollController(
      initialScrollOffset: initPosition
    );
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new SwitchPageState();
    return this.state;
  }

  void addPage(Widget wid) {
    this.children.add(wid);
  }

  void switchToPage(int i) {

    if(i < 0 || i > this.children.length)return;

    double dest = i * ScreenTool.partOfScreenWidth(1);
    double now = this.currentPage * ScreenTool.partOfScreenWidth(1);
    double bias = dest - now;
    if(bias == 0)return;
    this.currentPage = i;
    this.ctl.animateTo(dest,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}

class SwitchPageState extends State<SwitchPage> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: widget.ctl,
          children: widget.children),
    );
  }
}

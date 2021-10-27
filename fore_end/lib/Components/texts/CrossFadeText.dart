import 'package:flutter/cupertino.dart';
import 'package:fore_end/Utils/MyTheme.dart';

class CrossFadeText extends StatefulWidget {
  double fontSize;
  Color fontColor;
  String initText;
  Function(Duration timeStamp) onStateInitDone;

  CrossFadeText(
      {Key key,
      String text = "",
      double fontSize = 12,
      Color fontColor,
      this.onStateInitDone})
      : super(key: key) {
    this.initText = text;
    this.fontSize = fontSize;
    this.fontColor =
        MyTheme.convert(ThemeColorName.NormalText, color: fontColor);
  }

  @override
  State<StatefulWidget> createState() {
    return CrossFadeTextState();
  }
}

class CrossFadeTextState extends State<CrossFadeText>
    with TickerProviderStateMixin {
  String textA;
  String textB;
  ValueNotifier<bool> showFirst;

  void changeTo(String s) {
    if (this.showFirst.value) {
      textB = s;
      this.showFirst.value = false;
    } else {
      textA = s;
      this.showFirst.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    this.textA = widget.initText;
    this.textB = "";
    this.showFirst = ValueNotifier(true);
    this.showFirst.addListener(() {
      setState(() {});
    });
    if (widget.onStateInitDone != null) {
      WidgetsBinding.instance.addPostFrameCallback(widget.onStateInitDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: Text(this.textA,
            style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.fontColor,
                fontFamily: "Futura",
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal)),
        secondChild: Text(
          this.textB,
          style: TextStyle(
              fontSize: widget.fontSize,
              color: widget.fontColor,
              fontFamily: "Futura",
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal),
        ),
        crossFadeState: this.showFirst.value
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 150));
  }
}

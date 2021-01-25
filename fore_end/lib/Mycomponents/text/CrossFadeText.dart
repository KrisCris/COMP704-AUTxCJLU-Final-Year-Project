import 'package:flutter/cupertino.dart';

class CrossFadeText extends StatefulWidget{
  String textA;
  String textB;

  double fontSize;
  Color fontColor;

  ValueNotifier<bool> showFirst;

  CrossFadeText({String text="",double fontSize=12,Color fontColor}){
    this.textA = text;
    this.textB = "";
    this.fontSize = fontSize;
    this.fontColor = fontColor;
    this.showFirst = ValueNotifier(true);
  }

  void changeTo(String s){
    if(this.showFirst.value){
      textB = s;
      this.showFirst.value = false;
    }else{
      textA = s;
      this.showFirst.value = true;
    }
  }
  @override
  State<StatefulWidget> createState() {
      return CrossFadeTextState();
  }
}

class CrossFadeTextState extends State<CrossFadeText>
with TickerProviderStateMixin{

  @override
  void didUpdateWidget(covariant CrossFadeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.showFirst.addListener(() {setState(() {
    });});
  }
  @override
  void initState() {
    super.initState();
    widget.showFirst.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: Text(widget.textA,style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.fontColor,
            fontFamily: "Futura",
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal)),
        secondChild:Text(widget.textB,style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.fontColor,
            fontFamily: "Futura",
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal),),
        crossFadeState: widget.showFirst.value?CrossFadeState.showFirst:CrossFadeState.showSecond,
        duration:Duration(milliseconds: 150));
  }

}
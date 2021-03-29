import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';

class CrossFadeText extends StatefulWidget{
  double fontSize;
  Color fontColor;
  String initText;

  CrossFadeText({Key key,String text="",double fontSize=12,Color fontColor}):super(key:key){
    this.initText = text;
    this.fontSize = fontSize;
    this.fontColor = MyTheme.convert(ThemeColorName.NormalText, color:fontColor);

  }


  @override
  State<StatefulWidget> createState() {
      return CrossFadeTextState();
  }
}

class CrossFadeTextState extends State<CrossFadeText>
with TickerProviderStateMixin{
  String textA;
  String textB;
  ValueNotifier<bool> showFirst;

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
  void initState() {
    super.initState();
    this.textA=widget.initText;
    this.textB="";
    this.showFirst = ValueNotifier(true);
    this.showFirst.addListener(() {setState(() {
    });});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: Text(this.textA,style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.fontColor,
            fontFamily: "Futura",
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal)),
        secondChild:Text(this.textB,style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.fontColor,
            fontFamily: "Futura",
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal),),
        crossFadeState:this.showFirst.value?CrossFadeState.showFirst:CrossFadeState.showSecond,
        duration:Duration(milliseconds: 150));
  }

}
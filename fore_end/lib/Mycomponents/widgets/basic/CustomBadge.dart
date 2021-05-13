import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/Mycomponents/text/CrossFadeText.dart';

class CustomBadge extends StatefulWidget{
  CustomBadge({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return CustomBadgeState();
  }
}

class CustomBadgeState extends State<CustomBadge>{
  int hintNumber;

  @override
  void initState() {
    this.hintNumber = 0;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return this.hintNumber == 0? SizedBox():Badge(
      badgeContent: CrossFadeText(
        text: this.hintNumber.toString(),
      ),
    );
  }
  void setHintNumber(int num){
    setState(() {
      this.hintNumber = num;
    });
  }
}
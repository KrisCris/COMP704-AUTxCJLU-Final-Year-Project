import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';

class DateSelect extends StatelessWidget {
  double width;
  double height;
  GlobalKey<DateButtonState> childKey;
  DateSelect({this.width,this.height,String debugLabel="Default DateButton"}){
    this.childKey = GlobalKey<DateButtonState>(debugLabel: debugLabel);
  }
  int getDate(){
    return this.childKey.currentState.widget.getValue();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            icon: FontAwesomeIcons.chevronLeft,
            backgroundOpacity: 0,
            onClick: (){
              this.childKey.currentState.minusDay();
            },
          ),
          DateButton(key:this.childKey,paddingHorizontal: 10,),
          CustomIconButton(
            icon: FontAwesomeIcons.chevronRight,
            backgroundOpacity: 0,
            onClick: (){
              this.childKey.currentState.addDay();
            },
          ),
        ],
      ),
    );
  }
}
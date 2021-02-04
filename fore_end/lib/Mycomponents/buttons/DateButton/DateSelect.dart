import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';

class DateSelect extends StatelessWidget {
  ///宽度，包含左右箭头，不设置时，根据内部的文字长度自适应
  double width;
  ///高度
  double height;
  ///当改变日期时候，触发的函数
  Function onChangeDate;
  ///日期按钮的Key，通过该Key来获取其State
  GlobalKey<DateButtonState> childKey;

  DateSelect({this.width,this.height,this.onChangeDate, String debugLabel="Default DateButton"}){
    this.childKey = GlobalKey<DateButtonState>(debugLabel: debugLabel);
  }
  ///获取当前选择的时间戳，精确到毫秒
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
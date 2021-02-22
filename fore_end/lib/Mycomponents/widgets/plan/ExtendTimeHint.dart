import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ExtendTimeHint extends StatelessWidget {
  int extendDays;
  Function onClickAccept;
  Function onClickFinish;
  ExtendTimeHint({Key key, this.extendDays,this.onClickAccept,this.onClickFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenTool.partOfScreenHeight(1),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: ScreenTool.partOfScreenHeight(0.3),
          width: ScreenTool.partOfScreenWidth(0.8),
          decoration: BoxDecoration(
              color: MyTheme.convert(ThemeColorName.ComponentBackground),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10),
              TitleText(
                text: "Your Plan will be delayed for " +
                    extendDays.toString() +
                    " days, do you accept it or finish the plan?",
                maxHeight: 55,
                maxWidth: 0.6,
                underLineLength: 0.6,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Accept Delay",
                width: 0.6,
                radius: 5,
                tapFunc: () async {
                  if(this.onClickAccept != null){
                    await this.onClickAccept();
                  }
                  Navigator.of(context).pop(true);
                  },
              ),
              SizedBox(height: 5),
              CustomButton(
                text: "Finish Plan",
                width: 0.6,
                radius: 5,
                firstColorName: ThemeColorName.Error,
                tapFunc: ()async{
                  if(this.onClickFinish != null){
                    await this.onClickFinish();
                  }
                  Navigator.of(context).pop(false);
                }
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

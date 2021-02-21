import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ExtendTimeHint extends StatelessWidget {
  int extendDays;
  Function onAcceptDelay;
  Function onFinishPlan;
  ExtendTimeHint({Key key, this.extendDays,this.onAcceptDelay,this.onFinishPlan}) : super(key: key);

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
                tapFunc: this.acceptDelay,
              ),
              SizedBox(height: 5),
              CustomButton(
                text: "Finish Plan",
                width: 0.6,
                radius: 5,
                firstColorName: ThemeColorName.Error,
                tapFunc: this.finishPlan,
              ),
              SizedBox(height: 10),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  void acceptDelay() async {
    User u = User.getInstance();
    Response res =await Requests.delayPlan({
      "uid":u.uid,
      "token":u.token,
      "pid":u.plan.id
    });
    if(res != null && res.data['code'] == 1){
      u.plan.extendDays = res.data['data']['ext'];
    }
    if(onAcceptDelay!= null){
      onAcceptDelay();
    }
  }
  //TODO:结束计划的接口
  void finishPlan() async {
    print("unimplemented yet");
    if(onFinishPlan != null){
      onFinishPlan();
    }
  }
}

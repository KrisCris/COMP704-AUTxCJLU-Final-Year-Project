import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/Models/User.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/Req.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/CustomButton.dart';
import 'package:fore_end/Components/input/ValueBar.dart';
import 'package:fore_end/Components/texts/TitleText.dart';

class ChooseExtendTime extends StatelessWidget {
  GlobalKey<ValueBarState> barKey = GlobalKey<ValueBarState>();
  @override
  Widget build(BuildContext context) {
    ValueBar bar = ValueBar<int>(
      key: barKey,
      adjustVal: 1,
      minVal: 7,
      maxVal: 365,
      initVal: 7,
      unit: CustomLocalizations.of(context).days,
      valuePosition: ValuePosition.center,
    );
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
                text: CustomLocalizations.of(context).planDelayQuestion,
                maxHeight: 55,
                maxWidth: 0.6,
                underLineLength: 0.6,
              ),
              SizedBox(height: 20),
              bar,
              CustomButton(
                text: CustomLocalizations.of(context).confirm,
                width: 0.6,
                radius: 5,
                tapFunc: () async {
                  User u = User.getInstance();
                  int days =
                      (barKey.currentWidget as ValueBar).widgetValue.value;
                  Response res = await Requests.delayPlan(context, {
                    "uid": u.uid,
                    "token": u.token,
                    "pid": u.plan.id,
                    "days": days
                  });
                  if (res != null && res.data['code'] == 1) {
                    Navigator.of(context).pop(days);
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

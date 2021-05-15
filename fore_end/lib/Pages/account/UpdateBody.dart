import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class UpdateBody extends StatelessWidget {
  Function onUpdate;
  String text;
  ValueBar height;
  ValueBar weight;
  bool needHeight;
  bool needWeight;
  bool needCancel;

  UpdateBody(
      {this.onUpdate,
      this.text,
      this.needHeight = true,
      this.needWeight = true,
      this.needCancel = true});
  double getHeight() {
    if (this.height != null) {
      return this.height.widgetValue.value;
    } else {
      double ht = User.getInstance().bodyHeight * 100;
      return ht;
    }
  }

  int getWeight() {
    return this.weight != null
        ? this.weight.widgetValue.value
        : User.getInstance().bodyWeight;
  }

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    if (this.needHeight) {
      height = ValueBar<double>(
        barThickness: 14,
        roundNum: 2,
        adjustVal: 0.01,
        width: 0.8,
        valueName: CustomLocalizations.of(context).height,
        unit: "m",
        maxVal: 2.50,
        minVal: 1.00,
        initVal: u.bodyHeight,
        borderThickness: 4,
        barColor: Colors.white,
        showValue: true,
        showAdjustButton: true,
        showBorder: false,
      );
    }
    if (this.needWeight) {
      weight = ValueBar<int>(
        barThickness: 14,
        width: 0.8,
        valueName: CustomLocalizations.of(context).weight,
        unit: "KG",
        maxVal: 150,
        minVal: 30,
        initVal: u.bodyWeight.floor(),
        adjustVal: 1,
        barColor: Color(0xFFBCA5D6),
        borderThickness: 4,
        showValue: true,
        showAdjustButton: true,
        showBorder: false,
        borderRadius_RT_RB_RT_RB: [2, 2, 2, 2],
        edgeEmpty: [0, 0.95, 0, 0.95],
      );
    }
    return Center(
      child: Container(
        width: ScreenTool.partOfScreenWidth(0.85),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: MyTheme.convert(ThemeColorName.ComponentBackground),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                TitleText(
                  fontSize: 18,
                  text: this.text ??
                      CustomLocalizations.of(context).updateBodyTitle,
                  underLineLength: 0,
                  maxWidth: 0.7,
                  maxHeight: 60,
                ),
              ],
            ),
            SizedBox(height: 40),
            height ?? SizedBox(height: 0),
            SizedBox(height: 30),
            weight ?? SizedBox(height: 0),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                this.needCancel == true
                    ? CustomButton(
                        text: CustomLocalizations.of(context).cancel,
                        firstColorName: ThemeColorName.Error,
                        width: 80,
                        radius: 5,
                        tapFunc: () {
                          Navigator.pop(context);
                        },
                      )
                    : SizedBox(width: 0),
                Expanded(child: SizedBox()),
                CustomButton(
                    text: CustomLocalizations.of(context).confirm,
                    width: 80,
                    radius: 5,
                    tapFunc: () {
                      User u = User.getInstance();
                      if (this.weight != null) {
                        u.bodyWeight = this.weight.getValue().toDouble();
                      }
                      if (this.height != null) {
                        u.bodyHeight = this.height.getValue().toDouble();
                      }
                      u.save();
                      this.onUpdate();
                    }),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

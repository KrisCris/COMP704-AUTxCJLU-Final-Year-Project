import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/ValueBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class UpdateBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    ValueBar height = ValueBar<double>(
      barThickness: 14,
      roundNum: 2,
      adjustVal: 0.01,
      width: 0.8,
      valueName: "Height",
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

    ValueBar weight = ValueBar<int>(
      barThickness: 14,
      width: 0.8,
      valueName: "Weight",
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
    return Center(
      child: Container(
        width: ScreenTool.partOfScreenWidth(0.85),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:MyTheme.convert(ThemeColorName.ComponentBackground),
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
                  text: "Update Your Weight and Height",
                  underLineLength: 0,
                  maxWidth: 0.7,
                  maxHeight: 40,
                ),
              ],
            ),
            SizedBox(height: 40),
            height,
            SizedBox(height: 30),
            weight,
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                CustomButton(
                  text: "Cancel",
                  firstColorName: ThemeColorName.Error,
                  width: 80,
                  radius: 5,
                  tapFunc: (){
                    Navigator.pop(context);
                  },
                ) ,
                Expanded(child: SizedBox()),
                CustomButton(
                  text: "Confirm",
                  width: 80,
                  radius: 5,
                ),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/painter/LinePainter.dart';
import 'package:fore_end/Mycomponents/widgets/PaintedColumn.dart';
import 'package:fore_end/Pages/AccountPage.dart';

import 'CustomAppBar.dart';

class My extends StatelessWidget {
  double width;
  My({double width=0.85}){
    this.width = ScreenTool.partOfScreenWidth(width);
  }
  @override
  Widget build(BuildContext context) {
    return PaintedColumn(
        width: this.width,
        backgroundColor: Color(0xFFF1F1F1),
        children: [
          Stack(
            children: [
              this.getAppBar(),
              Column(
                children: [
                  SizedBox(height: 90),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        theme: MyTheme.blueStyle,
                        firstThemeState: ComponentThemeState.warning,
                        radius: 5,
                        hasShadow: true,
                        text: "Account",
                        width: this.width-30,
                        tapFunc: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AccountPage();
                          }));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        theme: MyTheme.blueStyle,
                        firstThemeState: ComponentThemeState.warning,
                        hasShadow: true,
                        radius: 5,
                        text: "Plan",
                        width: this.width/2-30,
                        tapFunc: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AccountPage();
                          }));
                        },
                      ),
                      SizedBox(width: 30),
                      CustomButton(
                        theme: MyTheme.blueStyle,
                        firstThemeState: ComponentThemeState.warning,
                        radius: 5,
                        hasShadow: true,
                        text: "Body Info",
                        width: this.width/2-30,
                        tapFunc: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return AccountPage();
                          }));
                        },
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ]);
  }

  Widget getAppBar() {
    return CustomAppBar();
  }
}

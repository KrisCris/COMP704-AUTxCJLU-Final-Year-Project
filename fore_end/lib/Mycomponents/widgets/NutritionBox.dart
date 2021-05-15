import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class NutritionBox extends StatelessWidget {
  ///分别是下划线颜色、营养标题比如卡路里、字体大小、下方数值、数值字体大小，单位
  Color color;
  String title;
  double titleSize;
  double value;
  double valueSize;
  String units;
  bool isUnSuitable;

  NutritionBox({
    Color color = Colors.red,
    String title = "xx",
    double titleSize = 18,
    double value = 10.0,
    double valueSize = 20,
    String units = "g",
    bool isUnSuitable = false,
    Key key,
  }) : super(key: key) {
    this.color = color;
    this.value = value;
    this.title = title;
    this.titleSize = titleSize;
    this.valueSize = valueSize;
    this.units = units;
    this.isUnSuitable = isUnSuitable;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleText(
              alignment: Alignment.center,
              text: this.title,
              underLineLength: 0.2,
              dividerColor: this.color,
              fontSize: this.titleSize,
              maxWidth: 0.2,
              maxHeight: 30,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              this.value.toString() + this.units,
              style: TextStyle(
                  color: MyTheme.convert(ThemeColorName.NormalText),
                  fontSize: this.valueSize,
                  fontFamily: 'Futura'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        this.isUnSuitable
            ? Icon(
                FontAwesomeIcons.exclamationTriangle,
                color: Colors.red,
                size: 20,
              )
            : SizedBox(
                width: 0,
              )
      ],
    );
    // return Container(
    //   width: ScreenTool.partOfScreenWidth(0.25),
    //   height: ScreenTool.partOfScreenHeight(0.1),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //
    //           TitleText(
    //             text: this.title,
    //             underLineLength: 0.2,
    //             dividerColor: this.color,
    //             fontSize: this.titleSize,
    //             maxWidth: 0.2,
    //             maxHeight: 30,
    //           ),
    //
    //
    //
    //           SizedBox(height: 5,),
    //           Text(
    //               this.value.toString()+this.units,
    //               style: TextStyle(
    //                   color: MyTheme.convert(ThemeColorName.NormalText),
    //                   fontSize: this.valueSize,
    //                   fontFamily: 'Futura'
    //               )
    //           ),
    //           // Divider(
    //           //   height: 5,
    //           //   thickness: 5,
    //           //   color: Colors.red,
    //           //   indent: 10,
    //           //   endIndent:10,
    //           //
    //           // ),
    //         ],
    //       ),
    //       this.isUnSuitable?
    //       Icon(FontAwesomeIcons.exclamation,color: Colors.red,size: 20,) : SizedBox(width: 0,)
    //     ],
    //   ),
    // );
  }
}

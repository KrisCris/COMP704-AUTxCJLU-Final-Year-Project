import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/text/ValueText.dart';

class NutritionText extends StatelessWidget {
  final String name;
  final double value;
  final String unit;
  final double width;

  NutritionText(
      {@required this.name,
      @required this.value,
      @required this.unit,
      @required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(this.name,
              style: TextStyle(
                  color: MyTheme.convert(ThemeColorName.NormalText),
                  fontSize: 13,
                  fontFamily: "Futura",
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ValueText(
            numLower: this.value,
            valueFontSize: 11,
            unit: this.unit,
            unitFontSize: 9,
          )
        ],
      ),
    );
  }
}

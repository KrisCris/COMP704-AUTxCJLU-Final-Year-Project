import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  // List<double> nutritionList = new List();
  double calories;
  double carbohydrate;
  double cellulose;
  double cholesterol;
  double fat;
  double protein;
  double totalSum;

  ///构建函数
  PieChartSample2({
    Key key,
    this.calories = 10,
    this.fat = 10,
    this.cholesterol = 10,
    this.cellulose = 10,
    this.carbohydrate = 10,
    this.protein = 10,
    this.totalSum = 60,
  }) : super(key: key) {
    this.calories = calories;
    this.protein = protein;
    this.carbohydrate = carbohydrate;
    this.cellulose = cellulose;
    this.cholesterol = cholesterol;
    this.fat = fat;
    this.totalSum = calories +
        carbohydrate +
        cellulose +
        cholesterol +
        fat +
        protein; //加在一起
  }

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      // child: Card(
      //   color: MyTheme.convert(ThemeColorName.ComponentBackground),
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch =
                            pieTouchResponse.touchInput is! PointerExitEvent &&
                                pieTouchResponse.touchInput is! PointerUpEvent;
                        if (desiredTouch &&
                            pieTouchResponse.touchedSection != null) {
                          touchedIndex = pieTouchResponse.touchedSectionIndex;
                          // touchedIndex = pieTouchResponse.touchedSection.value.toInt();
                          ///之前是会报错touchedSection.touchedSectionIndex
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 5,
                    centerSpaceRadius: 0,

                    ///改变饼图中间空白的大小
                    sections: showingSections()),
              ),
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
      // ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 120 : 110;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xffa5ef00),

            ///卡路里
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),

            ///脂肪
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),

            ///胆固醇
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),

            ///纤维素
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xff09edfe),

            ///碳水
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 5:
          return PieChartSectionData(
            color: const Color(0xffff5983),

            ///蛋白质
            value: 0,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/text/NutritionText.dart';
import 'package:fore_end/Mycomponents/widgets/food/ValueAdjuster.dart';

class SwitchFoodInfoArea extends StatefulWidget {
  double width;
  double height;
  Function(Food f) onWeightChange;
  SwitchFoodInfoArea(
      {Key key, double width, double height, this.onWeightChange})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
  }
  @override
  State<StatefulWidget> createState() {
    return SwitchFoodInfoAreaState();
  }
}

class SwitchFoodInfoAreaState extends State<SwitchFoodInfoArea> {
  Food foodA;
  Food foodB;
  ValueNotifier<bool> showFirst;
  @override
  void initState() {
    this.showFirst = ValueNotifier(true);
    this.showFirst.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void changeTo(Food f) {
    if (this.showFirst.value) {
      foodB = f;
      this.showFirst.value = false;
    } else {
      foodA = f;
      this.showFirst.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoArea();
  }

  Widget InfoArea() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: MyTheme.convert(ThemeColorName.ComponentBackground),
          borderRadius: BorderRadius.circular(5)),
      child: AnimatedCrossFade(
        firstChild: foodInfo(foodA),
        secondChild: foodInfo(foodB),
        crossFadeState: this.showFirst.value
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  Widget foodInfo(Food f) {
    if (f == null) {
      return defaultInfo();
    } else {
      return detailedInfo(f);
    }
  }

  Widget defaultInfo() {
    return Center(
        child: CustomIconButton(
      icon: FontAwesomeIcons.receipt,
      backgroundOpacity: 0,
      text: "Food Info",
      gap: 10,
      buttonSize: 80,
      iconSize: 30,
    ));
  }

  Widget detailedInfo(Food f) {
    GlobalKey<ValueAdjusterState> valueAdjusterKey =
        new GlobalKey<ValueAdjusterState>();
    ValueAdjuster vaj = ValueAdjuster<int>(
        valueWeight: 10,
        initValue: f.weight.floor(),
        key: valueAdjusterKey,
        lower: 10);
    vaj.onValueChange = () {
      f.weight = valueAdjusterKey.currentState.valueNotifier.value;
      if (this.widget.onWeightChange != null) {
        this.widget.onWeightChange(f);
      }
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 0.05 * widget.width,
        ),
        Container(
          width: 0.9 * widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 0.05 * widget.height),
              Text(
                f.getName(context),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Futura",
                    fontSize: 16,
                    color: MyTheme.convert(ThemeColorName.NormalText)),
              ),
              SizedBox(height: 0.1 * widget.height),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NutritionText(
                      name: CustomLocalizations.of(context).calories,
                      value: f.calorie,
                      unit: "Kcal/100g",
                      width: 0.3 * widget.width),
                  NutritionText(
                      name: CustomLocalizations.of(context).protein,
                      value: f.protein,
                      unit: "g/100g",
                      width: 0.3 * widget.width),
                  NutritionText(
                      name: CustomLocalizations.of(context).fat,
                      value: f.fat,
                      unit: "g/100g",
                      width: 0.3 * widget.width),
                ],
              ),
              SizedBox(height: 0.3 * widget.height),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [vaj],
              ),
            ],
          ),
        ),
        SizedBox(width: 0.05 * widget.width)
      ],
    );
  }
}

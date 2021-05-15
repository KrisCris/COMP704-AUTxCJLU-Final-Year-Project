import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/Meal.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/widgets/food/SmallFoodBox.dart';

class DetailedMealList extends StatefulWidget {
  double width;
  double height;
  double dragAreaHeight;
  double paddingHorizontal;
  double paddingVertical;
  final Meal meal;
  DetailedMealList(
      {this.meal,
      double width,
      double height,
      double dragAreaHeight = 50,
      this.paddingHorizontal = 10,
      this.paddingVertical = 10})
      : assert(
            height == null ? true : dragAreaHeight + paddingVertical < height) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.height = ScreenTool.partOfScreenHeight(height);
    this.dragAreaHeight = ScreenTool.partOfScreenHeight(dragAreaHeight);
  }

  @override
  State<StatefulWidget> createState() {
    return DetailedMealListState();
  }
}

class DetailedMealListState extends State<DetailedMealList> {
  Food detailFood;

  @override
  void didUpdateWidget(covariant DetailedMealList oldWidget) {
    // TODO: implement didUpdateWidget\
    setState(() {});
    detailFood = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String foodName = "";
    String calories = "";
    String protein = "";
    String clickHint = this.widget.meal.foods.length == 0
        ? CustomLocalizations.of(context).noFoodSearch
        : "Click Picture for Details";
    if (this.detailFood != null) {
      foodName = this.detailFood.getName(context) +
          "  " +
          this.detailFood.weight.toString() +
          "g";
      calories = CustomLocalizations.of(context).calories +
          "  " +
          this.detailFood.getCalories().toString() +
          "Kcal";
      protein = CustomLocalizations.of(context).protein +
          "  " +
          this.detailFood.getProtein().toString() +
          'g';
    }
    return Container(
      width: this.widget.width,
      height: this.widget.height,
      decoration: BoxDecoration(
        color: MyTheme.convert(ThemeColorName.ComponentBackground),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: this.widget.paddingVertical),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: this.widget.paddingHorizontal),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          CustomLocalizations.of(context)
                              .getContent(this.widget.meal.mealName),
                          style: TextStyle(
                              fontSize: 16,
                              color: MyTheme.convert(ThemeColorName.HeaderText),
                              fontFamily: "Futura",
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold)),
                      Expanded(child: SizedBox()),
                      Text(
                          CustomLocalizations.of(context).total +
                              " " +
                              this
                                  .widget
                                  .meal
                                  .calculateTotalCalories()
                                  .toString() +
                              " KCal",
                          style: TextStyle(
                              fontSize: 16,
                              color: MyTheme.convert(ThemeColorName.HeaderText),
                              fontFamily: "Futura",
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: this.widget.width,
                    height: this.widget.dragAreaHeight,
                    decoration: BoxDecoration(
                      color:
                          MyTheme.convert(ThemeColorName.ComponentBackground),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListView.builder(
                      itemCount: this.widget.meal.foods.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctx, int idx) {
                        return SmallFoodBox(
                          food: this.widget.meal.foods[idx],
                          pictureSize: this.widget.dragAreaHeight - 10,
                          onclick: (Food f) {
                            this.detailFood = f;
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: this.widget.width,
                    alignment: Alignment.center,
                    child: AnimatedCrossFade(
                        firstChild: Text(
                          clickHint,
                          style: TextStyle(
                              fontFamily: "Futura",
                              fontWeight: FontWeight.bold,
                              color: MyTheme.convert(ThemeColorName.NormalText),
                              fontSize: 12),
                        ),
                        secondChild: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              foodName,
                              style: TextStyle(
                                  fontFamily: "Futura",
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.convert(
                                      ThemeColorName.NormalText),
                                  fontSize: 12),
                            ),
                            Text(
                              calories,
                              style: TextStyle(
                                  fontFamily: "Futura",
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.convert(
                                      ThemeColorName.NormalText),
                                  fontSize: 12),
                            ),
                            Text(
                              protein,
                              style: TextStyle(
                                  fontFamily: "Futura",
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.convert(
                                      ThemeColorName.NormalText),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        crossFadeState: this.detailFood == null
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 300)),
                  )
                ],
              )),
              SizedBox(width: this.widget.paddingHorizontal),
            ],
          ),
          SizedBox(height: this.widget.paddingVertical),
        ],
      ),
    );
  }
}

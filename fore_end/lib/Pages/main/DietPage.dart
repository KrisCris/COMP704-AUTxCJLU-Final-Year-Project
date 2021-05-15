import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/inputs/FoodSearchBar.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/HintManager.dart';
import 'package:fore_end/Mycomponents/widgets/food/CaloriesChart.dart';
import 'package:fore_end/Mycomponents/widgets/food/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanNotifier.dart';
import 'package:fore_end/Pages/detail/DetailMealPage.dart';
import '../FoodRecommandation.dart';

class DietPage extends StatefulWidget {
  DietPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new DietPageState();
  }
}

class DietPageState extends State<DietPage> {
  GlobalKey<FoodSearchBarState> foodsearchKey;

  OpenContainer buildOpenContainer() {
    return OpenContainer(
      closedColor: Colors.transparent,
      closedBuilder: (context, action) {
        return PlanNotifier(
          width: 0.95,
          height: 100,
          effectColor: Colors.black12,
        );
      },
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 350),
      openBuilder: (context, action) {
        return FoodRecommandation();
      },
    );
  }

  @override
  void initState() {
    this.foodsearchKey = GlobalKey<FoodSearchBarState>();
    HintManager.instance.foodSearchKey = this.foodsearchKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HintManager.instance.receiveHint(context);
    return Container(
        width: ScreenTool.partOfScreenWidth(1),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenTool.partOfScreenHeight(0.11)),
                  SizedBox(height: ScreenTool.partOfScreenHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
                      TitleText(
                        text: CustomLocalizations.of(context).planProcess,
                        underLineLength: 0,
                        fontSize: 18,
                        maxWidth: 0.95,
                        maxHeight: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  buildOpenContainer(),
                  // Expanded(child:SizedBox()),
                  SizedBox(height: 10),
                  Container(
                    child: CaloriesBarChart(
                      width: 0.95,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
                      TitleText(
                        text: CustomLocalizations.of(context).todayMeal,
                        underLineLength: 0,
                        fontSize: 18,
                        maxWidth: 0.475,
                        maxHeight: 30,
                      ),
                      Expanded(child: SizedBox()),
                      CustomTextButton(
                        CustomLocalizations.of(context).detail,
                        autoReturnColor: true,
                        fontsize: 15,
                        tapUpFunc: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (ctx) {
                            return DetailMealPage(
                              mealTime: DateTime.now(),
                            );
                          }));
                        },
                      ),
                      SizedBox(width: ScreenTool.partOfScreenWidth(0.05))
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: ScreenTool.partOfScreenWidth(0.95),
                    height: 220,
                    child: MealListUI(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            FoodSearchBar(
              key: this.foodsearchKey,
            ),
          ],
        ));
  }
}

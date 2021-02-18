import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';
import 'package:fore_end/Mycomponents/widgets/plan/BodyWeightChart.dart';
import 'package:fore_end/Mycomponents/widgets/plan/GoalData.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/account/UpdateBody.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlanDetailPage extends StatelessWidget {
  GlobalKey<GoalDataState> goalKey = new GlobalKey<GoalDataState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top+6),
          DotColumn(
            width: 0.95,
            mainAxisAlignment: MainAxisAlignment.center,
            borderRadius: 6,
            children: [
              SizedBox(height: 12),
              Text(
                CustomLocalizations.of(context).planType +" : "+
                CustomLocalizations.of(context).getContent(User.getInstance().plan.getPlanType()),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.convert(ThemeColorName.NormalText),
                    fontFamily: "Futura"),
              ),
              SizedBox(height: 12),
            ],
          ),
          SizedBox(height: ScreenTool.partOfScreenHeight(50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: CustomLocalizations.of(context).yourPlan,
                underLineLength: 0,
                fontSize: 18,
                maxWidth: 0.475,
                maxHeight: 30,
              ),
              Expanded(child: SizedBox()),
              CustomTextButton(
                CustomLocalizations.of(context).changePlan,
                autoReturnColor: true,
                fontsize: 15,
                tapUpFunc: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (ctx) {
                    return GuidePage(
                      firstTime: false,
                    );
                  }));
                },
              ),
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
            ],
          ),
          SizedBox(height: 5),
          GoalData(
            width: 0.95,
            height: 100,
            k: this.goalKey,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: CustomLocalizations.of(context).bodyWeightInfo,
                underLineLength: 0,
                fontSize: 18,
                maxWidth: 0.475,
                maxHeight: 30,
              ),
              Expanded(child: SizedBox()),
              CustomTextButton(
                CustomLocalizations.of(context).updateWeight,
                autoReturnColor: true,
                fontsize: 15,
                tapUpFunc: () {
                  showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new UpdateBody();
                    },
                  ).then((val) {
                    if(val == true){
                      goalKey.currentState.setState(() {});
                    }
                  });
                },
              ),
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
            ],
          ),
          SizedBox(height: 10),
          //TODO: 体重折线图
          Container(
            width: ScreenTool.partOfScreenWidth(0.95),
            decoration: BoxDecoration(
              color: MyTheme. convert(ThemeColorName.ComponentBackground),
              borderRadius: BorderRadius.circular(6)
            ),
            child: BodyWeightChart()
          ),
        ],
      ),
    );
  }
}

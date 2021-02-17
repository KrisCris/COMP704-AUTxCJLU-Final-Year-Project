import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';
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
          SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
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
          DotColumn(
            width: 0.95,
            borderRadius: 6,
            children: [
              SizedBox(height: 10),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  axisLine: AxisLine(
                    width: 1,
                    color: MyTheme.convert(ThemeColorName.NormalText),
                  )
                ),
                primaryYAxis: NumericAxis(
                    labelFormat: '{value}KG',
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(color: Colors.transparent)),
                trackballBehavior: TrackballBehavior(
                  lineType: TrackballLineType.vertical, //纵向选择指示器
                  activationMode: ActivationMode.singleTap,
                  enable: true,
                  tooltipAlignment: ChartAlignment.near, //工具提示位置(顶部)
                  shouldAlwaysShow: true, //跟踪球始终显示(纵向选择指示器)
                  tooltipDisplayMode:
                  TrackballDisplayMode.groupAllPoints, //工具提示模式(全部分组)
                  lineColor: MyTheme.convert(ThemeColorName.NormalText),
                ),
                //打开工具提示
                series: <LineSeries<BodyChangeLog,String>>[
                  LineSeries<BodyChangeLog,String>(
                    xAxisName: "Time",
                    yAxisName: "Weight(KG)",
                    name: "Body Weight",
                      dataSource: <BodyChangeLog>[
                        BodyChangeLog(time:1611874156990,weight:68,height: 174),
                        BodyChangeLog(time:1611974156990,weight:70,height: 174),
                        BodyChangeLog(time:1612074156990,weight:69,height: 174),
                        BodyChangeLog(time:1612174156990,weight:71,height: 174),
                      ],
                      xValueMapper: (BodyChangeLog log, _)=> log.getTime(),
                      yValueMapper: (BodyChangeLog log, _)=> log.weight,
                      dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                        textStyle: TextStyle(
                          color: MyTheme.convert(ThemeColorName.NormalText)
                        )
                      ),
                      markerSettings: MarkerSettings(isVisible: true)
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

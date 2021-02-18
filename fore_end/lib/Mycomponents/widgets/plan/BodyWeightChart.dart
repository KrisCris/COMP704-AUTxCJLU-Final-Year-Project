import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BodyWeightChart extends StatefulWidget{
  BodyWeightChart({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    return BodyWeightChartState();
  }

}

class BodyWeightChartState extends State<BodyWeightChart>{
  List<BodyChangeLog> bodyChanges;
  @override
  void initState() {
   this.repaintData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SfCartesianChart chart = SfCartesianChart(
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
            dataSource: bodyChanges,
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
    );
    return chart;
  }
  void repaintData(){
    User u = User.getInstance();
    DateTime now = DateTime.now();
    bodyChanges = [];
    Requests.getWeightTrend({
      "uid":u.uid,
      "token":u.token,
      "begin": (now.add(Duration(days: -60)).millisecondsSinceEpoch/1000).floor(),
      "end":(now.millisecondsSinceEpoch/1000).floor(),
    }).then((value){
      if(value == null)return;
      if(value.data['code'] != 1)return;
      for(Map m in value.data['data']['trend']){
        bodyChanges.add(BodyChangeLog(
            time: m['time']*1000,
            weight: (m['weight'] as double).floor(),
            height: 0
        ));
      }
      setState(() {});
    });
  }
}
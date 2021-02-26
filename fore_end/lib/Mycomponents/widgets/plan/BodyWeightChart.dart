import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/LocalDataManager.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    bodyChanges = [];
    if(u.isOffline){
      SharedPreferences pre = LocalDataManager.pre;
      String json = pre.getString("localBodyChanges");
      List<dynamic> obj = jsonDecode(json);
      for(Map m in obj){
        bodyChanges.add(BodyChangeLog(
          time: m['time'];/,
          weight: m['weight'],
          height: m['height']
        ));
      }
      if(mounted){
        setState(() {});
      }
      return;
    }
    DateTime now = DateTime.now();
    Requests.getWeightTrend({
      "uid":u.uid,
      "token":u.token,
      "begin": (now.add(Duration(days: -60)).millisecondsSinceEpoch/1000).floor(),
      "end":(now.millisecondsSinceEpoch/1000).floor(),
    }).then((value){
      if(value == null)return;
      if(value.data['code'] != 1)return;
      DateTime oneDay;
      int oneWeight;
      for(Map m in value.data['data']['trend']){
        DateTime tm = DateTime.fromMillisecondsSinceEpoch(m['time']*1000);
        //保存某一天的数据
        if(oneDay == null){
          oneDay = tm;
          oneWeight = (m['weight'] as double).floor();
        }else{
          //如果这次获取到的时间和上次保存的是同一天
          if(oneDay.year == tm.year && oneDay.month == tm.month && oneDay.day == tm.day){
            //取同一天里靠后的那次数据
            if(tm.compareTo(oneDay) >= 0){
              oneDay = tm;
              oneWeight = (m['weight'] as double).floor();
            }
          }else{
            //如果不是同一天，将之前保存的那天的数据录入，然后更新保存的时间
            bodyChanges.add(BodyChangeLog(
                time: oneDay.millisecondsSinceEpoch,
                weight: oneWeight,
                height: 0
            ));
            oneDay = tm;
            oneWeight = (m['weight'] as double).floor();
          }
        }
      }
      //将最后保存的那天的数据录入
      if(oneDay != null && oneWeight != null){
        bodyChanges.add(BodyChangeLog(
            time: oneDay.millisecondsSinceEpoch,
            weight: oneWeight,
            height: 0
        ));
      }
      if(mounted){
        setState(() {});
      }
    });
  }
}
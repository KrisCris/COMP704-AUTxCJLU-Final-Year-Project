import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/DateButton/DateButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanListItem.dart';
import 'package:date_format/date_format.dart';


class HistoryPlanPage extends StatefulWidget {
  ///不会变的全局数据


  @override
  _HistoryPlanPageState createState() => _HistoryPlanPageState();
}

class _HistoryPlanPageState extends State<HistoryPlanPage> {

  ///数据放到State
  ///
  String planType; //减肥 增肌  维持

  DateTime startedPlanTime;
  DateTime finishedPlanTime;

  int caloriesTotalInput;
  int caloriesDailyInput;
  int proteinTotalInput;
  int proteinDailyInput;
  int startedWeight;
  int finishedWeight;


  List bodyWeightUpdateList=[];

  int standardCaloriesDays;
  int overCaloriesDays;
  int lessCaloriesDays;
  int delayDays;

  String commentOfPlan="减肥卓有成效，完成情况良好，未有延期记录";

  int index=0;
  int testN=1;
  SwiperController swiperController= new SwiperController();
  //
  // @override
  // void didUpdateWidget(T oldWidget) {
  //
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: ScreenTool.partOfScreenHeight(0.05)),
        height: ScreenTool.partOfScreenHeight(1),
        width: ScreenTool.partOfScreenWidth(1),
        decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(5),
              color: MyTheme.convert(ThemeColorName.ComponentBackground),
        ),
        child: new Swiper(

          ///TODO:当用户手动拖拽或者自动播放引起下标改变的时候调用，刷新就在这里，如果换到下一页，那么所有的数据都要变化
          ///但要考虑 怎么让上一页的数据不发生改变   试一试  现在是会让所有页面都改变 因为是同样的数据 因此
          ///切换一次build一次  切到一半就以及build了  怎么解决
          onIndexChanged:	 (int index){

            // this.index++;
            this.testN++;
            this.commentOfPlan="增肥卓有成效，完成情况良好，未有延期记录"+this.testN.toString();

            // setState(() {
            //
            // });
          },


          outer:false,
          itemBuilder: (context, index) {
            return new Column(
              children: [
                Container(
                  height:ScreenTool.partOfScreenHeight(0.08),
                  margin: EdgeInsets.only(left: 25,right: 15,),
                  padding:EdgeInsets.only(top: 5,bottom: 5,),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.white),
                  // ),
                  child: Row(
                    children: [
                      Text("From",style: TextStyle(fontSize: 20,color: Colors.white),),
                      DateSelect(
                        width: 0.3,
                        height: 40,
                        buttonMargin: 18,
                        beginTime: DateTime(2021,1,1),
                        lastTime: DateTime.now(),
                        isShowTwoButton: false,
                        onChangeDate: (int newDate){
                          this.judgeDate(time:DateTime.fromMillisecondsSinceEpoch(newDate));
                          setState(() {

                          });
                        },
                      ),
                      Text("To",style: TextStyle(fontSize: 20,color: Colors.white),),
                      DateSelect(
                        width: 0.3,
                        height: 40,
                        buttonMargin: 18,
                        beginTime: DateTime(2021,1,1),
                        lastTime: DateTime.now(),
                        isShowTwoButton: false,
                        onChangeDate: (int newDate){
                          this.judgeDate(time:DateTime.fromMillisecondsSinceEpoch(newDate));
                          setState(() {

                          });
                        },

                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,

                  ),
                ),
                Divider(color: Colors.white,thickness: 2,),
                Container(
                    margin: EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 6),
                    padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    height: ScreenTool.partOfScreenHeight(0.8),

                    child: Column(
                      children: [
                        TitleText(
                          text: "减肥",
                          underLineLength: 0.5,
                          fontSize: 25,
                          maxWidth: 0.8,
                          maxHeight: 40,
                        ),
                        SizedBox(height: 5,),
                        PlanTextItem(leftText: "计划开始", rightText: "2020年06月20日", rightValue: 0, isShowRightValue: false,),
                        PlanTextItem(leftText: "计划完成", rightText: "2020年10月10日", rightValue: 0, isShowRightValue: false,),

                        SizedBox(height: 15,),
                        TitleText(
                          text: "营养统计",
                          underLineLength: 0.5,
                          fontSize: 18,
                          maxWidth: 0.8,
                          maxHeight: 30,
                        ),
                        SizedBox(height: 5,),
                        PlanTextItem(leftText: "卡路里总摄入", rightText: "千卡", rightValue: 215130,),
                        PlanTextItem(leftText: "卡路里总摄入", rightText: "千卡", rightValue: 1955,),
                        PlanTextItem(leftText: "蛋白质总摄入", rightText: "克", rightValue: 6820,),
                        PlanTextItem(leftText: "蛋白质总摄入", rightText: "克", rightValue: 62,),
                        PlanTextItem(leftText: "初始体重", rightText: "公斤", rightValue: 71,),
                        PlanTextItem(leftText: "完成体重", rightText: "公斤", rightValue: 65,),

                        SizedBox(height: 15,),
                        TitleText(
                          text: "计划执行情况",
                          underLineLength: 0.5,
                          fontSize: 18,
                          maxWidth: 0.8,
                          maxHeight: 30,
                        ),
                        SizedBox(height: 5,),
                        PlanTextItem(leftText: "卡路里标准天数", rightText: "天", rightValue: 97,),
                        PlanTextItem(leftText: "卡路里过量天数", rightText: "天", rightValue: 10,),
                        PlanTextItem(leftText: "卡路里不足天数", rightText: "天", rightValue: 3,),
                        PlanTextItem(leftText: "延期次数", rightText: "次", rightValue: 0,),


                        SizedBox(height: 15,),
                        TitleText(
                          text: "评价",
                          underLineLength: 0.5,
                          fontSize: 18,
                          maxWidth: 0.8,
                          maxHeight: 30,
                        ),
                        SizedBox(height: 5,),
                        Text(
                          this.commentOfPlan,
                          style: TextStyle(fontSize: 15,color: Colors.white ), //color: MyTheme.convert(ThemeColorName.NormalText)
                          softWrap: true,//自动换行
                          // overflow: TextOverflow.visible,
                        ),
                      ],
                    )
                ),
              ],
            );
          },

          ///pagination展示默认分页指示器,这里选择另外一个 ///如果需要定制自己的分页指示器，那么可以这样写：
          pagination: new SwiperPagination(
            margin: new EdgeInsets.all(10.0),  //分页指示器与容器边框的距离
            alignment: Alignment.bottomCenter,
          ),

          ///设置 new SwiperControl() 展示默认分页按钮 左右两边的按钮
          control: new SwiperControl(
              size: 40,
              padding: EdgeInsets.only(left: 10,),

          ),
          controller: this.swiperController,

          indicatorLayout: PageIndicatorLayout.COLOR, //分页指示器滑动方式
          itemCount: 5,  //页数，这个应该由plan个数决定
          scrollDirection: Axis.horizontal, //滚动方向，现在是水平滚动，设置为Axis.vertical为垂直滚动
          loop: false, //无限轮播模式开关
          index: 0, //初始的时候下标位置
          autoplay: false, //自动播放开关.
          // itemWidth: ,
          // itemHeight: ,
          onTap: (int index){
            print("123123123");
          }, //当用户手动拖拽或者自动播放引起下标改变的时候调用
          duration:300,  //动画时间，单位是毫秒

          // controller: new SwiperController(
          // ),


        ),
      ),

    );



  }


  ///时间选择按钮的配置函数，来设置新的日期并且刷新组件
  void judgeDate({DateTime time}){
    DateTime settingDay = DateTime(time.year,time.month,time.day);

  }


  @override
  void initState() {
    ///初始化数据的方法
  }
}

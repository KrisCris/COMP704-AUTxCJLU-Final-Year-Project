import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';


class HistoryPlanPage extends StatefulWidget {
  ///不会变的全局数据


  @override
  _HistoryPlanPageState createState() => _HistoryPlanPageState();
}

class _HistoryPlanPageState extends State<HistoryPlanPage> {

  ///数据放到State

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: ScreenTool.partOfScreenHeight(1),
        width: ScreenTool.partOfScreenWidth(1),
        decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(5),
              color: MyTheme.convert(ThemeColorName.ComponentBackground),
        ),
        child: new Swiper(
          outer:false,
          itemBuilder: (context, index) {
            return new Container(
              child: Column(
                children: [
                  // SizedBox(height: 100,),
                  Text("123456xxxx",style: TextStyle(fontSize: 30,color: Colors.blue),),
                ],
              )

            );
          },
          // itemWidth: ,
          // itemHeight: ,
          ///pagination展示默认分页指示器,这里选择另外一个 ///如果需要定制自己的分页指示器，那么可以这样写：
          pagination: new SwiperPagination(
            margin: new EdgeInsets.all(5.0),  //分页指示器与容器边框的距离
            alignment: Alignment.bottomCenter,
          ),

          ///设置 new SwiperControl() 展示默认分页按钮 左右两边的按钮
          control: new SwiperControl(
            // iconPrevious	Icons.arrow_back_ios	上一页的IconData
            // iconNext	Icons.arrow_forward_ios	下一页的IconData
            // color	Theme.of(context).primaryColor	控制按钮颜色
            // size	30.0	控制按钮的大小
            // padding	const EdgeInsets.all(5.0)	控制按钮与容器的距离

          ),

          indicatorLayout: PageIndicatorLayout.COLOR, //分页指示器滑动方式
          itemCount: 5,  //页数，这个应该由plan个数决定
          scrollDirection: Axis.horizontal, //滚动方向，现在是水平滚动，设置为Axis.vertical为垂直滚动
          loop: false, //无限轮播模式开关
          index: 0, //初始的时候下标位置
          autoplay: false, //自动播放开关.

          onTap: (int index){}, //当用户手动拖拽或者自动播放引起下标改变的时候调用
          duration:300,  //动画时间，单位是毫秒

          // controller: new SwiperController(
          // ),
          // onIndexChanged:	void onIndexChanged(int index); //当用户手动拖拽或者自动播放引起下标改变的时候调用




        ),
      ),

    );
  }





  @override
  void initState() {
    ///初始化数据的方法
  }
}

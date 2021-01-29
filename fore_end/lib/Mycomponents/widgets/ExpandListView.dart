import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/clipper/DownTopClipper.dart';
import 'package:fore_end/Mycomponents/clipper/TopDownClipper.dart';

///从上到下展开的listView
class ExpandListView extends StatefulWidget{
  ///组件的宽度
  double width;

  ///展开后的组件高度
  double height;

  ///展开动画的持续时间
  int animationTime;

  ///展开后的列表项
  List<Widget> children;

  ///背景颜色
  Color backgroundColor;

  ///是否展开
  ValueNotifier<bool> isOpen;

  ExpandListView({this.animationTime = 400,double width,this.height,this.children,bool open = true,this.backgroundColor = Colors.white}){
    this.isOpen = new ValueNotifier<bool>(open);
    this.width = ScreenTool.partOfScreenWidth(width);
  }

  ///展开列表
  void open(){
    this.isOpen.value = true;
  }

  ///关闭列表
  void close(){
    this.isOpen.value = false;
  }

  @override
  State<StatefulWidget> createState() {
    return new ExpandListViewState();
  }

}

///ExpandListView的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///
class ExpandListViewState extends State<ExpandListView>
with TickerProviderStateMixin{
  ///展开动画
  TweenAnimation<double> clipAnimation = new TweenAnimation();

  ///展开的类型，0表示从上到下展开，1表示从下到上展开
  ///0 - TopDownClipper   1 - DownTopClipper
  int activateClipper = 0;

  @override
  void initState() {
    super.initState();
    //根据初始状态设置展开动画
    if(widget.isOpen.value){
      this.clipAnimation.initAnimation(widget.height, 0.0, widget.animationTime, this, (){setState((){});});
      this.activateClipper = 1;
    }else{
      this.clipAnimation.initAnimation(0.0, widget.height, widget.animationTime, this, (){setState((){});});
      this.activateClipper = 0;
    }
    print("clip animation initialize state: dismissed = "+this.clipAnimation.isDismissed().toString());

    //添加监听器
    this.clipAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        //1 to 0, 0 to 1
        this.activateClipper = (this.activateClipper - 1).abs();
        if(this.activateClipper == 1){
          this.clipAnimation.initAnimation(widget.height,0.0, widget.animationTime, this, (){setState((){});});
        }else{
          this.clipAnimation.initAnimation(0.0, widget.height, widget.animationTime, this, (){setState((){});});
        }
        this.setState(() {});
      }
    });

    //主要用于处理当高速连续变化展开状态时的情况
    widget.isOpen.addListener(() {
        if(this.clipAnimation.isDismissed()){
          this.clipAnimation.beginAnimation();
        }else{
          //2个statusListener为默认的，此时添加Statuslistener进行延迟动画
          //3个时，再添加动画说明打开和关闭动画抵消，直接去除第三个statusListener即可
          if(this.clipAnimation.statusListenerList.length == 2){
            this.clipAnimation.addStatusListener(this.delayAnimation);
          }else{
            Function f = this.clipAnimation.popStatusListener();
            //检测剔除的监听器是否正确
            if(f != this.delayAnimation){
              this.clipAnimation.addStatusListener(f);
            }
          }
        }
    });
  }

  ///当快速多次切换展开状态时，等待完全展开或关闭后再执行下一项动画
  void delayAnimation(AnimationStatus status){
    if(status == AnimationStatus.dismissed){
      this.clipAnimation.popStatusListener();
      this.clipAnimation.beginAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  ClipRect(
      clipper: this.activateClipper == 0 ? TopDownClipper(clipAnimation.value) : DownTopClipper(clipAnimation.value),
      child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:  widget.backgroundColor,
          ),
          child: ListView(
            children: [
              ListTile(title: new Text("1"),),
              ListTile(title: new Text("2"),),
              ListTile(title: new Text("3"),),
              ListTile(title: new Text("4"),),
              ListTile(title: new Text("5"),),
              ListTile(title: new Text("6"),),
            ],
          )
      ),
    ) ;
  }

}
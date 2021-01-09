import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/clipper/DownTopClipper.dart';
import 'package:fore_end/Mycomponents/clipper/TopDownClipper.dart';

class ExpandListView extends StatefulWidget{
  double width;
  double height;
  int animationTime;
  List<Widget> children;
  Color backgroundColor;
  ValueNotifier<bool> isOpen;

  ExpandListView({this.animationTime = 400,double width,this.height,this.children,bool open = true,this.backgroundColor = Colors.white}){
    this.isOpen = new ValueNotifier<bool>(open);
    this.width = ScreenTool.partOfScreenWidth(width);
  }

  void open(){
    this.isOpen.value = true;
  }
  void close(){
    this.isOpen.value = false;
  }

  @override
  State<StatefulWidget> createState() {
    return new ExpandListViewState();
  }

}
class ExpandListViewState extends State<ExpandListView>
with TickerProviderStateMixin{
  TweenAnimation<double> clipAnimation = new TweenAnimation();
  ///0 - TopDownClipper   1 - DownTopClipper
  int activateClipper = 0;
  @override
  void initState() {
    super.initState();
    if(widget.isOpen.value){
      this.clipAnimation.initAnimation(widget.height, 0.0, widget.animationTime, this, (){setState((){});});
      this.activateClipper = 1;
    }else{
      this.clipAnimation.initAnimation(0.0, widget.height, widget.animationTime, this, (){setState((){});});
      this.activateClipper = 0;
    }
    print("clip animation initialize state: dismissed = "+this.clipAnimation.isDismissed().toString());
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
  void delayAnimation(AnimationStatus status){
    if(status == AnimationStatus.dismissed){
      this.clipAnimation.popStatusListener();
      this.clipAnimation.beginAnimation();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  ClipRect(
      clipper: this.activateClipper == 0 ? TopDownClipper(clipAnimation.getValue()) : DownTopClipper(clipAnimation.getValue()),
      child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color:  widget.backgroundColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12, //阴影范围
                  spreadRadius: 4, //阴影浓度
                  color: Color(0x33000000), //阴影颜色
                ),
              ]
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
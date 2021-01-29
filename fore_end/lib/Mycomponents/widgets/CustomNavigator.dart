import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import '../buttons/CustomIconButton.dart';

///自定义的导航器，用于多个标签页之间的切换
class CustomNavigator extends StatefulWidget {

  ///导航器的宽度
  double width;

  ///导航器的高度
  double height;

  ///导航器的透明度
  ///0 - 完全透明
  ///1 - 完全不透明
  double opacity;

  ///背景色
  Color backgroundColor;

  ///当前被选中的标签按钮
  CustomIconButton activateButton;

  ///导航器中的所有标签按钮
  List<CustomIconButton> buttons = const <CustomIconButton>[];

  ///标签页控制器
  TabController controller;

  ///历史遗留问题，不推荐使用这种方式保存State的引用
  CustomNavigatorState state;

  CustomNavigator({
    Key key,
    this.width,
    this.height,
    this.opacity = 1,
    this.backgroundColor = Colors.white,
    this.controller,
    List<CustomIconButton> buttons,
  }):super(key:key) {
    this.buttons = buttons;
    //遍历数组，设置对应按钮所属的导航器
    for (CustomIconButton bt in this.buttons) {
      bt.setParentNavigator(this);
    }
    //默认选中第一个标签按钮
    this.buttons[0].addDelayInit(() {
      this.activateButtonByIndex(0);
    });
  }

  ///历史遗留问题，不推荐使用这种方式保存State的引用
  @override
  State<StatefulWidget> createState() {
    this.state = new CustomNavigatorState();
    return this.state;
  }

  ///某个按钮是否为当前选中的按钮
  ///参数 [bt] 为想要判断的按钮实例
  bool isActivate(CustomIconButton bt) {
    return this.activateButton == bt;
  }

  ///根据索引 [i] 选中某个按钮
  void activateButtonByIndex(int i) {
    for (int j = 0; j < this.buttons.length; j++) {
      if (j == i) {
        this.buttons[i].setFocus(true);
        this.activateButton = this.buttons[i];
      } else {
        this.buttons[j].setFocus(false);
      }
    }
  }

  ///根据按钮实例 [button] 选重某个按钮
  void activateButtonByObject(CustomIconButton button) {
    for (CustomIconButton bt in this.buttons) {
      if (bt == button) {
        bt.setFocus(true);
        this.activateButton = bt;
      } else {
        bt.setFocus(false);
      }
    }
  }

  ///获取当前选中的标签页索引
  int getActivatePageNo() {
    return this.controller.index;
  }

  ///获取标签页控制器 [TabController]
  TabController getController() {
    return this.controller;
  }

  ///根据按钮实例 [button] 切换标签页
  void switchPageByObject(CustomIconButton button) {
    for (int i = 0; i < this.buttons.length; i++) {
      if (this.buttons[i] == button) {
        this.controller.animateTo(i);
        return;
      }
    }
  }

  ///历史遗留问题，不推荐使用这种方式调用State的函数
  ///开始播放透明度动画
  void beginOpacity() {
    this.state.beginOpacity();
  }

  ///历史遗留问题，不推荐使用这种方式调用State的函数
  ///逆向播放透明度动画
  void reverseOpacity() {
    this.state.reverseOpacity();
  }
}

///CustomNavitor的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///
class CustomNavigatorState extends State<CustomNavigator>
    with TickerProviderStateMixin {

  ///背景透明度动画
  TweenAnimation backgroundOpacity;

  ///阴影尺寸动画
  TweenAnimation shadowSize;

  ///阴影浓度动画
  TweenAnimation shadowDense;

  ///navigator长度动画
  TweenAnimation lengthChange;

  ///位置变化动画
  TweenAnimation positionChange;

  ///是否正在切换标签页
  bool changing;

  @override
  void initState() {
    //初始化各种动画
    this.backgroundOpacity = new TweenAnimation();
    this.shadowSize = new TweenAnimation();
    this.shadowDense = new TweenAnimation();
    this.lengthChange = new TweenAnimation();
    this.positionChange = new TweenAnimation();

    this.backgroundOpacity.initAnimation(1.0, 0.35, 300, this, () {
      setState(() {});
    });
    this.shadowSize.initAnimation(10.0, 0.0, 300, this, () {
      setState(() {});
    });
    this.shadowDense.initAnimation(3.0, 0.0, 300, this, () {
      setState(() {});
    });
    this.lengthChange.initAnimation(widget.width, widget.width * 0.9, 300, this, null);

    this.positionChange.initAnimation(0.0, -65.0, 300, this, null);

    this.changing = false;

    //标签页添加监听器
    widget.controller.addListener(() {
      if (widget.controller.indexIsChanging) {
        this.changing = true;
      } else {
        if (this.changing == true) {
          this.changing = false;
          print("page animate done, now " + widget.controller.index.toString());
          //当切换标签页完毕时，执行回调
          if (widget.activateButton.navigatorCallback != null)
            widget.activateButton.navigatorCallback();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget container = AnimatedBuilder(
        animation: this.lengthChange.ctl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.buttons,
        ),
        builder: (BuildContext context, Widget child) {
          return Container(
              width: this.lengthChange.getValue(),
              height: widget.height,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: new BoxDecoration(
                  color: widget.backgroundColor
                      .withOpacity(this.backgroundOpacity.getValue()),
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: this.shadowSize.getValue(), //阴影范围
                      spreadRadius: this.shadowDense.getValue(), //阴影浓度
                      color: Color(0x33000000), //阴影颜色
                    ),
                  ]),
              child: child);
        });

    Widget body = AnimatedBuilder(
      animation: this.positionChange.ctl,
      child: container,
      builder: (BuildContext context, Widget child) {
        return Transform.translate(
          offset: Offset(this.positionChange.getValue(), 0),
          child: child,
        );
      },
    );
    return body;
  }

  void beginOpacity() {
    this.backgroundOpacity.beginAnimation();
    this.shadowSize.beginAnimation();
    this.shadowDense.beginAnimation();
    // this.positionChange.beginAnimation();
    // this.lengthChange.beginAnimation();
  }

  void reverseOpacity() {
    this.backgroundOpacity.reverse();
    this.shadowSize.reverse();
    this.shadowDense.reverse();
    // this.positionChange.reverse();
    // this.lengthChange.reverse();
  }
}

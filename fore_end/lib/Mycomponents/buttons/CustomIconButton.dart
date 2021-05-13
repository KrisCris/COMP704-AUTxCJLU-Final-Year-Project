
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/util/CalculatableColor.dart';
import 'package:fore_end/MyTool/util/MyCounter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/PaintedNavigator.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Focusable.dart';

class CustomIconButton extends StatefulWidget
    with DisableWidgetMixIn, FocusableWidgetMixIn{
  ///显示的ICON图标
  IconData icon;

  ///图标的尺寸
  double iconSize;

  ///字体大小
  double fontSize;

  ///按钮的边长
  double buttonSize;

  ///按钮圆角边框的半径
  double borderRadius;

  ///按钮的背景透明度
  ///0 - 完全透明
  ///1 - 完全不透明
  double backgroundOpacity;

  ///进行角度变化动画时，动画持续事件
  ///单位: 毫秒
  int angleDuration;

  ///文字和icon的间距
  double gap;

  ///由于部分ICON库的图标并不是位于中心，需要在垂直方向上进行微调
  ///该值表示向上偏移的量
  ///单位: 像素
  double adjustHeight;

  ///图标下方显示的文字
  ///该值为 [""] 或者 [null] 时, 按钮将不产生文字部分占位
  String text;

  ///该按钮的State, 历史遗留问题，不推荐使用这种方式保存State的引用
  CustomIconButtonState state;

  ///在state还未init时,提前指定init所需要的执行的内容
  List<Function> delayInit = <Function>[];

  ///点击事件
  Function onClick;

  ///长按点击事件
  Function onLongPress;
  Function onLongPressUp;
  Function onTapDown;
  Function onTapUp;
  Function onTapCancel;


  ///作为navigator的一部分时, 当navigator切换页面完毕后，执行的回调函数
  Function navigatorCallback;

  ///所属的navigator, 默认情况下为 [null]
  PaintedNavigator navi;

  ///按钮的阴影
  List<BoxShadow> shadows;

  ///按钮按下时，是否需要播放图标尺寸变化动画
  bool sizeChangeWhenClick;
  bool backgroundSizeChange;

  bool backgroundColorChange;


  MyCounter counter;

  CustomIconButton(
      {
      @required this.icon,
      this.text = "",
        this.sizeChangeWhenClick = false,
        this.backgroundSizeChange = false,
        this.backgroundColorChange = true,
      this.iconSize = 20,
      this.fontSize = 12,
        this.gap = 0,
      this.buttonSize = 55,
      this.borderRadius = 1000,
      this.backgroundOpacity = 1,
        this.angleDuration = 200,
        this.adjustHeight = 0,
      this.shadows,
      this.onClick,
        this.onLongPress,
        this.onLongPressUp,
        this.counter,
        this.onTapCancel,
        this.onTapDown,
        this.onTapUp,
        bool disabled = false,
        bool focus = false,
        Key key,
      this.navigatorCallback})
      : super(key:key) {
    this.disabled = new ValueNotifier<bool>(disabled);
    this.focus = new ValueNotifier<bool>(focus);
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new CustomIconButtonState();
    return this.state;
  }

  ///切换按钮上显示的图标
  ///参数 [icon] 是切换后的图标
  void changeIcon(IconData icon){
    this.icon = icon;
    this.state.setState(() {});
  }

  ///添加提前指定的初始化项目
  void addDelayInit(Function f) {
    this.delayInit.add(f);
  }

  ///设置所属的navigator
  ///参数 [nv] 是所属的 [PaintedNavigator] 实例
  void setParentNavigator(PaintedNavigator nv) {
    this.navi = nv;
  }

}

///CustomIconButton的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///混入了 [ThemeStateMixIn] 用于控制主题颜色
///混入了 [DisableStateMixIn] 用于控制disable状态
///混入了 [FocusableStateMixIn] 用于控制Focus状态
///
class CustomIconButtonState extends State<CustomIconButton>
    with TickerProviderStateMixin,DisableStateMixIn,FocusableStateMixIn {
  TweenAnimation<CalculatableColor> backgroundColorAnimation =
      TweenAnimation<CalculatableColor>();
  TweenAnimation<CalculatableColor> iconAndTextColorAnimation =
      TweenAnimation<CalculatableColor>();
  TweenAnimation<double> iconSizeAnimation = TweenAnimation<double>();
  TweenAnimation<double> backgourndSizeAnimation = TweenAnimation<double>();
  bool disabled = false;

  @override
  void didUpdateWidget(covariant CustomIconButton oldWidget) {
    widget.disabled.value = oldWidget.disabled.value;
    widget.focus.value = oldWidget.focus.value;
    //初始化disable监听器，实现在DisbaleStateMxiIn中
    this.initDisableListener(this.widget.disabled);
    widget.focus.addListener(() {
      if(widget.focus.value){
        this.setFocus();
      }else{
        this.setUnFocus();
      }
    });
    this.iconAndTextColorAnimation.initAnimation(
        this.getIconAndTextColor(widget.focus.value,null),
        this.getIconAndTextColor(widget.focus.value,null),
        150,
        this, () {
      setState(() {});
    });
    super.didUpdateWidget(oldWidget);
  }
  ///历史遗留问题, 不推荐在buiild函数中绑定state
  @override
  Widget build(BuildContext context) {
    widget.state = this;
    return this.buttonUI;
  }

  @override
  initState() {
    super.initState();
    //添加disabled监听器，可以像CustomButton中那样直接调用
    //已经实现的函数
    widget.disabled.addListener(() {
        if(widget.disabled.value){
          this.setDisabled();
        }else{
          this.setEnabled();
        }
    });

    //添加focus监听器
    widget.focus.addListener(() {
      if(widget.focus.value){
        this.setFocus();
      }else{
        this.setUnFocus();
      }
    });

    //执行提前设定好的初始化项目
    for (Function f in widget.delayInit) {
      f();
    }

    //各种动画的初始化
    bool colorSet = widget.focus.value;
    if(widget.backgroundColorChange == false){
      colorSet = false;
    }
    this.backgroundColorAnimation.initAnimation(
        this.getBackgroundColor(colorSet),
        this.getBackgroundColor(colorSet), 150, this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.initAnimation(
        this.getIconAndTextColor(widget.focus.value,null),
        this.getIconAndTextColor(widget.focus.value,null),
        150,
        this, () {
      setState(() {});
    });
    double res = widget.iconSize;
    if(widget.sizeChangeWhenClick){
      res -= 5;
    }
    this.iconSizeAnimation.initAnimation(widget.iconSize, res, 100, this, () {setState(() {});});
    if(widget.backgroundSizeChange){
      res = widget.buttonSize - 5;
    }else{
      res = widget.buttonSize;
    }
    this.backgourndSizeAnimation.initAnimation(widget.buttonSize, res, 100, this, () {setState(() {
    });});
  }

  Widget get IconText {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedBuilder(
            animation: this.iconAndTextColorAnimation.ctl,
            builder: (BuildContext context, Widget child) {
              return Icon(widget.icon,
                  color: this.iconAndTextColorAnimation.value,
                  size: this.iconSizeAnimation.value);
            }),
        SizedBox(height: widget.gap),
        Offstage(
            offstage: widget.text == "" || widget.text == null,
            child: AnimatedBuilder(
                animation: this.iconAndTextColorAnimation.ctl,
                builder: (BuildContext context, Widget child) {
                  return Text(
                    widget.text,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Futura",
                        color: this.iconAndTextColorAnimation.value),
                  );
                })),
        SizedBox(height: widget.adjustHeight)
      ],
    );
  }

  Widget get buttonUI {
    return GestureDetector(
        // onLongPress: (){
        //   print("长按按钮的操作");
        //   if (widget.onLongClick != null) {
        //     if (widget.navi == null) {
        //       if(!this.disabled){
        //         widget.onLongClick();
        //       }
        //     } else {
        //       if (!widget.navi.isActivate(widget)) {
        //         widget.onLongClick();
        //       }
        //     }
        //   }
        //   if (widget.navi != null && !this.disabled) {
        //     widget.navi.activateButtonByObject(widget);
        //     widget.navi.switchPageByObject(widget);
        //   }
        //
        // },
        // onLongPressEnd: (  v  ){
        //   print("长按结束");
        // },
        onLongPressStart: (state){
          if(this.widget.onLongPress != null){
            this.widget.onLongPress();
          }
        },
        onLongPressUp: () {
          if(this.widget.onLongPressUp != null){
            this.widget.onLongPressUp();
          }

        },
        onTap: () {
          if (widget.onClick != null) {
            if (widget.navi == null) {
              if(!this.disabled){
                widget.onClick();
              }
            } else {
              if (!widget.navi.isActivate(widget)) {
                widget.onClick();
              }
            }
          }
          if (widget.navi != null && !this.disabled) {
            widget.navi.activateButtonByObject(widget);
            widget.navi.switchPageByObject(widget);
          }
        },
        onTapDown: (TapDownDetails details){
          this.iconSizeAnimation.forward();
          this.backgourndSizeAnimation.forward();
        },
        onTapUp: (TapUpDetails details){
          this.iconSizeAnimation.reverse();
          this.backgourndSizeAnimation.reverse();
        },
        onTapCancel: (){
          this.iconSizeAnimation.reverse();
          this.backgourndSizeAnimation.reverse();
        },
        child: AnimatedBuilder(
          animation: this.backgroundColorAnimation.ctl,
          child: this.IconText,
          builder: (BuildContext context, Widget child) {
            return Container(
              width: this.backgourndSizeAnimation.value,
              height: this.backgourndSizeAnimation.value,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: this.backgroundColorAnimation.value,
                  boxShadow: widget.shadows),
              child: child,
            );
          },
        ));
  }

  ///计算背景色
  ///当前的设计中，背景色和图标颜色相反
  CalculatableColor getBackgroundColor(bool isFocus) {
    double opacity = widget.backgroundOpacity;
    if (isFocus) {
      opacity = 1.0;
    }
    return MyTheme.convert(ThemeColorName.Button).withOpacity(opacity);
  }

  ///计算图标和文字颜色
  CalculatableColor getIconAndTextColor(bool isFocus, bool isDisabled) {
    if (isFocus) {
      return MyTheme.convert(ThemeColorName.HightLightIcon);
    }else{
      return MyTheme.convert(ThemeColorName.NormalIcon);
    }
  }

  ///DisableStateMixIn的抽象函数，暂不需要实现
  @override
  void setEnabled() {
  }

  @override
  ///DisableStateMixIn的抽象函数，暂不需要实现
  void setDisabled(){
  }

  ///聚焦时需要执行的动画变化
  @override
  void setFocus() {
    if(widget.backgroundColorChange){
      this.backgroundColorAnimation.initAnimation(
          this.getBackgroundColor(false),
          this.getBackgroundColor(true),
          200,
          this, () {
        setState(() {});
      });
      this.backgroundColorAnimation.beginAnimation();
    }
    this.iconAndTextColorAnimation.initAnimation(
        getIconAndTextColor(false,null),
        getIconAndTextColor(true,null),
        200,
        this, () {
      setState(() {});
    });
    this.iconAndTextColorAnimation.beginAnimation();
  }

  ///取消聚焦时，需要执行的动画变化
  @override
  void setUnFocus() {
    if(widget.backgroundColorChange){
      this.backgroundColorAnimation.initAnimation(
          this.getBackgroundColor(true),
          this.getBackgroundColor(false),
          200,
          this, () {
        setState(() {});
      });
      this.backgroundColorAnimation.beginAnimation();
    }
    this.iconAndTextColorAnimation.initAnimation(
        getIconAndTextColor(true,null),
        getIconAndTextColor(false,null),
        200,
        this, () {
      setState(() {});
    });

    this.iconAndTextColorAnimation.beginAnimation();
  }

}

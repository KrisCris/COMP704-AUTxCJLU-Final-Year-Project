import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/util/CalculatableColor.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Valueable.dart';


class CustomTextButton extends StatefulWidget
    with DisableWidgetMixIn, ValueableWidgetMixIn<String>{
  ///文字的尺寸
  double fontsize;

  ///文字的颜色
  Color textColor;

  ///文字点击后的颜色
  Color clickColor;

  ///按下的函数
  Function tapUpFunc;

  ///颜色变化动画的持续时间
  ///单位: 毫秒
  int colorChangeDura;

  ///是否被点击，历史遗留问题，不建议在Widget中用这些可变属性
  bool isTap = false;

  ///是否不执行点击时间
  bool ignoreTap;

  ///颜色变化动画执行完毕时，是否自动恢复到变化之前的颜色
  bool autoReturnColor;

  CustomTextButton(
      String text,
      {this.fontsize = 16,
        bool disabled = false,
        bool canChangeDisable = true,
        Color textColor,
        Color clickColor,
        this.ignoreTap = false,
        this.autoReturnColor = true,
        Function tapUpFunc,
      this.colorChangeDura = 300,
      Key key})
      : super(key: key) {
      this.textColor = MyTheme.convert(ThemeColorName.NormalText,color:textColor);
      this.clickColor = MyTheme.convert(ThemeColorName.HighLightText,color:clickColor);
      this.tapUpFunc = tapUpFunc==null?(){}:tapUpFunc;
      this.widgetValue = ValueNotifier<String>(text);
      this.disabled = ValueNotifier(disabled);
      this.canChangeDisable = canChangeDisable;
  }

  @override
  State<StatefulWidget> createState() {
    return new CustomTextButtonState();
  }
}

///CustomTextButton的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///混入了 [ThemeStateMixIn] 用于控制主题颜色
///混入了 [DisableStateMixIn] 用于控制disable状态
///混入了 [ValueableStateMixIn] 用于控制控件的输出值
///
class CustomTextButtonState extends State<CustomTextButton>
    with TickerProviderStateMixin, DisableStateMixIn,ValueableStateMixIn<String> {
  TweenAnimation<CalculatableColor> animation = new TweenAnimation<CalculatableColor>();
  TapGestureRecognizer recognizer = new TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    //初始化value监听器，实现在ValueableStateMixIn中
    this.initValueListener(widget.widgetValue);
    //初始化disable监听器，实现在DisbaleStateMxiIn中
    this.initDisableListener(widget.disabled);
    //初始化动画效果
    this.animation.initAnimation(
        widget.textColor,
        widget.clickColor,
        widget.colorChangeDura, this, null);
    //点击完毕后，颜色从高亮恢复正常
    if(widget.autoReturnColor) {
      this.animation.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (!widget.isTap) {
            this.animation.reverseAnimation();
          }
        }
      });
    }
  }
  @override
  void dispose() {
    this.animation.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextBUttonUI;
  }

  Widget get TextBUttonUI {
    TapGestureRecognizer recog = TapGestureRecognizer()
      ..onTapUp = (TapUpDetails tpd) {
        if(widget.disabled.value)return;
        widget.isTap = false;
        print("tapUp");
        this.animation.reverseAnimation();
        widget.tapUpFunc();
      }
      ..onTapDown = (TapDownDetails details) {
        if(widget.disabled.value)return;
        widget.isTap = true;
        print("tapDown");
        this.animation.beginAnimation();
      }
      ..onTapCancel= (){
        if(widget.disabled.value)return;
        widget.isTap = false;
        print("tapCancel");
        this.animation.reverseAnimation();
      };
    if(widget.ignoreTap){
      recog = null;
    }
    return AnimatedBuilder(
        animation: this.animation.ctl,
        builder: (BuildContext context, Widget child){
          return RichText(
              text: TextSpan(
                  text: widget.widgetValue.value,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: widget.fontsize,
                      fontFamily: "Futura",
                      color: this.animation.value),
                  recognizer: recog
              ));
        });
  }

  ///ValueableStateMixIn的抽象函数, value发生变化时，进行组件刷新
  @override
  void onChangeValue() {
    setState(() {});
  }

  ///设置disable状态时的动画变化
  @override
  void setDisabled() {
    this.animation.initAnimation(
        widget.textColor,
        MyTheme.convert(ThemeColorName.DisableText),
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.beginAnimation();
  }

  ///设置enable状态时的动画变化
  @override
  void setEnabled() {
    this.animation.initAnimation(
        MyTheme.convert(ThemeColorName.DisableText),
        widget.textColor,
        widget.colorChangeDura,
        this, () {setState((){});});
    this.animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        this.animation.initAnimation(
            widget.textColor,
            widget.clickColor,
            widget.colorChangeDura, this, null);
        this.animation.popStatusListener();
      }
    });
    this.animation.beginAnimation();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/clipper/RightLeftClipper.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';

///点击图标后可以展开的输入框
class ExpandInputField extends StatefulWidget {

  ///输入框的宽度
  double width;

  ///输入框右侧图标的尺寸
  double iconSize;

  ///背景色
  Color backgroundColor;

  //TODO:采用disableableWidgetMixIN，而不是单独的变量
  ///是否为disabled
  bool disabled;

  ///第一次聚焦时，是否需要执行 [OnEmpty] 函数
  bool isFirstFocusDoFunction;

  ///输入框变为空时候执行的回调
  Function onEmpty;

  ///输入框从空值变为非空值时候执行的回调
  Function onNotEmpty;

  ///输入框的尾部icon
  IconData suffix;

  ///输入框的内部提示字
  String placeholer;

  ExpandInputField(
      {@required double width = 0.7,
      this.placeholer,
      this.disabled = true,
      this.onEmpty,
      this.onNotEmpty,
      this.isFirstFocusDoFunction = false,
      this.suffix = FontAwesomeIcons.search,
      double iconSize = 20,
      this.backgroundColor = Colors.white})
      : assert(ScreenTool.partOfScreenWidth(width) > iconSize) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.iconSize = iconSize;
  }
  State<StatefulWidget> createState() {
    return new ExpandInputFieldState();
  }
}

///ExpandInputField的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///
class ExpandInputFieldState extends State<ExpandInputField>
    with TickerProviderStateMixin {
  TweenAnimation lengthAnimation;
  CustomTextField textField;

  @override
  void initState() {
    //初始化动画效果
    this.lengthAnimation = new TweenAnimation();
    this.lengthAnimation.initAnimation(0.0, widget.width, 400, this, () {
      setState(() {});
    });
    this.lengthAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.textField.focus(context);
      }
    });
  }

  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.iconSize + 15,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: widget.backgroundColor),
      child: Stack(
        children: [
          Positioned(
              bottom: -25,
              left: 5,
              child: ClipRect(
                  clipper: new RightLeftClipper(lengthAnimation.getValue()),
                  child: this.createInput())),
          Positioned(right: 12, child: this.createSuffix()),
        ],
      ),
    );
  }

  ///创建输入框，历史遗留问题，不推荐使用这种方式保存输入框的引用
  Widget createInput() {
    if(this.textField == null){
      this.textField = CustomTextField(
        placeholder: widget.placeholer,
        isAutoChangeState: false,
        isAutoCheck: false,
        inputType: InputFieldType.verifyCode,
        theme: MyTheme.blueStyleForInput,
        width: widget.width - widget.iconSize * 1.5,
        sizeChangeMode: 0,
        bottomPadding: -15,
        disableSuffix: true,
        disabled: widget.disabled,
        onEmpty: widget.onEmpty,
        onNotEmpty: widget.onNotEmpty,
        isFirstFocusDoFunction: widget.isFirstFocusDoFunction,
      );
    }
    return this.textField;
  }

  Widget createSuffix() {
    return CustomIconButton(
      theme: MyTheme.blackAndWhite,
      icon: widget.suffix,
      backgroundOpacity: 0,
      iconSize: widget.iconSize,
      borderRadius: 100,
      buttonSize: 35,
      onClick: () {
        this.lengthAnimation.beginAnimation();
      },
    );
  }

}

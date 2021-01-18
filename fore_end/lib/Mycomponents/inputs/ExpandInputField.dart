import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/clipper/RightLeftClipper.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';

class ExpandInputField extends StatefulWidget {

  ///输入框的宽度
  double width;

  ///输入框右侧图标的尺寸
  double iconSize;

  //TODO: 不应该通过背景前景色遮盖来呈现展开效果，尝试使用clipper
  ///背景色
  Color backgroundColor;

  ///前景色
  Color foregroundColor;

  bool disabled;
  bool isFirstFocusDoFunction;

  Function onEmpty;
  Function onNotEmpty;

  IconData suffix;
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
      this.backgroundColor = Colors.white,
      this.foregroundColor = Colors.blue})
      : assert(ScreenTool.partOfScreenWidth(width) > iconSize) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.iconSize = iconSize;
  }
  State<StatefulWidget> createState() {
    return new ExpandInputFieldState();
  }
}

class ExpandInputFieldState extends State<ExpandInputField>
    with TickerProviderStateMixin {
  TweenAnimation lengthAnimation;
  CustomTextField textField;

  @override
  void initState() {
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

  Widget createForeground() {
    return Container(
      width: this.lengthAnimation.getValue(),
      height: widget.iconSize + 15,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: widget.foregroundColor),
    );
  }
}

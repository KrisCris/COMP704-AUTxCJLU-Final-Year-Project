import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';

class ExpandInputField extends StatefulWidget {
  double width;
  IconData suffix;
  String placeholer;
  double iconSize;
  Color backgroundColor;
  Color foregroundColor;
  ExpandInputField(
      {@required double width = 0.7,
      this.placeholer,
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
    this.lengthAnimation.initAnimation(widget.width, 0.0, 400, this, () {
      setState(() {});
    });
    this.lengthAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
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
            bottom: -20,
              child: this.createInput()
          ),
          this.createForeground(),
          Positioned(right: 1, child: this.createSuffix()),
        ],
      ),
    );
  }

  Widget createInput() {
    this.textField = CustomTextField(
      placeholder: widget.placeholer,
      autoChangeState: false,
      inputType: InputFieldType.verifyCode,
      theme: MyTheme.blueStyle,
      width: widget.width - widget.iconSize*2,
      sizeChangeMode: 0,
    );
    return this.textField;
  }

  Widget createSuffix() {
    return CustomIconButton(
      theme: MyTheme.blackAndWhite,
      icon: widget.suffix,
      backgroundOpacity: 0,
      iconSize: widget.iconSize,
      borderRadius: 100,
      buttonRadius: 35,
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

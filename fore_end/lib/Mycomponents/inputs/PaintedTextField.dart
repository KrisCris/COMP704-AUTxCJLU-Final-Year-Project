import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/painter/ColorPainter.dart';

class PaintedTextField extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  double width;
  final String hint;
  final double gap;
  final double paddingLeft;
  final double contentPadding;
  final IconData icon;
  FocusNode node;
  final double borderRadius;
  PaintedTextField(
      {this.backgroundColor = Colors.transparent,
        this.textColor = Colors.white,
        this.paddingLeft = 5,
        this.contentPadding = 0,
      this.gap = 5,
        this.hint = "",
      double width = 0.5,
      this.icon,
      this.borderRadius,
      Key key,  })
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(width);
    this.node = new FocusNode(debugLabel: "PaintedTextField");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      SizedBox(width: this.paddingLeft)
    ];
    if(this.icon != null){
      content.add(CustomIconButton(
        theme: MyTheme.blueStyle,
        icon: this.icon,
        iconSize: 18,
        buttonSize: 25,
        backgroundOpacity: 0.1,
      ));
    }
    content.addAll([
      SizedBox(width: this.gap),
      Expanded(child:this.getTextField()),
    ]);
    return CustomPaint(
      painter: ColorPainter(
        color: this.backgroundColor,
        context: context,
        borderRadius: 5,
      ),
      child: Container(
          width: this.width,
          child: Row(
            children: content,
          )),
    );
  }

  TextField getTextField() {
    return TextField(
      focusNode: this.node,
      style: TextStyle(
        color: this.textColor
      ),
      decoration: InputDecoration(
        hintText: this.hint,
        hintStyle: TextStyle(
            color: this.textColor
        ),
        border: OutlineInputBorder(borderSide: BorderSide.none), //去除下边框
        contentPadding: const EdgeInsets.symmetric(vertical: 1),
      ),
    );
  }
}

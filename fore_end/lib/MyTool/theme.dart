import 'dart:ui';
import 'package:flutter/material.dart';

class Theme {

  Color unfocusedColor;
  Color disabledColor;
  Color errorColor;
  Color focusedColor;
  Color warningColor;
  Color completeColor;

  Theme( {this.unfocusedColor,this.disabledColor,this.errorColor,this.focusedColor,this.warningColor,this.completeColor});

  static Theme blueStyle = Theme(
    unfocusedColor: Color(0xFF929497),
    focusedColor:  Color(0xFF0090FF),
    disabledColor: Color(0xFF929497),
    errorColor: Color(0xFFFF6060),
    warningColor: Color(0xFFFFC35F),
    completeColor: Color(0xFF0091EA)
  );
}

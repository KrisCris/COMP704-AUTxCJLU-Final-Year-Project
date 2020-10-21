import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/screenTool.dart';
//textfield的一些常用参数
class Constants{
  static Color ERROR_COLOR = Colors.redAccent;
  static Color DEFAULT_COLOR = Colors.grey;
  static Color FOCUSED_COLOR = Colors.lightBlue;
  static Color COMPLETED_COLOR = Colors.lightBlueAccent;
  

  static double WIDTH_TF_FOCUSED = ScreenTool.partOfScreenHeight(3);
  static double WIDTH_TF_UNFOCUSED = ScreenTool.partOfScreenHeight(2);
}
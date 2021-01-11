import 'package:flutter/cupertino.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Valueable.dart';

class ValueableImage extends StatefulWidget
with ValueableWidgetMixIn<String>, DisableWidgetMixIn{
  
  
  @override
  String getValue() {
    // TODO: implement getValue
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    return ValueableImageState();
  }
  
}

class ValueableImageState extends State<ValueableImage>
with DisableStateMixIn{
  @override
  Widget build(BuildContext context) {
    return Image(image: null)
  }

  @override
  void setDisabled() {
    // TODO: implement setDisabled
  }

  @override
  void setEnabled() {
    // TODO: implement setEnabled
  }
  
}
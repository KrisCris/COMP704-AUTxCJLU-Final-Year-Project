import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:fore_end/interface/Valueable.dart';

class EditableArea extends StatelessWidget
    with ThemeWidgetMixIn {
  List<Widget> displayContent;
  CustomIconButton editButton;
  Function onEditComplete;
  bool editing;
  double width;
  double height;
  double borderRadius;
  String title;
  ComponentThemeState the;
  EditableArea(
      {Key key,
      @required MyTheme theme,
      @required this.displayContent,
      this.width = 300,
      this.height = 500,
        this.editing = false,
        this.borderRadius = 12,
        @required this.onEditComplete,
      this.title = ""})
      : super(key: key) {
    this.theme = theme;
    if (this.width <= 1) {
      this.width = ScreenTool.partOfScreenWidth(this.width);
    }
    if (this.height <= 1) {
      this.height = ScreenTool.partOfScreenHeight(this.height);
    }
    this.the = ComponentThemeState.normal;
    this.disableAll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
            boxShadow: [
              BoxShadow(
                blurRadius: 12, //阴影范围
                spreadRadius: 3, //阴影浓度
                color: Color(0x33000000), //阴影颜色
              ),
            ]),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: this.getColumn(context)));
  }

  List<Widget> getColumn(BuildContext context) {
    List<Widget> widgets = [
      SizedBox(height: 10),
      Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Text(this.title,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 17,
                    color: this.theme.getThemeColor(this.the),
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold)),
          ),
          this.getEditButton(context),
          SizedBox(width: 10)
        ],
      ),
      SizedBox(
        width: 10,
      )
    ];
    for (Widget wd in this.displayContent) {
      widgets.add(wd);
    }
    return widgets;
  }

  CustomIconButton getEditButton(BuildContext context) {
    this.editButton = CustomIconButton(
      disabled: false,
      theme: MyTheme.blueStyle,
      icon: FontAwesomeIcons.edit,
      backgroundOpacity: 0,
      iconSize: 25,
    );
    this.editButton.onClick = (){
      if(!this.editing){
        this.editButton.changeIcon(FontAwesomeIcons.check);
        this.startEdit(context);
      }else{
        this.editButton.changeIcon(FontAwesomeIcons.edit);
        this.endEdit();
      }
    };
    return this.editButton;
  }

  void startEdit(BuildContext context) {
    this.editing = true;
    this.enableAll();
  }

  void endEdit() {
    this.editing = false;
    this.disableAll();
    if(this.onEditComplete != null){
      this.onEditComplete();
    }
  }
  void disableAll() {
    for (Widget wd in this.displayContent) {
      if(wd is DisableWidgetMixIn){
        (wd as DisableWidgetMixIn).setDisabled(true);
      }
    }
  }

  void enableAll({Function(CustomTextField) doOnFirstOne}) {
    for (Widget wd in this.displayContent) {
      if(wd is DisableWidgetMixIn){
        (wd as DisableWidgetMixIn).setDisabled(false);
      }
    }
  }
  List<String> getAllValue(){
    List<String> res = new List<String>();
    for (Widget wd in this.displayContent) {
      if( wd is ValueableWidgetMixIn<String>){
        res.add((wd as ValueableWidgetMixIn).getValue());
      }
    }
    return res;
  }
  Map<String,String> getMapWithValue(List<String> keys){
    Map<String,String> res = new Map<String,String>();

    int i=0;
    for(Widget wd in this.displayContent){
      if(!(wd is ValueableWidgetMixIn))continue;
      if(keys.length <= i){
        String key = "name-"+(i-keys.length).toString();
        res[key] = (wd as ValueableWidgetMixIn).getValue();
      }else{
        res.addAll((wd as ValueableWidgetMixIn).getValueWithKey(keys[i]));
      }
      i++;
    }
    return res;
  }
}

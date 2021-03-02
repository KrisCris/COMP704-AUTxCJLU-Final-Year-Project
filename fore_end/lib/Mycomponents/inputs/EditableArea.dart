
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:fore_end/interface/Valueable.dart';

///用于统一修改可变值组件的区域
class EditableArea extends StatelessWidget {

  ///区域内显示的组件
  List<Widget> displayContent;

  ///右上角的编辑按钮
  CustomIconButton editButton;

  ///编辑完成时执行的回调函数
  Function onEditComplete;

  ///是否正在编辑
  bool editing;

  ///区域的宽度
  double width;

  ///区域的高度
  double height;

  ///圆角边框半径
  double borderRadius;

  ///区域的标题
  String title;

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
    if (this.width <= 1) {
      this.width = ScreenTool.partOfScreenWidth(this.width);
    }
    if (this.height <= 1) {
      this.height = ScreenTool.partOfScreenHeight(this.height);
    }
    this._disableAll();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
            color: MyTheme.convert(ThemeColorName.ComponentBackground),
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
                    color: MyTheme.convert(ThemeColorName.HeaderText),
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
      icon: FontAwesomeIcons.edit,
      backgroundOpacity: 0,
      iconSize: 25,
    );
    this.editButton.onClick = (){
      if(!this.editing){
        this.editButton.changeIcon(FontAwesomeIcons.check);
        this._startEdit(context);
      }else{
        this.editButton.changeIcon(FontAwesomeIcons.edit);
        this._endEdit();
      }
    };
    return this.editButton;
  }

  ///开始编辑
  void _startEdit(BuildContext context) {
    this.editing = true;
    this.enableAll();
  }

  ///结束编辑
  void _endEdit() {
    this.editing = false;
    this._disableAll();
    if(this.onEditComplete != null){
      this.onEditComplete();
    }
  }

  ///将所有可以设置为disable的组件全部设置为disable
  void _disableAll() {
    for (Widget wd in this.displayContent) {
      if(wd is DisableWidgetMixIn){
        (wd as DisableWidgetMixIn).setDisabled(true);
      }
    }
  }

  ///将所有可以设置为disable的组件全部取消disable
  void enableAll() {
    for (Widget wd in this.displayContent) {
      if(wd is DisableWidgetMixIn){
        (wd as DisableWidgetMixIn).setDisabled(false);
      }
    }
  }

  ///获取所有可以产生值的组件里的值，以list返回
  List<String> getAllValue(){
    List<String> res = new List<String>();
    for (Widget wd in this.displayContent) {
      if( wd is ValueableWidgetMixIn<String>){
        res.add((wd as ValueableWidgetMixIn).getValue());
      }
    }
    return res;
  }

  ///获取所有可以产生值的组件里的值，并以给定的键 [keys] 对应
  ///若给定的键不够，将自动补充键
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

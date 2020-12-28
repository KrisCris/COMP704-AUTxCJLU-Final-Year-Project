import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/interface/Themeable.dart';

class EditableArea extends StatefulWidget {
  List<Widget> displayContent;
  MyTheme theme;
  double width;
  double height;
  double borderRadius;
  String title;
  EditableAreaState state;
  EditableArea(
      {Key key,
      @required this.theme,
      @required this.displayContent,
      this.width = 300,
      this.height = 500,
        this.borderRadius = 12,
      this.title = ""})
      : super(key: key) {
    if (this.width <= 1) {
      this.width = ScreenTool.partOfScreenWidth(this.width);
    }
    if (this.height <= 1) {
      this.height = ScreenTool.partOfScreenHeight(this.height);
    }
  }

  @override
  State<StatefulWidget> createState() {
    this.state = new EditableAreaState(
        ComponentReactState.able, ComponentThemeState.normal);
    return this.state;
  }
}

class EditableAreaState extends State<EditableArea>
    with TickerProviderStateMixin, Themeable {
  bool editing;
  ComponentReactState rea;
  ComponentThemeState the;

  CustomIconButton editButton;

  EditableAreaState(ComponentReactState rea, ComponentThemeState the) {
    this.rea = rea;
    this.the = the;
  }
  @override
  void initState() {
    this.editing = false;
    this.disableAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
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
          Expanded(
            child: Text(widget.title,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 25,
                    color: widget.theme.getThemeColor(this.the),
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
    for (Widget wd in widget.displayContent) {
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

  void disableAll({Function(CustomTextField) doOnFirstOne}) {
    int i = 0;
    for (Widget wd in widget.displayContent) {
      if (wd is CustomTextField) {
        i++;
        if(i == 1 && doOnFirstOne != null){
          doOnFirstOne(wd);
        }
        (wd as CustomTextField).setDisable(true);
      }
    }
  }

  void enableAll({Function(CustomTextField) doOnFirstOne}) {
    int i = 0;
    for (Widget wd in widget.displayContent) {
      if (wd is CustomTextField) {
        (wd as CustomTextField).setDisable(false);
        i++;
        if(i == 1 && doOnFirstOne != null){
          doOnFirstOne(wd);
        }

      }
    }
  }

  void startEdit(BuildContext context) {
    this.editing = true;
    this.enableAll(doOnFirstOne: (CustomTextField f){
        // f.addFunctionWhenCouldFocus((){
        //   FocusScope.of(context).requestFocus(f.getFocusNode());
        // });
    });
  }

  void endEdit() {
    this.editing = false;
    this.disableAll();
  }

  @override
  void setReactState(ComponentReactState rea) {
    // TODO: implement setReactState
  }

  @override
  void setThemeState(ComponentThemeState the) {
    // TODO: implement setThemeState
  }
}

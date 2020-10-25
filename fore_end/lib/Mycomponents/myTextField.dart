import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyIcons.dart';
import 'package:fore_end/MyTool/formatChecker.dart';
import 'package:fore_end/MyTool/screenTool.dart';

class MyTextField extends StatefulWidget {
  // final iconString;  //这里是放图表的，暂时用不到
  final String placeholder; //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  // final bool isPassword; //判断是不是密码框
  // final bool isEmail;   //判断邮箱格式
  final InputFieldType type;
  final bool isAutoFocus;
  final String inputTypes;
  final int maxlength; //长度
  final IconData myIcon;
  final bool showIcon;
  double width;   //文本框的宽
  Color defaultColor;  //不点击的颜色  灰
  Color focusColor; //点击的颜色   蓝
  Color errorColor;  //报错的颜色  红
  double ulDefaultWidth;  //未点击的下划线厚度
  double ulFocusedWidth;  //点击的厚度

  MyTextFieldState st;



  // bool checkContent;
  // final inputController;  //用来获取输入内容的

  MyTextField(
      {this.placeholder,
        this.type = InputFieldType.text,
        this.isAutoFocus= false,
      this.width,
      this.ulFocusedWidth,
      this.ulDefaultWidth,
      this.errorColor,
      this.focusColor,
      this.defaultColor,
        this.inputTypes="text",
        this.maxlength= 30, //默认文本框输入长度
        this.myIcon=Icons.email_outlined,
        this.showIcon=false,
      Key key,})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);
    } //构造函数

  //测试逻辑方法

  String getInput(){
    return this.st.getInput();
  }

  bool isEmpty(){
    return this.st.isEmpty();
  }

  void addListener(Function f){
    this.st.addListener(f);
  }
  bool checkInput(){
  return FormatChecker.check(this.type, this.getInput());
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
      this.st = new MyTextFieldState();
      return this.st;
  }

  void iconSizeController(){
    if(!this.checkInput()){

      //如果输入错误的时候，显示错误图表，并且提示内容
      this.st.iconSize =25;
      // this.st.errorTextContent="email address not exist！";
      this.st.setState(() {

      });
    }
    return;
  }



}

class MyTextFieldState extends State<MyTextField> {
  TextEditingController _inputcontroller  = TextEditingController();
  double iconSize=0;
  Color errorColors=Colors.blue;



  @override
  void initState() {
    super.initState();
    this._inputcontroller.addListener(() {
      //监听内容的

    });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        margin: new EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: TextField(

          controller: this._inputcontroller,
          style: TextStyle(fontSize: 18),
          autofocus: widget.isAutoFocus,
          cursorColor: Colors.blue,
          cursorWidth: 2,

          decoration: new InputDecoration( //下划线的设置
            // focusedBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(
            //       color: widget.errorColor, width: widget.ulFocusedWidth),
            // ),
            // enabledBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(
            //       color: widget.defaultColor, width: widget.ulDefaultWidth),
            // ),
            // disabledBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(
            //         color: Colors.orange, width: widget.ulDefaultWidth)
            // ),
            // errorBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(
            //         color: widget.errorColor, width: widget.ulDefaultWidth)
            // ),
            // focusedErrorBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(
            //         color: widget.errorColor, width: widget.ulFocusedWidth)
            // ),

            //文本框基本属性
            hintText: widget.placeholder,
            contentPadding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
            isDense: true,
            helperText: "Please input correct email!",
            // errorText: !widget.checkInput()? null :"wrong email!",
            //当失去焦点的时候去判断邮箱地址是不是正确

            // icon: Icon(widget.myIcon,color: Constants.FOCUSED_COLOR,size: 20,),
            //icon: Icon(Icons.phone),
            suffixIcon: Padding(

                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Icon(
                  FontAwesomeIcons.timesCircle, color: Colors.red, size: iconSize,)
            ),
          ),
          obscureText: widget.type == InputFieldType.password,
        )
    );
  }

  String getInput(){
    return this._inputcontroller.text;
  }
  bool isEmpty(){
    return this._inputcontroller.text == "";
  }
  void addListener(Function f){
    this._inputcontroller.addListener(f);
  }
}

enum InputFieldType{
  email,
  password,
  text
}

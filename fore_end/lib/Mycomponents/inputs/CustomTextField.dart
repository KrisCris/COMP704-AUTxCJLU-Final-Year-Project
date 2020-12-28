import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/interface/Themeable.dart';

enum InputFieldType { email, password, text, verifyCode }

class CustomTextField extends StatefulWidget {
  static final double WIDTH_TF_FOCUSED = ScreenTool.partOfScreenHeight(3);
  static final double WIDTH_TF_UNFOCUSED = ScreenTool.partOfScreenHeight(2);

  final MyTheme theme;
  // final iconString;  //这里是放图表的，暂时用不到
  final String placeholder; //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  String errorText;
  final FocusNode next;
  String helpText;
  final InputFieldType inputType;
  final bool isAutoFocus;
  final int maxlength; //长度
  final IconData myIcon;
  final bool showIcon;
  bool autoChangeState;
  double width; //文本框的宽
  double ulDefaultWidth; //未点击的下划线厚度
  double ulFocusedWidth; //点击的厚度
  Function onCorrect;
  Function onError;
  Function onEmpty;
  TextInputType keyboardType;
  TextInputAction keyboardAction;
  List<Function> listenerList;
  ComponentReactState firstReactState;
  ComponentThemeState firstThemeState;
  CustomTextFieldState st;

  ///when length change, button fix at center(0),left(1) or right(2)
  int sizeChangeMode;

  CustomTextField({
    this.placeholder,
    this.inputType = InputFieldType.text,
    this.isAutoFocus = false,
    this.errorText = "input error",
    this.helpText = "",
    @required this.theme,
    this.width,
    ulFocusedWidth,
    ulDefaultWidth,
    this.firstReactState = ComponentReactState.unfocused,
    this.firstThemeState = ComponentThemeState.normal,
    this.myIcon = Icons.email_outlined,
    this.showIcon = false,
    this.maxlength,
    this.onCorrect,
    this.onError,
    this.onEmpty,
    this.next,
    this.sizeChangeMode = 0,
    this.autoChangeState = true,
    Key key,
  }) : super(key: key) {
    this.ulFocusedWidth = CustomTextField.WIDTH_TF_FOCUSED;
    this.ulDefaultWidth = CustomTextField.WIDTH_TF_UNFOCUSED;

    this.st = new CustomTextFieldState(this.firstThemeState, this.firstReactState);
    this.width = ScreenTool.partOfScreenWidth(this.width);
    if (this.inputType == InputFieldType.email) {
      this.keyboardType = TextInputType.emailAddress;
    } else {
      this.keyboardType = TextInputType.text;
    }
    if (next != null) {
      this.keyboardAction = TextInputAction.next;
    }

    this.listenerList = List<Function>();
  }

  String getInput() {
    return this.st.getInput();
  }

  FocusNode getFocusNode() {
    return this.st._focusNode;
  }

  void setWidth(double len) {
    double newWidth = ScreenTool.partOfScreenWidth(len);
    this.st.lengthAnimation.initAnimation(
        this.width, newWidth, this.st.sizeChangeDura, this.st, () {
      this.st.setState(() {});
    });
    this.st.lengthAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        this.width = newWidth;
      }
    });
    this.st.lengthAnimation.beginAnimation();
  }

  bool isEmpty() {
    return this.st.isEmpty();
  }

  bool isCorrect() {
    return this.st.isCorrect;
  }

  bool isChange() {
    return this.st.isCorrect;
  }

  void clearInput() {
    this.st._inputcontroller.clear();
  }

  void addListener(Function f) {
    if (this.st == null)
      this.listenerList.add(f);
    else
      this.st.addListener(f);
  }

  bool checkInput() {
    return FormatChecker.check(this.inputType, this.getInput());
  }

  void setError() {
    this.st.isCorrect = false;
    this.setThemeState(ComponentThemeState.error, force: true);
    this.st.suffixSizeAnimation.beginAnimation();
  }

  void setNormal() {
    this.st.isCorrect = false;
    this.setThemeState(ComponentThemeState.normal, force: true);
    this.st.suffixSizeAnimation.reverseAnimation();
  }

  void setCorrect() {
    this.st.isCorrect = true;
    this.setThemeState(ComponentThemeState.correct, force: true);
    this.st.suffixSizeAnimation.beginAnimation();
  }

  void setErrorText(String txt) {
    this.st.setState(() {
      this.errorText = txt;
    });
  }

  void setHelpText(String txt) {
    this.st.setState(() {
      this.helpText = txt;
    });
  }

  void setThemeState(ComponentThemeState the, {bool force = false}) {
    this.st.setThemeState(the, force: force);
  }

  void setReactState(ComponentReactState rea) {
    this.st.setReactState(rea);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return this.st;
  }
}

class CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin, Themeable {
  TextEditingController _inputcontroller = TextEditingController();
  TweenAnimation<CalculatableColor> colorAnimation = TweenAnimation<CalculatableColor>();
  TweenAnimation<double> suffixSizeAnimation = TweenAnimation<double>();
  TweenAnimation<double> underlineWidthAnimation = TweenAnimation<double>();
  TweenAnimation<double> lengthAnimation = TweenAnimation<double>();

  FocusNode _focusNode = FocusNode();
  Color errorColors = Colors.blue;
  bool isCorrect = false;
  int colorChangeDura = 350;
  int sizeChangeDura = 200;
  double firstWidth;
  MyCounter continuousInputChecker;
  bool isInputing = false;
  String prev = "";

  CustomTextFieldState(ComponentThemeState the, ComponentReactState rea) : super() {
    this.themeState = the;
    this.reactState = rea;
  }

  @override
  void initState() {
    super.initState();
    this.firstWidth = widget.width;
    this.initColor();
    for (Function f in widget.listenerList) {
      this.addListener(f);
    }
    this.lengthAnimation.initAnimation(
        this.firstWidth, this.firstWidth, this.sizeChangeDura, this,null);
    this.lengthAnimation.beginAnimation();

    this.underlineWidthAnimation.initAnimation(
        widget.ulDefaultWidth, widget.ulFocusedWidth, sizeChangeDura, this, () {
      setState(() {});
    });

    this.suffixSizeAnimation.initAnimation(0.0, 25.0, sizeChangeDura, this, () {
      setState(() {});
    });

    this._focusNode.addListener(() {
      if (this._focusNode.hasFocus) {
        this.setReactState(ComponentReactState.focused);
        this.continuousInputChecker = new MyCounter(
            times: 1,
            callWhenStart: false,
            duration: 700,
            calling: () {
              this.isInputing = false;
              if (this._inputcontroller.text.isEmpty) {
                if (widget.autoChangeState) {
                  this.setThemeState(ComponentThemeState.normal);
                }
                if (widget.onEmpty != null) {
                  widget.onEmpty();
                }
                this.suffixSizeAnimation.reverseAnimation();
                this.isCorrect = false;
              } else {
                if (this.themeState == ComponentThemeState.normal &&
                    widget.autoChangeState) {
                  this.suffixSizeAnimation.beginAnimation();
                }
                if (FormatChecker.check(
                    widget.inputType, this._inputcontroller.text)) {
                  if (widget.autoChangeState) {
                    this.setThemeState(ComponentThemeState.correct);
                    this.isCorrect = true;
                  }

                  if (widget.onCorrect != null) {
                    widget.onCorrect();
                  }
                } else {
                  if (widget.autoChangeState) {
                    this.setThemeState(ComponentThemeState.error);
                    this.isCorrect = false;
                  }
                  if (widget.onError != null) {
                    widget.onError();
                  }
                }
              }
            });
      } else {
        if(!this.continuousInputChecker.isStop()){
          this.continuousInputChecker.stop();
          this.continuousInputChecker.callCounterFunc();
        }else{
          this.setReactState(ComponentReactState.unfocused);
        }

      }
    });

    this._inputcontroller.addListener(() {
      if (this.prev == this._inputcontroller.text) return;
      this.prev = this._inputcontroller.text;
      this.isInputing = true;
      if (this.continuousInputChecker != null) {
        this.continuousInputChecker.reset();
      }
      this.setThemeState(ComponentThemeState.normal);
      this.suffixSizeAnimation.reverse();
    });
  }

  void initColor() {
    this.colorAnimation.initAnimation(
        widget.theme.getReactColor(this.reactState),
        widget.theme.getReactColor(this.reactState),
        colorChangeDura,
        this, () {
      setState(() {});
    });
    this.colorAnimation.beginAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(this.continuousInputChecker != null){
      this.continuousInputChecker.stop();
    }
    this.colorAnimation.dispose();
    this.suffixSizeAnimation.dispose();
    this.underlineWidthAnimation.dispose();
    this._inputcontroller.dispose();
    this._focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget vis = AnimatedBuilder(
        animation: this.lengthAnimation.ctl,
        child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(' '))
          ],
          textInputAction: widget.keyboardAction,
          keyboardType: widget.keyboardType,
          focusNode: this._focusNode,
          controller: this._inputcontroller,
          style: TextStyle(fontSize: 18),
          autofocus: widget.isAutoFocus,
          cursorColor: colorAnimation.getValue(),
          cursorWidth: 2,
          maxLength: widget.maxlength,
          onEditingComplete: () {
            if (widget.next != null) {
              FocusScope.of(context).requestFocus(widget.next);
            }
          },
          decoration: new InputDecoration(
            //下划线的设置
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: colorAnimation.getValue(),
                  width: this.underlineWidthAnimation.getValue()),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: colorAnimation.getValue(),
                  width: this.underlineWidthAnimation.getValue()),
            ),
            disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: colorAnimation.getValue(),
                    width: this.underlineWidthAnimation.getValue())),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: colorAnimation.getValue(),
                    width: this.underlineWidthAnimation.getValue())),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: colorAnimation.getValue(),
                    width: this.underlineWidthAnimation.getValue())),

            //文本框基本属性
            hintText: widget.placeholder,
            contentPadding: new EdgeInsets.fromLTRB(0, 20, 0, 0),
            isDense: true,
            helperText: this.isCorrect ? "" : widget.helpText,
            errorText: this.isCorrect ||
                (!this.isCorrect &&
                    this._inputcontroller.text.isEmpty)
                ? null
                : widget.errorText,
            suffixIcon: Transform.translate(
                offset: Offset(10, 5),
                child: Icon(
                    this.isCorrect
                        ? FontAwesomeIcons.checkCircle
                        : FontAwesomeIcons.timesCircle,
                    color: this.colorAnimation.getValue(),
                    size: this.suffixSizeAnimation.getValue())),
          ),
          obscureText: widget.inputType == InputFieldType.password,
        ),
        builder: (BuildContext context, Widget child){
          return Visibility(
              visible: this.lengthAnimation.getValue() == 0 ? false : true,
              child: Transform.translate(
                  offset: Offset(this.calculatePosition(), 0),
                  child: Container(
                      width: this.lengthAnimation.getValue(),
                      margin: new EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: child)));
        });
    return vis;
  }

  String getInput() {
    return this._inputcontroller.text;
  }

  bool isEmpty() {
    return this._inputcontroller.text == "";
  }

  double calculatePosition() {
    if (widget.sizeChangeMode == 0)
      return 0;
    else if (widget.sizeChangeMode == 1) {
      double gap = this.firstWidth - this.lengthAnimation.getValue();
      return -(gap / 2);
    } else if (widget.sizeChangeMode == 2) {
      double gap = this.firstWidth - this.lengthAnimation.getValue();
      return gap / 2;
    }
  }

  void addListener(Function f) {
    this._inputcontroller.addListener(f);
  }

  @override
  void setReactState(ComponentReactState rea) {
    if (rea == this.reactState) return;

    if (rea == ComponentReactState.unfocused) {
      if (this.themeState == ComponentThemeState.normal) {
        this.colorAnimation.initAnimation(
            widget.theme.getThemeColor(this.themeState),
            widget.theme.getReactColor(rea),
            colorChangeDura,
            this, () {
          setState(() {});
        });
        this.underlineWidthAnimation.reverseAnimation();
      }
    } else {
      if (this.themeState == ComponentThemeState.normal) {
        this.colorAnimation.initAnimation(
            widget.theme.getReactColor(this.reactState),
            widget.theme.getThemeColor(this.themeState),
            colorChangeDura,
            this, () {
          setState(() {});
        });
        this.underlineWidthAnimation.beginAnimation();
      }
    }
    this.colorAnimation.beginAnimation();
    this.reactState = rea;
  }

  @override
  void setThemeState(ComponentThemeState the, {bool force = false}) {
    if (the == this.themeState) return;

    if (this.reactState == ComponentReactState.focused) {
      this.colorAnimation.initAnimation(
          widget.theme.getThemeColor(this.themeState),
          widget.theme.getThemeColor(the),
          colorChangeDura,
          this, () {
        setState(() {});
      });
      this.colorAnimation.beginAnimation();
      this.themeState = the;
    } else {
      if (force) {
        this.colorAnimation.initAnimation(
            widget.theme.getThemeColor(this.themeState),
            widget.theme.getThemeColor(the),
            colorChangeDura,
            this, () {
          setState(() {});
        });
        this.colorAnimation.beginAnimation();
      }
      this.themeState = the;
    }
  }
}

class FormatChecker {
  Map<InputFieldType, Function(String)> mapper;
  factory FormatChecker() =>  _getInstance();
  static FormatChecker get instance => _getInstance();
  static FormatChecker _instance;
  FormatChecker._internal(){
    mapper = new Map<InputFieldType, Function(String)>();
    mapper.addAll({
      InputFieldType.email : (String s){
        String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
        if (s == null || s.isEmpty) return false;
        return (new RegExp(regexEmail)).hasMatch(s);},

      InputFieldType.text :(String s){return !s.isEmpty;},

      InputFieldType.password : (String s){
        return s.length > 6;
      },

      InputFieldType.verifyCode:(String s){
        return s.length==6;
      }
    });
  }

  static FormatChecker _getInstance(){
    if (_instance == null) {
      _instance = new FormatChecker._internal();
    }
    return _instance;
  }

  static bool check(InputFieldType tp, String text){
    return FormatChecker.instance.mapper[tp](text);
  }
}
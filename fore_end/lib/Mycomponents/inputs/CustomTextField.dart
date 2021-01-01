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
  double bottomPadding;
  double width; //文本框的宽
  double ulDefaultWidth; //未点击的下划线厚度
  double ulFocusedWidth; //点击的厚度

  final String placeholder; //第一行输入框内容  可以是用户名  这里可以自定义输入框数量的
  String errorText;
  String helpText;
  String defaultContent;

  final bool isAutoFocus;
  final bool isAutoCheck;
  final bool isAutoChangeState;
  final bool disableSuffix;

  final int maxlength; //长度
  int sizeChangeMode;

  Function onCorrect;
  Function onError;
  Function onEmpty;
  Function disabledFunc;
  List<Function> listenerList;
  List<Function> doWhenCouldfocus;

  final FocusNode next;
  FocusNode _focusNode = FocusNode();

  final InputFieldType inputType;
  TextInputType keyboardType;
  TextInputAction keyboardAction;

  ComponentReactState firstReactState;
  ComponentThemeState firstThemeState;
  CustomTextFieldState st;
  TextAlign textAlign;

  final MyTheme theme;
  final IconData myIcon;

  ///when length change, button fix at center(0),left(1) or right(2)


  CustomTextField({
    bool disabled = false,
    this.placeholder,
    this.inputType = InputFieldType.text,
    this.isAutoCheck = true,
    this.isAutoFocus = false,
    this.isAutoChangeState = true,
    this.disableSuffix=false,
    this.errorText = "input error",
    this.helpText = "",
    @required this.theme,
    this.width = 0.5,
    this.bottomPadding=0,
    this.ulFocusedWidth,
    this.ulDefaultWidth,
    this.defaultContent = "",
    this.firstReactState = ComponentReactState.unfocused,
    this.firstThemeState = ComponentThemeState.normal,
    this.myIcon = Icons.email_outlined,
    this.maxlength,
    this.textAlign=TextAlign.left,
    this.onCorrect,
    this.onError,
    this.onEmpty,
    this.disabledFunc,
    this.next,
    this.sizeChangeMode = 0,
    Key key,
  }) : super(key: key) {
    if (this.ulFocusedWidth == null) {
      this.ulFocusedWidth = CustomTextField.WIDTH_TF_FOCUSED;
    }
    if (this.ulDefaultWidth == null) {
      this.ulDefaultWidth = CustomTextField.WIDTH_TF_UNFOCUSED;
    }
    this.st = new CustomTextFieldState(
        this.firstThemeState, this.firstReactState, disabled);
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
    this.doWhenCouldfocus = List<Function>();
  }

  String getInput() {
    return this.st.getInput();
  }

  FocusNode getFocusNode() {
    return this._focusNode;
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
  void focus(BuildContext context){
    FocusScope.of(context).requestFocus(this._focusNode);
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

  void addFunctionWhenCouldFocus(Function f) {
    this.doWhenCouldfocus.add(f);
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

  void setDisable(bool dis) {
    if (this.st != null) {
      if (this.st.mounted) {
        this.st.setDisable(dis);
      } else {
        this.st.disabled = dis;
      }
    }
  }

  void setThemeState(ComponentThemeState the, {bool force = false}) {
    this.st.setThemeState(the, force: force);
  }

  void setReactState(ComponentReactState rea) {
    this.st.setReactState(rea);
  }

  @override
  State<StatefulWidget> createState() {
    return this.st;
  }
}








class CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin, Themeable {
  TextEditingController _inputcontroller = TextEditingController();
  TweenAnimation<CalculatableColor> colorAnimation =
      TweenAnimation<CalculatableColor>();
  TweenAnimation<double> suffixSizeAnimation = TweenAnimation<double>();
  TweenAnimation<double> underlineWidthAnimation = TweenAnimation<double>();
  TweenAnimation<double> lengthAnimation = TweenAnimation<double>();

  TextField field;
  Color errorColors = Colors.blue;
  bool isCorrect = false;
  bool disabled = false;
  int colorChangeDura = 350;
  int sizeChangeDura = 200;
  double firstWidth;
  MyCounter continuousInputChecker;
  bool isInputing = false;
  String prev = "";

  CustomTextFieldState(
      ComponentThemeState the, ComponentReactState rea, bool disabled)
      : super() {
    this.themeState = the;
    this.reactState = rea;
    this.disabled = disabled;
  }

  @override
  void initState() {
    super.initState();
    this.firstWidth = widget.width;
    this._inputcontroller = TextEditingController.fromValue(
        TextEditingValue(
          text: widget.defaultContent,
          selection: TextSelection.fromPosition(
              TextPosition(
              affinity: TextAffinity.downstream,
              offset: widget.defaultContent.length)
          )
        )
    );
    this.prev = widget.defaultContent;
    if(this.disabled){
      this.reactState = ComponentReactState.disabled;
    }
    this.initColor();
    for (Function f in widget.listenerList) {
      this.addListener(f);
    }
    this.lengthAnimation.initAnimation(
        this.firstWidth, this.firstWidth, this.sizeChangeDura, this, null);
    this.lengthAnimation.beginAnimation();

    this.underlineWidthAnimation.initAnimation(
        widget.ulDefaultWidth, widget.ulFocusedWidth, sizeChangeDura, this, () {
      setState(() {});
    });
    double suffixValue = 25;
    if(widget.disableSuffix)suffixValue = 0;
    this.suffixSizeAnimation.initAnimation(0.0, suffixValue, sizeChangeDura, this, () {
      setState(() {});
    });

    widget._focusNode.addListener(() {
      if (widget._focusNode.canRequestFocus) {
        if (widget.doWhenCouldfocus != null &&
            widget.doWhenCouldfocus.isNotEmpty) {
          Function f = widget.doWhenCouldfocus.removeAt(0);
          f();
        }
      }
      if (widget._focusNode.hasFocus) {
        this.setReactState(ComponentReactState.focused);
        this.continuousInputChecker = new MyCounter(
            times: 1,
            callWhenStart: false,
            duration: 700,
            calling: () {
              this.isInputing = false;
              if (this._inputcontroller.text.isEmpty) {
                if (widget.isAutoChangeState) {
                  this.setThemeState(ComponentThemeState.normal);
                }
                if (widget.onEmpty != null) {
                  widget.onEmpty();
                }
                this.suffixSizeAnimation.reverseAnimation();
                this.isCorrect = false;
              } else {
                if (this.themeState == ComponentThemeState.normal &&
                    widget.isAutoChangeState) {
                  this.suffixSizeAnimation.beginAnimation();
                }
                if(!widget.isAutoCheck) return;

                if (FormatChecker.check(
                    widget.inputType, this._inputcontroller.text)) {
                  if (widget.isAutoChangeState) {
                    this.setThemeState(ComponentThemeState.correct);
                    this.isCorrect = true;
                  }

                  if (widget.onCorrect != null) {
                    widget.onCorrect();
                  }
                } else {
                  if (widget.isAutoChangeState) {
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
        if (this.continuousInputChecker != null &&
            !this.continuousInputChecker.isStop()) {
          this.continuousInputChecker.stop();
          this.continuousInputChecker.callCounterFunc();
        } else {
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
    if (this.continuousInputChecker != null) {
      this.continuousInputChecker.stop();
    }
    this.colorAnimation.dispose();
    this.suffixSizeAnimation.dispose();
    this.underlineWidthAnimation.dispose();
    this._inputcontroller.dispose();
    widget._focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget vis = AnimatedBuilder(
        animation: this.lengthAnimation.ctl,
        child: this.getInputField(),
        builder: (BuildContext context, Widget child) {
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

  Widget getInputField() {
    return TextField(
      enabled: !this.judgeDisabled(),
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(' '))],
      textInputAction: widget.keyboardAction,
      keyboardType: widget.keyboardType,
      focusNode: widget._focusNode,
      controller: this._inputcontroller,
      maxLines: 1,
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
      textAlign: widget.textAlign,
      decoration: new InputDecoration(
        //下划线的设置
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: colorAnimation.getValue(),
              width: this.underlineWidthAnimation.getValue()),
        ),
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //       color: colorAnimation.getValue(),
        //       width: this.underlineWidthAnimation.getValue()),
        // ),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,),
        // errorBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(
        //         color: colorAnimation.getValue(),
        //         width: this.underlineWidthAnimation.getValue())),
        // focusedErrorBorder: UnderlineInputBorder(
        //     borderSide: BorderSide(
        //         color: colorAnimation.getValue(),
        //         width: this.underlineWidthAnimation.getValue())),

        //文本框基本属性
        hintText: widget.placeholder,
        contentPadding: new EdgeInsets.fromLTRB(0, 20, 0, widget.bottomPadding),
        isDense: true,
        helperText: this.isCorrect ? "" : widget.helpText,
        errorText: this.isCorrect ||
                (!this.isCorrect && this._inputcontroller.text.isEmpty) || this.disabled
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
    );
  }

  void setDisable(bool dis) {
    this.disabled = dis;
    if (this.disabled) {
      this.setReactState(ComponentReactState.disabled);
    } else {
      this.setReactState(ComponentReactState.able);
    }
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
  bool judgeDisabled(){
    if(widget.disabledFunc == null){
      return this.disabled;
    }
    dynamic res = widget.disabledFunc();
    if(!(res is bool))return this.disabled;

    return res as bool;
  }
  @override
  void setReactState(ComponentReactState rea) {
    if (rea == this.reactState) return;

    if (rea == ComponentReactState.unfocused) {
      //进入非聚焦状态，correct和error状态都不进行变化，只有normal状态进行变化
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
    } else if (rea == ComponentReactState.focused) {
      //进入聚焦状态，correct和error状态都不进行变化，只有normal状态进行变化
      if (this.themeState == ComponentThemeState.normal) {
        this.colorAnimation.initAnimation(
            widget.theme.getThemeColor(this.themeState),
            widget.theme.getReactColor(rea),
            colorChangeDura,
            this, () {
          setState(() {});
        });
        this.underlineWidthAnimation.beginAnimation();
      }
    } else if (rea == ComponentReactState.disabled) {
      //进入禁用状态，直接从当前颜色变化到disable状态
      this.colorAnimation.initAnimation(this.colorAnimation.getValue(),
          widget.theme.getReactColor(rea), colorChangeDura, this, () {
        setState(() {});
      });
      //禁用状态下，下划线和尾部图标全部回缩
      this.underlineWidthAnimation.reverse();
      this.suffixSizeAnimation.reverse();
    } else if (rea == ComponentReactState.able) {
      //可用状态，从当前颜色回到theme控制的颜色
      this.colorAnimation.initAnimation(
          this.colorAnimation.getValue(),
          widget.theme.getThemeColor(this.themeState),
          colorChangeDura,
          this, () {
        setState(() {});
      });
      //可用状态下，若为correct或者error,则将下划线和尾部图片放大
      if (this.themeState == ComponentThemeState.correct ||
          this.themeState == ComponentThemeState.error) {
        this.suffixSizeAnimation.beginAnimation();
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
  factory FormatChecker() => _getInstance();
  static FormatChecker get instance => _getInstance();
  static FormatChecker _instance;
  FormatChecker._internal() {
    mapper = new Map<InputFieldType, Function(String)>();
    mapper.addAll({
      InputFieldType.email: (String s) {
        String regexEmail =
            "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
        if (s == null || s.isEmpty) return false;
        return (new RegExp(regexEmail)).hasMatch(s);
      },
      InputFieldType.text: (String s) {
        return !s.isEmpty;
      },
      InputFieldType.password: (String s) {
        return s.length > 6;
      },
      InputFieldType.verifyCode: (String s) {
        return s.length == 6;
      }
    });
  }

  static FormatChecker _getInstance() {
    if (_instance == null) {
      _instance = new FormatChecker._internal();
    }
    return _instance;
  }

  static bool check(InputFieldType tp, String text) {
    return FormatChecker.instance.mapper[tp](text);
  }
}

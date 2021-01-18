import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/CalculatableColor.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/interface/Disable.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:fore_end/interface/Valueable.dart';

///定义了输入框的输入类别
enum InputFieldType { email, password, text, verifyCode }

///自定义的输入框
class CustomTextField extends StatefulWidget
    with ThemeWidgetMixIn,DisableWidgetMixIn,ValueableWidgetMixIn<String> {
  ///常量，聚焦和不聚焦的时候，下划线的厚度
  static final double WIDTH_TF_FOCUSED = ScreenTool.partOfScreenHeight(3);
  static final double WIDTH_TF_UNFOCUSED = ScreenTool.partOfScreenHeight(2);

  ///输入框的文字和底部的距离
  double bottomPadding;

  ///输入框的宽度
  double width;

  ///输入框的下划线厚度
  double ulDefaultWidth;

  ///聚焦时，下划线的厚度
  double ulFocusedWidth;

  ///输入框的内部提示字
  final String placeholder;

  ///输入框的错误提示字
  String errorText;

  ///输入框的提示字
  String helpText;

  ///输入框的默认填充内容
  ///默认为空
  String defaultContent;

  ///是否需要自动聚焦
  final bool isAutoFocus;

  ///是否需要自动检查输入正确性
  final bool isAutoCheck;

  ///是否需要自动改变主题状态
  final bool isAutoChangeState;

  ///是否需要禁用后缀图标
  final bool disableSuffix;

  ///第一次聚焦时，是否需要执行 [onEmpty] 函数
  final bool isFirstFocusDoFunction;

  ///输入框允许输入的最大字符数量
  final int maxlength;

  ///尺寸变化模式，同CustomButton
  ///when length change, button fix at center(0),left(1) or right(2)
  ///有时候表现会出现错误，不推荐大量使用
  int sizeChangeMode;

  ///检测正确时的回调
  Function onCorrect;

  ///检测错误时的回调
  Function onError;

  ///内容为空的时候的回调
  Function onEmpty;

  ///从空内容到非空内容变化时执行的回调
  ///only do when from empty to not empty
  Function onNotEmpty;

  ///监听器列表，在初始化时会添加到 [TextEditingController] 监听器中
  List<Function> listenerList;

  ///当聚焦状态变为可聚焦时，执行的函数
  ///表现暂时不稳定，不推荐使用
  List<Function> doWhenCouldfocus;

  ///下一个聚焦的Node
  final FocusNode next;

  ///当前的FocusNode
  FocusNode _focusNode = FocusNode();

  ///输入类型，详见 [InputFieldType]
  final InputFieldType inputType;

  ///Flutter自带的输入类型，与自定义的InputFieldType有功能重复
  ///需要进行修改
  TextInputType keyboardType;

  ///Flutter自带的输入行为，用于控制弹出的键盘右下角按钮的行为
  TextInputAction keyboardAction;

  ///输入控制器
  TextEditingController _inputcontroller = TextEditingController();

  ///初次渲染时的主题状态
  ComponentThemeState firstThemeState;

  ///保存的State引用。历史遗留问题，不推荐用这种方式保存引用
  CustomTextFieldState st;

  ///文字的靠边方向
  TextAlign textAlign;

  CustomTextField({
    bool disabled = false,
    bool canChangeDisabled = true,
    this.placeholder,
    this.inputType = InputFieldType.text,
    this.isAutoCheck = true,
    this.isAutoFocus = false,
    this.isAutoChangeState = true,
    this.disableSuffix=false,
    this.errorText = "input error",
    this.helpText = "",
    this.isFirstFocusDoFunction = false,
    @required MyTheme theme,
    this.width = 0.5,
    this.bottomPadding=0,
    this.ulFocusedWidth,
    this.ulDefaultWidth,
    this.defaultContent = "",
    this.firstThemeState = ComponentThemeState.normal,
    this.maxlength,
    this.textAlign=TextAlign.left,
    this.onCorrect,
    this.onError,
    this.onEmpty,
    this.onNotEmpty,
    this.next,
    this.sizeChangeMode = 0,
    Key key,
  }) : super(key: key) {
    this.theme = theme;
    this.disabled = new ValueNotifier<bool>(disabled);
    this.canChangeDisable = canChangeDisabled;
    if (this.ulFocusedWidth == null) {
      this.ulFocusedWidth = CustomTextField.WIDTH_TF_FOCUSED;
    }
    if (this.ulDefaultWidth == null) {
      this.ulDefaultWidth = CustomTextField.WIDTH_TF_UNFOCUSED;
    }
    this.width = ScreenTool.partOfScreenWidth(this.width);

    //对于功能重复的InputField和Flutter自带的TextInputType进行适配处理
    //需要进一步修改
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

  FocusNode getFocusNode() {
    return this._focusNode;
  }

  ///设置变化后的宽度
  ///参数 [len] 是变化后的宽度
  ///历史遗留问题，不推荐使用这种方式调用state中的setState方法
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

  ///进行聚焦
  ///参数 [context] 为进行聚焦时的上下文
  void focus(BuildContext context){
    FocusScope.of(context).requestFocus(this._focusNode);
  }

  ///输入框的内容是否为空
  bool isEmpty() {
    return this._inputcontroller.text == "";
  }

  ///输入框目前的检测状态是否为correct
  ///若 [isAutoCheck] 未开启，该值不会自动更新
  bool isCorrect() {
    return this.st.isCorrect;
  }

  ///将输入框的内容清空
  ///由于未设置didUpdateWidget的行为，该方法有时候无效
  ///需要更改
  void clearInput() {
    this._inputcontroller.clear();
  }

  ///添加textInputController的监听
  void addListener(Function f) {
    if (this.st == null)
      this.listenerList.add(f);
    else
      this._inputcontroller.addListener(f);
  }

  ///设置输入错误时的动画效果和变量赋值
  ///历史遗留问题，不推荐用这种方式调用state的方法
  void setError() {
    this.st.isCorrect = false;
    this.st.setError();
    this.st.suffixSizeAnimation.beginAnimation();
  }

  ///设置一般状态时的动画效果和变量赋值
  ///历史遗留问题，不推荐用这种方式调用state的方法
  void setNormal() {
    this.st.isCorrect = false;
    this.st.setNormal();
    this.st.suffixSizeAnimation.reverseAnimation();
  }

  ///设置输入正确时的动画效果和变量赋值
  ///历史遗留问题，不推荐用这种方式调用state的方法
  void setCorrect() {
    this.st.isCorrect = true;
    this.st.setCorrect();
    this.st.suffixSizeAnimation.beginAnimation();
  }

  ///设置输入错误时的提示文字
  ///历史遗留问题，不推荐用这种方式调用state的方法
  void setErrorText(String txt) {
    this.st.setState(() {
      this.errorText = txt;
    });
  }

  ///设置输入平时的提示文字
  ///历史遗留问题，不推荐用这种方式调用state的方法
  void setHelpText(String txt) {
    this.st.setState(() {
      this.helpText = txt;
    });
  }

  ///历史遗留问题，不推荐用这种方式保存State的引用
  @override
  State<StatefulWidget> createState() {
    this.st = new CustomTextFieldState(
        this.firstThemeState);
    return this.st;
  }

  ///获取输入框的值
  @override
  String getValue() {
    return this._inputcontroller.text;
  }

  ///设置输入框的值
  @override
  void setValue(String s){
    this._inputcontroller.text = s;
  }
}



///CustomTextField的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///混入了 [ThemeStateMixIn] 用于控制主题颜色
///混入了 [DisableStateMixIn] 用于控制disable状态
///
class CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin, ThemeStateMixIn, DisableStateMixIn {

  ///控制颜色变化的动画
  TweenAnimation<CalculatableColor> colorAnimation =
      TweenAnimation<CalculatableColor>();

  ///控制后缀ICON大小变化的动画
  TweenAnimation<double> suffixSizeAnimation = TweenAnimation<double>();

  ///控制下划线厚度的动画
  TweenAnimation<double> underlineWidthAnimation = TweenAnimation<double>();

  ///控制输入框长度的动画
  TweenAnimation<double> lengthAnimation = TweenAnimation<double>();

  ///输入框本体
  TextField field;

  ///是否检测状态为correct
  bool isCorrect = false;

  ///颜色变化的动画持续时间
  ///单位：毫秒
  int colorChangeDura = 350;

  ///后缀ICON尺寸，下划线厚度，以及输入框长度变化的动画持续时间
  ///单位：毫秒
  int sizeChangeDura = 200;

  ///初次渲染时的输入框长度
  double firstWidth;

  ///用于持续性输入检测
  MyCounter continuousInputChecker;

  ///是否正在输入
  bool isInputing = false;

  ///上一次输入的内容
  String prev = "";

  CustomTextFieldState(
      ComponentThemeState the)
      : super() {
    this.themeState = the;
  }

  ///父组件刷新时执行的函数，重新绑定widget中的各种数据
  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.widgetBinding();

  }
  @override
  void initState() {
    super.initState();
    this.firstWidth = widget.width;
    //初始化输入控制器
    widget._inputcontroller = TextEditingController.fromValue(
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
    //初始化颜色
    this.initColor();

    //各种动画的初始化
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

    //widget相关内容的绑定
    this.widgetBinding();
  }

  ///初始化颜色动画的颜色
  void initColor() {
      this.colorAnimation.initAnimation(
          widget.theme.getDisabledColor(),
          widget.theme.getDisabledColor(),
          colorChangeDura,
          this, () {
        setState(() {});
      });
    this.colorAnimation.beginAnimation();
  }

  ///绑定widget相关的监听器，函数等内容
  ///当发生didUpdateWidget时，需要执行该函数
  void widgetBinding(){
    //添加监听器
    for (Function f in widget.listenerList) {
      widget.addListener(f);
    }

    //聚焦状态的监听
    widget._focusNode.addListener(() {
      if (widget._focusNode.canRequestFocus) {
        if (widget.doWhenCouldfocus != null &&
            widget.doWhenCouldfocus.isNotEmpty) {
          Function f = widget.doWhenCouldfocus.removeAt(0);
          f();
        }
      }
      //如果状态变为聚焦
      if (widget._focusNode.hasFocus) {
        //执行聚焦的相关动画效果
        this.setFocus();
        //如果设定了第一次聚焦需要执行函数，则按要求执行
        //TODO: 这里并没有判断第一次聚焦，而是聚焦时内容为空，需要进一步修改
        if(widget.isFirstFocusDoFunction){
          if(widget._inputcontroller.text.isEmpty){
            widget.onEmpty();
          }
        }

        //初始化持续输入检测
        this.continuousInputChecker = new MyCounter(
            times: 1,
            callWhenStart: false,
            duration: 700,
            calling: () {
              //当设定的间隔倒数完毕后，执行该回调
              //将isInput设置为false
              this.isInputing = false;

              //内容为空，则设置为normal状态（前提是isAutoChangeState设定为true）
              if (widget._inputcontroller.text.isEmpty) {
                if (widget.isAutoChangeState) {
                  this.setNormal();
                }
                if (widget.onEmpty != null) {
                  widget.onEmpty();
                }
                this.suffixSizeAnimation.reverseAnimation();
                this.isCorrect = false;
              } else {
                //内容非空，先显示后缀图标
                if (this.themeState == ComponentThemeState.normal &&
                    widget.isAutoChangeState) {
                  this.suffixSizeAnimation.beginAnimation();
                }
                //若没有设定isAutoCheck，则不执行后续内容
                if(!widget.isAutoCheck) return;

                //进行输入正确性检测,检测正确的情况
                if (FormatChecker.check(
                    widget.inputType, widget._inputcontroller.text)) {
                  //如果设定了isAutoChangeState，则进行动画播放
                  if (widget.isAutoChangeState) {
                    this.setCorrect();
                    this.isCorrect = true;
                  }

                  if (widget.onCorrect != null) {
                    widget.onCorrect();
                  }
                } else {
                  //检测错误的情况
                  if (widget.isAutoChangeState) {
                    this.setError();
                    this.isCorrect = false;
                  }
                  if (widget.onError != null) {
                    widget.onError();
                  }
                }
              }
            });
      } else {
        //如果状态变为失去焦点

        //检测持续性输入是否正在倒计时
        if (this.continuousInputChecker != null &&
            !this.continuousInputChecker.isStop()) {
          //若仍在倒计时，立刻结束倒计时，并且执行回调函数
          this.continuousInputChecker.stop();
          this.continuousInputChecker.callCounterFunc();
        } else {
          //若没有倒计时，直接设置失去焦点的动画
          //在倒计时的if分支里没有setUnFocus，因为相关的代码已经在计时器的回调中设置了
          this.setUnFocus();
        }
      }
    });


    widget._inputcontroller.addListener(() {
      if (this.prev == widget._inputcontroller.text) return;
      if(this.prev == "" && widget.onNotEmpty != null){
        widget.onNotEmpty();
      }
      this.prev = widget._inputcontroller.text;
      this.isInputing = true;
      if (this.continuousInputChecker != null) {
        this.continuousInputChecker.reset();
      }
      this.setNormal();
      this.suffixSizeAnimation.reverse();
    });
    this.initDisableListener(widget.disabled);
  }
  @override
  void dispose() {
    if (this.continuousInputChecker != null) {
      this.continuousInputChecker.stop();
    }
    this.colorAnimation.dispose();
    this.suffixSizeAnimation.dispose();
    this.underlineWidthAnimation.dispose();
    widget._inputcontroller.dispose();
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

  Widget getInputField() {
    return TextField(
      enabled: !widget.disabled.value,

      //TODO: tab按键不允许输入
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(' '))],

      textInputAction: widget.keyboardAction,
      keyboardType: widget.keyboardType,
      focusNode: widget._focusNode,
      controller: widget._inputcontroller,
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
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: colorAnimation.getValue(),
              width: this.underlineWidthAnimation.getValue()),
        ),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide.none,),
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
        contentPadding: new EdgeInsets.fromLTRB(0, 20, 0, widget.bottomPadding),
        isDense: true,
        helperText: this.isCorrect ? "" : widget.helpText,
        errorText: this.isCorrect ||
                (!this.isCorrect && widget._inputcontroller.text.isEmpty) || widget.disabled.value
            ? null
            : widget.errorText,

        //TODO: icon缩小为0，或被禁止时，真正消失，而不是设置大小到0
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

  ///长度发生变化时，进行位置的计算
  ///表现有时候会不正确，不推荐大量使用
  ///需要进一步改进
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

  ///设置correct状态时的动画播放
  @override
  ComponentThemeState setCorrect() {
    ComponentThemeState stt = super.setCorrect();
    this.colorAnimation.initAnimation(
        widget.theme.getThemeColor(stt),
        widget.theme.getThemeColor(this.themeState),
        colorChangeDura,
        this, () {
      setState(() {});
    });
    this.colorAnimation.beginAnimation();
    this.themeState = ComponentThemeState.correct;
  }

  ///设置error状态时的动画播放
  @override
  ComponentThemeState setError() {
    // TODO: implement setError
    ComponentThemeState stt = super.setError();
    this.colorAnimation.initAnimation(
        widget.theme.getThemeColor(stt),
        widget.theme.getThemeColor(this.themeState),
        colorChangeDura,
        this, () {
      setState(() {});
    });
    this.colorAnimation.beginAnimation();
  }

  ///设置normal状态时的动画播放
  @override
  ComponentThemeState setNormal() {
    // TODO: implement setNormal
    ComponentThemeState stt = super.setNormal();
    this.colorAnimation.initAnimation(
        widget.theme.getThemeColor(stt),
        widget.theme.getThemeColor(this.themeState),
        colorChangeDura,
        this, () {
      setState(() {});
    });
    this.colorAnimation.beginAnimation();
  }

  ///设置warning状态时候的动画播放
  @override
  ComponentThemeState setWarning() {
    // TODO: implement setWarning
    ComponentThemeState stt = super.setWarning();
    this.colorAnimation.initAnimation(
        widget.theme.getThemeColor(stt),
        widget.theme.getThemeColor(this.themeState),
        colorChangeDura,
        this, () {
      setState(() {});
    });
    this.colorAnimation.beginAnimation();
  }

  ///设置disable的动画播放
  @override
  void setDisabled() {
    // TODO: implement setDisabled
    //进入禁用状态，直接从当前颜色变化到disable状态
    this.colorAnimation.initAnimation(this.colorAnimation.getValue(),
        widget.theme.getDisabledColor(), colorChangeDura, this, () {
          setState(() {});
        });
    this.colorAnimation.beginAnimation();
    //禁用状态下，下划线和尾部图标全部回缩
    this.underlineWidthAnimation.reverse();
    this.suffixSizeAnimation.reverse();
  }

  ///设置enable的动画播放
  @override
  void setEnabled() {
    //可用状态，从当前颜色回到theme控制的颜色
    this.colorAnimation.initAnimation(
        this.colorAnimation.getValue(),
        widget.theme.getThemeColor(this.themeState),
        colorChangeDura,
        this, () {
      setState(() {});
    });
    this.colorAnimation.beginAnimation();
    //可用状态下，若为correct或者error,则将下划线和尾部图片放大
    if (this.themeState == ComponentThemeState.correct ||
        this.themeState == ComponentThemeState.error) {
      this.suffixSizeAnimation.beginAnimation();
      this.underlineWidthAnimation.beginAnimation();
    }
  }

  ///设置聚焦状态的动画播放
  void setFocus(){
    //进入聚焦状态，correct和error状态都不进行变化，只有normal状态进行变化
    if (this.themeState == ComponentThemeState.normal) {
      this.colorAnimation.initAnimation(
          widget.theme.getThemeColor(this.themeState),
          widget.theme.getFocusedColor(),
          colorChangeDura,
          this, () {
        setState(() {});
      });
      this.underlineWidthAnimation.beginAnimation();
      this.colorAnimation.beginAnimation();
    }
  }

  ///设置失去焦点状态的动画播放
  void setUnFocus(){
    //进入非聚焦状态，correct和error状态都不进行变化，只有normal状态进行变化
    if (this.themeState == ComponentThemeState.normal) {
      this.colorAnimation.initAnimation(
          widget.theme.getThemeColor(this.themeState),
          widget.theme.getDisabledColor(),
          colorChangeDura,
          this, () {
        setState(() {});
      });
      this.underlineWidthAnimation.reverseAnimation();
      this.colorAnimation.beginAnimation();
    }
  }
}

///用于辅助判断CustomTextField的输入检测
class FormatChecker {
  ///将InputFieldType和具体的检测规则映射
  Map<InputFieldType, Function(String)> mapper;

  ///采用单例模式
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

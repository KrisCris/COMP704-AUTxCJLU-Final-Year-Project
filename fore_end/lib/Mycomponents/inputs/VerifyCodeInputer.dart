import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/util/MyCounter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';

import 'CustomTextField.dart';

///用于输入验证码的组件
class VerifyCodeInputer extends StatefulWidget {
  ///根据该输入框获取要发送的邮箱
  @required
  CustomTextField emailField;

  ///当验证码正确时的回调
  Function onCheckSuccess;

  ///当验证码错误时的回调
  Function onCheckFailed;

  ///获取验证码按钮上，第一次显示的文字
  String firstShowText;

  ///或企业验证码按钮上, 按下一次之后显示的文字
  String repeatShowText;

  ///当验证码错误时，提示的文字
  String checkWrongText;

  ///输入框的内部提示字
  String placeHolder;

  ///输入框的宽度
  double width;

  //TODO: zsk 补充注释
  bool transVerifyType;

  ///历史遗留问题，不推荐用这种方式保存State的引用
  VerifyCodeState state;

  VerifyCodeInputer(
      {Key key,
      this.transVerifyType = false,
      this.emailField,
      this.onCheckFailed,
      this.onCheckSuccess,
      this.firstShowText = "Acquire Verify Code",
      this.repeatShowText = "Acquire again",
      this.checkWrongText = "Wrong verify code",
      this.placeHolder = "input verify code",
      double width = 0.7})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(width);
  }

  ///历史遗留问题，不推荐用这种方式保存State的引用
  @override
  State<StatefulWidget> createState() {
    this.state = new VerifyCodeState();
    return this.state;
  }

  ///历史遗留问题，不推荐用这种方式调用state的函数
  ///设置按钮禁用状态
  void setButtonDisabled(bool dis) {
    this.state.button.setDisabled(dis);
  }

  ///历史遗留问题，不推荐用这种方式调用state的函数
  ///设置输入框error状态
  void setError() {
    this.state.textField.setError();
  }

  ///历史遗留问题，不推荐用这种方式调用state的函数
  ///设置输入框correct状态
  void setCorrect() {
    this.state.textField.setCorrect();
  }

  //TODO: zsk 补充注释
  bool getCodeType() {
    return this.transVerifyType;
  }

  ///历史遗留问题，不推荐用这种方式调用state的函数
  ///获取用户点击获取验证码按钮时，输入框里的内容
  String getContentWhenClickButton() {
    return this.state.contentWhenClickButton;
  }
}

///VerifyCodeInputer的State类
class VerifyCodeState extends State<VerifyCodeInputer> {
  ///当用户点击获取验证码按钮时，输入框里的内容
  String contentWhenClickButton;

  ///是否验证通过
  bool verified;

  ///输入框本体
  CustomTextField textField;

  ///按钮本体
  CustomButton button;

  ///计时器，用于控制重复获取验证码的间隔
  MyCounter counter;

  @override
  void initState() {
    ///设置计时器的间隔，默认1000毫秒进行一次倒数，总共进行60次
    //TODO: 可以由外部设置倒数间隔
    this.counter = new MyCounter(times: 60, duration: 1000);

    ///设置计时器的回调
    this.counter.calling = () {
      ///若按钮已经被销毁，则不执行任何事情
      if (!this.button.isMounted()) return;
      this.button.text = this.counter.getRemain().toString();
      this.button.refresh();
      // if (this.counter.isStop()) {
      //   this.button.text = widget.repeatShowText;
      //   this.button.fontsize = 13;
      //   if (widget.emailField.isCorrect()) this.button.setDisabled(false);
      // }
    };
    this.counter.callingFinish = () {
      this.button.text = widget.repeatShowText;
      this.button.fontsize = 13;
      if (widget.emailField.isCorrect()) this.button.setDisabled(false);
    };

    super.initState();
  }

  @override
  void dispose() {
    if (this.counter != null) {
      this.counter.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Stack(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [this.getInput()]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [this.getButton()],
          )
        ],
      ),
    );
  }

  Widget getButton() {
    this.button = CustomButton(
        text: widget.firstShowText,
        fontsize: 20,
        width: widget.width,
        height: 50,
        radius: 8,
        disabled: true,
        sizeChangeMode: 2,
        tapFunc: () {
          this.verified = false;
          this.contentWhenClickButton = widget.emailField.getValue();
          this.button.fontsize = 20;
          this.button.setDisabled(true);
          this.button.setWidth(0.3 * widget.width);
          this.textField.setWidth(widget.width * 0.65);
          if (this.counter.isStop()) {
            this.counter.start();
          }
          ////////////zsk修改
          if (widget.getCodeType()) {
            this.sendSecurityCode(this.contentWhenClickButton);
          } else {
            this.sendEmail(this.contentWhenClickButton);
          }
        },
        isBold: true);
    return this.button;
  }

  Widget getInput() {
    this.textField = CustomTextField(
      placeholder: widget.placeHolder,
      isAutoChangeState: false,
      inputType: InputFieldType.verifyCode,
      width: 0,
      sizeChangeMode: 0,
      onCorrect: () async {
        String emailVal = widget.emailField.getValue();
        if (emailVal != this.contentWhenClickButton) {
          this.textField.setError();
          this.button.setDisabled(true);
          this.textField.setErrorText("verify code invalid");
          return;
        }
        if (this.verified) return;
        String codeVal = this.textField.getValue();
        this.checkVerifyCode(emailVal, codeVal);
        if (!this.counter.isStop()) return;
        this.button.setDisabled(false);
      },
    );
    return this.textField;
  }

  ///调用后台接口，检测验证码正确性
  ///参数 [emailVal] 邮箱地址
  ///参数 [codeVal]  用户输入的验证码
  ///
  Future<void> checkVerifyCode(String emailVal, String codeVal) async {
    try {
      Response res = await Requests.checkVerifyCode(
          context, {"email": emailVal, "auth_code": codeVal});
      if (res.data['code'] == 1) {
        widget.onCheckSuccess();
        this.textField.setCorrect();
        this.verified = true;
      } else {
        widget.onCheckFailed();
        this.textField.setError();
        this.textField.setErrorText(widget.checkWrongText);
      }
    } on DioError catch (e) {
      print("Exception when check verify code\n");
      print(e.toString());
    }
  }

  ///向邮箱中发送验证码
  Future<void> sendEmail(String emailVal) async {
    try {
      Response res =
          await Requests.sendRegisterEmail(context, {"email": emailVal});
    } on DioError catch (e) {
      print("Exception when sending email:\n");
      print(e.toString());
    }
  }

  //TODO: zsk 补充注释
  Future<void> sendSecurityCode(String emailVal) async {
    try {
      Response res =
          await Requests.sendSecurityCode(context, {"email": emailVal});
    } on DioError catch (e) {
      print("Exception when sending email:\n");
      print(e.toString());
    }
  }
}

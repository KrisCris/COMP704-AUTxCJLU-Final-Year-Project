import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/interface/Themeable.dart';

import 'CustomTextField.dart';

class VerifyCodeInputer extends StatefulWidget{
  @required CustomTextField emailField;
  Function onCheckSuccess;
  Function onCheckFailed;
  String firstShowText;
  String repeatShowText;
  String checkWrongText;
  String placeHolder;
  double width;

  VerifyCodeState state;

  VerifyCodeInputer({Key key, this.emailField, this.onCheckFailed,this.onCheckSuccess,
    this.firstShowText="Acquire Verify Code",this.repeatShowText="Acquire again",
    this.checkWrongText="Wrong verify code",this.placeHolder="input verify code",
    this.width = 0.7}):super(key:key);
  @override
  State<StatefulWidget> createState() {
    this.state = new VerifyCodeState();
    return this.state;
  }

  void setButtonDisabled(bool dis){
    this.state.button.setDisabled(dis);
  }
  void setError(){
    this.state.textField.setError();
  }
  void setCorrect(){
    this.state.textField.setCorrect();
  }
}

class VerifyCodeState extends State<VerifyCodeInputer>{
  String contentWhenClickButton;
  bool verified;
  CustomTextField textField;
  CustomButton  button;
  MyCounter counter;
  @override
  void initState() {
    this.counter = new MyCounter(times: 60, duration: 1000);
    this.counter.calling = () {
      if (!this.button.isMonted()) return;
      this.button.text = this.counter.getRemain().toString();
      this.button.refresh();
      if (this.counter.isStop()) {
        this.button.text = widget.repeatShowText;
        this.button.fontsize = 13;
        if (widget.emailField.isCorrect()) this.button.setDisabled(false);
      }
    };
    super.initState();
  }
  @override
  void dispose() {
    if(this.counter != null){
      this.counter.stop();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
            left: 0,
            child: this.getInput()
        ),
        Positioned(
            child: this.getButton()
        )

      ],
    );
  }

  Widget getButton(){
    this.button = CustomButton(
        text: widget.firstShowText,
        fontsize: 20,
        width: widget.width,
        height: 50,
        radius: 8,
        theme: MyTheme.blueStyle,
        disabled: true,
        sizeChangeMode: 2,
        tapFunc: ()async {
          this.verified = false;
          this.contentWhenClickButton = widget.emailField.getInput();
          this.button.fontsize = 20;
          this.button.setDisabled(true);
          this.button.setWidth(0.3*widget.width);
          this.textField.setWidth(0.65*widget.width);
          if (this.counter.isStop()) {
            this.counter.start();
          }
          this.sendEmail(this.contentWhenClickButton);
        },
        isBold: true);
    return this.button;
  }

  Widget getInput(){
    this.textField = CustomTextField(
      placeholder: widget.placeHolder,
      isAutoChangeState: false,
      inputType: InputFieldType.verifyCode,
      theme: MyTheme.blueStyle,
      width: 0,
      sizeChangeMode: 0,
      onCorrect: () async {
        String emailVal = widget.emailField.getInput();
        if (emailVal != this.contentWhenClickButton) {
          this.textField.setError();
          this.button.setDisabled(true);
          this.textField.setErrorText("verify code invalid");
          return;
        }
        if(this.verified)return;
        String codeVal = this.textField.getInput();
        this.checkVerifyCode(emailVal, codeVal);
        if (!this.counter.isStop()) return;
        this.button.setDisabled(false);
      },
    );
    return this.textField;
  }

  Future<void> checkVerifyCode(String emailVal, String codeVal) async {
    try{
      Response res = await Requests.checkVerifyCode({
        "email": emailVal,
        "auth_code": codeVal
      });
      if (res.data['code'] == -4) {
        widget.onCheckFailed();
        this.textField.setError();
        this.textField.setErrorText(widget.checkWrongText);
      } else {
        widget.onCheckSuccess();
        this.textField.setCorrect();
        this.verified = true;
      }
    }on DioError catch(e){
      print("Exception when check verify code\n");
      print(e.toString());
    }
  }

  Future<void> sendEmail(String emailVal) async {
    try{
      Response res = await Requests.sendRegisterEmail({
        "email": emailVal
      });
    } on DioError catch(e){
      print("Exception when sending email:\n");
      print(e.toString());
    }
  }
}
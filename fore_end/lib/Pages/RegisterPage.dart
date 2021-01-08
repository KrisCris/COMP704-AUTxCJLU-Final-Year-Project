
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/VerifyCodeInputer.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  CustomTextField emailTextField;
  VerifyCodeInputer verifyTextField;
  CustomTextField nicknameTextField;
  CustomTextField passwordTextField;
  CustomTextField confirmPasswordTextField;
  CustomButton nextButton;
  CustomButton backButton;
  String emailWhenClickButton = "";
  ScrollController scrollCtl;
  bool verified = false;
  int step = 0;

  bool nickNameDone = false;
  bool passwordDone = false;
  bool repasswordDone = false;

  @override
  Widget build(BuildContext context) {
    // this.counter = new MyCounter(times: 60, duration: 1000);
    this.scrollCtl = new ScrollController();

    // this.verifyTextField = CustomTextField(
    //   placeholder: 'Verify Code',
    //   autoChangeState: false,
    //   inputType: InputFieldType.verifyCode,
    //   theme: MyTheme.blueStyle,
    //   width: 0,
    //   sizeChangeMode: 0,
    //   onCorrect: () async {
    //     String emailVal = this.emailTextField.getInput();
    //     if (emailVal != this.emailWhenClickButton) {
    //       this.verifyTextField.setError();
    //       this.nextButton.setDisable(true);
    //       this.verifyTextField.setErrorText("verify code invalid");
    //       return;
    //     }
    //
    //     if(this.verified)return;
    //
    //     String codeVal = this.verifyTextField.getInput();
    //     try{
    //       Response res = await Requests.checkVerifyCode({
    //         "email": emailVal,
    //         "auth_code": codeVal
    //       });
    //       if (res.data['code'] == -4) {
    //         EasyLoading.showError("Verify failed",
    //             duration: Duration(milliseconds: 2000));
    //         this.nextButton.setDisable(true);
    //         this.verifyTextField.setError();
    //         this.verifyTextField.setErrorText("verify code wrong");
    //       } else {
    //         this.nextButton.setDisable(false);
    //         this.verifyTextField.setCorrect();
    //         this.verified = true;
    //       }
    //     }on DioError catch(e){
    //       print("Exception when check verify code\n");
    //       print(e.toString());
    //     }
    //     if (!this.counter.isStop()) return;
    //     this.verifyButton.setDisable(false);
    //   },
    // );

    this.emailTextField = CustomTextField(
      placeholder: 'Email',
      inputType: InputFieldType.email,
      theme: MyTheme.blueStyle,
      isAutoChangeState: false,
      errorText: "Wrong email address!",
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "Please input correct email!",
      maxlength: 30,
      onCorrect: () async {
        // if (!this.counter.isStop()) return;
        this.emailTextField.setHelpText("checking whether email has been registered...");
        Response res = await Requests.checkEmailRepeat({
          "email":this.emailTextField.getValue()
        });
        if(res.data['code'] == 1){
          this.verifyTextField.setButtonDisabled(false);
          this.emailTextField.setCorrect();
        }else{
          this.verifyTextField.setButtonDisabled(true);
          this.emailTextField.setErrorText("This Email has already been registered");
          this.emailTextField.setError();
        }
      },
      onError: () {
        this.emailTextField.setErrorText("please input correct email format");
        this.emailTextField.setError();
        this.verifyTextField.setButtonDisabled(true);
        this.nextButton.setDisabled(true);
      },
    );

    this.verifyTextField = VerifyCodeInputer(
      onCheckSuccess: (){ this.nextButton.setDisabled(false);},
      onCheckFailed: (){this.nextButton.setDisabled(true);},
      emailField: this.emailTextField,
    );

    this.confirmPasswordTextField = CustomTextField(
      placeholder: 'confirm password',
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      isAutoChangeState: false,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "re-enter the password",
      maxlength: 30,
      onCorrect: () {
        if (this.confirmPasswordTextField.getValue() ==
            this.passwordTextField.getValue()) {
          //correct
          this.repasswordDone = true;
          this.confirmPasswordTextField.setCorrect();
          if (this.passwordDone && this.nickNameDone && this.repasswordDone) {
            this.nextButton.setDisabled(false);
          }
        } else {
          this.repasswordDone = false;
          this.confirmPasswordTextField.setError();
          this.nextButton.setDisabled(true);
          this.confirmPasswordTextField.setErrorText("two password different");
        }
      },
      onError: () {
        this.repasswordDone = false;
        this.confirmPasswordTextField.setError();
        this.nextButton.setDisabled(true);
        this.confirmPasswordTextField.setErrorText("two password different");
      },
    );

    this.passwordTextField = CustomTextField(
      placeholder: 'password',
      next: this.confirmPasswordTextField.getFocusNode(),
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "At least 6 length, contain number \nand english characters",
      maxlength: 30,
      onCorrect: () {
        this.passwordDone = true;
        if (this.confirmPasswordTextField.getValue() !=
                this.passwordTextField.getValue() &&
            !this.confirmPasswordTextField.isEmpty()) {
          this.confirmPasswordTextField.setError();
          this.repasswordDone = false;
          this.nextButton.setDisabled(true);
        }
        if (this.passwordDone && this.nickNameDone && this.repasswordDone) {
          this.nextButton.setDisabled(false);
        }
      },
      onError: () {
        this.passwordDone = false;
        this.nextButton.setDisabled(true);
      },
    );

    this.nicknameTextField = CustomTextField(
      placeholder: 'Nick name',
      next: this.passwordTextField.getFocusNode(),
      inputType: InputFieldType.text,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "please input your nick name",
      maxlength: 30,
      onCorrect: () {
        this.nickNameDone = true;
        if (this.passwordDone && this.nickNameDone && this.repasswordDone) {
          this.nextButton.setDisabled(false);
        }
      },
      onError: () {
        this.nickNameDone = false;
        this.nextButton.setDisabled(true);
      },
      onEmpty: () {
        this.nickNameDone = false;
        this.nextButton.setDisabled(true);
      },
    );

    this.emailTextField.addListener(() {
      if (this.emailWhenClickButton.isEmpty) return;
      if (this.emailTextField.getValue() != this.emailWhenClickButton) {
        if (this.nextButton.isEnable()) {
          this.verifyTextField.setError();
        }
        this.nextButton.setDisabled(true);
      } else if (this.verified) {
        this.verifyTextField.setCorrect();
        this.nextButton.setDisabled(false);
      }
    });

    // this.verifyButton = CustomButton(
    //     text: "Acquire verify code",
    //     fontsize: 20,
    //     width: 0.7,
    //     height: 50,
    //     radius: 8,
    //     theme: MyTheme.blueStyle,
    //     firstReactState: ComponentReactState.disabled,
    //     sizeChangeMode: 2,
    //     tapFunc: () {},
    //     isBold: true);
    this.backButton = CustomButton(
      text: "Back",
      isBold: true,
      leftMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.20),
      theme: MyTheme.blueStyle,
      firstThemeState: ComponentThemeState.error,
      tapFunc: () {
        Navigator.pop(context);
      },
    );
    // verifyButton.tapFunc = () async {
    //   this.verified = false;
    //   this.emailWhenClickButton = this.emailTextField.getInput();
    //   try{
    //     verifyButton.fontsize = 20;
    //     verifyButton.setDisable(true);
    //     verifyButton.setWidth(0.2);
    //     verifyTextField.setWidth(0.45);
    //     if (this.counter.isStop()) {
    //       this.counter.start();
    //     }
    //     Response res = await Requests.sendRegisterEmail({
    //       "email": this.emailWhenClickButton
    //     });
    //   } on DioError catch(e){
    //     print("Exception when sending email:\n");
    //     print(e.toString());
    //   }
    // };

    // this.counter.calling = () {
    //   if (!verifyButton.isMonted()) return;
    //   verifyButton.text = this.counter.getRemain().toString();
    //   verifyButton.refresh();
    //   if (this.counter.isStop()) {
    //     verifyButton.text = "Acquire\nagain";
    //     verifyButton.fontsize = 13;
    //     if (this.emailTextField.isCorrect()) verifyButton.setDisable(false);
    //   }
    // };

    this.nextButton = CustomButton(
      disabled: true,
      text: "Next",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.20),
      theme: MyTheme.blueStyle,
    );

    nextButton.tapFunc = () async {
      if (this.step == 0) {
        this.scrollCtl.animateTo(ScreenTool.partOfScreenWidth(1),
            duration: Duration(milliseconds: 800), curve: Curves.ease);
        this.step = 1;
        nextButton.setDisabled(true);
      } else if (this.step == 1) {
        this.nextButton.setDisabled(true);
        EasyLoading.showToast("Waiting for register...");
        try{
          Response res = await Requests.signUp({
            "email": this.emailWhenClickButton,
            "password": this.passwordTextField.getValue(),
            "nickname": this.nicknameTextField.getValue()
          });
          if (res.data['code'] == 1) {
            EasyLoading.showSuccess("Register success!",
                duration: Duration(milliseconds: 500));
            Navigator.pop(context);
          }
        } on DioError catch(e){
          this.nextButton.setDisabled(false);
          print("Exception when sign up\n");
          print(e.toString());
        }
      }
    };

    Widget emailPart = Container(
        width: ScreenTool.partOfScreenWidth(1),
        child: KeyboardAvoider(
            autoScroll: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, //水平居中
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10),
                SizedBox(height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenTool.partOfScreenWidth(0.7),
                      child: this.emailTextField,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                    )
                  ],
                ),
                Container(
                  width: ScreenTool.partOfScreenWidth(0.7),
                  height: ScreenTool.partOfScreenHeight(0.1),
                  child: this.verifyTextField
                ),
                SizedBox(height: 20),
                SizedBox(height: 1),
                SizedBox(height: 1),
              ],
            )));
    Widget passwordPart = Container(
        width: ScreenTool.partOfScreenWidth(1),
        child: KeyboardAvoider(
            autoScroll: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 15),
                this.nicknameTextField,
                SizedBox(height: 15),
                this.passwordTextField,
                this.confirmPasswordTextField,
                SizedBox(height: 1),
                SizedBox(height: 1),
                SizedBox(height: 15),
              ],
            )));
    Widget listScrool = Flexible(
        child: ListView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: this.scrollCtl,
      children: [emailPart, passwordPart],
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackGround(
          sigmaY: 15,
          sigmaX: 15,
          color: Colors.white,
          opacity: 0.79,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 40),
                Container(
                  width: ScreenTool.partOfScreenWidth(0.7),
                  child: Text(
                    "Create your\nAccount",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: "Futura",
                        color: Colors.black),
                  ),
                ),
                listScrool,
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      this.backButton,
                      Expanded(child: Text("")),
                      this.nextButton
                    ]),
              ])),
    );
  }
}

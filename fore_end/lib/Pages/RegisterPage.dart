
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/VerifyCodeInputer.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import 'GuidePage.dart';
import 'WelcomePage.dart';

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

    this.emailTextField = CustomTextField(
      placeholder: 'Email',
      inputType: InputFieldType.email,
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
      String contentWhenClickButton = this.verifyTextField.getContentWhenClickButton();
      if (contentWhenClickButton == null||contentWhenClickButton.isEmpty) return;

      if (this.emailTextField.getValue() != emailWhenClickButton) {
        if (this.nextButton.isEnable()) {
          this.verifyTextField.setError();
        }
        this.nextButton.setDisabled(true);
      } else if (this.verified) {
        this.verifyTextField.setCorrect();
        this.nextButton.setDisabled(false);
      }
    });
    this.backButton = CustomButton(
      text: "Back",
      isBold: true,
      leftMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.20),
      firstColorName: ThemeColorName.Error,
      tapFunc: () {
        Navigator.pop(context);
      },
    );

    this.nextButton = CustomButton(
      disabled: true,
      text: "Next",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.20),
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
            "email": this.verifyTextField.getContentWhenClickButton(),
            "password": this.passwordTextField.getValue(),
            "nickname": this.nicknameTextField.getValue()
          });
          if (res.data['code'] == 1) {
            EasyLoading.showSuccess("Register success, login in...",
                duration: Duration(milliseconds: 1000));
            res = await Requests.login({
              "email":  this.verifyTextField.getContentWhenClickButton(),
              "password": this.passwordTextField.getValue()
            });
            if(res.data['code'] == 1){
              User u = User.getInstance();
              u.token = res.data['data']['token'];
              u.uid = res.data['data']['uid'];
              u.email = this.verifyTextField.getContentWhenClickButton();
              int code = await u.synchronize();
              if(code == 1){
                EasyLoading.dismiss();
                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context){
                  return new GuidePage();
                }),(ct)=>false);
              }else{
                EasyLoading.showError("Login token invalid",
                    duration: Duration(milliseconds: 2000));
                Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context){
                  return new Welcome();
                }),(ct)=>false);
              }
            }
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
      body: Container(
          color: MyTheme.convert(ThemeColorName.PageBackground),
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
                        color: MyTheme.convert(ThemeColorName.HeaderText)),
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

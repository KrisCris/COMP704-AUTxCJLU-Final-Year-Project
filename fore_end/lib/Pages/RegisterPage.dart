import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyCounter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/formatChecker.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(Register());
}

class Register extends StatelessWidget {
  MyTextField emailTextField;
  MyTextField verifyTextField;
  MyTextField nicknameTextField;
  MyTextField passwordTextField;
  MyTextField confirmPasswordTextField;
  MyButton verifyButton;
  MyCounter counter;
  MyButton nextButton;
  String emailWhenClickButton = "";
  ScrollController scrollCtl;
  bool verified = false;
  int step = 0;

  bool nickNameDone = false;
  bool passwordDone = false;
  bool repasswordDone = false;

  @override
  Widget build(BuildContext context) {
    this.counter = new MyCounter(times: 60, duration: 1000);
    this.scrollCtl = new ScrollController();

    this.verifyTextField = MyTextField(
      placeholder: 'Verify Code',
      autoChangeState: false,
      inputType: InputFieldType.verifyCode,
      theme: MyTheme.blueStyle,
      width: 0,
      sizeChangeMode: 0,
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      maxlength: null,
      onCorrect: () {
        String emailVal = this.emailTextField.getInput();
        if (emailVal != this.emailWhenClickButton) {
          this.verifyTextField.setError();
          this.nextButton.setDisable(true);
          this.verifyTextField.setErrorText("verify code invalid");
          return;
        }

        String codeVal = this.verifyTextField.getInput();
        http.post(Constants.REQUEST_URL + "/user/check_code",
            body: {"email": emailVal, "auth_code": codeVal}).then((value) {
          var res = jsonDecode(value.body);
          if (res['code'] == -4) {
            EasyLoading.showError("Verify failed",
                duration: Duration(milliseconds: 2000));
            this.nextButton.setDisable(true);
            this.verifyTextField.setError();
            this.verifyTextField.setErrorText("verify code wrong");
          } else {
            this.nextButton.setDisable(false);
            this.verifyTextField.setCorrect();
            this.verified = true;
          }
        });
        if (!this.counter.isStop()) return;
        this.verifyButton.setDisable(false);
      },
    );

    this.emailTextField = MyTextField(
      placeholder: 'Email',
      next: this.verifyTextField.getFocusNode(),
      inputType: InputFieldType.email,
      theme: MyTheme.blueStyle,
      errorText: "Wrong email address!",
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "Please input correct email!",
      maxlength: 30,
      onCorrect: () {
        if (!this.counter.isStop()) return;
        this.verifyButton.setDisable(false);
      },
      onError: () {
        this.verifyButton.setDisable(true);
        this.nextButton.setDisable(true);
      },
    );

    this.confirmPasswordTextField = MyTextField(
      placeholder: 'confirm password',
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      autoChangeState: false,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "re-enter the password",
      maxlength: 30,
      onCorrect: () {
        if (this.confirmPasswordTextField.getInput() ==
            this.passwordTextField.getInput()) {
          //correct
          this.repasswordDone = true;
          this.confirmPasswordTextField.setCorrect();
          if (this.passwordDone && this.nickNameDone && this.repasswordDone) {
            this.nextButton.setDisable(false);
          }
        } else {
          this.repasswordDone = false;
          this.confirmPasswordTextField.setError();
          this.nextButton.setDisable(true);
          this.confirmPasswordTextField.setErrorText("two password different");
        }
      },
      onError: () {
        this.repasswordDone = false;
        this.confirmPasswordTextField.setError();
        this.nextButton.setDisable(true);
        this.confirmPasswordTextField.setErrorText("two password different");
      },
    );

    this.passwordTextField = MyTextField(
      placeholder: 'password',
      next: this.confirmPasswordTextField.getFocusNode(),
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "At least 6 length, contain number \nand english characters",
      maxlength: 30,
      onCorrect: () {
        this.passwordDone = true;
        if (this.confirmPasswordTextField.getInput() !=
                this.passwordTextField.getInput() &&
            !this.confirmPasswordTextField.isEmpty()) {
          this.confirmPasswordTextField.setError();
          this.repasswordDone = false;
          this.nextButton.setDisable(true);
        }
        if (this.passwordDone && this.nickNameDone && this.repasswordDone) {
          this.nextButton.setDisable(false);
        }
      },
      onError: () {
        this.passwordDone = false;
        this.nextButton.setDisable(true);
      },
    );

    this.nicknameTextField = MyTextField(
      placeholder: 'Nick name',
      next: this.passwordTextField.getFocusNode(),
      inputType: InputFieldType.text,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "please input your nick name",
      maxlength: 30,
      onCorrect: () {
        this.nickNameDone = true;
        if (this.passwordDone && this.nickNameDone && this.repasswordDone) {
          this.nextButton.setDisable(false);
        }
      },
      onError: () {
        this.nickNameDone = false;
        this.nextButton.setDisable(true);
      },
      onEmpty: () {
        this.nickNameDone = false;
        this.nextButton.setDisable(true);
      },
    );

    this.emailTextField.addListener(() {
      if (this.emailWhenClickButton == null) return;
      if (this.emailTextField.getInput() != this.emailWhenClickButton) {
        if (this.nextButton.isEnable()) {
          this.verifyTextField.setError();
          this.verifyTextField.setErrorText("verify code invalid");
        }
        this.nextButton.setDisable(true);
      } else if (this.verified) {
        this.verifyTextField.setCorrect();
        this.nextButton.setDisable(false);
      }
    });

    this.verifyButton = MyButton(
        text: "Acquire verify code",
        fontsize: 20,
        width: 0.7,
        height: 50,
        radius: 8,
        theme: MyTheme.blueStyle,
        firstReactState: ComponentReactState.disabled,
        sizeChangeMode: 2,
        tapFunc: () {},
        isBold: true);

    verifyButton.tapFunc = () {
      Fluttertoast.showToast(
          msg: "Sending",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      this.verified = false;
      this.emailWhenClickButton = this.emailTextField.getInput();
      http.post(Constants.REQUEST_URL + "/user/send_code",
          body: {"email": this.emailWhenClickButton}).then((value) {
        var res = jsonDecode(value.body);
        switch (res['code']) {
          case 1:
            verifyButton.fontsize = 20;
            verifyButton.setDisable(true);
            verifyButton.setWidth(0.2);
            verifyTextField.setWidth(0.45);
            if (this.counter.isStop()) {
              this.counter.start();
            }
            print(res['code']);
            break;
          case -3:
            Fluttertoast.cancel();
            Fluttertoast.showToast(
                msg: res['msg'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Color(0xFFFF6060),
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0
            );
            // EasyLoading.showError(
            //     res['msg'],
            //     duration: Duration(microseconds: 200000));
            print(res['code']);
            print(res['msg']);
            break;
          case -5:
            Fluttertoast.cancel();
            Fluttertoast.showToast(
                msg: res['msg'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Color(0xFFFF6060),
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0
            );
            // EasyLoading.showError(
            //     res['msg'],
            //     duration: Duration(milliseconds: 2000));
            print(res['code']);
            print(res['msg']);
            break;
        }
        if (res['code'] == -5) {}
      });
    };

    this.counter.calling = () {
      if (verifyButton == null) return;
      verifyButton.text = this.counter.getRemain().toString();
      verifyButton.refresh();
      if (this.counter.isStop()) {
        verifyButton.text = "Acquire\nagain";
        verifyButton.fontsize = 13;
        if (this.emailTextField.isCorrect()) verifyButton.setDisable(false);
      }
    };

    this.nextButton = MyButton(
      firstReactState: ComponentReactState.disabled,
      text: "Next",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.20),
      theme: MyTheme.blueStyle,
    );

    nextButton.tapFunc = () {
      if (this.step == 0) {
        this.scrollCtl.animateTo(ScreenTool.partOfScreenWidth(1),
            duration: Duration(milliseconds: 800), curve: Curves.ease);
        this.step = 1;
        nextButton.setDisable(true);
      } else if (this.step == 1) {
        this.nextButton.setDisable(true);
        EasyLoading.showToast("Waiting for register...");
        http.post(Constants.REQUEST_URL + "/user/signup", body: {
          "email": this.emailWhenClickButton,
          "password": this.passwordTextField.getInput(),
          "nickname": this.nicknameTextField.getInput()
        }).then((value) {
          var res = jsonDecode(value.body);
          print(res.toString());
          if (res['code'] == 1) {
            EasyLoading.showSuccess("Register success!",
                duration: Duration(milliseconds: 500));
            Navigator.pop(context);
          }
        });
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        top: 8,
                        child: this.verifyTextField,
                      ),
                      Positioned(
                        child: verifyButton,
                      ),
                    ],
                  ),
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
                      MyButton(
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
                      ),
                      Expanded(child: Text("")),
                      this.nextButton
                    ]),
              ])),
    );
  }
}

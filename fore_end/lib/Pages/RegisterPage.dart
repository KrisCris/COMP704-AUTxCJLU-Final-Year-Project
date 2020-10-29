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

  @override
  Widget build(BuildContext context) {
    this.counter = new MyCounter(times: 60, duration: 1000);
    this.scrollCtl = new ScrollController();

    this.emailTextField = MyTextField(
      placeholder: 'Email',
      keyboardAction: TextInputAction.next,
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

    this.verifyTextField = MyTextField(
      placeholder: 'Verify Code',
      errorText: "asd",
      autoChangeState: false,
      inputType: InputFieldType.verifyCode,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.45),
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

    this.nicknameTextField = MyTextField(
      placeholder: 'Nick name',
      keyboardAction: TextInputAction.next,
      inputType: InputFieldType.text,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "please input your nick name",
      maxlength: 30,
    );
    this.passwordTextField = MyTextField(
      placeholder: 'password',
      keyboardAction: TextInputAction.next,
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "At least 6 length, contain number and english characters",
      maxlength: 30,
    );
    this.confirmPasswordTextField = MyTextField(
      placeholder: 'confirm password',
      keyboardAction: TextInputAction.go,
      inputType: InputFieldType.password,
      errorText: "two password different",
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      helpText: "re-enter the password",
      maxlength: 30,
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
      this.verified = false;
      this.emailWhenClickButton = this.emailTextField.getInput();
      verifyButton.fontsize = 20;
      verifyButton.setDisable(true);
      verifyButton.setWidth(0.2);
      if (this.counter.isStop()) {
        this.counter.start();
      }
      http.post(Constants.REQUEST_URL + "/user/send_code",
          body: {"email": this.emailWhenClickButton}).then((value) {
        var res = jsonDecode(value.body);
        if (res['code'] == -5) {
          EasyLoading.showError("Email send failed",
              duration: Duration(milliseconds: 2000));
        }
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
      firstReactState: ComponentReactState.able,
      text: "Next",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.20),
      theme: MyTheme.blueStyle,
    );

    nextButton.tapFunc = () {
     this.scrollCtl.animateTo(
         ScreenTool.partOfScreenWidth(1),
         duration: Duration(milliseconds: 800),
         curve: Curves.ease);
    };

    Widget emailPart = Container(
        width: ScreenTool.partOfScreenWidth(1),
        child:KeyboardAvoider(
          autoScroll: true,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center, //水平居中
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 80),
              Container(
                width: ScreenTool.partOfScreenWidth(0.7),
                child: Text(
                  "Create your\nAccount with Email",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: "Futura",
                      color: Colors.black),
                ),
              ),
              SizedBox(height: ScreenTool.partOfScreenHeight(0.08)),
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
                decoration: BoxDecoration(),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
            ],
          )
        ));
    Widget passwordPart = Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: KeyboardAvoider(
        autoScroll: true,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 40),
            Container(
              width: ScreenTool.partOfScreenWidth(0.7),
              child: Text(
                "Sign your nickname \nand password",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: "Futura",
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 15),
            this.nicknameTextField,
            this.passwordTextField,
            this.confirmPasswordTextField,
            SizedBox(height: 40),
            SizedBox(height: 15),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
          ],
        )
      )
    );
    Widget listScrool = ListView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: this.scrollCtl,
      children: [
        emailPart,
        passwordPart
      ],
    );

    return Scaffold(
      body: BackGround(
          sigmaY: 15,
          sigmaX: 15,
          color: Colors.white,
          opacity: 0.79,
          child: listScrool
      ),
    );
  }
}

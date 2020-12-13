
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/LocalDataManager.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/Pages/MainPage.dart';
import 'package:fore_end/interface/Themeable.dart';

class Login extends StatelessWidget {
  MyButton backButton;
  MyButton nextButton;
  MyTextField emailField;
  MyTextField passwordField;
  bool emailIsInput = false;
  bool passwordIsInput = false;

  @override
  Widget build(BuildContext context) {
    this.backButton = MyButton(
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

    this.nextButton = MyButton(
      text: "Next",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      theme: MyTheme.blueStyle,
      firstReactState: ComponentReactState.disabled,
      width: ScreenTool.partOfScreenWidth(0.20),
      tapFunc: () async {
        EasyLoading.show(status: "Logining...");
        this.nextButton.setDisable(true);
        String emailVal = this.emailField.getInput();
        String passwordVal = this.passwordField.getInput();
        this.login(emailVal, passwordVal, context);
      },
    );
    this.emailField = MyTextField(
      placeholder: "Email address",
      // keyboardAction: TextInputAction.next,
      theme: MyTheme.blueStyle,
      inputType: InputFieldType.email,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      onCorrect: () {
        emailIsInput = true;
        if (passwordIsInput) this.nextButton.setDisable(false);
      },
      onError: () {
        emailIsInput = false;
        this.nextButton.setDisable(true);
      },
    );

    this.passwordField = MyTextField(
      placeholder: "Password",
      theme: MyTheme.blueStyle,
      inputType: InputFieldType.password,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      onCorrect: () {
        passwordIsInput = true;
        if (emailIsInput) this.nextButton.setDisable(false);
      },
      onError: () {
        passwordIsInput = false;
        this.nextButton.setDisable(true);
      },
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BackGround(
          sigmaX: 15,
          sigmaY: 15,
          opacity: 0.79,
          backgroundImage: "image/fruit-main.jpg",
          color: Colors.white,
          child: this.LoginUI)
    );
  }

  Widget get LoginUI {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: ScreenTool.partOfScreenHeight(0.1)),
          Container(
            width: ScreenTool.partOfScreenWidth(0.7),
            child: Text("Login your \naccount",
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Futura",
                    color: Colors.black)),
          ),
          SizedBox(height: ScreenTool.partOfScreenHeight(0.08)),
          this.emailField,
          SizedBox(height: 20),
          this.passwordField,
          SizedBox(
            height: ScreenTool.partOfScreenHeight(0.3),
          ),
          this.bottomUI,
        ]);
  }

  Widget get bottomUI {
    return Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      this.backButton,
      Expanded(child: Text("")),
      this.nextButton,
      //this.nextButton,
    ]));
  }

  void login(String email, String pass, BuildContext context) async{
    try{
      Response res = await Requests.login({
        "email": email,
        "password": pass
      });
      if (res.data['code'] == -2) {
        EasyLoading.showError("Email or password wrong",
            duration: Duration(milliseconds: 2000));
        this.
        passwordField.clearInput();
      } else if (res.data['code'] == 1) {
        User u = new User(
          token: res.data['data']['token'],
          uid:res.data['data']['uid'],
          email: email,
        );
        Requests.getBasicInfo({
          'uid':u.uid,
          'token':u.token
        }).then((value){
          if(value.data['code'] == 1){
            u.userName =value.data['data']['nickname'];
            u.avatar_remote = value.data['data']['avatar'];
            u.age = value.data['data']['age'];
            u.gender = value.data['data']['gender'];
            u.save();
            Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (context){
              return new MainPage(user:u);
            }),(ct)=>false);
          }else if(value.data['code'] == -1){
            EasyLoading.showError("Login token invalid",
                duration: Duration(milliseconds: 2000));
          }
        });
      }
    }on DioError catch(e){
      print("Exception when login\n");
      print(e.toString());
    }
  }
}

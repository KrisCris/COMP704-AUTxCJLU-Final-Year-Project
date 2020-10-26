
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/background.dart';
import 'package:fore_end/Mycomponents/myButton.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/interface/Themeable.dart';
import 'package:http/http.dart' as http;

class Login extends StatelessWidget {
  MyButton backButton;
  MyButton nextButton;
  MyTextField emailField;
  MyTextField passwordField;

  bool emailIsInput;
  bool passwordIsInput;

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
      tapFunc: (){
        String emailVal = this.emailField.getInput();
        String passwordVal = this.passwordField.getInput();
        http.post(Constants.REQUEST_URL+"/user/login",
          body:{
            "email":emailVal,
            "password":passwordVal
          }).then((value){
            print(value.body.toString());
        });
      },
    );
    this.emailField = MyTextField(
      placeholder: "Email address",
      keyboardAction: TextInputAction.next,
      theme: MyTheme.blueStyle,
      inputType: InputFieldType.email,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      onCorrect: (){
        emailIsInput = true;
        if(passwordIsInput)this.nextButton.setDisable(false);
      },
      onError: (){
        emailIsInput = false;
        this.nextButton.setDisable(true);
      },
    );

    this.passwordField = MyTextField(
      placeholder: "Password",
      keyboardAction: TextInputAction.go,
      theme: MyTheme.blueStyle,
      inputType:InputFieldType.password,
      width: ScreenTool.partOfScreenWidth(0.7),
      ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
      ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
      onCorrect: (){
        passwordIsInput = true;
        if(emailIsInput)this.nextButton.setDisable(false);
      },
      onError: (){
        passwordIsInput = false;
        this.nextButton.setDisable(true);
      },
    );

    return Scaffold(
      resizeToAvoidBottomPadding:false,
      body: BackGround(
              sigmaX: 15,
              sigmaY: 15,
              opacity: 0.79,
              backgroundImage: "image/fruit-main.jpg",
              color: Colors.white,
              child: this.LoginUI),
    );
  }

  Widget get LoginUI {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height:ScreenTool.partOfScreenHeight(0.1)),
            Container(
              width: ScreenTool.partOfScreenWidth(0.7),
              child:Text("Login your \naccount",
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
            SizedBox(height: ScreenTool.partOfScreenHeight(0.3),),
            this.bottomUI,

        ]);
  }

  Widget get bottomUI {
    return Container(
      child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            this.backButton,
            Expanded(child: Text("")),
            this.nextButton,
            //this.nextButton,
          ])
    ) ;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/VerifyCodeInputer.dart';
import 'package:fore_end/interface/Themeable.dart';

import 'AccountPage.dart';

class UpdatePwdPage extends StatefulWidget {
  @override
  UpdatePasswordPageState createState() => UpdatePasswordPageState();
}


class UpdatePasswordPageState extends State<UpdatePwdPage> {
  // FocusNode focusNode = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController pwdOneController = TextEditingController();
  TextEditingController pwdTwoController = TextEditingController();

  CustomButton saveButton;
  CustomTextField emailTextField;
  CustomTextField pwdOneTextField;
  CustomTextField pwdTwoTextField;
  CustomTextField oldPasswordTextField;
  VerifyCodeInputer verifyTextField;

  bool verifySuccess= false;
  bool oldPasswordDone=false;
  bool passwordDone = false;
  bool repasswordDone = false;
  String currentPassword;
  CustomButton nextButton;
  CustomButton backButton;


  @override
  void initState() {
    super.initState();
    // emailController.addListener(_verify);
  }

  void _verify() {
    // String email = emailController.text;
  }

    Future<void> _confirm() async {

  }

  @override
  Widget build(BuildContext context) {

    this.saveButton= CustomButton(
      theme: MyTheme.blueStyle,
      text: "SAVE",
      width: 100,
      height: 40,
    );

    this.emailTextField=CustomTextField(
      placeholder: 'Email',
      inputType: InputFieldType.email,
      theme: MyTheme.blueStyle,
      // autoChangeState: false,
      errorText: "Wrong email address!",
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "Please input correct email!",
      maxlength: 30,
      onCorrect: () async {
        // if (!this.counter.isStop()) return;
        this.emailTextField.setHelpText("checking whether email has been registered...");
        Response res = await Requests.checkEmailRepeat({
          "email":this.emailTextField.getInput()
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
        // this.nextButton.setDisable(true);
      },
    );


    this.oldPasswordTextField= CustomTextField(

      placeholder: 'Old password',
      // next: pwdTwoTextField.getFocusNode(),
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "At least 7 length",
      maxlength: 30,
      onCorrect: (){
        this.oldPasswordDone=true;
      },


    );

    this.verifyTextField = VerifyCodeInputer(
      onCheckSuccess: (){ this.nextButton.setDisable(false); this.verifySuccess=true;},
      onCheckFailed: (){this.nextButton.setDisable(true);},
      emailField: this.emailTextField,
    );

    this.pwdOneTextField=CustomTextField(
      placeholder: 'New password',
      // next: pwdTwoTextField.getFocusNode(),
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "At least 7 length",
      maxlength: 30,

      onCorrect: () {
        this.passwordDone = true;
        if (this.pwdTwoTextField.getInput() !=
            this.pwdOneTextField.getInput() &&
            !this.pwdTwoTextField.isEmpty()) {
          this.pwdTwoTextField.setError();
          this.repasswordDone = false;
          this.nextButton.setDisable(true);
        }
        if (this.passwordDone && this.repasswordDone&&this.verifySuccess&&this.oldPasswordDone) {
          this.nextButton.setDisable(false);
        }
      },
      onError: () {
        this.passwordDone = false;
        this.nextButton.setDisable(true);
      },
    );

    this.pwdTwoTextField=CustomTextField(
      placeholder: 'Confirm password',
      helpText: "re-enter the password",
      // next: this.confirmPasswordTextField.getFocusNode(),
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      isAutoChangeState: false,
      width: ScreenTool.partOfScreenWidth(0.7),

      maxlength: 30,
      onCorrect: () {
        if (this.pwdTwoTextField.getInput() ==
            this.pwdOneTextField.getInput()) {
          //correct
          this.repasswordDone = true;
          this.pwdTwoTextField.setCorrect();
          if (this.passwordDone  && this.repasswordDone&&this.verifySuccess&this.oldPasswordDone) {
            this.nextButton.setDisable(false);
          }
        } else {
          this.repasswordDone = false;
          this.pwdTwoTextField.setError();
          this.nextButton.setDisable(true);
          this.pwdTwoTextField.setErrorText("two password different");  //bug有一个就是如果先输入pwdTwo的密码再输入pwdOne会显示不一样，就是这个验证的顺序问题，回头可能要改
        }
      },
      onError: () {
        this.repasswordDone = false;
        this.pwdTwoTextField.setError();
        this.nextButton.setDisable(true);
        this.pwdTwoTextField.setErrorText("two password different");
      },

    );



    this.backButton = CustomButton(
      firstReactState: ComponentReactState.able,
      text: "Back",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.3),
      theme: MyTheme.blueStyle,
      tapFunc: (){
        Navigator.pop(context);
      },
    );

    this.nextButton = CustomButton(
      firstReactState: ComponentReactState.disabled,
      text: "Save",
      isBold: true,
      rightMargin: 20,
      bottomMargin: 20,
      width: ScreenTool.partOfScreenWidth(0.3),
      theme: MyTheme.blueStyle,
    );

    nextButton.tapFunc = () async {
      User user= User.getInstance();
      String oldPassword=oldPasswordTextField.getInput();
      String newPassword=pwdTwoTextField.getInput();

      try{
        Response res = await Requests.modifyBasicInfo({
          "uid": user.uid,
          "token": user.token,
          "password": oldPassword,
          "new_password": newPassword,

        });
        if (res.data['code'] == 1) {
          EasyLoading.showSuccess("Change success!",
              duration: Duration(milliseconds: 2000));
        }
      } on DioError catch(e){
        print("Exception when change password\n");
        print(e.toString());
      }

      Navigator.pop(context);
    };




    return FlutterEasyLoading(
      child: Scaffold(
        body: ListView(
            children: <Widget>[
              Container(
              // margin: EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(60,20,10,10),
              child: Text(
                "Change login PASSWORD",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: "Futura",
                ),
                ),
              ),

              SizedBox( height:  20,),

              Container(
                decoration: BoxDecoration(
                    // border: Border.all(),
                  ),
                padding: EdgeInsets.fromLTRB(60, 1, 40, 10),
                child:this.emailTextField,
              ),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(20, 1, 1, 10),
                child:this.verifyTextField,
              ),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(60, 1, 40, 10),
                child:this.oldPasswordTextField,
              ),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(60, 1, 40, 10),
                child:this.pwdOneTextField,
              ),
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(60, 1, 40, 10),
                child:this.pwdTwoTextField,
              ),
              SizedBox(height: 30,),

              Container(
                decoration: BoxDecoration(
                  // border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(60, 1, 40, 10),
                child:Row(
                  children: [
                    this.backButton,
                    this.nextButton,
                  ],
                ),
              ),

            ],
          ),
        ),

    );
  }
}


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

class UpdatePwdPage extends StatefulWidget {
  @override
  UpdatePasswordPageState createState() => UpdatePasswordPageState();
}

class UpdatePasswordPageState extends State<UpdatePwdPage> {
  // FocusNode focusNode = new FocusNode();
  static const double leftRightGap = 0.1;

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

  bool verifySuccess = false;
  bool oldPasswordDone = false;
  bool passwordDone = false;
  bool repasswordDone = false;
  String currentPassword;
  CustomButton nextButton;
  CustomButton backButton;

  User user = User.getInstance();

  @override
  void initState() {
    super.initState();
    // emailController.addListener(_verify);
  }

  void _verify() {
    // String email = emailController.text;
  }

  Future<void> _confirm() async {}

  @override
  Widget build(BuildContext context) {
    this.saveButton = CustomButton(
      text: "SAVE",
      width: 100,
      height: 40,
    );

    this.emailTextField = CustomTextField(
      placeholder: 'Email',
      inputType: InputFieldType.email,
      // autoChangeState: false,
      errorText: "Wrong email address!",
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "Please input correct email!",
      maxlength: 30,
      onError: () {
        this.emailTextField.setErrorText("please input correct email format");
        this.emailTextField.setError();
        this.verifyTextField.setButtonDisabled(true);
        // this.nextButton.setDisable(true);
      },
    );

    this.emailTextField.onCorrect = () {
      if (this.emailTextField.getValue() == this.user.email) {
        this.verifyTextField.setButtonDisabled(false);
        this.emailTextField.setCorrect();
      }
    };

    this.oldPasswordTextField = CustomTextField(
      placeholder: 'Old password',
      // next: pwdTwoTextField.getFocusNode(),
      inputType: InputFieldType.password,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "At least 7 length",
      maxlength: 30,
      onCorrect: () {
        this.oldPasswordDone = true;
      },
    );

    this.verifyTextField = VerifyCodeInputer(
      transVerifyType: true,
      onCheckSuccess: () {
        this.nextButton.setDisabled(false);
        this.verifySuccess = true;
      },
      onCheckFailed: () {
        this.nextButton.setDisabled(true);
      },
      width: 1-leftRightGap*2,
      emailField: this.emailTextField,
    );

    this.pwdOneTextField = CustomTextField(
      placeholder: 'New password',
      // next: pwdTwoTextField.getFocusNode(),
      inputType: InputFieldType.password,
      width: ScreenTool.partOfScreenWidth(0.7),
      helpText: "At least 7 length",
      maxlength: 30,

      onCorrect: () {
        this.passwordDone = true;
        if (this.pwdTwoTextField.getValue() !=
                this.pwdOneTextField.getValue() &&
            !this.pwdTwoTextField.isEmpty()) {
          this.pwdTwoTextField.setError();
          this.repasswordDone = false;
          this.nextButton.setDisabled(true);
        }
        if (this.passwordDone &&
            this.repasswordDone &&
            this.verifySuccess &&
            this.oldPasswordDone) {
          this.nextButton.setDisabled(false);
        }
      },
      onError: () {
        this.passwordDone = false;
        this.nextButton.setDisabled(true);
      },
    );

    this.pwdTwoTextField = CustomTextField(
      placeholder: 'Confirm password',
      helpText: "re-enter the password",
      // next: this.confirmPasswordTextField.getFocusNode(),
      inputType: InputFieldType.password,
      isAutoChangeState: false,
      width: ScreenTool.partOfScreenWidth(0.7),

      maxlength: 30,
      onCorrect: () {
        if (this.pwdTwoTextField.getValue() ==
            this.pwdOneTextField.getValue()) {
          //correct
          this.repasswordDone = true;
          this.pwdTwoTextField.setCorrect();
          if (this.passwordDone &&
              this.repasswordDone &&
              this.verifySuccess & this.oldPasswordDone) {
            this.nextButton.setDisabled(false);
          }
        } else {
          this.repasswordDone = false;
          this.pwdTwoTextField.setError();
          this.nextButton.setDisabled(true);
          this.pwdTwoTextField.setErrorText(
              "two password different"); //bug有一个就是如果先输入pwdTwo的密码再输入pwdOne会显示不一样，就是这个验证的顺序问题，回头可能要改
        }
      },
      onError: () {
        this.repasswordDone = false;
        this.pwdTwoTextField.setError();
        this.nextButton.setDisabled(true);
        this.pwdTwoTextField.setErrorText("two password different");
      },
    );

    this.backButton = CustomButton(
      disabled: false,
      text: "Back",
      isBold: true,
      width: ScreenTool.partOfScreenWidth(0.3),
      tapFunc: () {
        Navigator.pop(context);
      },
    );

    this.nextButton = CustomButton(
      disabled: true,
      text: "Save",
      isBold: true,
      width: ScreenTool.partOfScreenWidth(0.3),
    );

    nextButton.tapFunc = () async {
      User user = User.getInstance();
      String oldPassword = oldPasswordTextField.getValue();
      String newPassword = pwdTwoTextField.getValue();
      print("目前的四个信息分别是： " +
          user.uid.toString() +
          "  " +
          user.token +
          "  " +
          oldPassword +
          "  " +
          newPassword);
      try {
        Response res = await Requests.modifyPassword({
          "uid": user.uid,
          "token": user.token,
          "password": oldPassword,
          "new_password": newPassword,
        });

        print("目前的四个信息分别是： " +
            user.uid.toString() +
            "  " +
            user.token +
            "  " +
            oldPassword +
            "  " +
            newPassword);

        if (res.data['code'] == 1) {
          print("密码修改成功!!!!!!!");
          EasyLoading.showSuccess("Change success!",
              duration: Duration(milliseconds: 2000));
        }
        if (res.data['code'] == -1) {
          print("Login Required");
        }
        if (res.data['code'] == -2) {
          print("Wrong Username or Password");
        }
        if (res.data['code'] == -4) {
          print("Code Expired");
        }
        if (res.data['code'] == -6) {
          print("User Not Exist");
        }
        if (res.data['code'] == -8) {
          print("Code Check Required");
        }
      } on DioError catch (e) {
        print("Exception when change password\n");
        print(e.toString());
      }

      // Navigator.pop(context);
    };

    return FlutterEasyLoading(
      child: Container(
        color: MyTheme.convert(ThemeColorName.PageBackground),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.15),
              margin: EdgeInsets.only(top: 35),
              child: Text(
                "Change Login PASSWORD",
                style: TextStyle(
                  color: MyTheme.convert(ThemeColorName.NormalText),
                  fontSize: 35,
                  fontFamily: "Futura",
                ),
              ),
            ),
            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.1),
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: this.emailTextField,
            ),

            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.07),
              // margin: EdgeInsets.only(top: 10,),

              // padding: EdgeInsets.only(top: 5),

              child: this.verifyTextField,
            ),

            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.1),
              margin: EdgeInsets.only(bottom: 10),
              child: this.oldPasswordTextField,
            ),

            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.1),
              margin: EdgeInsets.only(bottom: 10),
              child: this.pwdOneTextField,
            ),

            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.1),
              margin: EdgeInsets.only(bottom: 10),
              child: this.pwdTwoTextField,
            ),

            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.1),
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

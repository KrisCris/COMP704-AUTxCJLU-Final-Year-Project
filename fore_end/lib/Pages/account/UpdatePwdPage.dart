import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
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
  static const double componentWidth = 0.8;

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
      text: CustomLocalizations.of(context).save,
      width: 100,
      height: 40,
    );

    this.emailTextField = CustomTextField(
      placeholder: CustomLocalizations.of(context).email,
      inputType: InputFieldType.email,
      // autoChangeState: false,
      errorText: CustomLocalizations.of(context).wrongEmail,
      width: componentWidth,
      disableSuffix: true,
      helpText: CustomLocalizations.of(context).emailHint,
      maxlength: 30,
      onError: () {
        this
            .emailTextField
            .setErrorText(CustomLocalizations.of(context).emailHint + "!");
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
      placeholder: CustomLocalizations.of(context).oldPassword,
      // next: pwdTwoTextField.getFocusNode(),
      inputType: InputFieldType.password,
      width: componentWidth,
      helpText: CustomLocalizations.of(context).passwordHint,
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
      width: 1 - leftRightGap * 2,
      emailField: this.emailTextField,
    );

    this.pwdOneTextField = CustomTextField(
      placeholder: CustomLocalizations.of(context).newPassword,
      // next: pwdTwoTextField.getFocusNode(),
      inputType: InputFieldType.password,
      width: componentWidth,
      helpText: CustomLocalizations.of(context).passwordHint,
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
      placeholder: CustomLocalizations.of(context).confirmPassword,
      helpText: CustomLocalizations.of(context).confirmPasswordHint,
      // next: this.confirmPasswordTextField.getFocusNode(),
      inputType: InputFieldType.password,
      isAutoChangeState: false,
      width: componentWidth,

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
              CustomLocalizations.of(context).differentPasswordHint);
        }
      },
      onError: () {
        this.repasswordDone = false;
        this.pwdTwoTextField.setError();
        this.nextButton.setDisabled(true);
        this.pwdTwoTextField.setErrorText(
            CustomLocalizations.of(context).differentPasswordHint);
      },
    );

    this.backButton = CustomButton(
      disabled: false,
      text: CustomLocalizations.of(context).back,
      isBold: true,
      width: ScreenTool.partOfScreenWidth(0.3),
      tapFunc: () {
        Navigator.pop(context);
      },
    );

    this.nextButton = CustomButton(
      disabled: true,
      text: CustomLocalizations.of(context).save,
      isBold: true,
      width: ScreenTool.partOfScreenWidth(0.3),
    );

    nextButton.tapFunc = () async {
      User user = User.getInstance();
      String oldPassword = oldPasswordTextField.getValue();
      String newPassword = pwdTwoTextField.getValue();
      try {
        Response res = await Requests.modifyPassword(context, {
          "uid": user.uid,
          "token": user.token,
          "password": oldPassword,
          "new_password": newPassword,
        });

        if (res.data['code'] == 1) {
          EasyLoading.showSuccess(CustomLocalizations.of(context).changeSuccess,
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
                CustomLocalizations.of(context).changePasswordPageTitle,
                style: TextStyle(
                  color: MyTheme.convert(ThemeColorName.NormalText),
                  fontSize: 35,
                  fontFamily: "Futura",
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
                this.emailTextField,
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
                this.verifyTextField,
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
              ],
            ),
            Row(
              children: [
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
                this.oldPasswordTextField,
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
              ],
            ),
            Row(
              children: [
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
                this.pwdOneTextField,
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
              ],
            ),
            Row(
              children: [
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
                this.pwdTwoTextField,
                SizedBox(width: ScreenTool.partOfScreenWidth(leftRightGap)),
              ],
            ),
            Container(
              width: ScreenTool.partOfScreenWidth(0.8),
              height: ScreenTool.partOfScreenHeight(0.1),
              margin: EdgeInsets.only(top: 10, bottom: 10),
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

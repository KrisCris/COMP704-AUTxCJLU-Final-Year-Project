import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/VerifyCodeInputer.dart';

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
  CustomTextField pwdTextField;
  VerifyCodeInputer verifyTextField;


  @override
  void initState() {
    super.initState();
    // emailController.addListener(_verify);
  }

  void _verify() {
    // String email = emailController.text;
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
      autoChangeState: false,
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

    this.verifyTextField = VerifyCodeInputer(
      onCheckSuccess: (){ },
      onCheckFailed: (){},
      emailField: this.emailTextField,
    );

    this.pwdTextField=CustomTextField(
      placeholder: 'password',
      // next: this.confirmPasswordTextField.getFocusNode(),
      inputType: InputFieldType.password,
      theme: MyTheme.blueStyle,
      width: ScreenTool.partOfScreenWidth(0.7),
      // helpText: "At least 6 length, contain number \nand english characters",
      maxlength: 30,
    );


    return FlutterEasyLoading(
      child: Scaffold(
        body: ListView(
            children: <Widget>[
              Container(
              // margin: EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(ScreenTool.partOfScreenWidth(20),20,10,10),
              child: Text(
                "Change login PASSWORD",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: "Futura",
                ),

                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                padding: EdgeInsets.fromLTRB(20, 1, 1, 20),
                child:this.emailTextField,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(20, 1, 1, 20),
                child:this.verifyTextField,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                padding: EdgeInsets.fromLTRB(20, 1, 1, 20),
                child:this.pwdTextField,
              ),



              SizedBox(height: 30,),

              OutlineButton(
                borderSide: BorderSide.none,
                child: Text("Save",style: TextStyle(color: Colors.black54,fontSize: 30),),
              )
            ],
          ),
        ),

    );
  }
}

// TextField(
// controller: emailController,
// // maxLength: 16,
// keyboardType: TextInputType.number,
// decoration: new InputDecoration(
// prefixIcon: Icon(FontAwesomeIcons.envelope),
// labelText: "Email Address",
// labelStyle: TextStyle(color: Colors.blue),
// // helperText: "Please input your age",
// helperStyle: TextStyle(color: Colors.green),
//
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// borderSide: BorderSide(
// color: Colors.red,
// width: 2.0,
// ),
// ),
// enabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// borderSide: BorderSide(
// color: Colors.grey,
// width: 2.0,
// ),
// ),
// disabledBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// borderSide: BorderSide(
// color: Colors.red,
// width: 2.0,
// ),
// ),
// focusedBorder: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(10)),
// borderSide: BorderSide(
// color: Colors.blue,
// width: 2.0,
// ),
// ),
// )
// ),
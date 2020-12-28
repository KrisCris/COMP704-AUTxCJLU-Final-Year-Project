import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';

import 'SettingPage.dart';

///修改用户名
class UpdateUserNamePage extends StatefulWidget {
  @override
  _UpdateUserNamePageState createState() => _UpdateUserNamePageState();
}

class _UpdateUserNamePageState extends State<UpdateUserNamePage> {
  //定义一个controller
  FocusNode focusNode = new FocusNode();
  TextEditingController _userNameController = TextEditingController();
  bool _isClick = false;

  @override
  void initState() {
    super.initState();
    //监听输入改变
    _userNameController.addListener(_verify);
  }

  void _verify() {
    String userName = _userNameController.text;
    bool isClick = true;
    if (userName.isEmpty) {
      isClick = false;
    }
    if (isClick != _isClick) {
      setState(() {
        _isClick = isClick;
      });
    }
  }

  Future<void> _confirm() async {

    String newUsername=this._userNameController.text;
    User user= User.getInstance();
    // EasyLoading.showToast("Waiting for xxxx...");
    try{
      Response res = await Requests.modifyBasicInfo({
        "uid": user.uid,
        "token": user.token,
        "age": user.age,
        "gender": user.gender,
        "nickname": newUsername,
      });
      if (res.data['code'] == 1) {
        EasyLoading.showSuccess("Change success!",
            duration: Duration(milliseconds: 2000));
        user.userName=newUsername;
        user.save();
        print("修改成功！！！！");
      }
    } on DioError catch(e){
      print("Exception when sign up\n");
      print(e.toString());
    }


    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {return SettingPage();},
      maintainState: false,
    ));

  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
        child: Scaffold(
      appBar: AppBar(title: Text("Update Username")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 16.0, top: 20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SizedBox(
                width: 400,
                height: 130,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.all(10),
                  ///Alignment 用来对齐 Widget
                  alignment: Alignment(0, 0),
                    child: TextField(
                        controller: _userNameController,
                        maxLength: 16,
                        decoration: new InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.blue),
                          helperText: "Please input new username",
                          helperStyle: TextStyle(color: Colors.green),
                          prefixIcon: Icon(FontAwesomeIcons.user),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),


                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),

                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                        )
                    )
                )
              ),
            ),


            OutlineButton(
              onPressed: _isClick ? _confirm : null,
              child: Text("确认"),

            )
          ],
        ),
      ),
    ),
    );
  }
}

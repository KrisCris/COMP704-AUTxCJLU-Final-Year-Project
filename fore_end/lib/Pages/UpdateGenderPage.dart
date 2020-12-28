import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Picker_Tool.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'file:///E:/phpstudy_pro/WWW/Food-detection-based-mobile-diet-keeper/fore_end/lib/Mycomponents/inputs/CustomTextField.dart';

import 'SettingPage.dart';

///修改用户名
class UpdateGenderPage extends StatefulWidget {
  @override
  _UpdateGenderPageState createState() => _UpdateGenderPageState();
}

class _UpdateGenderPageState extends State<UpdateGenderPage> {

  bool _isClick = false;

  var gender=['Male','Female'];
  String _gendervalue;
  //this.widget.getUserGender(User.getInstance().gender);

  @override
  void initState() {
    super.initState();
  }

//如果改变后和本地一样会报错  因此要判断好
  // Failed assertion: line 4041 pos 12: '!_debugLocked': is not true.

  Future<void> _confirm() async {
    User user= User.getInstance();
    int newGender;
    print("现在的性别是"+_gendervalue);
    if(_gendervalue=="Male"){
      newGender=0;
    }else if(_gendervalue=="Female"){
      newGender=1;
    }
    try{
      Response res = await Requests.modifyBasicInfo({
        "uid": user.uid,
        "token": user.token,
        "age": user.age,
        "gender": newGender,
        "nickname": user.userName,
      });
      if (res.data['code'] == 1) {
        EasyLoading.showSuccess("Change success!",
            duration: Duration(milliseconds: 2000));
        user.gender=newGender;
        user.save();
        print("现在的本地性别数字是:"+newGender.toString());
        print("性别修改成功！！！！");
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
        appBar: AppBar(title: Text("Update Gender")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 16.0, top: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                child: InkWell(
                  onTap: () {
                    JhPickerTool.showStringPicker(context, title: 'Gender',data: gender, clickCallBack: (int index,var item) {
                      setState(() {
                        this._gendervalue=item;
                      });
                    }
                    );
                  },
                  child: SizedBox(
                      width: 400,
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            // margin: EdgeInsets.all(20),
                            child: Text(
                              "Please click to change your gender",
                              style: TextStyle(color: Colors.blue),

                            ),
                          ),


                          Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            ///Alignment 用来对齐 Widget
                            alignment: Alignment(0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(FontAwesomeIcons.transgender,size: 20,),
                                // Text("Gender"),
                                Text("Gender:   "+"${_gendervalue}"),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(width: 2,color: Colors.blue,)
                            ),

                          )

                        ],
                      ),

                  ),
                )

              ),

              OutlineButton(
                onPressed: _gendervalue!=null && _gendervalue!=this.getUserGender(User.getInstance().gender) ? _confirm : null,
                child: Text("确认"),

              )
            ],
          ),
        ),
      ),
    );
  }


  String getUserGender(int i){
    if(i==0){
      return "Male";
    }else{
      return "Female";
    }
  }

}

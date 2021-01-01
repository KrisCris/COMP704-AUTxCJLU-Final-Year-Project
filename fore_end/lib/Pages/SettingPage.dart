import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Picker_Tool.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/Pages/UpdateUsernamePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'UpdateAgePage.dart';
import 'UpdateGenderPage.dart';
import 'UpdatePwdPage.dart';

class SettingPage extends StatefulWidget {

  String username;
  String gender;
  String age;
  String email;
  File _iamge;
  String imageSource;
  User user= User.getInstance();
  var genderData=['Male','Female'];
  bool visible = true;
  PageState state;

  String getUserGender(int i){
    if(i==0){
      return "Male";
    }else{
      return "Female";
    }
  }

  int setGender(String gender){
    if(gender=="Male") return 0;
    else return 1;
  }



  Future<String> pictureToBase64(File f) async {
    Uint8List byteData = await f.readAsBytes();
    String bs64 = base64Encode(byteData);
    return bs64;
  }

  @override
  State<StatefulWidget> createState() {
    this.state=new PageState();
    return this.state;
  }

  void refreshPage(){
    this.state.setState(() {});
  }


}

class PageState extends State<SettingPage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: ListView(
            children: <Widget>[
              Container(
                // margin: EdgeInsets.all(20),
                margin: EdgeInsets.fromLTRB(ScreenTool.partOfScreenWidth(20),20,10,10),
                child: Text(
                  "ACCOUNT INFO",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: "Futura",
                  ),

                ),
              ),

            SizedBox(height: 10,),

            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Personal Information",
                style: TextStyle(color: Colors.blue),

              ),
            ),

            this.getAvatarItem(),

              SettingItem(
                leftIcon: Icon(FontAwesomeIcons.user),
                leftText: "Username",
                rightText: widget.user.userName,
                onTap: (){
                  //Dialog可以里面嵌套不同的widget，如果是输入框那么就可以满足需求了。
                  print("用户名");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return UpdateUserNamePage();
                  }));
                },
              ),


            this.getGenderItem(context),

            SettingItem(
              leftIcon: Icon(Icons.calendar_today),
              leftText: "Age",
              rightText: widget.user.age.toString(),
              onTap: (){
                //Dialog可以里面嵌套不同的widget，如果是输入框那么就可以满足需求了。
                print("年龄");
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                  return UpdateAgePage();
                }));
              },
            ),

            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Account Information",
                style: TextStyle(color: Colors.blue),

              ),
            ),

            SettingItem(
              leftIcon: Icon(FontAwesomeIcons.envelope),
              leftText: "Email",
              rightText: widget.user.email,
              isChange: false,
              onTap: (){
              },
            ),

            SettingItem(
              leftIcon: Icon(FontAwesomeIcons.key,size: 23,),
              leftText: "Password",
              rightText: "*******",
              isChange: true,
              onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                  return UpdatePwdPage();
                }));
              },
            ),


            OutlineButton(
              child: Text("Cancel changes"),
              onPressed: () {
                print(widget.user.userName);

              },
            ),

          ],
        )
    );
  }
  Widget getAvatarItem(){
    SettingItem item = SettingItem(
      leftIcon: Icon(FontAwesomeIcons.userCircle),
      leftText: "Profile Photo",
      isRightText: false,
      isRightImage: true,
    );
    item.onTap =  () async {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(image == null){
        return;
      }else {
        widget.imageSource = await widget.pictureToBase64(image);
        User.getInstance().avatar=widget.imageSource;
        User.getInstance().save();
        item.refresh();
      }
    };
    return item;
  }

  Widget getGenderItem(BuildContext context){
    SettingItem genderItem=SettingItem(
      leftIcon: Icon(FontAwesomeIcons.transgender),
      leftText: "Gender",
      rightText: widget.getUserGender(widget.user.gender),
    );

    genderItem.onTap= () {
      int newGender;
      JhPickerTool.showStringPicker(context, title: 'Gender',data: widget.genderData, clickCallBack: (int index,var item) {
        newGender=widget.setGender(item);
        print("newGender现在的值是"+newGender.toString());
        User.getInstance().gender=newGender;
        User.getInstance().save();
        print("执行到1步了,User的性别是："+User.getInstance().gender.toString());
      });

  };

    return genderItem;
}
}
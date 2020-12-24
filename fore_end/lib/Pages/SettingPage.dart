import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/Pages/UpdateUsernamePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'MainPage.dart';
import 'UpdateAgePage.dart';
import 'UpdateGenderPage.dart';

class SettingPage extends StatelessWidget {

  String username;
  String gender;
  String age;
  String email;
  User user= User.getInstance();



  bool visible = true;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting Page"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10,),

          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Personal Information",
              style: TextStyle(color: Colors.blue),

            ),
          ),

          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.userCircle),
            leftText: "Profile Photo",
            isRightText: false,
            isRightImage: true,
            onTap: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              if(image == null){
                print("没有成功获取相册里面的图片");
              }else print("成功获取到了相册里面的图片");

              if(image == null) return;
              String bs64 = await this.pictureToBase64(image);
              User.getInstance().avatar=bs64;
            },
          ),

          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.envelope),
            leftText: "Email",
            rightText: this.user.email,
            isChange: false,
            onTap: (){
            },
          ),

          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.user),
            leftText: "Username",
            rightText: this.user.userName,
            onTap: (){
              //Dialog可以里面嵌套不同的widget，如果是输入框那么就可以满足需求了。
              print("用户名");
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return UpdateUserNamePage();
              }));
            },
          ),

          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.transgender),
            leftText: "Gender",
            rightText: this.getUserGender(this.user.gender),
            onTap: (){
              print("性别");
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return UpdateGenderPage();
              }));
            },
          ),

          SettingItem(
            leftIcon: Icon(Icons.calendar_today),
            leftText: "Age",
            rightText: this.user.age.toString(),
            onTap: (){
              //Dialog可以里面嵌套不同的widget，如果是输入框那么就可以满足需求了。
              print("年龄");
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return UpdateAgePage();
              }));
            },
          ),

          OutlineButton(
            child: Text("Save changes"),
            onPressed: () {
              //把这个页面的信息保存一遍发给服务器，等ok了就可以返回主界面
              User.getInstance().save();
              print( User.getInstance().userName);
              // print("保存成功，返回上一页");
              // print(User.getInstance().avatar);

            },
          ),

          OutlineButton(
            child: Text("Cancel changes"),
            onPressed: () {

            },
          ),

        ],
      )
    );
  }

  String getUserGender(int i){
    if(i==0){
      return "Male";
    }else{
      return "Female";
    }
  }


  Future<String> pictureToBase64(File f) async {
    print("我pictureToBase64被调用了");
    Uint8List byteData = await f.readAsBytes();
    print("转换为byteData有问题");
    String bs64 = base64Encode(byteData);
    print("picture convert complete:\n"+bs64);
    return bs64;
  }

}




import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Picker_Tool.dart';
import 'package:fore_end/MyTool/Req.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/inputs/EditableArea.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'UpdatePwdPage.dart';

class AccountPage extends StatefulWidget {
  String username;
  String gender;
  String age;
  String email;
  String imageSource;
  User user = User.getInstance();
  var genderData = ['Male', 'Female'];
  bool visible = true;
  PageState state;


  String getUserGender(int i) {
    if (i == 0) {
      return "Male";
    } else {
      return "Female";
    }
  }

  int setGender(String gender) {
    if (gender == "Male")
      return 0;
    else
      return 1;
  }

  Future<String> pictureToBase64(File f) async {
    Uint8List byteData = await f.readAsBytes();
    String bs64 = base64Encode(byteData);
    return bs64;
  }

  @override
  State<StatefulWidget> createState() {
    this.state = new PageState();
    return this.state;
  }

  void refreshPage() {
    this.state.setState(() {});
  }
}

class PageState extends State<AccountPage> {
  EditableArea basicInfoEditableArea;


  @override
  Widget build(BuildContext context) {

    this.basicInfoEditableArea= EditableArea(
        theme: MyTheme.blueStyle,
        width: 0.7,
        height: 320,
        title: "Basic information",
        displayContent: [
          this.getAvatarItem(),
          this.getUserNameItem(),
          this.getGenderItem(context),
          this.getAgeItem(),
        ]
    );


    return Scaffold(
        body: ListView(
           children: <Widget>[
             //Account Page的最上面标题
         Container(
          // margin: EdgeInsets.all(20),
          margin:
              EdgeInsets.fromLTRB(ScreenTool.partOfScreenWidth(20), 20, 10, 10),
          child: Text(
            "ACCOUNT INFO",
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontFamily: "Futura",
            ),
          ),
        ),


          SizedBox(
          height: 10,
        ),

          EditableArea(
              theme: MyTheme.blueStyle,
              width: 0.7,
              height: 190,
              title: "Account information",
              displayContent: [
                this.getEmailItem(),
                this.getPwdItem(context),
              ]
          ),

             SizedBox(
               height: 10,
             ),

           this.basicInfoEditableArea,



             SizedBox(
          height: 10,
        ),

             OutlineButton(
               child: Text("Save Changes"),
               onPressed:  () async {
                 User user= User.getInstance();
                 List<String> basicInfo = new List<String>();
                 basicInfo= this.basicInfoEditableArea.getAllValue();
                 user.userName=basicInfo[0];
                 user.gender=widget.setGender(basicInfo[1]);
                 user.age=int.parse(basicInfo[2]);

                 try{
                   Response res = await Requests.modifyBasicInfo({
                     "uid": widget.user.uid,
                     "token": widget.user.token,
                     "age": widget.user.age.toString(),
                     "gender": widget.getUserGender(user.gender),
                     "nickname": widget.user.userName,
                   });
                   if (res.data['code'] == 1) {
                     EasyLoading.showSuccess("Change success!",
                         duration: Duration(milliseconds: 2000));

                     widget.user.save();

                   }
                 } on DioError catch(e){
                   print("Exception when sign up\n");
                   print(e.toString());
                 }
               },

             ),
             SizedBox(
               height: 10,
             ),

             OutlineButton(
                child: Text("Back MainPage"),
              onPressed: () {
                Navigator.pop(context);
          },
        ),
      ],
    ));
  }


  Widget getEmailItem(){
    SettingItem item =new SettingItem(
      leftIcon: Icon(FontAwesomeIcons.envelope),
      leftText: "Email",
      rightText: widget.user.email,
      isChange: false,
      isRightText: false,
      isRightUneditText: true,
      onTap: () {},
    );

    return item;
  }

  Widget getPwdItem(BuildContext context){
    SettingItem item = SettingItem(
      leftIcon: Icon(
        FontAwesomeIcons.key,
        size: 23,
      ),
      leftText: "Password",
      rightText: "*******",
      isChange: false,
      isRightText: false,
      isRightUneditText: true,
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UpdatePwdPage();}
            ));


      },
    );

    return item;
  }




  Widget getAvatarItem() {
    User u = User.getInstance();
    SettingItem item = SettingItem(
      leftIcon: Icon(FontAwesomeIcons.userCircle),
      leftText: "Profile Photo",
      isRightText: false,
      isRightImage: true,
      image: u.getAvatar(40, 40),
    );
    item.onTap = () async {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      } else {
        widget.imageSource = await widget.pictureToBase64(image);
        u.avatar = widget.imageSource;
        u.save();
        item.image = u.getAvatar(40, 40);
        item.refresh();
      }
    };
    return item;
  }

  Widget getGenderItem(BuildContext context) {
    SettingItem genderItem = SettingItem(
      leftIcon: Icon(FontAwesomeIcons.transgender),
      leftText: "Gender",
      isRightText: false,
      isRightUneditText: true,
      rightText: widget.getUserGender(widget.user.gender),
    );

    genderItem.onTap = () {
      print("click gender Item");
      User u = User.getInstance();
      int newGender;
      JhPickerTool.showStringPicker(context,
          title: 'Gender',
          normalIndex: u.gender,
          data: widget.genderData, clickCallBack: (int index, var item) {
        newGender = widget.setGender(item);
        print("newGender现在的值是" + newGender.toString());
        u.gender = newGender;
        u.save();

        genderItem.rightText = widget.getUserGender(u.gender);
        genderItem.refresh();
      });
    };

    return genderItem;
  }

  Widget getUserNameItem() {
    return SettingItem(
      leftIcon: Icon(FontAwesomeIcons.user),
      leftText: "Username",
      rightText: widget.user.userName,
      inputFieldWidth: 0.45,
    );
  }

  Widget getAgeItem() {
    return SettingItem(
      leftIcon: Icon(Icons.calendar_today),
      leftText: "Age",
      rightText: widget.user.age.toString(),
      inputFieldWidth: 0.45,
    );
  }
}

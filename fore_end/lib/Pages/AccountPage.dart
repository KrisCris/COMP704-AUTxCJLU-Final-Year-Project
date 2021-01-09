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
    } else if(i==1){
      return "Female";
    }
      return null;
  }

  int setGender(String gender) {
    if (gender == "Male")
      return 0;
    else if(gender== "Female")
      return 1;
    return null;
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
    this.basicInfoEditableArea = EditableArea(
        theme: MyTheme.blueStyle,
        width: 0.7,
        height: 320,
        title: "Basic information",
        displayContent: [
          this.getAvatarItem(),
          this.getUserNameItem(),
          this.getAgeItem(),
          this.getGenderItem(context),

        ]
    );

    this.basicInfoEditableArea.onEditComplete= () async {
      User user = User.getInstance();
      List<String> basicInfo = new List<String>();
      basicInfo = this.basicInfoEditableArea.getAllValue();
      try {
        Response res = await Requests.modifyBasicInfo({
          "uid": widget.user.uid,
          "token": widget.user.token,
          "age": int.parse(basicInfo[2]),
          "gender": widget.setGender(basicInfo[3]),
          "nickname": basicInfo[1],
        });
        if (res.data['code'] == 1) {
          EasyLoading.showSuccess("Change success!",
              duration: Duration(milliseconds: 4000));
          user.userName = basicInfo[1];
          user.age = int.parse(basicInfo[2]);
          user.gender = widget.setGender(basicInfo[3]);
          widget.user.save();
        }
      } on DioError catch (e) {
        print("Exception when sign up\n");
        print(e.toString());
      }
      // Navigator.pop(context);
    };


    return FlutterEasyLoading(
        child: Scaffold(
            body: ListView(
              children: <Widget>[
                //Account Page的最上面标题
                Container(
                  // margin: EdgeInsets.all(20),
                  margin:
                  EdgeInsets.fromLTRB(
                      ScreenTool.partOfScreenWidth(20), 20, 10, 10),
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
                  child: Text("Back MainPage"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
        )
    );
  }





  Widget getEmailItem(){
    SettingItem item =new SettingItem(
      leftIcon: Icon(FontAwesomeIcons.envelope),
      leftText: "Email",
      rightText: widget.user.email,
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
        item.imageBase64=widget.imageSource;
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
      User user = User.getInstance();
      int newGender;
      if(genderItem.rightText=="Female"){
        newGender=1;
      }else if(genderItem.rightText=="Male"){
        newGender=0;
      }

      JhPickerTool.showStringPicker(context,
          title: 'Gender',
          normalIndex: newGender,
          data: widget.genderData, clickCallBack: (int index, var item) {
        genderItem.rightText=item;
        if(item=="Male"){
          user.gender=0;
        }else if(item=="Female"){
          user.gender=1;
        }
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
      disabled: true,
    );
  }

  Widget getAgeItem() {
    return SettingItem(
      leftIcon: Icon(Icons.calendar_today),
      leftText: "Age",
      rightText: widget.user.age.toString(),
      inputFieldWidth: 0.45,
      disabled: true,
    );
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/Picker_Tool.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        // extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   toolbarHeight: 0,
        // ),
        body: ListView(
      children: <Widget>[
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
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            "Personal Information",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        this.getAvatarItem(),
        this.getGenderItem(context),
        EditableArea(
            theme: MyTheme.blueStyle,
            width: 0.7,
            height:200,
            title: "Basic information",
            displayContent: [
          this.getUserNameItem(),
          this.getAgeItem()
        ]),
        SizedBox(
          height: 10,
        ),
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
          onTap: () {},
        ),
        SettingItem(
          leftIcon: Icon(
            FontAwesomeIcons.key,
            size: 23,
          ),
          leftText: "Password",
          rightText: "*******",
          isChange: true,
          onTap: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
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
    ));
  }

  Widget getAvatarItem() {
    User u =  User.getInstance();
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
      rightText: widget.getUserGender(widget.user.gender),
    );

    genderItem.onTap = () {
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

  Widget getUserNameItem(){
    return SettingItem(
      leftIcon: Icon(FontAwesomeIcons.user),
      leftText: "Username",
      rightText: widget.user.userName,
      inputFieldWidth: 0.45,
    );

  }

  Widget getAgeItem(){
    return SettingItem(
      leftIcon: Icon(Icons.calendar_today),
      leftText: "Age",
      rightText: widget.user.age.toString(),
      inputFieldWidth: 0.45,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/Picker_Tool.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/inputs/EditableArea.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/Mycomponents/widgets/ValueableImage.dart';
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
  String imageSource = User.getInstance().avatar;
  User user = User.getInstance();
  var genderData = ['Male', 'Female',];
  bool visible = true;
  PageState state;

  //CustomLocalizations.of(context).detail,
  String getUserGender(int i) {
    if (i == 0) {
      return "Male";
    } else if (i == 1) {
      return "Female";
    }
    return null;
  }

  int setGender(String gender) {
    if (gender == "Male"|| gender == "男性")
      return 0;
    else if (gender == "Female"|| gender == "女性")
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
        width: 0.7,
        height: 320,
        title: CustomLocalizations.of(context).accountInformation,
        displayContent: [
          this.getAvatarItem(),
          this.getUserNameItem(),
          this.getAgeItem(),
          this.getGenderItem(context),
        ]);

    this.basicInfoEditableArea.onEditComplete = () async {
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
          "avatar": widget.imageSource,
        });
        if (res.data['code'] == 1) {
          EasyLoading.showSuccess(CustomLocalizations.of(context).changeSuccess,
              duration: Duration(milliseconds: 4000));
          user.userName = basicInfo[1];
          user.age = int.parse(basicInfo[2]);
          user.gender = widget.setGender(basicInfo[3]);
          user.avatar = widget.imageSource;
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
            body: Stack(
            children: [
              Container(
                width: ScreenTool.partOfScreenWidth(1),
                height: ScreenTool.partOfScreenHeight(1),
                color: MyTheme.convert(ThemeColorName.PageBackground),
              ),
              ListView(
                // padding: EdgeInsets.only(),
                children: <Widget>[
                  //Account Page的最上面标题
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      GestureDetector(
                        child: Icon(FontAwesomeIcons.arrowAltCircleLeft,size: 35,color: MyTheme.convert(ThemeColorName.NormalIcon),),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),

                      Container(
                        // margin: EdgeInsets.all(20),
                        margin: EdgeInsets.fromLTRB(20, 18, 10, 10),
                        child: Text(
                          CustomLocalizations.of(context).accountPageTitle,
                          style: TextStyle(
                            color: MyTheme.convert(ThemeColorName.HeaderText),
                            fontSize: 32,
                            fontFamily: "Futura",
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  EditableArea(
                      width: 0.7,
                      height: 190,
                      title: CustomLocalizations.of(context).accountInformation,
                      displayContent: [
                        this.getEmailItem(),
                        this.getPwdItem(context),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  this.basicInfoEditableArea,
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      
                    ],
                  )
                ],
              )
            ],
    )));
  }

  Widget getEmailItem() {
    SettingItem item = new SettingItem(
      leftIcon: Icon(FontAwesomeIcons.envelope,color: MyTheme.convert(ThemeColorName.NormalIcon),),
      leftText: CustomLocalizations.of(context).email,
      rightComponent: CustomTextButton(
        widget.user.email,
      ),
      disabled: true,
      canChangeDisabled: false,
    );

    return item;
  }

  Widget getPwdItem(BuildContext context) {
    SettingItem item = SettingItem(
      leftIcon: Icon(
        FontAwesomeIcons.key,
        color: MyTheme.convert(ThemeColorName.NormalIcon),
        size: 23,
      ),
      leftText: CustomLocalizations.of(context).password,
      disabled: false,
      canChangeDisabled: true,
      rightComponent: CustomTextButton(
        "******",
        ignoreTap: true,
        autoReturnColor: false,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return UpdatePwdPage();
        }));
      },
    );

    return item;
  }

  Widget getAvatarItem() {
    User u = User.getInstance();
    SettingItem item = SettingItem(
      leftIcon: Icon(FontAwesomeIcons.userCircle,color: MyTheme.convert(ThemeColorName.NormalIcon)),
      leftText: CustomLocalizations.of(context).profilePhoto,
      rightComponent: ValueableImage(
        base64: u.avatar,
        disabled: true,
        behavior: HitTestBehavior.translucent,
        ignoreTap: true,
      ),
      disabled: true,
    );
    item.onTap = () async {
      File image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      } else {
        widget.imageSource = await widget.pictureToBase64(image);
        u.avatar = widget.imageSource;
        item.setValue(u.avatar);
      }
    };

    return item;
  }

  Widget getGenderItem(BuildContext context) {
    SettingItem genderItem = SettingItem(
      leftIcon: Icon(FontAwesomeIcons.transgender,color: MyTheme.convert(ThemeColorName.NormalIcon)),
      leftText: CustomLocalizations.of(context).gender,
      disabled: true,
      rightComponent: CustomTextButton(
        widget.getUserGender(widget.user.gender),
        ignoreTap: true,
        autoReturnColor: false,
      ),
    );

    genderItem.onTap = () {
      User user = User.getInstance();
      int newGender;
      if (genderItem.getValue() == "Female" || genderItem.getValue() == "女性") {
        newGender = 1;
      } else if (genderItem.getValue() == "Male"|| genderItem.getValue() == "男性") {
        newGender = 0;
      }

      JhPickerTool.setInitialState();

      JhPickerTool.showStringPicker(context,
          title: CustomLocalizations.of(context).gender,
          normalIndex: newGender,
          data: widget.genderData, clickCallBack: (int index, var item) {
        genderItem.setValue(item);
        if (item == "Male") {
          user.gender = 0;
        } else if (item == "Female") {
          user.gender = 1;
        }
      });
    };

    return genderItem;
  }

  Widget getUserNameItem() {
    return SettingItem(
      leftIcon: Icon(FontAwesomeIcons.user,color: MyTheme.convert(ThemeColorName.NormalIcon)),
      leftText: CustomLocalizations.of(context).username,
      text: widget.user.userName,
      inputFieldWidth: 0.45,
      disabled: true,
    );
  }

  Widget getAgeItem() {
    return SettingItem(
      leftIcon: Icon(Icons.calendar_today,color: MyTheme.convert(ThemeColorName.NormalIcon)),
      leftText: CustomLocalizations.of(context).age,
      text: widget.user.age.toString(),
      inputFieldWidth: 0.45,
      disabled: true,
    );
  }
}

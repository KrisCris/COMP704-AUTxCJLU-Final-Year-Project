import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/iconButton.dart';
import 'package:fore_end/Mycomponents/myNavigator.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/Mycomponents/switchPage.dart';
import 'package:fore_end/Pages/takePhotoPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget myDietPart = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("myDietPage"),
        ],
      ),
    );
    TakePhotoPage takePhotoPart = new TakePhotoPage();
    Widget addPlanPart = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("addPlanPart"),
        ],
      ),
    );

    MyIconButton myDietButton = MyIconButton(
      theme: MyTheme.blackAndWhite,
      icon: FontAwesomeIcons.utensils,
      text: "My Diet",
      buttonRadius: 70,
      borderRadius: 10,
    );
    MyIconButton takePhotoButton = MyIconButton(
        theme: MyTheme.blackAndWhite,
        icon: FontAwesomeIcons.camera,
        text: "Take Photo",
        buttonRadius: 70,
        borderRadius: 10,
        fontSize: 12,
        onClick: () {
          takePhotoPart.getCamera();
        });
    MyIconButton addPlanButton = MyIconButton(
      theme: MyTheme.blackAndWhite,
      icon: FontAwesomeIcons.folderPlus,
      text: "Add Plan",
      borderRadius: 10,
      buttonRadius: 70,
      fontSize: 13,
    );

    MyNavigator navigator = MyNavigator(
      buttons: [addPlanButton, takePhotoButton, myDietButton],
      switchPages: [addPlanPart, takePhotoPart, myDietPart],
      width: ScreenTool.partOfScreenWidth(0.8),
      height: ScreenTool.partOfScreenHeight(0.08),
      activateNum: 2,
    );
    SwitchPage bodyContent = navigator.getPages();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage(
                "image/avatar.png",
              ),
            ),
            Text(
              "Username",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  fontFamily: "Futura",
                  color: Colors.white),
            ),
            SizedBox(width: 0.1),
            SizedBox(
              width: 0.2,
            ),
            MyTextField(
              placeholder: "Search Food",
              // keyboardAction: TextInputAction.next,
              theme: MyTheme.WhiteAndBlack,
              inputType: InputFieldType.text,
              width: ScreenTool.partOfScreenWidth(0.4),
              ulDefaultWidth: Constants.WIDTH_TF_UNFOCUSED,
              ulFocusedWidth: Constants.WIDTH_TF_FOCUSED,
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Expanded(child: bodyContent), navigator],
        ),
      ),
    );
  }
}

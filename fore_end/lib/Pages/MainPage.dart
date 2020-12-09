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
  bool photoPageOff = true;
  Widget myDietPart;
  TakePhotoPage takePhotoPart;
  Widget addPlanPart;
  MyIconButton myDietButton;
  MyIconButton takePhotoButton;
  MyIconButton addPlanButton;
  MyNavigator navigator;
  SwitchPage bodyContent;
  AppBar appBar;
  MainState state;

  MainPage({Key key}) : super(key: key) {
    this.myDietPart = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("myDietPage"),
        ],
      ),
    );
    this.takePhotoPart = new TakePhotoPage();
    this.addPlanPart = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("addPlanPart"),
        ],
      ),
    );
    this.myDietButton = MyIconButton(
      theme: MyTheme.blackAndWhite,
      icon: FontAwesomeIcons.utensils,
      backgroundOpacity: 0.0,
      text: "My Diet",
      buttonRadius: 70,
      borderRadius: 10,
      onClick: () {
        this.state.setState(() {
          this.photoPageOff = true;
        });
      },
    );
    this.takePhotoButton = MyIconButton(
        theme: MyTheme.blackAndWhite,
        icon: FontAwesomeIcons.camera,
        backgroundOpacity: 0.0,
        text: "Take Photo",
        buttonRadius: 70,
        borderRadius: 10,
        fontSize: 12,
        onClick: () {
          takePhotoPart.getCamera();
          this.state.setState(() {
            this.photoPageOff = false;
          });
        });
    this.addPlanButton = MyIconButton(
        theme: MyTheme.blackAndWhite,
        icon: FontAwesomeIcons.folderPlus,
        backgroundOpacity: 0.0,
        text: "Add Plan",
        borderRadius: 10,
        buttonRadius: 70,
        fontSize: 13,
        onClick: () {
          this.state.setState(() {
            this.photoPageOff = true;
          });
        });
    this.navigator = MyNavigator(
      buttons: [addPlanButton, takePhotoButton, myDietButton],
      switchPages: [addPlanPart, takePhotoPart, myDietPart],
      opacity: 0.25,
      edgeWidth: 0.5,
      width: ScreenTool.partOfScreenWidth(0.7),
      height: ScreenTool.partOfScreenHeight(0.08),
      activateNum: 2,
    );
    this.bodyContent = navigator.getPages();
    this.appBar = AppBar(
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
    );
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new MainState();
    return this.state;
  }
}

class MainState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              widget.bodyContent,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: SizedBox()),
                  Offstage(
                      offstage: widget.photoPageOff,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyIconButton(
                              theme: MyTheme.blackAndWhite,
                              icon: FontAwesomeIcons.image,
                              backgroundOpacity: 0.25,
                              text: "",
                              borderRadius: 10,
                              buttonRadius: 50,
                              iconSize: 20,
                              fontSize: 13,
                            ),
                            MyIconButton(
                              theme: MyTheme.blackAndWhite,
                              icon: FontAwesomeIcons.image,
                              backgroundOpacity: 0.25,
                              text: "",
                              borderRadius: 10,
                              buttonRadius: 50,
                              iconSize: 20,
                              fontSize: 13,
                            )
                          ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.navigator,
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}

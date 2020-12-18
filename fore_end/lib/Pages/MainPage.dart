import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/Mycomponents/CustomDrawer.dart';
import 'package:fore_end/Mycomponents/iconButton.dart';
import 'package:fore_end/Mycomponents/myNavigator.dart';
import 'package:fore_end/Mycomponents/myTextField.dart';
import 'package:fore_end/Mycomponents/switchPage.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/takePhotoPage.dart';

import 'LoginPage.dart';

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
  MainState state;
  User user;
  Widget userAvatarContainer;
  MainPage({@required User user, Key key}) : super(key: key) {
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
    this.user = user;
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new MainState();
    return this.state;
  }
}

class MainState extends State<MainPage> {

  @override
  void initState() {
    widget.userAvatarContainer = this.getCircleAvatar();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    this.resetNavigator();

    return Scaffold(
        drawer: this.getDrawer(),
        body: Builder(
          builder: (BuildContext ctx) {
            return Container(
                alignment: Alignment.center,
                height: ScreenTool.partOfScreenHeight(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    this.getAppBar(ctx),
                    Expanded(
                        child: Stack(
                      children: [
                        widget.bodyContent,
                        Column(
                          children: [
                            Expanded(child: SizedBox()),
                            Offstage(
                              offstage: widget.photoPageOff,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  this.getAlbumButton(),
                                  this.getPhotoButton()
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [widget.navigator],
                            )
                          ],
                        )
                      ],
                    ))
                  ],
                ));
          },
        ));
  }

  void openDrawer(BuildContext ctx) {
    Scaffold.of(ctx).openDrawer();
  }

  Widget getAppBar(BuildContext ctx){
    return Container(
      width: ScreenTool.partOfScreenWidth(0.85),
      height: 70,
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: Color(0xFF0091EA),
        boxShadow: [
          BoxShadow(
            blurRadius: 12, //阴影范围
            spreadRadius: 3, //阴影浓度
            color: Color(0x33000000), //阴影颜色
          ),
        ]
      ),
      child: Row(
        children: [
          SizedBox(width: 15,),
          GestureDetector(
            onTap: (){this.openDrawer(ctx);},
            child: this.getCircleAvatar(size: 50),
          )
          ,
          SizedBox(width: 10,),
          Text(
            widget.user.userName,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                fontFamily: "Futura",
                color: Colors.black),
          ),
        ],
      ),
    );
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: Scaffold.of(ctx).openDrawer,
              child: widget.userAvatarContainer),
          Text(
            widget.user.userName,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 20,
                fontFamily: "Futura",
                color: Colors.black),
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
  Widget getPhotoButton() {
    return new MyIconButton(
      theme: MyTheme.blackAndWhite,
      icon: FontAwesomeIcons.camera,
      iconSize: 40,
      backgroundOpacity: 0,
    );
  }

  Widget getAlbumButton() {
    return new MyIconButton(
      theme: MyTheme.blackAndWhite,
      icon: FontAwesomeIcons.image,
      iconSize: 40,
      backgroundOpacity: 0,
    );
  }

  CustomDrawer getDrawer() {

    Widget info = this.getDrawerHeader();
    Widget userSetting = this.getUserSetting();
    Widget aboutUs = this.getAboutUs();
    Widget logOut = this.getLogOut();

    List<Widget> drawerItems = [
      SizedBox(height: ScreenTool.partOfScreenHeight(0.05),),
      info,
      SizedBox(height: 70,),
      userSetting,
      SizedBox(height: 30,),
      aboutUs,
      Expanded(child: SizedBox()),
      Row(
        children: [
          Expanded(child: SizedBox()),
          logOut,
          SizedBox(width: 15,)
        ],
      ),
      SizedBox(height: 15,),
    ];
    return CustomDrawer(
      widthPercent: 1,
      child: Column(
        children: drawerItems,
      ),
    );
  }

  Widget getCircleAvatar({double size=60}){
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: MemoryImage(widget.user.getAvatarBin()),
            fit: BoxFit.cover
          ),
        boxShadow:[
          BoxShadow(
            blurRadius: 10, //阴影范围
            spreadRadius: 1, //阴影浓度
            color: Color(0x33000000), //阴影颜色
          ),
        ]
      )
      // child: , //增加文字等
    );
  }
  Widget getDrawerHeader(){
    return Row(
      children: [
        SizedBox(width: 15,),
        this.getCircleAvatar(),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.userName,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Futura",
                    color: Colors.black)),
            Text("Registered For xxx Days",
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Futura",
                    color: Colors.black38)),
          ],
        ),
        Expanded(child: SizedBox()),
        MyIconButton(
          icon: FontAwesomeIcons.times,
          theme: MyTheme.blackAndWhite,
          backgroundOpacity: 0,
          iconSize: 30,
        ),
        SizedBox(width: 15,)
      ],
    );
  }
  Widget getUserSetting(){
    return ListTile(
      title: Text("SETTINGS",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black)),
    );
  }
  Widget getAboutUs(){
    return ListTile(
      title: Text("ABOUT US",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black)),
    );
  }
  Widget getLogOut(){
    return MyIconButton(
      icon: FontAwesomeIcons.signOutAlt,
      theme: MyTheme.blackAndWhite,
      backgroundOpacity: 0,
      iconSize: 30,
      onClick: (){
        widget.user.logOut();
        Navigator.pushAndRemoveUntil(context,
          new MaterialPageRoute(builder: (ctx){return Welcome();}),
              (route) => false);
        },
    );
  }
  void resetNavigator() {
    int activateNum = 0;
    if (widget.navigator != null) {
      activateNum = widget.navigator.getActivatePageNo();
    }
    widget.navigator = MyNavigator(
      buttons: [
        widget.myDietButton,
        widget.addPlanButton,
        widget.takePhotoButton,

      ],
      switchPages: [
        widget.myDietPart,
        widget.addPlanPart,
        widget.takePhotoPart,
      ],
      opacity: 0.25,
      edgeWidth: 0.5,
      width: ScreenTool.partOfScreenWidth(0.7),
      height: ScreenTool.partOfScreenHeight(0.08),
      activateNum: activateNum,
    );
    widget.bodyContent = widget.navigator.getPages();
  }
}

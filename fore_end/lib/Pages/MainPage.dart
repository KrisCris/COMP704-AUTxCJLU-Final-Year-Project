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
  Container userAvatarContainer;
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
    this.userAvatarContainer = Container(
      width: 50,
      height: 50,
      child: ClipRRect(
        child: this.user.getAvatar(double.infinity, double.infinity),
        borderRadius: BorderRadius.circular(2),
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color(0xAA424242),
            offset: Offset(3.0, 10.0), //阴影xy轴偏移量
            blurRadius: 20.0, //阴影模糊程度
            spreadRadius: 2.0 //阴影扩散程度,
            )
      ]),
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
                    AppBar(
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
                    ),
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

  void openDrawer() {
    Scaffold.of(context).openDrawer();
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
    Widget header = DrawerHeader(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(
                widget.user.getAvatarBin(),
              ),
              fit: BoxFit.cover)),
    );

    Widget info = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListTile(
          leading: widget.user.genderIcon(),
          title: Text(widget.user.userName,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Futura",
                  color: Colors.black)),
          subtitle: Text("No." + widget.user.uid.toString(),
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Futura",
                  color: Colors.black26)),
        ),
        ListTile(
          leading: Icon(
            FontAwesomeIcons.drumstickBite,
            color: Colors.brown,
            size: 30,
          ),
          title: Text(widget.user.planType,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Futura",
                  color: Colors.black)),
          subtitle: Text("PLAN",
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Futura",
                  color: Colors.black26)),
        )
      ],
    );
    Widget userSetting = ListTile(
      leading: Icon(
        FontAwesomeIcons.userCog,
        color: Colors.blue,
        size: 30,
      ),
      title: Text("Setting",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: "Futura",
              color: Colors.black)),
    );
    Widget logOut = ListTile(
      onTap: (){
        widget.user.logOut();
        Navigator.pushAndRemoveUntil(context,
            new MaterialPageRoute(builder: (ctx){return Welcome();}),
                (route) => false);
      },
      leading: Icon(
        FontAwesomeIcons.signOutAlt,
        color: Colors.deepOrange,
        size: 35,
      ),
      title: Text("Log out",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: "Futura",
              color: Colors.black)),
    );
    List<Widget> drawerItems = [
      userSetting,
      Divider(
        color: Colors.black26,
      ),
      logOut,
      Divider(
        color: Colors.black26,
      ),
    ];
    return CustomDrawer(
      widthPercent: 0.7,
      child: Column(
        children: [
          header,
          info,
          Divider(),
          Expanded(
            child: ListView(
              children: drawerItems,
            ),
          ),
        ],
      ),
    );
  }

  void resetNavigator() {
    int activateNum = 2;
    if (widget.navigator != null) {
      activateNum = widget.navigator.getActivatePageNo();
    }
    widget.navigator = MyNavigator(
      buttons: [
        widget.addPlanButton,
        widget.takePhotoButton,
        widget.myDietButton
      ],
      switchPages: [
        widget.addPlanPart,
        widget.takePhotoPart,
        widget.myDietPart
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

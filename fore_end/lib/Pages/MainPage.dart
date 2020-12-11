import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Constants.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
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
    this.appBar = AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: AssetImage(
              user.getAvatar(),
            ),
          ),
          Text(
            user.userName,
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
    this.resetNavigator();
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: ScreenTool.partOfScreenHeight(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.appBar,
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
                            children: [
                                widget.navigator
                            ],
                          )
                        ],
                      )
                    ],
              ))
            ],
          )),
    );
  }

  Widget getPhotoButton(){
    return new MyIconButton(
        theme: MyTheme.blackAndWhite,
        icon: FontAwesomeIcons.camera,
        iconSize: 40,
        backgroundOpacity: 0,
    );
  }
  Widget getAlbumButton(){
    return new MyIconButton(
      theme: MyTheme.blackAndWhite,
      icon: FontAwesomeIcons.image,
      iconSize: 40,
      backgroundOpacity: 0,
    );
  }

  void resetNavigator(){
    int activateNum = 2;
    if(widget.navigator != null){
      activateNum = widget.navigator.getActivatePageNo();
    }
    widget.navigator = MyNavigator(
      buttons: [widget.addPlanButton, widget.takePhotoButton, widget.myDietButton],
      switchPages: [widget.addPlanPart, widget.takePhotoPart, widget.myDietPart],
      opacity: 0.25,
      edgeWidth: 0.5,
      width: ScreenTool.partOfScreenWidth(0.7),
      height: ScreenTool.partOfScreenHeight(0.08),
      activateNum: activateNum,
    );
    widget.bodyContent = widget.navigator.getPages();
  }
}

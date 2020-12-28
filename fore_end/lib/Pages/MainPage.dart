
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/mySearchBarDelegate.dart';
import 'package:fore_end/Mycomponents/widgets/CustomAppBar.dart';
import 'package:fore_end/Mycomponents/widgets/CustomDrawer.dart';
import 'package:fore_end/Mycomponents/widgets/CustomNavigator.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/TakePhotoPage.dart';
import 'SettingPage.dart';

class MainPage extends StatefulWidget {
  Widget myDietPart;
  TakePhotoPage takePhotoPart;
  Widget addPlanPart;
  CustomIconButton myDietButton;
  CustomIconButton takePhotoButton;
  CustomIconButton addPlanButton;
  CustomNavigator navigator;
  Widget bodyContent;
  MainState state;
  User user;
  MySearchBarDelegate searchBarDelegate;
  CustomAppBar appBar;
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
    this.myDietButton = CustomIconButton(
      theme: MyTheme.blueAndWhite,
      icon: FontAwesomeIcons.utensils,
      backgroundOpacity: 0.0,
      text: "My Diet",
      buttonRadius: 65,
      borderRadius: 10,
      onClick: () {
        this.appBar.reverseTransparency();
        this.navigator.reverseOpacity();
      },
    );
    this.takePhotoButton = CustomIconButton(
        theme: MyTheme.blueAndWhite,
        icon: FontAwesomeIcons.camera,
        backgroundOpacity: 0.0,
        text: "Take Photo",
        buttonRadius: 65,
        borderRadius: 10,
        fontSize: 12,
        onClick: () {
          this.appBar.startTransparency();
          this.navigator.beginOpacity();
        },
        navigatorCallback: (){
          this.takePhotoPart.getCamera();
        },);
    this.addPlanButton = CustomIconButton(
        theme: MyTheme.blueAndWhite,
        icon: FontAwesomeIcons.folderPlus,
        backgroundOpacity: 0.0,
        text: "Add Plan",
        borderRadius: 10,
        buttonRadius: 65,
        fontSize: 12,
        onClick: () {
          this.appBar.reverseTransparency();
          this.navigator.reverseOpacity();
        });
    this.user = user;
  }
  @override
  State<StatefulWidget> createState() {
    this.state = new MainState();
    return this.state;
  }
}

class MainState extends State<MainPage> with TickerProviderStateMixin {

  @override
  void initState() {
    widget.appBar = this.getAppBar();
    this.setNavigator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: this.getDrawer(),
        body: Builder(
          builder: (BuildContext ctx) {
            return Container(
                alignment: Alignment.center,
                height: ScreenTool.partOfScreenHeight(1),
                child: Stack(
                  children: [
                    widget.bodyContent,
                    Column(
                      children: [
                        widget.appBar,
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [widget.navigator],
                        )
                      ],
                    )
                  ],
                ));

          },
        ));
  }

  Widget getAppBar() {
    return CustomAppBar(
      userAvatarContainer: this.getCircleAvatar(size: 45),
      username: widget.user.userName,
    );
  }

  CustomDrawer getDrawer() {
    Widget info = this.getDrawerHeader();
    Widget userSetting = this.getUserSetting();
    Widget aboutUs = this.getAboutUs();
    Widget logOut = this.getLogOut();

    List<Widget> drawerItems = [
      SizedBox(
        height: ScreenTool.partOfScreenHeight(0.05),
      ),
      info,
      SizedBox(
        height: 70,
      ),
      userSetting,
      SizedBox(
        height: 30,
      ),
      aboutUs,
      Expanded(child: SizedBox()),
      Row(
        children: [
          Expanded(child: SizedBox()),
          logOut,
          SizedBox(
            width: 15,
          )
        ],
      ),
      SizedBox(
        height: 15,
      ),
    ];
    return CustomDrawer(
      widthPercent: 1,
      child: Column(
        children: drawerItems,
      ),
    );
  }

  Widget getCircleAvatar({double size = 60}) {
    return Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: MemoryImage(widget.user.getAvatarBin()),
                fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                blurRadius: 10, //阴影范围
                spreadRadius: 1, //阴影浓度
                color: Color(0x33000000), //阴影颜色
              ),
            ])
        // child: , //增加文字等
        );
  }

  Widget getDrawerHeader() {
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        this.getCircleAvatar(),
        SizedBox(
          width: 20,
        ),
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
        CustomIconButton(
          icon: FontAwesomeIcons.times,
          theme: MyTheme.blackAndWhite,
          backgroundOpacity: 0,
          iconSize: 30,
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Widget getUserSetting() {
    return ListTile(
      onTap: () {
        //这里写setting pages的跳转
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingPage();
        }));
      },
      title: Text("SETTINGS",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black)),
    );
  }

  Widget getAboutUs() {
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

  Widget getLogOut() {
    return CustomIconButton(
      icon: FontAwesomeIcons.signOutAlt,
      theme: MyTheme.blackAndWhite,
      backgroundOpacity: 0,
      iconSize: 30,
      onClick: () {
        widget.user.logOut();
        Navigator.pushAndRemoveUntil(context,
            new MaterialPageRoute(builder: (ctx) {
          return Welcome();
        }), (route) => false);
      },
    );
  }

  Widget getNavigator(TabController ctl){
    return CustomNavigator(
      buttons: [
        widget.myDietButton,
        widget.addPlanButton,
        widget.takePhotoButton,
      ],
      controller: ctl,
      opacity: 0.25,
      edgeWidth: 0.5,
      width: ScreenTool.partOfScreenWidth(0.7),
      height: ScreenTool.partOfScreenHeight(0.08),
    );
  }
  Widget getBodyContent(TabController ctl){
    return TabBarView(
        controller: ctl,
        children: [
          widget.myDietPart,
          widget.addPlanPart,
          widget.takePhotoPart
        ]
    );
  }
  TabController getTabController(){
    if (widget.navigator != null) {
      return widget.navigator.getController();
    }
    return TabController(length: 3, vsync: this);
  }
  void setNavigator() {
    List<CustomIconButton> buttons = [
      widget.myDietButton,
      widget.addPlanButton,
      widget.takePhotoButton,
    ];
    TabController ctl = TabController(length: buttons.length, vsync: this);
    if (widget.navigator != null) {
      ctl = widget.navigator.getController();
    }
    widget.navigator = new CustomNavigator(
      buttons: buttons,
      controller: ctl,
      opacity: 0.25,
      edgeWidth: 0.5,
      width: ScreenTool.partOfScreenWidth(0.7),
      height: ScreenTool.partOfScreenHeight(0.08),
    );
    widget.bodyContent = TabBarView(
        physics:new NeverScrollableScrollPhysics(),
        controller: ctl,
        children: [
      widget.myDietPart,
      widget.addPlanPart,
      widget.takePhotoPart
    ]);
  }
}

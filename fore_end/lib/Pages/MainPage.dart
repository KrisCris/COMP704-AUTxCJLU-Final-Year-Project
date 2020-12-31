import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/mySearchBarDelegate.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/CustomAppBar.dart';
import 'package:fore_end/Mycomponents/widgets/CustomDrawer.dart';
import 'package:fore_end/Mycomponents/widgets/CustomNavigator.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/TakePhotoPage.dart';
import 'AccountPage.dart';

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
      buttonRadius: 65,
      iconSize: 25,
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
      buttonRadius: 65,
      borderRadius: 10,
      iconSize: 25,
      fontSize: 12,
      onClick: () {
        this.appBar.startTransparency();
        this.navigator.beginOpacity();
      },
      navigatorCallback: () {
        this.takePhotoPart.getCamera();
      },
    );
    this.addPlanButton = CustomIconButton(
        theme: MyTheme.blueAndWhite,
        icon: FontAwesomeIcons.folderPlus,
        backgroundOpacity: 0.0,
        borderRadius: 10,
        buttonRadius: 65,
        iconSize: 25,
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
        drawer: this.getDrawer(context),
        body: BackGround(
            sigmaX: 2,
            sigmaY: 2,
            opacity: 0.39,
            backgroundImage: "image/food.jpg",
            color: Colors.white,
            child: Builder(
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
            )));
  }

  Widget getAppBar() {
    return CustomAppBar(
      userAvatarContainer: this.getCircleAvatar(size: 45),
      username: widget.user.userName,
    );
  }

  CustomDrawer getDrawer(BuildContext context) {
    Widget account = this.getAccount();
    Widget setting = this.getSetting();
    Widget aboutUs = this.getAboutUs();
    Widget logOut = this.getLogOut();

    List<Widget> drawerItems = [
      account,
      SizedBox(
        height: 30,
      ),
      setting,
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
      children: drawerItems
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

  Widget getAccount() {
    return ListTile(
      onTap: () {
        //这里写setting pages的跳转
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AccountPage();
        }));
      },
      title: Text("ACCOUNTS",
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black)),
    );
  }
  Widget getSetting() {
    return ListTile(
      onTap: () {
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

  TabController getTabController() {
    if (widget.navigator != null) {
      return widget.navigator.getController();
    }
    return TabController(length: 3, vsync: this);
  }

  void setNavigator() {
    List<CustomIconButton> buttons = [
      widget.myDietButton,
      widget.takePhotoButton,
      widget.addPlanButton,
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
        physics: new NeverScrollableScrollPhysics(),
        controller: ctl,
        children: [
          widget.myDietPart,
          widget.takePhotoPart,
          widget.addPlanPart,
        ]);
  }
}

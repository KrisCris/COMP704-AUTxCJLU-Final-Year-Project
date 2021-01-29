import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/inputs/PaintedTextField.dart';
import 'package:fore_end/Mycomponents/widgets/CustomDrawer.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/CustomNavigator.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/PaintedNavigator.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/main/DietPage.dart';
import 'package:fore_end/Pages/main/TakePhotoPage.dart';
import 'package:fore_end/Pages/main/ThirdPage.dart';
import '../AccountPage.dart';

class MainPage extends StatefulWidget {
  User user;

  MainPage({@required User user, bool needSetPlan = false, Key key})
      : super(key: key) {
    this.user = user;
  }
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<MainPage> with TickerProviderStateMixin {
  GlobalKey<TakePhotoState> photoKey;
  List<GlobalKey<CustomIconButtonState>> buttonKey;
  GlobalKey<CustomNavigatorState> navigatorKey;
  TabController ctl;
  @override
  void initState() {
    photoKey = new GlobalKey<TakePhotoState>();
    navigatorKey = new GlobalKey<CustomNavigatorState>();
    buttonKey = [
      new GlobalKey<CustomIconButtonState>(),
      new GlobalKey<CustomIconButtonState>(),
      new GlobalKey<CustomIconButtonState>()
    ];
    this.ctl = TabController(length: 3, vsync: this,initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        drawer: this.getDrawer(context),
        body: Builder(
          builder: (BuildContext ctx) {
            return Container(
                alignment: Alignment.center,
                height: ScreenTool.partOfScreenHeight(1),
                child: Stack(
                  children: [
                    ClipRect(
                      child: Container(
                        width: ScreenTool.partOfScreenWidth(1),
                        height: ScreenTool.partOfScreenHeight(1),
                        color: Color(0xFF172632),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PaintedTextField(
                              backgroundColor: Colors.white10,
                              hint: "search foods",
                              icon: FontAwesomeIcons.search,
                              borderRadius: 5,
                              paddingLeft: 10,
                              width: 0.95,
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [this.setNavigator()],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: TabBarView(
                              //physics: new NeverScrollableScrollPhysics(),
                              controller: ctl,
                              children: [
                                new TakePhotoPage(key: this.photoKey),
                                new DietPage(),
                                new ThirdPage(),
                              ]),
                        ),
                      ],
                    )
                  ],
                ));
          },
        ));
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
    return CustomDrawer(widthPercent: 1, children: drawerItems);
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
      onTap: () {},
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

  PaintedNavigator setNavigator() {
    List<CustomIconButton> buttons = this.getButtons();
    PaintedNavigator navigator = new PaintedNavigator(
      buttons: buttons,
      controller: ctl,
      width: ScreenTool.partOfScreenWidth(0.85),
      height: 30,
    );
    return navigator;
  }

  List<CustomIconButton> getButtons() {
    CustomIconButton myDietButton = CustomIconButton(
      key: this.buttonKey[1],
      theme: MyTheme.blueAndWhite,
      icon: FontAwesomeIcons.utensils,
      backgroundOpacity: 0.0,
      buttonSize: 30,
      iconSize: 15,
      borderRadius: 10,
      onClick: () {
      },
      navigatorCallback: () {
        User.getInstance().refreshMeal();
      },
    );
    CustomIconButton takePhotoButton = CustomIconButton(
      key: this.buttonKey[0],
      theme: MyTheme.blueAndWhite,
      icon: FontAwesomeIcons.camera,
      backgroundOpacity: 0.0,
      buttonSize: 30,
      borderRadius: 10,
      iconSize: 15,
      fontSize: 12,
      onClick: () {
      },
      navigatorCallback: () {
        this.photoKey.currentState.getCamera();
        // this.takePhotoPart.getCamera();
      },
    );
    CustomIconButton addPlanButton = CustomIconButton(
        key: this.buttonKey[2],
        theme: MyTheme.blueAndWhite,
        icon: FontAwesomeIcons.folderPlus,
        backgroundOpacity: 0.0,
        borderRadius: 10,
        buttonSize: 30,
        iconSize: 15,
        fontSize: 12,
        onClick: () {
        });
    return [takePhotoButton, myDietButton,addPlanButton];
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/painter/DotPainter.dart';
import 'package:fore_end/Mycomponents/widgets/CustomDrawer.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PaintedColumn.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/CustomNavigator.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/PaintedNavigator.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/account/SettingPage.dart';
import 'package:fore_end/Pages/main/DietPage.dart';
import 'package:fore_end/Pages/main/TakePhotoPage.dart';
import 'package:fore_end/Pages/main/PlanDetailPage.dart';
import '../account/AccountPage.dart';

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
    this.ctl = TabController(length: 3, vsync: this, initialIndex: 1);
    if(widget.user.shouldUpdateWeight){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.user.shouldUpdateWeight = false;
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: ScreenTool.partOfScreenHeight(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DotColumn(
                      borderRadius: 5,
                      children: [
                        SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
                        Container(
                          child: Text(
                            "1 week had passed since your last body weight updating. It's time to update!",style: TextStyle(
                              fontFamily: "Futura",
                              fontSize: 15,
                              color: MyTheme.convert(ThemeColorName.NormalText)
                          ),),
                          width: ScreenTool.partOfScreenWidth(0.6),
                        ),
                        SizedBox(height: ScreenTool.partOfScreenHeight(0.05)),
                      ])
                ],
              ),
            );
          },
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.setNavigator();
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
                        color: MyTheme.convert(ThemeColorName.PageBackground),
                      ),
                    ),
                    TabBarView(
                        //physics: new NeverScrollableScrollPhysics(),
                        controller: ctl,
                        children: [
                          new TakePhotoPage(key: this.photoKey),
                          new DietPage(),
                          new PlanDetailPage(),
                        ]),
                  ],
                ));
          },
        ));
  }

  CustomDrawer getDrawer(BuildContext context) {
    Widget account = this.getAccount(context);
    Widget setting = this.getSetting(context);
    Widget aboutUs = this.getAboutUs(context);
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

  Widget getAccount(BuildContext context) {
    return ListTile(
      onTap: () {
        //这里写setting pages的跳转
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AccountPage();
        }));
      },
      title: Text(CustomLocalizations.of(context).drawerAccount,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black)),
    );
  }

  Widget getSetting(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingPage();
        }));
      },
      title: Text(CustomLocalizations.of(context).drawerSetting,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black)),
    );
  }

  Widget getAboutUs(BuildContext context) {
    return ListTile(
      title: Text(CustomLocalizations.of(context).drawerAbout,
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
      icon: FontAwesomeIcons.solidCircle,
      backgroundColorChange: false,
      backgroundOpacity: 0.0,
      buttonSize: 30,
      iconSize: 10,
      borderRadius: 10,
      onClick: () {},
      navigatorCallback: () {
        User.getInstance().refreshMeal();
      },
    );
    CustomIconButton takePhotoButton = CustomIconButton(
      key: this.buttonKey[0],
      icon: FontAwesomeIcons.camera,
      backgroundColorChange: false,
      backgroundOpacity: 0.0,
      buttonSize: 30,
      borderRadius: 10,
      iconSize: 15,
      fontSize: 12,
      onClick: () {},
      navigatorCallback: () {
        this.photoKey.currentState.getCamera();
        // this.takePhotoPart.getCamera();
      },
    );
    CustomIconButton addPlanButton = CustomIconButton(
        key: this.buttonKey[2],
        icon: FontAwesomeIcons.solidCircle,
        backgroundColorChange: false,
        backgroundOpacity: 0.0,
        borderRadius: 10,
        buttonSize: 30,
        iconSize: 10,
        fontSize: 12,
        onClick: () {});
    return [takePhotoButton, myDietButton, addPlanButton];
  }
}

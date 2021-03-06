import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Models/User.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/CustomButton.dart';
import 'package:fore_end/Components/buttons/CustomIconButton.dart';
import 'package:fore_end/Components/widgets/CustomDrawer.dart';
import 'package:fore_end/Components/widgets/navigator/PaintedNavigator.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/account/SettingPage.dart';
import 'package:fore_end/Pages/main/AboutUs.dart';
import 'package:fore_end/Pages/main/DietPage.dart';
import 'package:fore_end/Pages/main/PlanDetailPage.dart';
import 'package:fore_end/Pages/main/TakePhotoPage.dart';

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
  GlobalKey<CustomDrawerState> drawerKey;
  GlobalKey<DietPageState> dietPageKey;
  TabController ctl;

  @override
  void initState() {
    photoKey = new GlobalKey<TakePhotoState>();
    this.drawerKey = GlobalKey<CustomDrawerState>();
    this.dietPageKey = GlobalKey<DietPageState>();

    buttonKey = [
      new GlobalKey<CustomIconButtonState>(),
      new GlobalKey<CustomIconButtonState>(),
      new GlobalKey<CustomIconButtonState>()
    ];
    this.ctl = TabController(length: 3, vsync: this, initialIndex: 1);
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
                          new DietPage(
                            key: this.dietPageKey,
                          ),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          account,
          setting,
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          aboutUs,
          logOut,
        ],
      ),
      SizedBox(
        height: 15,
      ),
    ];
    return CustomDrawer(
      widthPercent: 1,
      children: drawerItems,
      dietKey: this.dietPageKey,
      key: this.drawerKey,
    );
  }

  Widget getAccount(BuildContext context) {
    return CustomButton(
      tapFunc: () {
        //?????????setting pages?????????
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AccountPage();
        })).then((value) {
          if (value) {
            drawerKey.currentState.setState(() {});
            setState(() {});
          }
        });
      },
      text: CustomLocalizations.of(context).drawerAccount,
      width: (ScreenTool.partOfScreenWidth(1) - 60) / 2,
      height: 40,
      firstColorName: ThemeColorName.Error,
      radius: 5,
    );
  }

  Widget getSetting(BuildContext context) {
    return CustomButton(
      tapFunc: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingPage();
        })).then((value) {});
      },
      text: CustomLocalizations.of(context).drawerSetting,
      width: (ScreenTool.partOfScreenWidth(1) - 60) / 2,
      firstColorName: ThemeColorName.ComponentBackground,
      height: 40,
      radius: 5,
    );
  }

  Widget getAboutUs(BuildContext context) {
    return CustomButton(
      tapFunc: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutUsPage();
        }));
      },
      text: CustomLocalizations.of(context).drawerAbout,
      width: (ScreenTool.partOfScreenWidth(1) - 60) / 2,
      firstColorName: ThemeColorName.Success,
      height: 40,
      radius: 5,
    );
  }

  Widget getLogOut() {
    return CustomIconButton(
      icon: FontAwesomeIcons.signOutAlt,
      backgroundOpacity: 0,
      iconSize: 20,
      text: CustomLocalizations.of(context).logout,
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

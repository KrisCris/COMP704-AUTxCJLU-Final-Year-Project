import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Hint.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/Req.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/painter/DotPainter.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/CustomDrawer.dart';
import 'package:fore_end/Mycomponents/widgets/basic/DotBox.dart';
import 'package:fore_end/Mycomponents/widgets/basic/PaintedColumn.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/CustomNavigator.dart';
import 'package:fore_end/Mycomponents/widgets/navigator/PaintedNavigator.dart';
import 'package:fore_end/Mycomponents/widgets/plan/ExtendTimeHint.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/WelcomePage.dart';
import 'package:fore_end/Pages/account/SettingPage.dart';
import 'package:fore_end/Pages/account/UpdateBody.dart';
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
  List<Hint> hints;
  @override
  void initState() {
    photoKey = new GlobalKey<TakePhotoState>();
    navigatorKey = new GlobalKey<CustomNavigatorState>();
    this.hints = [];
    buttonKey = [
      new GlobalKey<CustomIconButtonState>(),
      new GlobalKey<CustomIconButtonState>(),
      new GlobalKey<CustomIconButtonState>()
    ];
    this.ctl = TabController(length: 3, vsync: this, initialIndex: 1);

    WidgetsBinding.instance.addPostFrameCallback((msg) {
      widget.user.solvePastDeadline(context);
      // widget.user.remindUpdateWeight(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.receiveHint();
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
        height: 30,
      ),
      Expanded(
        child: Container(
          child: AnimatedCrossFade(
            firstChild: Center(
              child: TitleText(
                text: "No Messages",
              ),
            ),
            secondChild: Row(
              children: [
                SizedBox(width: 15),
                Expanded(
                    child: Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: this.hints.length,
                        itemBuilder: (BuildContext ctx, int idx) {
                          GlobalKey k = new GlobalKey(
                              debugLabel: "hintBox-" + idx.toString());
                          return CustomButton(
                            key: k,
                            topMargin: 15,
                            bottomMargin: 15,
                            width: ScreenTool.partOfScreenWidth(1) - 60,
                            height: 80,
                            radius: 5,
                            text: this.hints[idx].hintContent,
                            firstColorName: ThemeColorName.TransparentShadow,
                            tapFunc: () {
                              this.hints[idx].onClick(k);
                            },
                          );
                      }),
                )),
                SizedBox(width: 15)
              ],
            ),
            crossFadeState: this.hints.length <= 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 500),
          ),
          decoration: BoxDecoration(
              color: MyTheme.convert(ThemeColorName.TransparentShadow),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
      SizedBox(
        height: 15,
      ),
    ];
    return CustomDrawer(widthPercent: 1, children: drawerItems);
  }

  Widget getAccount(BuildContext context) {
    return CustomButton(
      tapFunc: () {
        //这里写setting pages的跳转
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AccountPage();
        }));
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
        }));
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

  void receiveHint() {
    this.hints.clear();

    if (widget.user.isOffline) {
      hints.add(new Hint(
          hintContent:
              "You are now in offline mode, most function is unavailable. Click to login.",
          instanceClose: false,
          onClick: (GlobalKey k) {
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (context) {
              return new Welcome();
            }), (route) => false);
            k?.currentState?.dispose();
          }));
    }
    if (widget.user.shouldUpdateWeight) {
      hints.add(new Hint(
          instanceClose: false,
          hintContent:
              "1 week had passed since your last body weight updating. It's time to update!",
          onClick: (GlobalKey k) {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                UpdateBody updateBody = new UpdateBody(
                    text:
                        "Before change your plan, please record your current weight",
                    needHeight: false);
                updateBody.onUpdate = () async {
                  User u = User.getInstance();
                  Response res = await Requests.finishPlan({
                    "uid": u.uid,
                    "token": u.token,
                    "pid": u.plan?.id ?? -1,
                    "weight": updateBody.weight.widgetValue.value.floor()
                  });
                  if (res != null && res.data['code'] == 1) {
                    k?.currentState?.dispose();
                    Navigator.pop(context, true);
                  } else {
                    Fluttertoast.showToast(msg: "update failed");
                  }
                };
                return updateBody;
              },
            ).then((val) {
              if (val == true) {
                Navigator.push(context, new MaterialPageRoute(builder: (ctx) {
                  return GuidePage(
                    firstTime: false,
                  );
                }));
              }
            });
          }));
    }
  }
}

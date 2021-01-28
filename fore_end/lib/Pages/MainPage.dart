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
import 'package:fore_end/Mycomponents/widgets/MealList.dart';
import 'package:fore_end/Mycomponents/widgets/My.dart';
import 'package:fore_end/Mycomponents/widgets/plan/GoalData.dart';
import 'package:fore_end/Mycomponents/widgets/plan/PlanNotifier.dart';
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

  MainPage({@required User user, bool needSetPlan=false, Key key}) : super(key: key) {
    this.myDietPart = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
          GoalData(width: 0.85, height: 100,backgroundColor:Color(0xFFF1F1F1),),
          SizedBox(height: 20),
          PlanNotifier(width: 0.85, height: 100,backgroundColor: Color(0xFFF1F1F1)),
          SizedBox(height: 20,),
          Container(
            width: ScreenTool.partOfScreenWidth(0.88),
            height: 220,
            child: MealListUI(key:new GlobalKey<MealListUIState>()),
          ),
        ],
      ),
    );
    this.takePhotoPart = new TakePhotoPage();
    this.addPlanPart = new Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
          My()
        ],
      ),
    );
    this.myDietButton = CustomIconButton(
      theme: MyTheme.blueAndWhite,
      icon: FontAwesomeIcons.utensils,
      backgroundOpacity: 0.0,
      buttonSize: 65,
      iconSize: 25,
      borderRadius: 10,
      onClick: () {
        this.navigator.reverseOpacity();
      },
      navigatorCallback: (){
        User.getInstance().refreshMeal();
      },
    );
    this.takePhotoButton = CustomIconButton(
      theme: MyTheme.blueAndWhite,
      icon: FontAwesomeIcons.camera,
      backgroundOpacity: 0.0,
      buttonSize: 65,
      borderRadius: 10,
      iconSize: 25,
      fontSize: 12,
      onClick: () {
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
        buttonSize: 65,
        iconSize: 25,
        fontSize: 12,
        onClick: () {
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
    this.setNavigator();
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
                        widget.bodyContent,
                        Column(
                          children: [
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
      width: ScreenTool.partOfScreenWidth(0.85),
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

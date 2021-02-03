import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/painter/ColorPainter.dart';
import 'package:fore_end/Mycomponents/widgets/basic/ExpandListView.dart';
import 'package:fore_end/Pages/WelcomePage.dart';

///自定义的AppBar，显示一些基本信息
class CustomAppBar extends StatefulWidget {

  ///历史遗留问题，不推荐使用这种方式保存State的引用
  CustomAppBarState state;

  CustomAppBar({Key key})
      : super(key: key) {}

  ///历史遗留问题，不推荐使用这种方式保存State的引用
  @override
  State<StatefulWidget> createState() {
    this.state = CustomAppBarState();
    return this.state;
  }
}

///CustomAppBar的State类
///混入了 [TickerProviderStateMixin] 用于控制动画
///
class CustomAppBarState extends State<CustomAppBar>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExpandListView historySearch = new ExpandListView(
      width: 0.85,
      height: 200,
      open: false,
    );
    Widget container = Container(
      width: ScreenTool.partOfScreenWidth(0.85),
      height: 70,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              backgroundImage: MemoryImage(User.getInstance().getAvatarBin()),
              radius: 40,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                User.getInstance().userName,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Futura",
                    color: Color(0xFF5079AF)),
              ),
              CustomPaint(
                painter: ColorPainter(
                  leftExtra: 5,
                  rightExtra: 5,
                  color: Colors.black12
                ),
                child: Text(
                  "Registered For x Days",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 13,
                      fontFamily: "Futura",
                      color: Color(0xFF5079AF)),
                ),
              )
            ],
          ),
          Expanded(child: SizedBox()),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              CustomIconButton(
                icon: FontAwesomeIcons.doorOpen,
                gap: 7,
                text: "Log out",
                backgroundOpacity: 0,
                iconSize: 22,
                onClick: (){
                  User.getInstance().logOut();
                  Navigator.pushAndRemoveUntil(context,
                      new MaterialPageRoute(builder: (ctx) {
                        return Welcome();
                      }), (route) => false);
                },
              ),
            ],
          ),
          SizedBox(width: 5)
        ],
      ),
    );
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        container,
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            historySearch,
          ],
        )
      ],
    );
  }

  ///打开侧边栏，前提是context中需要有侧边栏
  void openDrawer(BuildContext ctx) {
    Scaffold.of(ctx).openDrawer();
  }
}

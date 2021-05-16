import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Models/User.dart';
import 'package:fore_end/Utils/CustomLocalizations.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/CustomIconButton.dart';
import 'package:fore_end/Components/painters/LinePainter.dart';
import 'package:fore_end/Models/HintManager.dart';
import 'package:fore_end/Pages/main/DietPage.dart';

///自定义的侧边栏，基本与官方侧边栏一样
class CustomDrawer extends StatefulWidget {
  final double elevation;
  final List<Widget> children;
  final String semanticLabel;
  final double widthPercent;
  final Function onOpen;
  final Function onClose;
  final GlobalKey<DietPageState> dietKey;
  const CustomDrawer(
      {Key key,
      this.elevation = 16.0,
      this.children,
      this.semanticLabel,
      this.widthPercent,
      this.onOpen,
      this.onClose,
      this.dietKey})
      : assert(widthPercent <= 1.0 && widthPercent > 0.0),
        super(key: key);
  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    ///add start
    if (widget.onOpen != null) {
      widget.onOpen();
    }

    ///add end
    super.initState();
  }

  @override
  void dispose() {
    ///add start
    if (widget.onClose != null) {
      widget.onClose();
    }

    ///add end
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = widget.semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = widget.semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = widget.semanticLabel ??
            MaterialLocalizations.of(context)?.drawerLabel;
    }
    final double _width =
        MediaQuery.of(context).size.width * widget.widthPercent;
    Widget info = this.getDrawerHeader(context);
    List<Widget> items = [
      SizedBox(
        height: ScreenTool.partOfScreenHeight(0.05),
      ),
      info,
      SizedBox(
        height: 40,
      )
    ];
    items.addAll(widget.children);
    GlobalKey<HintBoxState> hintBoxKey = new GlobalKey<HintBoxState>();
    HintManager.instance.boxKey = hintBoxKey;
    items.add(Expanded(child: HintBox(hintBoxKey)));
    items.add(SizedBox(height: 15));
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Opacity(
              opacity: 0.75,
              child: ClipRect(
                child: CustomPaint(
                  foregroundPainter: LinePainter(
                    k: 1,
                    lineWidth: 2,
                    lineGap: 4,
                    context: context,
                    color: MyTheme.convert(ThemeColorName.TransparentShadow),
                  ),
                  child: Container(
                    width: ScreenTool.partOfScreenWidth(1),
                    color: MyTheme.convert(ThemeColorName.PageBackground),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(children: items),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getDrawerHeader(BuildContext context) {
    return Row(
      children: [
        this.getCircleAvatar(),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(User.getInstance().userName,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Futura",
                    color: MyTheme.convert(ThemeColorName.NormalText))),
            Text(
                CustomLocalizations.of(context).registerDuration +
                    User.getInstance().registerTime().toString() +
                    CustomLocalizations.of(context).days,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Futura",
                    color: MyTheme.convert(ThemeColorName.NormalText))),
          ],
        ),
        Expanded(child: SizedBox()),
        CustomIconButton(
          icon: FontAwesomeIcons.times,
          backgroundOpacity: 0,
          iconSize: 30,
          onClick: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget getCircleAvatar({double size = 60}) {
    return Container(
        margin: EdgeInsets.only(top: 8, bottom: 0),
        width: size,
        height: size,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,

            ///circle是圆的 这里改为圆角
            borderRadius: BorderRadius.circular(6.0),
            image: DecorationImage(
                image: MemoryImage(User.getInstance().getAvatarBin()),
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
}

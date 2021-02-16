import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';


class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Column col = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          CustomLocalizations.of(context).welcomeTitle,
          textDirection: TextDirection.ltr,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 50.0,
              fontFamily: "Futura",
              color: MyTheme.convert(ThemeColorName.HeaderText)),
        ),
        SizedBox(height: 60.0),
        CustomButton(
            text: CustomLocalizations.of(context).signUp,
            fontsize: 18.0,
            width: 0.7,
            height: 55.0,
            radius: 30.0,
            sizeChangeMode: 2,
            isBold: true,
            tapFunc: () {
              Navigator.pushNamed(context, "register");
            }),
        SizedBox(height: 20),
        CustomTextButton(
          CustomLocalizations.of(context).alreadyHave,
          fontsize: 16.0,
          tapUpFunc: () {
            Navigator.pushNamed(context, "login");
          },
        ),
      ],
    );
    return  Container(
      color: MyTheme.convert(ThemeColorName.PageBackground),
      child: col,
    );
  }
}
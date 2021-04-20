import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/Pages/CoverPage.dart';
import 'package:fore_end/Pages/FoodRecommandation.dart';
import 'package:fore_end/Pages/detail/HistoryPlanPage.dart';
import 'Mycomponents/widgets/buildFloatingSearchBar.dart';
import 'Pages/ComponentTestPage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/RegisterPage.dart';
import 'Pages/WelcomePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this._preCacheAllImage();
    return MaterialApp(
       home: CoverPage(),
        // home: FoodRecommandation(),
      routes: <String, WidgetBuilder>{
        "login": (context) => Login(),
        "register": (context) => Register(),
        "welcome": (context) => Welcome(),
      },
        builder: EasyLoading.init(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizationsDelegate.delegate
      ],
      supportedLocales: CustomLocalizations.supported.values
    );
  }

  void _preCacheAllImage() {
    precacheImage(AssetImage("image/fruit-main.jpg"), context);
    precacheImage(AssetImage("image/food.jpg"), context);
    precacheImage(AssetImage("image/defaultFood.png"), context);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/req.dart';

class CoverPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
      return CoverState();
  }
  
  void getCookie() async {
    Map<String,String> cookie = await Requests.getCookies();
    print(cookie);
  }
}

class CoverState extends State<CoverPage>{
  @override
  Widget build(BuildContext context) {
      return Center(
        child: Container(
          child: Column(
            children: [
              Icon(FontAwesomeIcons.lemon,color: Colors.black,size: 30),
              Text("Take a Picture of your food!",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Futura",
                      color: Colors.black))
            ],
          ),
        ),
      );
  }
}
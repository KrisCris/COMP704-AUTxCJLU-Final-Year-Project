import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/req.dart';

class CoverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CoverState();
  }

  void getCookie() async {
    Map<String, String> cookie = await Requests.getCookies();
    print(cookie);
  }
}

class CoverState extends State<CoverPage> {
  Widget getPage(String text) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ClipRRect(
          // make sure we apply clip it properly
          child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, //水平居中
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.lemon, color: Colors.black, size: 50),
                  SizedBox(height: 10),
                  Text("Take a Picture of your food!",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Futura",
                          color: Colors.black)),
                  SizedBox(height: 30),
                  Text(text,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Futura",
                          color: Colors.black))
                ],
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Requests.getCookies(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            Map<String,String> token = snapShot.data;
            if(token.isEmpty){
              Future.delayed(Duration(milliseconds: 1500),(){
                Navigator.pushNamed(context, "welcome");
              });
              return this.getPage("welcome to here!");
            }else{
              Future.delayed(Duration(milliseconds: 1500),(){
                Navigator.pushNamed(context, "main");
              });
              return this.getPage("Auto login...");
            }
          } else {
            return this.getPage("Checking login state...");
          }
        });
  }
}

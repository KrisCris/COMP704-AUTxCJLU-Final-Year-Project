import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }

}

class MainState extends State<MainPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Text("test main page"),
      ),
    );
  }

}
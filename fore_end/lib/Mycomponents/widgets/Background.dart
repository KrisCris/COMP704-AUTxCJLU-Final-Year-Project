import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BackGround extends StatelessWidget {
  double sigmaX;
  double sigmaY;
  String backgroundImage;
  Color color;
  Widget child;
  double opacity;
  Alignment alignment;

  ///type = 0 -> AssetImage
  ///type = 1 -> MemoryImage
  int _type;

  BackGround({
    this.sigmaX = 0,
      this.sigmaY = 0,
      this.opacity = 0,
      this.alignment = Alignment.center,
      this.backgroundImage = "image/fruit-main.jpg",
      this.color = Colors.white,
      this.child,
      Key key}) : super(key: key){this._type = 0;}

  BackGround.base64({
    Key key,
    String base64,
    this.sigmaX=0,
   this.sigmaY=0,
   this.opacity=0,
    this.alignment=Alignment.center,
    this.child,
    this.color=Colors.white}):super(key: key){
      this._type = 1;
      this.backgroundImage = base64;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: this.getImage(),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            // make sure we apply clip it properly
            child: BackdropFilter(
                //背景滤镜
                filter: ImageFilter.blur(sigmaX: this.sigmaX, sigmaY: this.sigmaY),
                child: Container(
                    alignment: this.alignment,
                    color: this.color.withOpacity(this.opacity),
                    child: this.child)),
          ),
    ));
  }

  ImageProvider getImage(){
    if(this._type == 0){
      return AssetImage(this.backgroundImage);
    }else if(this._type == 1){
      return MemoryImage(base64Decode(this.backgroundImage));
    }
  }
}

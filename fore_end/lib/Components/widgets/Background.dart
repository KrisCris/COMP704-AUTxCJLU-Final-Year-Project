import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

///背景图片组件
class BackGround extends StatelessWidget {
  ///X轴上的模糊程度
  double sigmaX;

  ///Y轴上的模糊程度
  double sigmaY;

  ///背景图片。根据 [_type] 来决定采用图片路径还是base64编码
  String backgroundImage;

  ///表面蒙版的颜色，默认为白色
  Color color;

  ///表面蒙版的透明度
  double opacity;

  ///子组件
  Widget child;

  ///子组件的对齐方式
  Alignment alignment;

  ///type = 0 -> AssetImage
  ///type = 1 -> MemoryImage
  int _type;

  ///采用资源图片路径指定背景图片
  BackGround(
      {this.sigmaX = 0,
      this.sigmaY = 0,
      this.opacity = 0,
      this.alignment = Alignment.center,
      this.backgroundImage = "image/fruit-main.jpg",
      this.color = Colors.white,
      this.child,
      Key key})
      : super(key: key) {
    this._type = 0;
  }

  ///采用base64指定背景图片
  BackGround.base64(
      {Key key,
      String base64,
      this.sigmaX = 0,
      this.sigmaY = 0,
      this.opacity = 0,
      this.alignment = Alignment.center,
      this.child,
      this.color = Colors.white})
      : super(key: key) {
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

  ///获取图片的ImageProvider
  ImageProvider getImage() {
    if (this._type == 0) {
      return AssetImage(this.backgroundImage);
    } else if (this._type == 1) {
      return MemoryImage(base64Decode(this.backgroundImage));
    }
  }
}

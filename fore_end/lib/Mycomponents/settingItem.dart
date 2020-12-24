import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/User.dart';


/// 个人信息设置页Item
class SettingItem extends StatelessWidget {
  final Function onTap; //点击事件
  final String leftText; //左侧显示文字
  final String rightText; //右侧显示文字
  final Widget leftIcon; //左侧图片
  final bool isRight; //是否显示右侧
  final bool isRightImage; //是否显示右侧图片
  final String rightImageUri; //右侧图片地址
  final bool isRightText; //是否显示右侧文字
  final Widget rightImage;
  final bool isChange;
  final Image image;

  const SettingItem({
    Key key,
    this.leftText = "",
    this.leftIcon,
    this.rightText = "",
    this.isRight = true,
    this.isRightImage = false,
    this.rightImageUri = "",
    this.isRightText = true,
    this.onTap,
    this.rightImage,
    this.isChange=true,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 50,
      child:  Material(
          //color:
          child: InkWell(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        leftIcon,
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            leftText,
                            style: TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                        )
                      ]),
                  //Visibility是控制子组件隐藏/可见的组件
                  Visibility(
                    visible: isRight,
                    child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Row(children: <Widget>[
                              Visibility(
                                  visible: isRightText,
                                  child: Text(
                                    rightText,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.grey),
                                  )),
                              Visibility(
                                  visible: isRightImage,
                                  // child: CircleAvatar(
                                  //   backgroundImage: this.image,
                                  // )
                                  //   child: this.image,
                                      child: this.getImage(),

                                  )
                            ]),
                          ),

                          Visibility(
                            visible: isChange,
                            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 20,),
                          )
                        ]),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Image getImage(){
    User user=User.getInstance();

    return user.getAvatar(40, 40);
  }

}
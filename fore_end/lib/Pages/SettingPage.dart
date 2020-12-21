import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';

class SettingPage extends StatelessWidget {
  bool visible = true;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting Page"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10,),

          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Personal Information",
              style: TextStyle(color: Colors.blue),

            ),
          ),

          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.userCircle),
            leftText: "头像",
            // rightImageUri: headImage,
            isRightText: false,
            isRightImage: true,
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Text("修改用户名"),

                        // TextField(
                        //   decoration: InputDecoration(
                        //       labelText: "用户名",
                        //       hintText: "用户名或邮箱",
                        //       prefixIcon: Icon(Icons.person),
                        //     suffixIcon: Icon(Icons.subdirectory_arrow_left_rounded),
                        //   ),
                        // ),
                        OutlineButton(
                          child: Text("Save changes"),
                          onPressed: () {},
                        ),
                        OutlineButton(
                          child: Text("Cancel changes"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },

              );
            },
          ),


          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.envelope),
            leftText: "Email",
            rightText: "605817494@qq.com",
            onTap: (){
              print("Email");
            },
          ),
          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.user),
            leftText: "Username",
            rightText: "SIMONZSK",
            onTap: (){
              //Dialog可以里面嵌套不同的widget，如果是输入框那么就可以满足需求了。
              print("用户名");
            },
          ),
          SettingItem(
            leftIcon: Icon(FontAwesomeIcons.transgender),
            leftText: "Gender",
            rightText: "Male",
            onTap: (){
              print("性别");
            },
          ),

          SettingItem(
            leftIcon: Icon(Icons.calendar_today),
            leftText: "Age",
            rightText: "21",
            onTap: (){
              //Dialog可以里面嵌套不同的widget，如果是输入框那么就可以满足需求了。
              print("年龄");
            },
          ),

          OutlineButton(
            child: Text("Save changes"),
            onPressed: () {},
          ),



        ],
      )
    );
  }

}




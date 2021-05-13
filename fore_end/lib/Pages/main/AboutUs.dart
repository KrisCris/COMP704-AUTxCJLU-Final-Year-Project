import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  Widget getItem(String name,String job){

    return Row(

      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(width: 15,),
        Icon(
          FontAwesomeIcons.male,
          size: 20,
          color: Colors.white,
        ),
        SizedBox(width: 10,),
        Text(name,
          style: TextStyle(
              color: MyTheme.convert(ThemeColorName.NormalText),
              fontSize: 14,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none),
        ),
        SizedBox(width: 40,),
        Text(job,
          style: TextStyle(
              color: MyTheme.convert(ThemeColorName.NormalText),
              fontSize: 14,
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none),
        ),

      ],


    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: MyTheme.convert(ThemeColorName.PageBackground),
      ),

      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(height: ScreenTool.partOfScreenHeight(0.05),),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                child: Icon(FontAwesomeIcons.arrowLeft,size: 30,color: MyTheme.convert(ThemeColorName.NormalIcon),),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: ScreenTool.partOfScreenWidth(0.15),
              ),
              Icon(
                FontAwesomeIcons.coffee,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(width: 15,),

              Text(
                "ABOUT US",
                style: TextStyle(
                    color: MyTheme.convert(ThemeColorName.NormalText),
                    fontSize: 25,
                    fontFamily: 'Futura',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          Divider(
            indent: 0.7,
            color: Colors.white,
          ),
          SizedBox(height: ScreenTool.partOfScreenHeight(0.05),),

          Row(
            children: [
              SizedBox(width: 33,),
              TitleText(
                text: "开发人员：",
                fontSize: 20,
                maxHeight: 30,
                maxWidth: 150,
                underLineDistance:5 ,
              ),
            ],
          ),

          SizedBox(height: ScreenTool.partOfScreenHeight(0.02),),
          this.getItem("YYZ", "Fore_end developer"),
          this.getItem("ZSK", "Fore_end developer"),
          this.getItem("YHT", "Fore_end developer"),
          this.getItem("HPC", "Fore_end developer"),

          SizedBox(height: ScreenTool.partOfScreenHeight(0.05),),
          Row(
            children: [
              SizedBox(width: 33,),
              TitleText(
                text: "软件功能：",
                fontSize: 20,
                maxHeight: 30,
                maxWidth: 150,
                underLineDistance:5 ,
              ),
            ],
          ),
          SizedBox(height: ScreenTool.partOfScreenHeight(0.02),),
          this.getItem("1：", "Food recognize"),
          this.getItem("2：", "Diet plan"),
          this.getItem("3：", "Foods of Meal record"),
          this.getItem("4：", "Food recommend"),
        ],
      ),
    );
  }
}

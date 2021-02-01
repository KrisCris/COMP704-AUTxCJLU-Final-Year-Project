import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/Mycomponents/buttons/CustomTextButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:fore_end/Mycomponents/widgets/DotBox.dart';
import 'package:fore_end/Mycomponents/widgets/plan/GoalData.dart';
import 'package:fore_end/Pages/GuidePage.dart';
import 'package:fore_end/Pages/UpdateBody.dart';

class PlanDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
          DotColumn(
            width: 0.95,
            mainAxisAlignment: MainAxisAlignment.center,
            borderRadius: 6,
            backgroundColor: Color(0xFF1F405A),
            children: [
              SizedBox(height: 12),
              Text(
                "Plan Type: " + User.getInstance().plan.getPlanType(),
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD1D1D1),
                    fontFamily: "Futura"),
              ),
              SizedBox(height: 12),
            ],
          ),
          SizedBox(height: ScreenTool.partOfScreenHeight(50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: "Your Plan",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.475,
                maxHeight: 30,
              ),
              Expanded(child: SizedBox()),
              CustomTextButton(
                  "Change Plan",
                  autoReturnColor: true,
                  fontsize: 15,
                  tapUpFunc: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (ctx){
                      return GuidePage(firstTime: false,);
                    }));
                  },
              ),
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
            ],
          ),
          SizedBox(height: 5),
          GoalData(
            width: 0.95,
            height: 100,
            backgroundColor: Color(0xFF1F405A),
            textColor: Color(0xFFD1D1D1),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
              TitleText(
                text: "Body Weight Info",
                underLineLength: 0,
                fontColor: Color(0xFFF1F1F1),
                fontSize: 18,
                maxWidth: 0.475,
                maxHeight: 30,
              ),
              Expanded(child: SizedBox()),
              CustomTextButton(
                "Update weight",
                autoReturnColor: true,
                fontsize: 15,
                tapUpFunc: (){
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new UpdateBody();
                    },
                  ).then((val) {
                    print(val);
                  });
                },
              ),
              SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
            ],
          ),
          SizedBox(height: 10),
          //TODO: 体重折线图
          DotColumn(
            width: 0.95,
            mainAxisAlignment: MainAxisAlignment.center,
            borderRadius: 6,
            backgroundColor: Color(0xFF1F405A),
            children: [
              SizedBox(height: 40),
              Text(
                "Here will be the line graph of body weight",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD1D1D1),
                    fontFamily: "Futura"),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

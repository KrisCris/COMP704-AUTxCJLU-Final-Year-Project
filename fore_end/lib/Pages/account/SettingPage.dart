import 'package:flutter/cupertino.dart';
import 'package:fore_end/MyTool/User.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooserGroup.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    User u = User.getInstance();
    CardChooserGroup group = CardChooserGroup(
      initVal: u.themeCode,
      listView: true,
      gap: 10,
      direction: CardChooserGroupDirection.horizontal,
      cards: List.generate(MyTheme.AVAILABLE_THEME.length, (index){
        return CardChooser<int>(
          width: 0.25,
          height: 100,
          isChosen: u.themeCode == index,
          textColor: MyTheme.AVAILABLE_THEME[index].normalTextColor,
          backgroundColor: MyTheme.AVAILABLE_THEME[index].componentBackgroundColor,
          text: MyTheme.AVAILABLE_THEME[index].name,
          paddingLeft: 5,
          paddingRight: 5,
          value: index,
        );
      }),
    );
    group.addValueChangeListener((){
      bool success = u.changeTheme(group.widgetValue.value);
      if(success){
        setState(() {});
      }
    });

    return Container(
      width: ScreenTool.partOfScreenWidth(1),
      height: ScreenTool.partOfScreenHeight(1),
      color: MyTheme.convert(ThemeColorName.PageBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: ScreenTool.partOfScreenWidth(0.05)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenTool.partOfScreenHeight(0.06)),
                TitleText(
                  text: "SETTING",
                  underLineLength: 0.9,
                  underLineDistance: 1,
                  maxHeight: 35,
                  fontSize: 20,
                ),
                SizedBox(height: 40),
                TitleText(
                  text: "Theme",
                  fontSize: 15,
                  underLineLength: 0,
                ),
                SizedBox(height: 5),
                Container(
                  height: 100,
                  child: group,
                )
              ],
            ),
          ),
          SizedBox(width: ScreenTool.partOfScreenWidth(0.1))
        ],
      ),
    );
  }
}

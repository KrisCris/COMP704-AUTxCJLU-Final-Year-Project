import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fore_end/MyTool/SoftwarePreference.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooser.dart';
import 'package:fore_end/Mycomponents/buttons/CardChooserGroup.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {

  @override
  Widget build(BuildContext context) {
    SoftwarePreference preference = SoftwarePreference.getInstance();
    CardChooserGroup group = CardChooserGroup(
      initVal: preference.theme,
      listView: true,
      gap: 10,
      direction: CardChooserGroupDirection.horizontal,
      cards: List.generate(MyTheme.AVAILABLE_THEME.length, (index) {
        return CardChooser<int>(
          width: 0.25,
          height: 100,
          isChosen: preference.theme == index,
          textColor: MyTheme.AVAILABLE_THEME[index].normalTextColor,
          backgroundColor: MyTheme.AVAILABLE_THEME[index]
              .componentBackgroundColor,
          text: CustomLocalizations.of(context).getContent(
              MyTheme.AVAILABLE_THEME[index].name),
          paddingLeft: 5,
          paddingRight: 5,
          value: index,
          borderRadius: 25,
          textSize: 15,
        );
      }),
    );
    List<Map<String, String>> languages = CustomLocalizations.getLanguages(
        context);
    CardChooserGroup languageList = CardChooserGroup(
      initVal: preference.theme,
      listView: true,
      gap: 10,
      direction: CardChooserGroupDirection.vertical,
      cards: List.generate(languages.length, (index) {
        String code = languages[index].values.first;
        String displayName = languages[index].keys.first;
        return CardChooser<String>(
          width: 0.9,
          height: 70,
          isChosen: preference.languageCode == code,
          textColor: MyTheme.convert(ThemeColorName.NormalText),
          backgroundColor: MyTheme.convert(ThemeColorName.ComponentBackground),
          text: displayName,
          paddingLeft: 5,
          paddingRight: 5,
          value: code,
          borderRadius: 35,
          textSize: 15,
        );
      }),
    );
    group.addValueChangeListener(() {
      bool success = preference.changeTheme(group.widgetValue.value);
      if (success) {
        setState(() {});
      }
    });
    languageList.addValueChangeListener(() {
      bool success = preference.changeLauguage(languageList.widgetValue.value);
      if (success) {
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
                SizedBox(height: ScreenTool.partOfScreenHeight(0.03)),
                Row(
                    children: [
                      GestureDetector(
                        child: Icon(
                          FontAwesomeIcons.arrowLeft, size: 30,
                          color: MyTheme.convert(ThemeColorName.NormalIcon),),
                        onTap: () {
                          Navigator.pop(context,true);
                        },
                      ),
                      Container(
                        // margin: EdgeInsets.all(20),
                        margin: EdgeInsets.fromLTRB(20, 18, 10, 10),
                        child: Text(
                          CustomLocalizations
                              .of(context)
                              .drawerSetting,
                          style: TextStyle(
                            color: MyTheme.convert(ThemeColorName.HeaderText),
                            fontSize: 32,
                            fontFamily: "Futura",
                          ),
                        ),
                      )
                    ]
                ),
                // TitleText(
                //   text:CustomLocalizations.of(context).drawerSetting,
                //   underLineLength: 0.9,
                //   underLineDistance: 1,
                //   maxHeight: 35,
                //   fontSize: 20,
                // ),
                SizedBox(height: 40),
                TitleText(
                  text: CustomLocalizations
                      .of(context)
                      .theme,
                  fontSize: 15,
                  maxHeight: 40,
                  underLineLength: 0,
                ),
                SizedBox(height: 5),
                Container(
                  height: 100,
                  child: group,
                ),
                SizedBox(height: 40),
                TitleText(
                  text: CustomLocalizations
                      .of(context)
                      .language,
                  fontSize: 15,
                  maxHeight: 40,
                  underLineLength: 0,
                ),
                SizedBox(height: 5),
                Container(
                  height: 250,
                  width: ScreenTool.partOfScreenWidth(0.9),
                  child: languageList,
                ),
              ],
            ),
          ),
          SizedBox(width: ScreenTool.partOfScreenWidth(0.05))
        ],
      ),
    );
  }
}

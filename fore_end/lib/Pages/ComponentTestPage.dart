import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/EditableArea.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';

class ComponentTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackGround(
      opacity: 0.5,
      child: EditableArea(
          theme: MyTheme.blueStyle,
          width: 0.8,
          height: 0.7,
          displayContent: [
            CustomTextField(
              theme: MyTheme.blueStyle,
              placeholder: "A",
              ulDefaultWidth: 0,
              defaultContent: "A",
            ),
            SettingItem(
              leftIcon: Icon(FontAwesomeIcons.user),
              leftText: "Username",
              rightText: "D",
              inputFieldWidth: 100,
            ),
          ]),
    );
  }
}

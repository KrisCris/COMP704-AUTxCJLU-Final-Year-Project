import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/EditableArea.dart';
import 'package:fore_end/Mycomponents/inputs/ExpandInputField.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';

class ComponentTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackGround(
      opacity: 0.5,
      child: ExpandInputField(
        width: 0.5,
      )
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/inputs/CustomTextField.dart';
import 'package:fore_end/Mycomponents/inputs/EditableArea.dart';
import 'package:fore_end/Mycomponents/inputs/ExpandInputField.dart';
import 'package:fore_end/Mycomponents/settingItem.dart';
import 'package:fore_end/Mycomponents/widgets/Background.dart';
import 'package:fore_end/Mycomponents/widgets/ExpandListView.dart';

class ComponentTestPage extends StatelessWidget {
  var _value;
  @override
  Widget build(BuildContext context) {
    ExpandListView list = ExpandListView(width: 200,height: 200,);
    return BackGround(
      opacity: 0.5,
      child: Column(
        children: [
          SizedBox(height: 100,),
          list,
          CustomButton(theme: MyTheme.blueStyle,width: 200,tapFunc: (){
            if(list.isOpen.value){
              list.close();
            }else{
              list.open();
            }
          },)
        ],
      )
    );
  }
}

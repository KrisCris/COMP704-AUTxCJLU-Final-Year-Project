import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fore_end/MyTool/util/CustomLocalizations.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/text/TitleText.dart';

class ExtendTimeHint extends StatelessWidget {
  Function onClickAccept;
  Function onClickFinish;
  String title;
  String delayText;
  String finishText;
  ExtendTimeHint(
      {Key key,
      this.onClickAccept,
      this.onClickFinish,
      String title,
      String delayText,
      String finishText})
      : super(key: key) {
    this.title = title;
    this.delayText = delayText;
    this.finishText = finishText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenTool.partOfScreenHeight(1),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: ScreenTool.partOfScreenHeight(0.45),
          width: ScreenTool.partOfScreenWidth(0.8),
          decoration: BoxDecoration(
              color: MyTheme.convert(ThemeColorName.ComponentBackground),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 10),
              TitleText(
                text: this.title,
                maxHeight: 70,
                maxWidth: 0.6,
                underLineLength: 0.6,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: this.delayText ??
                    CustomLocalizations.of(context).acceptDelayButton,
                width: 0.6,
                radius: 5,
                tapFunc: () async {
                  if (this.onClickAccept != null) {
                    await this.onClickAccept();
                  }
                  Navigator.of(context).pop(true);
                },
              ),
              SizedBox(height: 5),
              CustomButton(
                  text: this.finishText ??
                      CustomLocalizations.of(context).finishPlanButton,
                  width: 0.6,
                  radius: 5,
                  firstColorName: ThemeColorName.Error,
                  tapFunc: () async {
                    if (this.onClickFinish != null) {
                      await this.onClickFinish();
                    }
                    Navigator.of(context).pop(false);
                  }),
              SizedBox(height: 10),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

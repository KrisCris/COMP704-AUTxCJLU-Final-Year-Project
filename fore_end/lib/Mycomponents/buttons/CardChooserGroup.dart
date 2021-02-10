import 'package:flutter/cupertino.dart';
import 'package:fore_end/interface/Valueable.dart';

import 'CardChooser.dart';

enum CardChooserGroupDirection { vertical, horizontal }

class CardChooserGroup<T> extends StatelessWidget with ValueableStatelessWidgetMixIn<T> {
  CardChooserGroupDirection direction;
  MainAxisAlignment mainAxisAlignment;
  bool listView;
  double gap;
  double paddingLeft;
  double paddingRight;
  List<CardChooser<T>> cards;

  CardChooserGroup(
      {@required T initVal,
      this.cards,
        this.listView=false,
      this.direction = CardChooserGroupDirection.vertical,
      this.mainAxisAlignment = MainAxisAlignment.center,
        this.paddingLeft=0,
        this.paddingRight=0,
        List<Function> onChange,
      this.gap = 0}) {
    this.widgetValue = ValueNotifier(initVal);
    if(onChange == null){
      this.onChangeValue = [];
    }else{
      this.onChangeValue = onChange;
    }
    this.initValueListener();
    for (CardChooser cd in cards) {
      if(cd.isChosen()){
        this.setValue(cd.getValue());
      }
      cd.setOnTap(() {
        for (CardChooser cho in cards) {
          if (cho == cd) continue;
          cho.setUnChosen();
        }
        this.setValue(cd.getValue());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> res = [];
    int idx = -1;
    if (direction == CardChooserGroupDirection.vertical) {
      for (CardChooser cd in this.cards) {
        idx++;
        res.add(cd);
        if (this.gap <= 0 || idx == this.cards.length - 1) continue;
        res.add(SizedBox(height: this.gap));
      }
      if(!this.listView){
        return Column(mainAxisAlignment: this.mainAxisAlignment, children: res);
      }
      return ListView(
        scrollDirection: Axis.vertical,
        children: res,
      );
    } else {
      if(this.paddingLeft !=0){
        res.add(SizedBox(width: this.paddingLeft));
      }
      for (CardChooser cd in this.cards) {
        idx++;
        res.add(cd);
        if (this.gap <= 0 || idx == this.cards.length - 1) continue;
        res.add(SizedBox(width: this.gap));
      }
      if(this.paddingRight !=0){
        res.add(SizedBox(width: this.paddingRight));
      }
      if(!this.listView) {
        return Row(mainAxisAlignment: this.mainAxisAlignment, children: res);
      }
      return ListView(
        scrollDirection: Axis.horizontal,
        children: res,
      );
    }
  }
}

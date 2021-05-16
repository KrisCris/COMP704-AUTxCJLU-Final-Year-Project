import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/Models/Food.dart';
import 'package:fore_end/Utils/MyTheme.dart';
import 'package:fore_end/Utils/ScreenTool.dart';
import 'package:fore_end/Components/buttons/CustomButton.dart';
import 'package:fore_end/Components/buttons/RotateIcon.dart';

import 'ValueAdjuster.dart';

///用于显示检测到食物后，展示食物数据的组件
class FoodBox extends StatefulWidget {
  ///未提供食物图片，或者未加载图片时，采用的默认图片
  static const String defaultPicturePath = "image/defaultFood.png";

  ///控制是否需要加载食物图片，一般用于滚动组件
  ValueNotifier<bool> shouldShowPic;

  ///该组件展示的食物
  Food food;

  ///未显示详情时，组件的高度
  double height;

  ///组件的宽度
  double width;

  ///详情内容的左边距
  double detailedPaddingLeft;

  ///头部内容的左边距
  double paddingLeft;

  ///头部内容的底边距
  double paddingBottom;

  ///头部内容的顶边距
  double paddingTop;

  ///头部内容的右边距
  double paddingRight;

  ///圆角边框的半径
  double borderRadius;

  ///展开详细内容的动画持续时间
  int expandDuration;

  ///是否可以被删除
  bool couldRemove;

  ///删除时执行的回调
  Function removeFunc;

  GlobalKey<FoodBoxState> key;
  GlobalKey<RotateIconState> iconKey;
  GlobalKey fadeKey;
  GlobalKey<ValueAdjusterState> valueAdjusterKey;

  FoodBox({
    @required Food food,
    double height = 60,
    double detailedPaddingLeft = 30,
    double paddingLeft = 10,
    double paddingBottom = 25,
    double paddingTop = 0,
    double paddingRight = 30,
    int expandDuration = 150,
    double borderRadius = 35,
    bool shouldShowPic = false,
    this.couldRemove = true,
    this.removeFunc,
    this.key,
    double width = 1,
  })  : assert(food != null),
        super(key: key) {
    this.food = food;
    this.height = ScreenTool.partOfScreenHeight(height);
    this.width = ScreenTool.partOfScreenWidth(width);
    this.detailedPaddingLeft = detailedPaddingLeft;
    this.paddingLeft = paddingLeft;
    this.paddingTop = paddingTop;
    this.paddingBottom = paddingBottom;
    this.paddingRight = paddingRight;
    this.expandDuration = expandDuration;
    this.borderRadius = borderRadius;
    this.shouldShowPic = ValueNotifier(shouldShowPic);
    this.iconKey = GlobalKey<RotateIconState>();
    this.fadeKey = GlobalKey();
    this.valueAdjusterKey = new GlobalKey<ValueAdjusterState>();
  }

  void setRemoveFunc(Function f) {
    this.removeFunc = f;
  }

  @override
  State<StatefulWidget> createState() {
    return new FoodBoxState();
  }

  ///展开详细内容
  Future<void> setShow(bool b) async {
    this.shouldShowPic.value = b;
  }
}

class FoodBoxState extends State<FoodBox>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ///是否应该展开，主要用于辅助判断展开按钮的图标旋转动画方向
  bool shouldExpand = false;

  ///图片类型，0表示使用默认图片，1表示使用拍摄获得的照片
  ///picType = 0 -> defaultPicture
  ///picType = 1 -> photo
  int picType = 0;

  ///用于显示图片的容器，特意用属性保存是为了防止刷新的时候产生闪烁
  Container pic;

  ///全局重量 点击按钮刷新组件
  int foodWeight = 50;

  ///增加和减少重量
  // void plusWeight(){
  //   setState(() {
  //     foodWeight++;
  //     widget.food.setWeight(foodWeight);
  //   });
  //
  // }
  // void minusWeight(){
  //   setState(() {
  //     if(foodWeight>1){
  //       foodWeight--;
  //       widget.food.setWeight(foodWeight);
  //     }
  //   });
  //
  // }

  @override
  void dispose() {
    super.dispose();
  }

  ///父组件更新时，重新为监听器添加回调
  @override
  void didUpdateWidget(covariant FoodBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.shouldShowPic.addListener(() {
      if (widget.shouldShowPic.value && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //给监听器添加回调
    widget.shouldShowPic.addListener(() {
      if (widget.shouldShowPic.value && mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    // ValueAdjuster valueAdjuster = ValueAdjuster<int>(valueWeight: 25,key: this.widget.valueAdjusterKey);
    // valueAdjuster.onValueChange = (){
    //   print("ValueAdjuster onValueChange");
    //   // this.totalProtein =  this.widget.valueAdjusterKey.currentState.getVal()*widget.protein/100;
    // };

    return this.getBorderBox();
  }

  Widget getBorderBox() {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: widget.expandDuration),
      width: widget.width,
      margin: EdgeInsets.only(
          bottom: 15,
          left: ScreenTool.partOfScreenWidth(0.05),
          right: ScreenTool.partOfScreenWidth(0.05)),
      child: this.getContainer(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: MyTheme.convert(ThemeColorName.ComponentBackground),
          boxShadow: [
            BoxShadow(
              blurRadius: 12, //阴影范围
              spreadRadius: 4, //阴影浓度
              color: Color(0x33000000), //阴影颜色
            )
          ]),
    );
  }

  Widget getContainer() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.paddingTop,
        ),
        this.getHeader(),
        AnimatedCrossFade(
            key: widget.fadeKey,
            firstChild: Container(
              height: 0.0,
            ),
            secondChild: this.getDetailedProperty(),
            crossFadeState: this.shouldExpand
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: widget.expandDuration))
      ],
    );
  }

  Widget getHeader() {
    return GestureDetector(
      onTap: this.clickFunc,
      child: Container(
        height: widget.height,
        child: Row(children: [
          SizedBox(width: widget.paddingLeft),
          getFoodPic(),
          SizedBox(width: 20),
          Expanded(child: getFoodName()),
          getExpandIcon(),
          SizedBox(width: widget.paddingRight)
        ]),
      ),
    );
  }

  Widget getFoodPic() {
    Image img = null;
    if (widget.shouldShowPic.value == false || widget.food.picture == null) {
      img = Image.asset(
        Food.defaultPicturePath,
        gaplessPlayback: true,
        fit: BoxFit.cover,
        width: 40,
        height: 40,
      );
    } else {
      img = Image.memory(
        base64Decode(widget.food.picture),
        gaplessPlayback: true,
        fit: BoxFit.cover,
        width: 40,
        height: 40,
      );
      this.picType = 1;
    }
    this.pic = Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipOval(
          child: img,
        ));
    return this.pic;
  }

  Widget getFoodName() {
    return Text(
      widget.food.getName(context),
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Futura",
          color: MyTheme.convert(ThemeColorName.NormalText)),
    );
  }

  Widget getExpandIcon() {
    return RotateIcon(
      icon: FontAwesomeIcons.chevronDown,
      iconColor: MyTheme.convert(ThemeColorName.NormalIcon),
      key: widget.iconKey,
      onTap: () {
        if (this.shouldExpand) {
          this.shouldExpand = false;
        } else {
          this.shouldExpand = true;
        }
        setState(() {});
      },
    );
  }

  //TODO: 部分食物数据还是静态值，需要修改
  Widget getDetailedProperty() {
    ValueAdjuster valueAdjuster = ValueAdjuster<int>(
        shouldFirstValueChange: true,
        initValue: 10,
        valueWeight: 10,
        key: this.widget.valueAdjusterKey,
        upper: 300,
        lower: 10);
    valueAdjuster.onValueChange = () {
      setState(() {
        print("ValueAdjuster onValueChange");
        this.foodWeight = this.widget.valueAdjusterKey.currentState.getVal();
        widget.food.setWeight(foodWeight);
      });
    };
    List<Widget> col = [
      this.propertyLine("Calorie", widget.food.getCaloriePerUnit()),
      this.propertyLine("Fat", widget.food.getFatPerUnit()),
      this.propertyLine("Protein", widget.food.getProteinPerUnit()),
      this.propertyLine("Carbohydrate", widget.food.getCarbohydratePerUnit()),
      this.propertyLine("Weight", foodWeight.toString() + "g"),
    ];
    if (widget.couldRemove) {
      col.addAll([
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomButton(
              firstColorName: ThemeColorName.Error,
              text: "Remove",
              width: 0.35,
              tapFunc: () {
                widget.removeFunc();
              },
            ),
            valueAdjuster,
          ],
        )
      ]);
    }
    col.add(SizedBox(
      height: widget.paddingBottom,
    ));
    return Column(children: col);
  }

  Widget propertyLine(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.detailedPaddingLeft,
        ),
        Expanded(
          child: Text(name,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Futura",
                  color: MyTheme.convert(ThemeColorName.NormalText))),
        ),
        Text(
          value,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: MyTheme.convert(ThemeColorName.NormalText)),
        ),
        SizedBox(
          width: widget.paddingRight,
        )
      ],
    );
  }

  void clickFunc() {
    if (this.shouldExpand) {
      this.shouldExpand = false;
    } else {
      this.shouldExpand = true;
    }
    (widget.iconKey.currentWidget as RotateIcon).rotate();
    this.setState(() {});
  }

  @override
  bool get wantKeepAlive => false;
}

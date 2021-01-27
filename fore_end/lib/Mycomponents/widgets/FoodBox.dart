import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/ScreenTool.dart';
import 'dart:math' as math;

///用于显示检测到食物后，展示食物数据的组件
class FoodBox extends StatefulWidget {
  ///未提供食物图片，或者未加载图片时，采用的默认图片
  static const String defaultPicturePath = "image/defaultFood.png";

  ///控制是否需要加载食物图片，一般用于滚动组件
  ValueNotifier<bool> shouldShowPic;

  ///该组件展示的食物
  Food food;

  ///食物的图片
  String picture;

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

  FoodBox(
      {@required String picture = "",
      @required Food food,
      double height = 60,
      double detailedPaddingLeft = 30,
      double paddingLeft = 10,
      double paddingBottom = 50,
      double paddingTop = 0,
      double paddingRight = 30,
      int expandDuration = 150,
      double borderRadius = 35,
        bool shouldShowPic = false,
      double width = 1})
      : assert(food != null) {
    this.food = food;
    this.picture = picture;
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

class FoodBoxState extends State<FoodBox> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {

  ///是否应该展开，主要用于辅助判断展开按钮的图标旋转动画方向
  bool shouldExpand = false;

  ///图片类型，0表示使用默认图片，1表示使用拍摄获得的照片
  ///picType = 0 -> defaultPicutre
  ///picType = 1 -> photo
  int picType = 0;

  ///控制按钮旋转角度的动画
  TweenAnimation<double> angleAnimation = new TweenAnimation<double>();

  ///用于显示图片的容器，特意用属性保存是为了防止刷新的时候产生闪烁
  Container pic;

  ///父组件更新时，重新为监听器添加回调
  @override
  void didUpdateWidget(covariant FoodBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.shouldShowPic.addListener(() {
      if(widget.shouldShowPic.value && mounted){
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //初始化动画
    this.angleAnimation.initAnimation(0, math.pi, widget.expandDuration, this,
            () {
          setState(() {});
        });

    //给监听器添加回调
    widget.shouldShowPic.addListener(() {
      if(widget.shouldShowPic.value && mounted){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return this.getBorderBox();
  }

  Widget getBorderBox() {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: widget.expandDuration),
      width: widget.width,
      margin: EdgeInsets.only(bottom: 15,left: ScreenTool.partOfScreenWidth(0.05),right: ScreenTool.partOfScreenWidth(0.05)),
      child: this.getContainer(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Colors.white,
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
    if (this.pic != null){
      if(widget.shouldShowPic.value && this.picType == 0){
        this.pic = null;
      }else{
        return this.pic;
      }
    }else{
      this.picType = 0;
    }
    ImageProvider img = null;
    if(widget.shouldShowPic.value == false){
      img = AssetImage(FoodBox.defaultPicturePath);
    }else{
      if (widget.picture != "" && widget.picture != null) {
        img = MemoryImage(base64Decode(widget.picture));
        this.picType = 1;
      }
    }
    this.pic = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: img,
          fit: BoxFit.cover,
        ),
      ),
    );
    return this.pic;
  }

  Widget getFoodName() {
    return Text(
      widget.food.name,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: "Futura",
          color: Colors.black),
    );
  }

  Widget getExpandIcon() {
    return Transform.rotate(
          angle: this.angleAnimation.getValue(),
          child: Icon(
            FontAwesomeIcons.chevronDown,
            color: Colors.blue,
          ),
        );
  }

  //TODO: 部分食物数据还是静态值，需要修改
  Widget getDetailedProperty() {
    return Column(
      children: [
        this.propertyLine("calorie", widget.food.getCalorie()),
        this.propertyLine("VC", "61mg"),
        this.propertyLine("VD", "39mg"),
        this.propertyLine("VD", "39mg"),
        this.propertyLine("water", "721mg"),
        SizedBox(
          height: widget.paddingBottom,
        )
      ],
    );
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
                  color: Colors.black)),
        ),
        Text(
          value,
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontFamily: "Futura",
              color: Colors.black),
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
      this.angleAnimation.reverse();
    } else {
      this.shouldExpand = true;
      this.angleAnimation.forward();
    }
  }

  @override
  bool get wantKeepAlive => false;
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/Food.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/MyTool/util/ScreenTool.dart';
import 'dart:math' as math;
import 'package:fore_end/Mycomponents/buttons/CustomButton.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';
import 'package:fore_end/Mycomponents/buttons/RotateIcon.dart';
import 'package:fore_end/Pages/FoodDetailsPage.dart';

///用于显示检测到食物后，展示食物数据的组件
class RecommendBox extends StatefulWidget {
  ///未提供食物图片，或者未加载图片时，采用的默认图片
  static const String defaultPicturePath = "image/defaultFood.png";

  ///控制是否需要加载食物图片，一般用于滚动组件
  ValueNotifier<bool> shouldShowPic;

  ///该组件展示的食物
  Food food;
  String title;

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


  GlobalKey<RecommendBoxState> key;
  GlobalKey<RotateIconState> iconKey;
  GlobalKey fadeKey;

  List<Food> foods;
  bool isSuitable;
  String foodName;


  RecommendBox({
    // @required Food food,
    String title = "推荐的相关食物",
    double height = 60,
    double detailedPaddingLeft = 30,
    double paddingLeft = 10,
    double paddingBottom = 25,
    double paddingTop = 0,
    double paddingRight = 30,
    int expandDuration = 150,
    double borderRadius = 10,
    bool shouldShowPic = false,
    @required this.foods,
    bool isSuitable=false,
    String foodName="hamburger",

    this.key,
    double width = 1,
  })  :
        super(key:key) {
    // this.food = food;
    this.foodName=foodName;
    this.isSuitable=isSuitable;
    this.height = ScreenTool.partOfScreenHeight(height);
    this.width = ScreenTool.partOfScreenWidth(width);
    this.detailedPaddingLeft = detailedPaddingLeft;
    this.paddingLeft = paddingLeft;
    this.paddingTop = paddingTop;
    this.paddingBottom = paddingBottom;
    this.paddingRight = paddingRight;
    this.expandDuration = expandDuration;
    this.borderRadius = borderRadius;
    this.title=title;

  }


  @override
  State<StatefulWidget> createState() {
    return new RecommendBoxState();
  }

  ///展开详细内容
  Future<void> setShow(bool b) async {
    this.shouldShowPic.value = b;
  }
}

class RecommendBoxState extends State<RecommendBox>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ///是否应该展开，主要用于辅助判断展开按钮的图标旋转动画方向
  bool shouldExpand = false;

  ///图片类型，0表示使用默认图片，1表示使用拍摄获得的照片
  ///picType = 0 -> defaultPicture
  ///picType = 1 -> photo
  int picType = 0;
  ///用于显示图片的容器，特意用属性保存是为了防止刷新的时候产生闪烁
  Container pic;
  @override
  void dispose() {
    super.dispose();
  }

  ///父组件更新时，重新为监听器添加回调
  @override
  void didUpdateWidget(covariant RecommendBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // widget.shouldShowPic.addListener(() {
    //   if (widget.shouldShowPic.value && mounted) {
    //     setState(() {});
    //   }
    // });
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
      margin: EdgeInsets.only(
          // bottom: 15,
          left: ScreenTool.partOfScreenWidth(0.025),
          right: ScreenTool.partOfScreenWidth(0.025)),
      child: this.getContainer(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color:MyTheme.convert(ThemeColorName.ComponentBackground),
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
        height: 40,);
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
        )
    );
    return this.pic;
  }

  Widget getFoodName() {
    return Text(
      widget.title,
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
      icon:  FontAwesomeIcons.chevronDown,
      iconColor: Colors.blue,
      key: widget.iconKey,
      onTap: (){
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
    // List<Widget> col = [
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: Text("评价：这个食物"+this.widget.foodName+"不适合您的计划[减肥],建议选择下面的推荐食物.",
                // overflow: ,
                softWrap: true,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Futura",
                    color: MyTheme.convert(ThemeColorName.NormalText))),

          ),
          Container(
            height: 70,
            margin: EdgeInsets.only(left: 30,right: 30),
            // padding: EdgeInsets.only(left: 1,),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: this.widget.foods.length,
                itemBuilder: (BuildContext ctx, int idx) {
                  GestureDetector foodImage = GestureDetector(
                    child: Image.memory( base64.decode(this.widget.foods[idx].picture),height:45, width:45, fit: BoxFit.fill, gaplessPlayback:true, ),
                    onTap:(){
                      ///点击食物图片会自动跳转
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FoodDetails(currentFood: this.widget.foods[idx],)));
                      print("click the food"+ idx.toString());
                    },
                  );
                  return Container(
                      margin: EdgeInsets.only(right: 10,),
                      child: foodImage);
                }),
          ),

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

  //控制是否可以展开
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

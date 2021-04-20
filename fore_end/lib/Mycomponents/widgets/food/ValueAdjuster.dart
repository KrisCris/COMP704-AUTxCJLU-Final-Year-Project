import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';
import 'package:fore_end/Mycomponents/buttons/CustomIconButton.dart';

class ValueAdjuster<T extends num> extends StatefulWidget {
  ///valueWeight是加减的值的单位   它的值不会变化 所以放在stf里面
  ///T继承自num 这样就可以定义泛型变量，外部创建这个widget就可以定义变量的类型
  T valueWeight;

  ///onValueChange是当变量发生改变时调用的方法
  Function onValueChange;

  ValueAdjuster({
    T valueWeight,
    Function onValueChange,
    Key key,
  }) : super(key: key) {
    ///外部通过Key来调用这个widget的state和各种变量   具体用法是在FoodDetailedPage  定义一个globalkey 然后来获取这个widget的所有信息
    ///GlobalKey<ValueAdjusterState> valueAdjusterKey;
    ///this.valueAdjusterKey=new GlobalKey<ValueAdjusterState>();
    ///this.widget.valueAdjusterKey.currentState.getVal();
    this.valueWeight = valueWeight;
    this.onValueChange=onValueChange;
  }

  @override
 ValueAdjusterState createState(){
   return ValueAdjusterState();

  }
}

class ValueAdjusterState<T extends num> extends State<ValueAdjuster<T>> {
  ///然后也是T泛型 所以ValueAdjusterStateState也要为写上泛型，包括继承的State里也要标记是<ValueAdjuster<T>> 才能是指定ValueAdjuster<T>
  ///指定同一个<T>  可以让整体的变量类型保持一致
  ///valueNotifier 是一个会改变的值，所以放到state里面声明，主要是被加减的valueNotifier.value的值
  ///ValueNotifier这个类型的变量，当发生改变，可以通过valueNotifier.addListener来监听改变 然后进行操作方法
  ValueNotifier<T> valueNotifier;

  T getVal(){
    return valueNotifier.value;
  }
  @override
  void didUpdateWidget(covariant ValueAdjuster<T> oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///初始化valueNotifier为上面的类型，并且初始化它的值
    ///并且监听变化
    this.valueNotifier = new ValueNotifier<T>(this.widget.valueWeight);
    this.valueNotifier.addListener(this.widget.onValueChange);
  }

  void plusWeight() {
    setState(() {
      ///增加或减少的是valueNotifier.value的值
      this.valueNotifier.value += this.widget.valueWeight;
    });
  }

  void minusWeight() {
    setState(() {
      if (this.valueNotifier.value >= this.widget.valueWeight) {
        this.valueNotifier.value -= this.widget.valueWeight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(
          icon: FontAwesomeIcons.minus,
          buttonSize: 40,
          sizeChangeWhenClick: true,
          backgroundSizeChange: true,
          onClick: () {
            minusWeight();
          },
        ),
        SizedBox(
          width: 20,
        ),
        ///有可能double会输出多余的0，刚刚测试是不会的 如果是double那么小数点只取决于给定的valueWeight

        Text(this.valueNotifier.value.toString(),
            style: TextStyle(
                fontSize: 20,
                color: MyTheme.convert(ThemeColorName.NormalText),
                fontFamily: "Futura",
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold)
        ),
        SizedBox(
          width: 20,
        ),
        CustomIconButton(
          sizeChangeWhenClick: true,
          backgroundSizeChange: true,
          icon: FontAwesomeIcons.plus,
          buttonSize: 40,
          onClick: () {
            plusWeight();
          },
        ),
      ],
    );
  }
}

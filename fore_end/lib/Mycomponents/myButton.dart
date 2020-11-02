import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fore_end/MyAnimation/MyAnimation.dart';
import 'package:fore_end/MyTool/screenTool.dart';
import 'package:fore_end/MyTool/MyTheme.dart';
import 'package:fore_end/interface/Themeable.dart';

class MyButton extends StatefulWidget {
  final MyTheme theme;

  ///The radius of border
  final double radius;

  ///The background color of button
  Color bgColor;

  ///The text color of button
  Color textColor;

  ///Function to be executed when button being
  ///clicked
  Function tapFunc;

  ///Function to be executed when button being
  ///double clicked
  Function doubleTapFunc;

  ///Text displayed on button
String text;

  ///Text font size
 double fontsize;

  ///whether text is bold or not
  final bool isBold;

  ///width of the button. When this value <=1
  ///it will be regard as the ratio of screen
  ///width. When this value > 1, it will be
  ///regard as pixel number of button width
  double width;

  ///height of the button. Same as width
  double height;

  double leftMargin;
  double rightMargin;
  double topMargin;
  double bottomMargin;

  ///when length change, button fix at center(0),left(1) or right(2)
  int sizeChangeMode;
  /// the opacity that flash animation start at
  double startOpac;
  ///the opacity that flash animation end at
  double endOpac;
  ///the color of flash cover
  Color flashColor;

  ///fluctuate duration
  int flucDura;
  ///color change duration
  int colorDura;
  ///duration of flash animation, use millionSecond
  int flashDura;
  ///duration of length change animation
  int lengthDura;

  MyButtonState state;
  ComponentReactState firstReactState;
  ComponentThemeState firstThemeState;

  MyButton(
      {this.text,
        @required this.theme,
      this.fontsize = 18,
        this.sizeChangeMode=0,
      this.isBold = false,
      this.radius = 30,
      this.width = 120,
      this.height = 40,
        this.leftMargin = 0,
        this.rightMargin = 0,
        this.topMargin = 0,
        this.bottomMargin = 0,
      this.startOpac = 0,
      this.endOpac = 0.5,
      this.flashDura = 200,
      this.flucDura = 200,
      this.colorDura = 200,
        this.lengthDura = 200,
      this.flashColor = Colors.white,
      this.tapFunc = null,
      this.doubleTapFunc = null,
        this.firstThemeState = ComponentThemeState.normal,
        this.firstReactState = ComponentReactState.able,
      Key key})
      : super(key: key) {
    this.width = ScreenTool.partOfScreenWidth(this.width);
    this.height = ScreenTool.partOfScreenHeight(this.height);
    this.textColor = this.theme.lightTextColor;
    // if (this.disabled) this.firstDisabled = true;
  }
  @override
  State<StatefulWidget> createState() {
    this.state = MyButtonState(this.firstReactState,this.firstThemeState);
    return this.state;
  }
  bool isMonted(){
    return this.state.mounted;
  }
  void setDisable(bool d){
    if(d){
      this.state.setReactState(ComponentReactState.disabled);
    }else{
      this.state.setReactState(ComponentReactState.able);
    }
  }
  void setWidth(double len){
    double newWidth = ScreenTool.partOfScreenWidth(len);
    this.state.lengthAnimation.initAnimation(this.width,
          newWidth, this.lengthDura, this.state,
            () { this.state.setState(() {});});
    this.state.lengthAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        this.width = newWidth;
      }
    });
    this.state.lengthAnimation.beginAnimation();
  }
  void refresh(){
    this.state.refresh();
  }
  bool isMounted(){
    return this.state.mounted;
  }
  bool isEnable(){
    return this.state.reactState != ComponentReactState.disabled;
  }

  ComponentThemeState getThemeState(){
    return this.state.themeState;
  }
  ComponentReactState getReactState(){
    return this.state.reactState;
  }
}

class MyButtonState extends State<MyButton> with TickerProviderStateMixin, Themeable {
  TweenAnimation flashAnimation = new TweenAnimation();
  TweenAnimation lengthAnimation = new TweenAnimation();
  FluctuateTweenAnimation fluctuateAnimation = new FluctuateTweenAnimation();
  ColorTweenAnimation colorAnimation = new ColorTweenAnimation();
  bool isTap = false;
  double firstWidth;

  MyButtonState(ComponentReactState rea, ComponentThemeState the):super(){
    this.reactState = rea;
    this.themeState = the;
  }
  void initBgColor(){
    //as button, only disabled state need set color
    if(reactState == ComponentReactState.disabled){
      widget.bgColor = widget.theme.getReactColor(reactState);
    }else{
      //if not disabled state, just get the theme color
      widget.bgColor = widget.theme.getThemeColor(this.themeState);
    }
  }
  @override
  void initState() {
    super.initState();
    this.initBgColor();
    this.firstWidth = widget.width;
    this.fluctuateAnimation.initAnimation(null, null, widget.flashDura, this,
        () {
      setState(() {});
    });
    this.lengthAnimation.initAnimation(widget.width, widget.width,
        widget.lengthDura, this,  () {setState(() {});});

    this.colorAnimation.initAnimation(
        widget.bgColor, widget.bgColor, widget.colorDura, this, () {
      setState(() {});
    });

    this.flashAnimation.initAnimation(
        widget.startOpac, widget.endOpac, widget.flashDura, this, () {
      setState(() {});
    });
    this.flashAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!isTap) {
          this.flashAnimation.reverseAnimation();
        }
      }
    });
  }

  @override
  void dispose() {
    this.colorAnimation.dispose();
    this.lengthAnimation.dispose();
    this.fluctuateAnimation.dispose();
    this.flashAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
        offset: Offset(this.fluctuateAnimation.getValue() + this.calculatePosition(), 0),
        child: GestureDetector(
            onDoubleTap: (){
              if(this.reactState == ComponentReactState.disabled)return;

              if(widget.doubleTapFunc != null){
                widget.doubleTapFunc();
              }else if(widget.tapFunc !=null){
                this.flashAnimation.beginAnimation();
                widget.tapFunc();
              }
            },
            onTapDown: (TapDownDetails tpd) {
              if (this.reactState == ComponentReactState.disabled) {
                this.fluctuateAnimation.forward();
              } else {
                this.isTap = true;
                this.flashAnimation.beginAnimation();
              }
            },
            onTapUp: (TapUpDetails tpu) {
              if (this.reactState == ComponentReactState.disabled) {
                return;
              }

              this.isTap = false;
              this.flashAnimation.reverseAnimation();
              if(widget.tapFunc != null){
                widget.tapFunc();
              }
            },
            onTapCancel: () {
              if (this.reactState == ComponentReactState.disabled) return;

              this.isTap = false;
              this.flashAnimation.reverseAnimation();
            },
            child: this.buttonUI));
  }

  Widget get buttonUI {
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
      this.buttonShape,
      this.buttonCover
    ]);
  }
  Widget get buttonShape {
    return Container(
      width: this.lengthAnimation.getValue(),
      height: widget.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: this.colorAnimation.getValue()
      ),
      margin: EdgeInsets.only(
          left: widget.leftMargin,
          right: widget.rightMargin,
          top: widget.topMargin,
          bottom: widget.bottomMargin
      ),
      child: Center(
        child: Text(
          widget.text,
          textDirection: TextDirection.ltr,
          style: TextStyle(
              fontSize: widget.fontsize,
              color: widget.textColor,
              decoration: TextDecoration.none,
              fontWeight:
              widget.isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    );
  }
  Widget get buttonCover {
    return Opacity(
      opacity: this.flashAnimation.getValue(),
      child: Container(
        width: this.lengthAnimation.getValue(),
        height: widget.height,
        margin: EdgeInsets.only(
            left: widget.leftMargin,
            right: widget.rightMargin,
            top: widget.topMargin,
            bottom: widget.bottomMargin
        ),
        decoration: new BoxDecoration(
          color: widget.flashColor,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),

        ),
      ),
    );
  }

  double calculatePosition(){
    if(widget.sizeChangeMode == 0)return 0;
    else if(widget.sizeChangeMode == 1){
      double gap = this.firstWidth - this.lengthAnimation.getValue();
      return -(gap/2);
    }else if(widget.sizeChangeMode == 2){
      double gap = this.firstWidth - this.lengthAnimation.getValue();
      return gap/2;
    }
  }
  @override
  void setReactState(ComponentReactState rea) {
    //do nothing when state not change
    if(this.reactState == rea)return;
    Color newColor = null;
    //as a button, only disable state should tackle
    if(this.reactState == ComponentReactState.disabled){
    //from disable to able
      newColor = widget.theme.getThemeColor(this.themeState);
    }else if(rea == ComponentReactState.disabled){
    //from able to disable
      newColor = widget.theme.getReactColor(rea);
    }
    //update state
    this.reactState = rea;

    //update color animation
    this.colorAnimation.initAnimation(widget.bgColor, newColor, widget.colorDura,
        this, () {setState((){});});
    this.colorAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.bgColor = newColor;
      }
    });
    this.colorAnimation.beginAnimation();
  }

  @override
  void setThemeState(ComponentThemeState the) {
    //do nothing when state not change
    if(this.themeState == the)return;
    //update the state
    this.themeState = the;
    //if button disabled, don't update color animation
    if(this.reactState == ComponentReactState.disabled)return;
    //update color animation
    Color newColor = widget.theme.getThemeColor(this.themeState);
    this.colorAnimation.initAnimation(widget.bgColor, newColor, widget.colorDura,
        this, () {setState((){});});
    this.colorAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        widget.bgColor = newColor;
      }
    });
    this.colorAnimation.beginAnimation();
  }

  void refresh(){
    if(this.mounted)
      this.setState(() {});
  }
}

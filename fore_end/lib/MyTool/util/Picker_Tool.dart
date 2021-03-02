
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:fore_end/MyTool/util/MyTheme.dart';


const double _kPickerHeight=216.0;
const double _kItemHeigt=40.0;
// const Color _kBtnColor=Color(0xFF323232);
// const Color _kTitleColor=Color(0xFF787878);
Color _kBtnColor=MyTheme.convert(ThemeColorName.PickerToolText);
Color _kTitleColor=MyTheme.convert(ThemeColorName.PickerToolText);
const double _kTextFontSize=17.0;

///通过mealTheme来改变布局颜色，目前就是默认的白黑和下面的暗色系，true为暗色系
///目前这个组件用于 修改性别  和  选择添加食物到一日三餐
bool mealTheme=false;
Color cancelAndConfirmColor=MyTheme.convert(ThemeColorName.NormalText);
Color titleColor=MyTheme.convert(ThemeColorName.NormalText);
Color bottomBackgroundColor=MyTheme.convert(ThemeColorName.PickerToolBackground);
Color upBackgroundColor=MyTheme.convert(ThemeColorName.PickerToolBackground);
Color itemTextColor=MyTheme.convert(ThemeColorName.NormalText);


typedef _StringClickCallBack=void Function(int selectIndex,Object selectStr);
typedef _ArrayClickCallBack=void Function(List<int> selecteds,List<dynamic> strData);
typedef _DateClickCallBack=void Function(dynamic selectDateStr,dynamic selectData);


enum DateType {
  YMD, // y,m,d
  YM, // y,m
  YMD_HM, //y,m,d,hh,mm
  YMD_AP_HM, //y,m,d,ap,hh,mm

}

class JhPickerTool{
  ///这里是用来初始化mealtheme的值，让其他使用这个组件的地方都初始化一下
  static void setInitialState(){
    mealTheme=false;
  }

  //单列
  static void showStringPicker<T>(
      BuildContext context,{
        @required List<T> data,
        String title,
        int normalIndex,
        PickerDataAdapter adapter,
        @required _StringClickCallBack clickCallBack,

        bool isChangeColor=false,
      }) {

    if(isChangeColor){
      mealTheme=true;
    }

    openModalPicker(context, adapter: adapter??PickerDataAdapter(pickerdata: data,isArray: false), clickCallBack: (Picker picker,List<int> selecteds) {
      clickCallBack(selecteds[0],data[selecteds[0]]);
    }, selecteds: [normalIndex??0],title: title);
  }

  //多列
  static void showArrayPicker<T>(
      BuildContext context,{
        @required List<T> data,
        String title,
        List<int> normalIndex,
        PickerDataAdapter adapter,
        @required _ArrayClickCallBack clickCallBack,
      }) {
    openModalPicker(context, adapter: adapter??PickerDataAdapter(
        pickerdata: data,isArray: true
    ), clickCallBack: (Picker picker,List<int> selecteds) {
      clickCallBack(selecteds,picker.getSelectedValues());
    },selecteds: normalIndex,title: title);


  }

  static void openModalPicker(
      BuildContext context,{
        @required PickerAdapter adapter,
        String title,
        List<int>  selecteds,
        @required PickerConfirmCallback clickCallBack,
      }) {
    new Picker(

        ///修改背景颜色，通过mealTheme? xxx : xxx 判断，下面也是一样，所有的颜色都是下面修改
        headercolor: mealTheme?upBackgroundColor:MyTheme.convert(ThemeColorName.NormalBackground),
        backgroundColor:mealTheme?bottomBackgroundColor:MyTheme.convert(ThemeColorName.NormalBackground),

        adapter: adapter,
        title: new Text(title??"Please Select",style: TextStyle(color: mealTheme?titleColor: _kTitleColor,fontSize: _kTextFontSize),),
        selecteds: selecteds,
        cancelText: 'Cancel',
        confirmText: "Confirm",
        cancelTextStyle: TextStyle(color: mealTheme ? cancelAndConfirmColor: _kBtnColor,fontSize: _kTextFontSize),
        confirmTextStyle: TextStyle(color: mealTheme ? cancelAndConfirmColor: _kBtnColor,fontSize: _kTextFontSize),
        textAlign: TextAlign.right,
        itemExtent: _kItemHeigt,
        height: _kPickerHeight,
        selectedTextStyle: TextStyle(color: mealTheme? itemTextColor:_kBtnColor),
        onConfirm: clickCallBack
    ).showModal(context);
  }


  //日期选择器
  static void showDatePicker(
      BuildContext context,{
        DateType dateType,
        String title,
        DateTime maxValue,
        DateTime minValue,
        DateTime value,
        DateTimePickerAdapter adapter,
        @required _DateClickCallBack clickCallBack,}
      ) {
    int timeType;
    if(dateType==DateType.YM) {
      timeType=PickerDateTimeType.kYM;
    }else if(dateType==DateType.YMD_HM){
      timeType=PickerDateTimeType.kYMDHM;
    }else if(dateType==DateType.YMD_AP_HM) {
      timeType=PickerDateTimeType.kYMD_AP_HM;
    }else {
      timeType=PickerDateTimeType.kYMD;
    }
    openModalPicker(context, adapter: adapter?? DateTimePickerAdapter(
      type: timeType,
      isNumberMonth: true,
      yearSuffix: "年",
      monthSuffix: "月",
      daySuffix: "日",
      strAMPM: const["上午","下午"],
      maxValue: maxValue,
      minValue: minValue,
      value: value??DateTime.now(),
    ), title: title,
        clickCallBack: (Picker picker,List<int> selecteds){
          var time=(picker.adapter as DateTimePickerAdapter).value;
          var timeStr;
          if(dateType==DateType.YM) {
            timeStr=time.year.toString()+"年"+time.month.toString()+"月";
          }else if(dateType==DateType.YMD_HM){
            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日"+time.hour.toString()+"时"+time.minute.toString()+"分";
          }else if(dateType == DateType.YMD_AP_HM) {
            var str = formatDate(time, [am])=="AM" ? "上午":"下午";
            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日"+str+time.hour.toString()+"时"+time.minute.toString()+"分";
          }else {
            timeStr =time.year.toString()+"年"+time.month.toString()+"月"+time.day.toString()+"日";
          }
          clickCallBack(timeStr,picker.adapter.text);
        });

  }

}


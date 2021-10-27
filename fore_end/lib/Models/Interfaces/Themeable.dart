//
// import 'package:fore_end/MyTool/util/MyTheme.dart';
//
// abstract class ThemeWidgetMixIn{
//   MyTheme theme;
// }
//
// abstract class ThemeStateMixIn{
//   ComponentThemeState themeState;
//
//   ///return the old theme state
//   ComponentThemeState setNormal(){return checkThemeChange(ComponentThemeState.normal);}
//   ComponentThemeState setCorrect(){return checkThemeChange(ComponentThemeState.correct);}
//   ComponentThemeState setWarning(){return checkThemeChange(ComponentThemeState.warning);}
//   ComponentThemeState setError(){return checkThemeChange(ComponentThemeState.error);}
//
//   ///return the old theme state
//   ComponentThemeState checkThemeChange(ComponentThemeState theme){
//     if(this.themeState == theme)return theme;
//     ComponentThemeState stt = this.themeState;
//     this.themeState = theme;
//     return stt;
//   }
// }
//
// enum ComponentReactState{
//   focused,
//   unfocused,
//   disabled,
//   able
// }

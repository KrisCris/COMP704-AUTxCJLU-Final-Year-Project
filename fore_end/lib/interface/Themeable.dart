

abstract class Themeable{
  ComponentThemeState themeState;
  ComponentReactState reactState;

  void setThemeState(ComponentThemeState the);
  void setReactState(ComponentReactState rea);
}
enum ComponentThemeState{
  warning,
  error,
  correct,
  normal
}
enum ComponentReactState{
  focused,
  unfocused,
  disabled,
  able
}
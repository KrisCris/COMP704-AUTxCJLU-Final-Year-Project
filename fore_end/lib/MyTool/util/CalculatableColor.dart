import 'package:flutter/cupertino.dart';

class CalculatableColor extends Color {
  static const CalculatableColor white = CalculatableColor(0xFFFFFFFF);
  const CalculatableColor(int value) : super(value);
  static CalculatableColor transform(Color clr){
    return CalculatableColor(clr.value);
  }
  Color operator -(Color another) {
    CalculatableColor clr = CalculatableColor.transform(Color.fromARGB(this.alpha -another.alpha,
        this.red - another.red,
        this.green - another.green,
        this.blue - another.blue));
    return clr;

  }
  Color operator +(Color another) {
    int newAlpha = this._colorRangeFilter(this.alpha + another.alpha);
    int newRed = this._colorRangeFilter(this.red + another.red);
    int newGreen = this._colorRangeFilter(this.green + another.green);
    int newBlue = this._colorRangeFilter(this.blue + another.blue);

    return CalculatableColor.transform(Color.fromARGB(newAlpha, newRed, newGreen, newBlue));
  }
  Color operator *(double t) {
    int newAlpha = (this.alpha * t).round();
    int newRed = (this.red * t).round();
    int newGreen = (this.green * t).round();
    int newBlue = (this.blue * t).round();
    return CalculatableColor.transform(Color.fromARGB(newAlpha, newRed, newGreen, newBlue));
  }

  @override
  CalculatableColor withAlpha(int a) {
    return CalculatableColor.transform(Color.fromARGB(a, red, green, blue));
  }
  @override
  CalculatableColor withOpacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return this.withAlpha((255.0 * opacity).round());
  }
  int _colorRangeFilter(int val){
    if (val > 255) {
      val = 255;
    }else if(val < -255){
      val = -255;
    }
    return val;
  }
}
// class ColorChannel{
//   List<int> channels;
//   ColorChannel(int a, int r, int g, int b){
//     this.channels = [a,r,g,b];
//   }
//   ColorChannel operator +(ColorChannel ano){
//     return ColorChannel(
//       this.alpha + ano.alpha,
//       this.red + ano.red,
//       this.green + ano.green,
//       this.blue + ano.blue
//     );
//   }
//   ColorChannel operator *(double t) {
//     int newAlpha = (this.alpha * t).round();
//     int newRed = (this.red * t).round();
//     int newGreen = (this.green * t).round();
//     int newBlue = (this.blue * t).round();
//     return ColorChannel(newAlpha, newRed, newGreen, newBlue);
//   }
//
//   int get alpha => this.channels[0];
//   int get red => this.channels[1];
//   int get green => this.channels[2];
//   int get blue => this.channels[3];
// }
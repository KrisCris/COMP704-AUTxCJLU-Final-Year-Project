import 'package:flutter/animation.dart';

class FluctuateTween {
  double waveHigh;
  double loop;
  double cycle;
  Tween<double> tween;
  FluctuateTween({this.waveHigh, this.loop}) {
    this.cycle = 4 * waveHigh;
    this.tween = new Tween(begin: 0, end: cycle * loop);
  }

  double lerp(double d) {
    if (d % cycle < waveHigh ||
        (d % cycle > waveHigh && d % cycle < waveHigh * 3)) {
      return d % waveHigh;
    } else {
      return waveHigh - (d % waveHigh);
    }
  }

  Animation<double> animate(Animation<double> parent) {
    return this.tween.animate(parent);
  }
}

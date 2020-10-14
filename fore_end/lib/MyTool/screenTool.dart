
import 'dart:ui';


class ScreenTool{
    static Size get phisicSize => window.physicalSize;
    static double get pixRatio => window.devicePixelRatio;
    static Size get pixSize => ScreenTool.phisicSize/ScreenTool.pixRatio;

    static Size partOfScreen(double part){
      return pixSize*part;
    }

    static double partOfScreenWidth(double part){
      return part>1 ? part : pixSize.width * part;
    }
    static double partOfScreenHeight(double part){
      return part>1 ? part : pixSize.height * part;
    }
}
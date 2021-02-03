
import 'dart:ui';


class ScreenTool{
    static Size get phisicSize => window.physicalSize;
    static double get pixRatio => window.devicePixelRatio;
    static Size get pixSize => ScreenTool.phisicSize/ScreenTool.pixRatio;
    static double get topPadding => window.padding.top;
    static double get bottomPadding => window.padding.bottom;

    static Size partOfScreen(double part){
      return pixSize*part;
    }

    static double partOfScreenWidth(double part){
      if(part == null){
        print("part of Screen width received a null part value");
        return part;
      }
      return part>1 ? part : pixSize.width * part;
    }

    static double partOfScreenHeight(double part){
      if(part == null){
        print("part of Screen Height received a null part value");
        return part;
      }
      return part>1 ? part : pixSize.height * part;
    }
}
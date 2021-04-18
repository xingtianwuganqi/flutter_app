import 'package:flutter/material.dart';

class NetWorkingConfig {
  static final UrlConfig urlConfig = UrlConfig.test;
  static String baseUrl() {
    switch (urlConfig) {
      case UrlConfig.formal:
        return 'https://rescue.rxswift.cn';
      case UrlConfig.test:
        return 'https://test.rxswift.cn';
      case UrlConfig.local:
        return 'http://127.0.0.1:8000';
    }
  }
}

enum UrlConfig {
  formal,
  test,
  local
}

/// 颜色
class ColorsUtil {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColor(int hex,{double alpha = 1}){
    if (alpha < 0){
      alpha = 0;
    }else if (alpha > 1){
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16 ,
        (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0,
        alpha);
  }

  // ignore: missing_return
  static Color fromEnmu(ColorEnum value) {
    switch(value) {
      case ColorEnum.system:
        return ColorsUtil.hexColor(0xffa500);
      case ColorEnum.title:
        return ColorsUtil.hexColor(0x000000);
      case ColorEnum.content:
        return ColorsUtil.hexColor(0x292929);
      case ColorEnum.note:
        return ColorsUtil.hexColor(0x666666);
      case ColorEnum.desc:
        return ColorsUtil.hexColor(0x8b8b8b);
      case ColorEnum.mark:
        return ColorsUtil.hexColor(0x999999);
      case ColorEnum.tableBack:
        return ColorsUtil.hexColor(0xEDEDED);
      case ColorEnum.defIcon:
        return ColorsUtil.hexColor(0xF5F5F5);
      case ColorEnum.tabbar:
        return ColorsUtil.hexColor(0x515151);
      case ColorEnum.urlColor:
        return ColorsUtil.hexColor(0x4169E1);
      default:
        return ColorsUtil.hexColor(0x000000);
    }
  }
}
enum ColorEnum {
  system,
  title,
  content,
  note,
  desc,
  mark,
  tableBack,
  defIcon,
  tabbar,
  urlColor,
}

/// 字体大小
class FontUtil {
  static double fs(FontSize value) {
    switch (value) {
      case FontSize.big:
        return 20.0;
      case FontSize.title:
        return 17.0;
      case FontSize.content:
        return 15.0;
      case FontSize.desc:
        return 13.0;
      case FontSize.small:
        return 11.0;
      default:
        return 15.0;
    }
  }
}

enum FontSize {
   big,
   title,
   content,
   desc,
   small,
}





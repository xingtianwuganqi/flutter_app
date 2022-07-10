import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImagePicker {
  // 工厂方法构造函数
  factory ImagePicker() => _getInstance();

  // instance的getter方法，singletonManager.instance获取对象
  static ImagePicker get instance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static ImagePicker _instance;

  // 获取对象
  static ImagePicker _getInstance() {
    if (_instance == null) {
      // 使用私有的构造方法来创建对象
      _instance = ImagePicker._internal();
    }
    return _instance;
  }

  // 私有的命名式构造方法，通过它实现一个类 可以有多个构造函数，
  // 子类不能继承internal
  // 不是关键字，可定义其他名字
  ImagePicker._internal() {
    //初始化...
  }

  Future<List<AssetEntity>> selectAssets(context, num) async {
    AssetPickerConfig config = AssetPickerConfig(
      themeColor: Colors.white,
      maxAssets: num
    );
    final List<AssetEntity> result = await  AssetPicker.pickAssets(
        context,
      pickerConfig: config
    );
    return result;
  }
}

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
      maxAssets: num
    );
    final List<AssetEntity> result = await  AssetPicker.pickAssets(
        context,
      pickerConfig: config
    );
    return result;
  }
}

/*
事件总线
 */

//订阅者回调签名
typedef void EventCallback(arg);

class EventBus {
  //私有构造函数
  EventBus._internal();

  //保存单例
  static EventBus _singleton = EventBus._internal();

  //工厂构造函数
  factory EventBus()=> _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _emap = Map<Object, List<EventCallback>>();

  //添加订阅者
  void on(eventName, EventCallback f) {
    _emap[eventName] ??=  <EventCallback>[];
    _emap[eventName].add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback f]) {
    var list = _emap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _emap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName, [arg]) {
    var list = _emap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}


//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
var bus = EventBus();
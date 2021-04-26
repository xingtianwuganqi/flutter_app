import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Login/LoginPage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';


class UserManager {
  // 工厂模式
  factory UserManager() =>_getInstance();
  static UserManager get instance => _getInstance();
  static UserManager _instance;

  UserManager._internal() {
  // 初始化

  }

  static UserManager _getInstance() {
    if (_instance == null) {
      _instance = new UserManager._internal();
    }
    return _instance;
  }

  UserInfoModel userInfo;
  String get token => userInfo?.token ?? "";
  bool get isLogin => (userInfo?.token?.length ?? 0) > 0;

  Future getUserInfo() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String data = prefs.getString('userInfo');
      Map json = jsonDecode(data);
      userInfo = UserInfoModel.fromJson(json);
    }catch(e){
      print('error');
      print(e);
    }

  }

  void saveUerInfo(UserInfoModel data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data != null) {
      String jsonStringA = jsonEncode(data.toJson());
      prefs.setString("userInfo", jsonStringA);
      print('jsonStringA');
      print(jsonStringA);
      userInfo = data;
    }else{
      return;
    }
  }

  void logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    UserManager.instance.userInfo = null;
  }
}

// class ProfileChangeNotifier extends ChangeNotifier {
//   UserInfoModel get _userInfo => UserManager.instance.userInfo;
//
//   @override
//   void notifyListeners() {
//     // Global.saveProfile(); //保存Profile变更
//     super.notifyListeners(); //通知依赖的Widget更新
//   }
// }

class UserProviderModel extends ChangeNotifier  {
  UserInfoModel _user;
  UserProviderModel(this._user);
  UserInfoModel get user => _user;
  bool get isLogin => (_user?.token?.length ?? 0) > 0;
  set user(UserInfoModel value) {
    _user = value;
    UserManager.instance.userInfo = _user;
    UserManager.instance.saveUerInfo(_user);
    print('_user');
    print(_user);
    notifyListeners();
  }
}

// class ProfileChangeNotifier extends ChangeNotifier {
//   Profile get _profile => Global.profile;
//
//   @override
//   void notifyListeners() {
//     Global.saveProfile(); //保存Profile变更
//     super.notifyListeners(); //通知依赖的Widget更新
//   }
// }

lazyAuthToDoThings(context, obj) async{
  if (UserManager.instance.isLogin) {
    await obj();
  }else{
    await Navigator.push(context, MaterialPageRoute(builder: (context){
      return LoginWidget();
    }));
  }
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
      case ColorEnum.iconColor:
        return ColorsUtil.hexColor(0x707070);
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
  iconColor
}

/// 字体大小
class FontUtil {
  static double fs(FontSize value) {
    switch (value) {
      case FontSize.big:
        return 20.0;
      case FontSize.title:
        return 16.0;
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


class ToolConfig {
  static String random({int length=8}) {
    String alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    int strlenght = length; /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /*
  var d1 = new DateTime(2018, 10, 1);
var d2 = new DateTime(2018, 10, 10);
var difference = d1.difference(d2);
print([difference.inDays, difference.inHours]);//d1与d2相差的天数与小时

   */
  static String timeT(String time) {
    if (time.length > 19 ) {
      // var d1 = new DateTime(2021,4,10,10,17,25);
      var d1 = DateTime.now();
      var d2 = DateTime.parse(time);
      var difference = d1.difference(d2);
      var firstTime = DateTime.parse(time).toString().substring(0,19);
      if (difference.inDays > 2) {
        return firstTime;
      }else if (difference.inDays > 1) {
        return '前天' + firstTime.substring(10);
      }else if (difference.inDays > 0) {
        return '昨天' + firstTime.substring(10);
      }else if (difference.inHours > 0) {
        return '${difference.inHours}小时前';
      }else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}分钟前';
      }else if (difference.inSeconds > 0) {
        return '${difference.inSeconds}秒前';
      }else{
        return firstTime;
      }
    }else{
      return time;
    }
  }
}

/// 无参数
// typedef ActionNoParam = void Function();

/// 空白页
// ignore: must_be_immutable
class EmptyPage extends StatelessWidget {
  String title;
  String desc;
  Function() obj;
  EmptyPage(this.obj,{this.title='暂无数据',this.desc='请点击重试'});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: GestureDetector(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,style: TextStyle(
                color: ColorsUtil.fromEnmu(ColorEnum.content),
                fontSize: FontUtil.fs(FontSize.content),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Text(desc,style: TextStyle(
                color: ColorsUtil.fromEnmu(ColorEnum.desc),
                fontSize: FontUtil.fs(FontSize.desc),
              ),
              ),
            ],
          ),
        ),
        onTap: () {
          obj();
        },
      )
    );
  }
}
/// 第一次加载的widget
Widget FirstLoadWidget() {
  return SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,);
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/Login/LoginPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/MessageModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'homepage/HomePage.dart';
import 'Message/MessagePage.dart';
import 'package:flutter_720yun/UserInfo/UserInfoPage.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoPage.dart';

class tabbar extends StatefulWidget {

  @override
  tabbarState createState() {
    // TODO: implement createState
    return new tabbarState();
  }
}

class tabbarState extends State<tabbar> {
  int _selectedIndex = 0;
  int _unreadNum = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _authUnreadMsgNetworking();
    _loadConfig();

    pages.add(HomePage());
    pages.add(ShowInfoPageWidget());
    pages.add(MessagePage(changed: (value){
      _unreadNum = value;
      setState(() {

      });
    },));
    pages.add(UserInfoWidget());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: IndexedStack(index: _selectedIndex,children: pages,),
      bottomNavigationBar: bottomTabbars()
    );
  }

  Widget bottomTabbars() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        // ignore: deprecated_member_use
        BottomNavigationBarItem(icon: _selectedIndex == 0 ?
        Image.asset('assets/icons/icon_tabbar_cat_se.png',width: 25,height: 25) :
        Image.asset('assets/icons/icon_tabbar_cat_un.png', width: 25, height: 25,),
          // ignore: deprecated_member_use
          title: Text("首页"),
        ),
        BottomNavigationBarItem(icon: _selectedIndex == 1 ?
        Image.asset('assets/icons/icon_tabbar_dog_se.png',width: 25,height: 25) :
        Image.asset('assets/icons/icon_tabbar_dog_un.png', width: 25, height: 25,)
            // ignore: deprecated_member_use
            ,title: Text("发现")),

        BottomNavigationBarItem(icon: unreadSelectIcon(_selectedIndex == 2)
            // _selectedIndex == 2 ?
            // Image.asset('assets/icons/icon_tabbar_msg_se.png',width: 25,height: 25) :
            // Image.asset('assets/icons/icon_tabbar_msg_un.png', width: 25, height: 25,)
            // ignore: deprecated_member_use
            ,title: Text("消息")),
        BottomNavigationBarItem(icon: _selectedIndex == 3 ?
        Image.asset('assets/icons/icon_tabbar_mi_se.png',width: 25,height: 25) :
        Image.asset('assets/icons/icon_tabbar_mi_un.png', width: 25, height: 25,),
            // ignore: deprecated_member_use
            title: Text("我的"))
      ],
      currentIndex: _selectedIndex,
      fixedColor: ColorsUtil.fromEnmu(ColorEnum.system),
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: ColorsUtil.hexColor(0x707070),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 25,
      elevation: 2.0,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget unreadSelectIcon(bool isSelect) {
    var num = "";
    if (_unreadNum > 0 && _unreadNum < 99) {
      num = '$_unreadNum';
    }else{
      num = '...';
    }
    return Stack(
      children: [
        isSelect ?
        Image.asset('assets/icons/icon_tabbar_msg_se.png',width: 25,height: 25):
        Image.asset('assets/icons/icon_tabbar_msg_un.png', width: 25, height: 25,),
        Positioned(
          child: _unreadNum > 0 ? Container(
            height: 16,
            width: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.redAccent,
            ),
            child: Text(num,style: TextStyle(color: Colors.white,fontSize: 10),),
          ) : Container(color: Colors.transparent,width: 2,height: 2,),
          top: 0,
          right: 0,
        )
      ],
    );
  }

  // Future<Null> _authUnreadMsgNetworking() async{
  //   final url = NetWorkingConfig.path(NetPath.authUnreadMsg);
  //   var dic = paramDic;
  //   await NetWorking.formDataPost(url, formData, (data) {
  //     print('unread');
  //     print(data);
  //     if (data['code'] == 200) {
  //       var model = UnreadModel.fromJson(data['data']);
  //       _unreadNum = (model.sys_unread ?? 0) + (model.collec_unread ?? 0) + (model.like_unread ?? 0) + (model.com_unread ?? 0);
  //       setState(() {
  //
  //       });
  //     }
  //   }, (error) {
  //
  //   });
  // }

  void _loadConfig() {

    if (NetWorkingConfig.urlConfig == UrlConfig.formal) {
      Printer.enable = true;
    }else{
      Printer.enable = true;
    }

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorColor = ColorsUtil.fromEnmu(ColorEnum.system)
      ..indicatorSize = 40.0
      ..radius = 10.0
      ..progressColor = ColorsUtil.fromEnmu(ColorEnum.system)
      ..backgroundColor = Colors.black54
      ..textColor = Colors.white
      ..lineWidth = 3
      ..toastPosition = EasyLoadingToastPosition.center
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

}
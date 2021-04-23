import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/Login/LoginPage.dart';
// import 'homepage/findpage.dart';
import 'homepage/HomePage.dart';
// import 'homepage/MyPage.dart';
import 'homepage/MessagePage.dart';
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

  List<Widget> pages = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// 先读取数据
    UserManager.instance.getUserInfo();
    pages.add(HomePage());
    pages.add(ShowInfoPageWidget());
    pages.add(MessagePage());
    pages.add(UserInfoWidget());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:
        IndexedStack(index: _selectedIndex,children: pages,),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: _selectedIndex == 0 ? Image.asset('assets/icons/icon_tabbar_cat_se.png') : Image.asset('assets/icons/icon_tabbar_cat_un.png',
            width: 25,
            // ignore: deprecated_member_use
            height: 25,),title: Text("首页")),
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: _selectedIndex == 1 ? Image.asset('assets/icons/icon_tabbar_dog_se.png') : Image.asset('assets/icons/icon_tabbar_dog_un.png',
            width: 25,
            // ignore: deprecated_member_use
            height: 25,),title: Text("发现")),
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: _selectedIndex == 2 ? Image.asset('assets/icons/icon_tabbar_msg_se.png') : Image.asset('assets/icons/icon_tabbar_msg_un.png',
            width: 25,
    // ignore: deprecated_member_use
            height: 25,),title: Text("消息")),
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: _selectedIndex == 3 ? Image.asset('assets/icons/icon_tabbar_mi_se.png') : Image.asset('assets/icons/icon_tabbar_mi_un.png',
            width: 25,
    // ignore: deprecated_member_use
            height: 25,),title: Text("我的"))
        ],
        currentIndex: _selectedIndex,
        fixedColor: ColorsUtil.fromEnmu(ColorEnum.system),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: ColorsUtil.hexColor(0x707070),
        elevation: 2.0,
        onTap: _onItemTapped,
      ),

    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
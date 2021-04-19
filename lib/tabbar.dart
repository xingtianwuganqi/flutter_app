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
    pages.add(HomePage());
    pages.add(ShowInfoPageWidget());
    pages.add(MessagePage());
    pages.add(UserInfoWidget());

    UserManager.instance.getUserInfo();
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
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("首页")),
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: Icon(Icons.label_important),title: Text("发现")),
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: Icon(Icons.message),title: Text("消息")),
          // ignore: deprecated_member_use
          BottomNavigationBarItem(icon: Icon(Icons.school),title: Text("我的"))
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
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
import 'package:flutter/material.dart';
import 'homepage/findpage.dart';
import 'homepage/HomePage.dart';
import 'homepage/MyPage.dart';
import 'homepage/MessagePage.dart';

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
    pages.add(findpage());
    pages.add(MessagePage());
    pages.add(MyPage());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:
        IndexedStack(index: _selectedIndex,children: pages,),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("首页")),
          BottomNavigationBarItem(icon: Icon(Icons.label_important),title: Text("发现")),
          BottomNavigationBarItem(icon: Icon(Icons.message),title: Text("消息")),
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
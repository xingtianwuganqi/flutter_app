import 'package:flutter/material.dart';
import 'package:flutter_720yun/UserInfo/RescuePublishPage.dart';
import 'package:flutter_720yun/UserInfo/ShowPublishPage.dart';

class UserPublishWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserPublishState();
  }
}

class UserPublishState extends State<UserPublishWidget> {

  List<String> tabs = ["我发布的领养","我发布的秀宠"];
  TabController _tabController; //需要定义一个Controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 120,
          height: 44,
          child: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
        elevation: 0.5,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RescuePublishWidget(),
          ShowPublishWidget(),
        ],
      ),
    );
  }
}
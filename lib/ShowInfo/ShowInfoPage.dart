import 'package:flutter/material.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoListPage.dart';
import '../ShowInfo/GambitListPage.dart';
class ShowInfoPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowInfoPageState();
  }
}

class ShowInfoPageState extends State<ShowInfoPageWidget> with SingleTickerProviderStateMixin {
  List tabs = ['秀宠','话题'];
  TabController _tabController; //需要定义一个Controller

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

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
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ShowInfoListWidget(),
          GambitListWidget(),
        ],
      ),
    );
  }
}
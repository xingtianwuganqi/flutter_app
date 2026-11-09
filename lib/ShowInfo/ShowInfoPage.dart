import 'package:flutter/material.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoListPage.dart';
import '../ShowInfo/GambitListPage.dart';
import '../Common/CommonPage.dart';
class ShowInfoPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowInfoPageState();
  }
}

class ShowInfoPageState extends State<ShowInfoPageWidget> with SingleTickerProviderStateMixin {
  List tabs = ['秀宠'];
  late TabController _tabController; //需要定义一个Controller

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
          width: 140,
          height: 44,
          child: TabBar(
            indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
            indicatorPadding: EdgeInsets.only(left: 10,right: 10),
            controller: _tabController,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: FontUtil.fs(FontSize.content)),
            tabs: tabs.map((e) => Tab(text: e,)).toList(),
          ),
        ),
        elevation: 0.5,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ShowInfoListWidget(),
          // GambitListWidget(),
        ],
      ),
    );
  }
}
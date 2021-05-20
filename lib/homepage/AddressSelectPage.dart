import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';

class AddressSelectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddressSelectState();
  }

}

class AddressSelectState extends State<AddressSelectPage> with SingleTickerProviderStateMixin {
  List tabs = ['','',''];
  TabController _tabController; //需要定义一个Controller

  @override
  void initState() {
    super.initState();
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    getLocationJsonInfo();

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
            indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
        elevation: 0.5,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CityPage(),
          CityPage(),
          CityPage(),
        ],
      ),
    );
  }

  Future<Null> getLocationJsonInfo() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/files/location.json");
    final jsonResult = json.decode(data);
    print(jsonResult);
  }

}

class CityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CityState();
  }
}

class CityState extends State<CityPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
          itemBuilder: (context,index){
        return Container(
          alignment: Alignment.centerLeft,
          child: Text('city'),
        );
      }),
    );
  }
}
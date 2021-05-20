import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import '../model/HomePageModel.dart';

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
  CountryModel _countryModel;

  ProvinceModel _provinceModel;
  CityModel _cityModel;
  AreaModel _areaModel;

  List<ProvinceModel> _provinceDatas;
  List<CityModel> _cityDatas;
  List<AreaModel> _areaDatas;


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
          CityPage(citys: _provinceDatas),
          CityPage(citys: _cityDatas),
          CityPage(citys: _areaDatas),
        ],
      ),
    );
  }

  Future<Null> getLocationJsonInfo() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/files/location.json");
    final jsonResult = json.decode(data);
    _countryModel = CountryModel.fromJson(jsonResult);
    _provinceDatas = _countryModel.children;
    setState(() {

    });
  }

}

class CityPage<T> extends StatefulWidget {

  final List<T> citys;
  CityPage({Key key, this.citys}): super(key: key);

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
        itemCount: (widget.citys != null) ? widget.citys.length : 0,
          itemBuilder: (context,index){
          var name = '';
          if (widget.citys[index] as ProvinceModel != null) {
            name = widget.citys[index].value;
          }else if (widget.citys[index] as CityModel != null) {
            name = widget.citys[index].value;
          }else if (widget.citys[index] as AreaModel != null) {
            name = widget.citys[index].value;
          }
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(name),
        );
      }),
    );
  }
}
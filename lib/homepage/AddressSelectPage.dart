import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import '../model/HomePageModel.dart';

class AddressSelectPage extends StatefulWidget {

  final ValueChanged changed;
  AddressSelectPage({Key key,@required this.changed}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddressSelectState();
  }

}

class AddressSelectState extends State<AddressSelectPage> with SingleTickerProviderStateMixin {
  List tabs = ['请选择','',''];
  TabController _tabController; //需要定义一个Controller
  CountryModel _countryModel;

  ProvinceModel _provinceModel;
  CityModel _cityModel;
  AreaModel _areaModel;

  List<ProvinceModel> _provinceArr;
  List<CityModel> _cityArr;
  List<AreaModel> _areaArr;


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
        automaticallyImplyLeading: false,
        title: Container(
          height: 44,
          alignment: Alignment.centerLeft,
          child: TabBar(
            indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            onTap: (index) {

              if (index == 0) {
                _cityModel = null;
                _areaModel = null;
                tabs[1] = '';
                tabs[2] = '';
                setState(() {

                });
              }else if (index == 1) {
                if (_provinceModel == null) {
                  _tabController.index = 0;
                  return;
                }

                _areaModel = null;
                tabs[2] = '';
                setState(() {

                });
              }else if (index == 2) {

                if (_provinceModel == null) {
                  _tabController.index = 0;
                  return;
                }

                if (_cityModel == null) {
                  _tabController.index = 1;
                  return;
                }
              }
            },
          ),
        ),
        elevation: 0.5,
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), //禁止滑动
        children: [
          CityPage(citys: _provinceArr,changed: (value) {
            print(value);
            _provinceModel = value;
            _cityArr = _provinceModel.children;
            tabs[0] = _provinceModel.value;
            tabs[1] = '请选择';
            _tabController.animateTo(1);

            Future.delayed(Duration(milliseconds: 500), (){
              setState(() {

              });
            });


          },),
          CityPage(citys: _cityArr,changed: (value) {
            _cityModel = value;
            _areaArr = _cityModel.children;
            tabs[1] = _cityModel.value;
            tabs[2] = '请选择';
            _tabController.animateTo(2);
            Future.delayed(Duration(milliseconds: 500), (){
              setState(() {

              });
            });
          }),
          CityPage(citys: _areaArr,changed: (value) {
            _areaModel = value;
            // 完成选择，退出
            tabs[2] = _areaModel.value;
            Future.delayed(Duration(milliseconds: 500),(){
              setState(() {

              });
            });

            Future.delayed(Duration(milliseconds: 1000),(){
              var address = _provinceModel.value + '.' + _cityModel.value + '.' + _areaModel.value;
              widget.changed(address);
              Navigator.pop(context);
            });
          }),
        ],
      ),
    );
  }

  Future<Null> getLocationJsonInfo() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/files/location.json");
    final jsonResult = json.decode(data);
    _countryModel = CountryModel.fromJson(jsonResult);
    _provinceArr = _countryModel.children;
    setState(() {

    });
  }

}

class CityPage<T> extends StatefulWidget {

  final ValueChanged<T> changed;
  final List<T> citys;
  CityPage({Key key, this.citys,this.changed}): super(key: key);

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
          var data = widget.citys[index];
          if (data is ProvinceModel) {
            name = data.value;
          }else if (data is CityModel) {
            name = data.value;
          }else if (data is AreaModel) {
            name = data.value;
          }
          return Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child:
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: Text(name),
                ),
                onTap: () {
                  print(widget.citys[index]);
                  widget.changed(widget.citys[index]);
                },
              ),
              Divider(color: ColorsUtil.fromEnmu(ColorEnum.tableBack),)
            ],
          );
      }),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  // CountryModel _countryModel;

  NewProvinceModel _provinceModel;
  NewCityModel _cityModel;
  NewAreaModel _areaModel;

  List<NewProvinceModel> _provinceArr;
  List<NewCityModel> _cityArr;
  List<NewAreaModel> _areaArr;


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
            isScrollable: false,
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
            _provinceModel = value;
            _cityArr = _provinceModel.children;
            tabs[0] = _provinceModel.name;
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
            tabs[1] = _cityModel.name;
            tabs[2] = '请选择';
            _tabController.animateTo(2);
            Future.delayed(Duration(milliseconds: 500), (){
              setState(() {

              });
            });
            // 如果没有area，则退出
            if (_cityModel.children == null || _cityModel.children.length == 0) {
              Future.delayed(Duration(milliseconds: 700),(){
                var address = _provinceModel.name + '.' + _cityModel.name;
                widget.changed(address);
                Navigator.pop(context);
              });
            }

          }),
          CityPage(citys: _areaArr,changed: (value) {
            _areaModel = value;
            // 完成选择，退出
            tabs[2] = _areaModel.name;
            Future.delayed(Duration(milliseconds: 500),(){
              setState(() {

              });
            });

            Future.delayed(Duration(milliseconds: 700),(){
              var address = _provinceModel.name + '.' + _cityModel.name + '.' + _areaModel.name;
              widget.changed(address);
              Navigator.pop(context);
            });
          }),
        ],
      ),
    );
  }

  Future<Null> getLocationJsonInfo() async {
    EasyLoading.show();
    String data = await DefaultAssetBundle.of(context).loadString("assets/files/location.json");
    final jsonResult = json.decode(data);
    var arr = (jsonResult as List).map((m) => NewProvinceModel.fromJson(m)).toList();
    _provinceArr = arr;
    setState(() {
      EasyLoading.dismiss();
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
          if (data is NewProvinceModel) {
            name = data.name;
          }else if (data is NewCityModel) {
            name = data.name;
          }else if (data is NewAreaModel) {
            name = data.name;
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
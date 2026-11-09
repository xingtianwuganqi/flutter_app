import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitySelectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CitySelectState();
  }
}

class CitySelectState extends State<CitySelectPage> {

  List<CityListModel> _cityList = [];
  String? _cityName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationJsonInfo();
    getUserCity();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("选择城市"),
        elevation: 0.2,
      ),
      body: ListView.builder(
        itemCount: _cityList.length,
        itemBuilder: (context, index) {
          var info = _cityList[index];
          if (info.code == "-1") {
            return  Container(
              padding: EdgeInsets.only(right: 15),
              height: 60,
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15,right: 15),
                    child: Image.asset("assets/icons/icon_topic_local.png"),
                  ),
                  Text("当前城市：$_cityName",
                    style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                        fontWeight: FontWeight.w600),),
                  Expanded(
                    child: Container(),
                  ),
                  Icon(Icons.chevron_right_rounded)
                ],
              ),
            );
          }else{
            return GestureDetector(
              child: ListTile(
                title: Text(info.name ?? '',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                      color: ColorsUtil.fromEnmu(ColorEnum.content)),
                ),
              ),
              onTap: () {
                  saveUserCity(info.name ?? '');
              },
            );
          }
        }),
    );
  }

  // Future<Null> getLocationJsonInfo() async {
  //   EasyLoading.show();
  //   String data = await DefaultAssetBundle.of(context).loadString("assets/files/location.json");
  //   final jsonResult = json.decode(data);
  //   var arr = (jsonResult as List).map((m) => NewProvinceModel.fromJson(m)).toList();
  //   _provinceArr = arr;
  //   setState(() {
  //     EasyLoading.dismiss();
  //   });
  // }
  Future<Null> getLocationJsonInfo() async {
    EasyLoading.show();
    String data = await DefaultAssetBundle.of(context).loadString("assets/files/city.json");
    final jsonResult = json.decode(data);
    var arr = (jsonResult as List).map((m) => CityListModel.fromJson(m)).toList();
    arr.insert(0,CityListModel(code: "-1",name: ""));
    _cityList = arr;
    setState(() {
      EasyLoading.dismiss();
    });
  }

  // 保存用户地址
  Future<void> saveUserCity(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userLocalCity", name);

    EasyLoading.show();
    Future.delayed(Duration(seconds: 1),(){
      EasyLoading.dismiss();
      getUserCity();
      Navigator.pop(context, 'refresh');
    });
  }

  Future<void> getUserCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cityName = prefs.getString("userLocalCity");
    _cityName = cityName ?? "北京市";
    setState(() {

    });
  }
}
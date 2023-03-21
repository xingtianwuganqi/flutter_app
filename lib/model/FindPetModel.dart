import 'package:flutter/material.dart';

class FindPetDetailModel {
  /// 自定义模型，用来保存数据
  int infoType = 1; // 1.选择类型，2：输入类型
  String desc;
  String placehandle;
  String value;
  int type;

  FindPetDetailModel({this.infoType, this.desc,this.placehandle,this.value,this.type});

  factory FindPetDetailModel.fromJson(Map<String, dynamic> json) {
    return FindPetDetailModel(
      infoType: json["infoType"],
      desc: json["desc"],
      placehandle: json["placehandle"],
      value: json["value"],
      type: json["type"]
    );
  }
}
import 'package:flutter/material.dart';
import 'UserModel.dart';

class FindPetListModel {
  int findId;
  String create_time;
  String update_time;
  int pet_type;
  String address;
  String address_info;
  int user_id;
  int is_delete;
  int effective;
  String desc;
  String contact;
  UserInfoModel userInfo;
  int liked;
  int collection;

  int likeNum;
  int collectionNum;
  int commNum;

  // 自定义字段
  bool open = false;

  String contact_info;
  int getedcontact;
  int id;

  FindPetListModel(
  {
    this.findId,
    this.create_time,
    this.update_time,
    this.pet_type,
    this.address,
    this.address_info,
    this.user_id,
    this.is_delete,
    this.effective,
    this.desc,
    this.contact,
    this.userInfo,
    this.liked,
    this.collection,
    this.likeNum,
    this.collectionNum,
    this.commNum,
    this.open,
    this.contact_info,
    this.getedcontact,
    this.id
    });
}

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
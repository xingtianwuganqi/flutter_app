import 'package:flutter_720yun/homepage/BlackDetailPage.dart';

class BlackListModel {
  final int id;
  final String name;
  final String contact;
  final String desc;
  final String wx_num;
  final List<String> images;
  final int black_status;
  final int from_userId;
  final int black_type;

  BlackListModel({
    this.id,
    this.name,
    this.contact,
    this.desc,
    this.wx_num,
    this.images,
    this.black_status,
    this.from_userId,
    this.black_type
  });

  factory BlackListModel.fromJson(Map<String,dynamic> json) {
    return BlackListModel(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      desc: json['desc'],
      wx_num: json['wx_num'],
      // images: json['image'],
      black_status: json['black_status'],
      from_userId: json['from_userId'],
      black_type: json['black_type']
    );
  }
}

class BlackInfoModel {
  final String desc;
  final String placeholder;
  dynamic value;
  final BlackType type;


  BlackInfoModel({
    this.desc,
    this.placeholder,
    this.value,
    this.type,
  });

  factory BlackInfoModel.fromJson(Map<String,dynamic> json) {
    return BlackInfoModel(
        desc: json['desc'],
        placeholder: json['placeholder'],
        value: json['value'],
        type: json['type']
    );
  }
}

class ReleaseReportInfo {
  final String phone;
  final String wx_num;
  final String name;
  final int black_type;
  final String desc;
  final String photos;

  ReleaseReportInfo({this.phone, this.wx_num, this.name, this.black_type, this.desc, this.photos});

  factory ReleaseReportInfo.fromJson(Map<String,dynamic> json) {
    return ReleaseReportInfo(
        phone: json['phone'],
        wx_num: json['wx_num'],
        name: json['name'],
        black_type: json['black_type'],
        desc: json['desc'],
        photos: json['photos']
    );
  }
}
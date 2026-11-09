import 'package:flutter_720yun/homepage/BlackDetailPage.dart';

class BlackListModel {
  int? id;
  String? name;
  String? contact;
  String? desc;
  String? wx_num;
  List<String>? images;
  int? black_status;
  int? from_userId;
  int? black_type;

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
      images: (json['images'] as List)?.map((e) => e as String)?.toList(),
      black_status: json['black_status'],
      from_userId: json['from_userId'],
      black_type: json['black_type']
    );
  }
}

class BlackInfoModel {
  String? desc;
  String? placeholder;
  dynamic value;
  BlackType? type;


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
  String? phone;
  String? wx_num;
  String? name;
  int? black_type;
  String? desc;
  String? photos;

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
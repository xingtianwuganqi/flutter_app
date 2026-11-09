import 'package:flutter/foundation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

import 'UserModel.dart';
class HomePageModel {
  int? topic_id;
  String? content;
  UserInfoModel? userInfo;
  List<String>? imgs;
  String? create_time;
  String? update_time;
  int? views_num;
  int? likes_num;
  int? collection_num;
  int? commNum;
  String? address_info;
  bool? is_complete;
  List<int>? tags;
  bool? liked;
  bool? collectioned;
  int? user;
  List<TagModel>? tagInfos;
  String? contact_info;
  bool? getedcontact;

  HomePageModel({
    this.topic_id,
    this.content,
    this.userInfo,
    this.imgs,
    this.create_time,
    this.update_time,
    this.views_num,
    this.likes_num,
    this.collection_num,
    this.is_complete,
    this.tags,
    this.liked,
    this.collectioned,
    this.user,
    this.contact_info,
    this.getedcontact,
    this.commNum,
    this.address_info,
    this.tagInfos,
  });

  factory HomePageModel.fromJson(Map<String,dynamic> json) {
    return HomePageModel(
      topic_id: json['topic_id'],
      content: json['content'],
      userInfo: json['userInfo'] != null ? UserInfoModel.fromJson(json['userInfo']) : null,
      imgs: (json['imgs'] as List)?.map((e) => e as String)?.toList(),
      create_time: json['create_time'],
      update_time: json['update_time'],
      views_num: json['views_num'],
      likes_num: json['likes_num'],
      collection_num: json['collection_num'],
      user: json['user'],
      contact_info: json['contact_info'],
      getedcontact: json['getedcontact'],
      commNum: json['commNum'],
      address_info: json['address_info'],
      tagInfos: json['tagInfos']== null ? null : (json['tagInfos'] as List)?.map((e) => TagModel.fromJson(e)).toList(),
      liked:  json['liked'],
      collectioned: json['collectioned'],
      is_complete: json['is_complete'],
    );
  }

}

class TagModel {
  int? id;
  String? tag_name;
  
  TagModel({
    this.id,
    this.tag_name,
  });
  
  factory TagModel.fromJson(Map<String,dynamic> json) {
    return TagModel(
      id: json['id'],
      tag_name: json['tag_name'],
    );
  }
}

class SearchKeyWordModel {
  int? id;
  String? keyword;

  SearchKeyWordModel({
    this.id,
    this.keyword,
  });

  factory SearchKeyWordModel.fromJson(Map<String,dynamic> json){
    return SearchKeyWordModel(
      id: json['id'],
      keyword: json['keyword'],
    );
  }
}

class ReleasePhotoModel {
  bool? isAdd = false;
  double? progress = 0.0;
  bool? complete = false;
  String? photoKey = '';
  String? photoUrl = '';
  AssetEntity? image;

  ReleasePhotoModel({
    this.isAdd,
    this.progress,
    this.complete,
    this.photoKey,
    this.photoUrl,
    this.image
  });
}


class TagInfoModel {
  TagInfoModel({this.id,this.tag_name, this.isSelect, this.tag_type});
  int? id;
  String? tag_name;
  int? tag_type;
  bool?  isSelect = false;

  factory TagInfoModel.fromJson(Map<String,dynamic> json) {
    return TagInfoModel(
      id: json['id'],
      tag_name: json['tag_name'],
      tag_type: json['tag_type'],
      isSelect: false,
    );
  }
}

class CountryModel {
  List<ProvinceModel>? children;
  String? id;
  String? pid;
  String? value;
  bool? isSelect = false;
  CountryModel({this.children,this.id,this.pid,this.value,this.isSelect});

  factory CountryModel.fromJson(Map<String,dynamic> json) {
    return CountryModel(
        children: (json['children'] as List).map((e) => ProvinceModel.fromJson(e)).toList(),
        id: json['id'],
        pid: json['pid'],
        value: json['value'],
        isSelect: false
    );
  }
}

class ProvinceModel {
  List<CityModel> ?children;
  String? id;
  String? pid;
  String? value;
  bool? isSelect = false;
  ProvinceModel({this.children,this.id,this.pid,this.value,this.isSelect});

  factory ProvinceModel.fromJson(Map<String,dynamic> json) {
    return ProvinceModel(
        children: (json['children'] as List).map((e) => CityModel.fromJson(e)).toList(),
        id: json['id'],
        pid: json['pid'],
        value: json['value'],
        isSelect: false
    );
  }
}

class CityModel {
  List<AreaModel>? children;
  String? id;
  String? pid;
  String? value;
  bool? isSelect = false;
  CityModel({this.children,this.id,this.pid,this.value,this.isSelect});

  factory CityModel.fromJson(Map<String,dynamic> json) {
    return CityModel(
        children: (json['children'] as List).map((e) => AreaModel.fromJson(e)).toList(),
        id: json['id'],
        pid: json['pid'],
        value: json['value'],
        isSelect: false
    );
  }
}

class AreaModel {
  String? id;
  String? pid;
  String? value;
  bool? isSelect = false;

  AreaModel({this.id,this.pid,this.value,this.isSelect});
  factory AreaModel.fromJson(Map<String,dynamic> json) {
    return AreaModel(
      id: json['id'],
      pid: json['pid'],
      value: json['value'],
      isSelect: false
    );
  }
}

class NewProvinceModel {
  String? code;
  String? name;
  List<NewCityModel>? children;
  bool? isSelect = false;

  NewProvinceModel({this.code,this.name,this.children,this.isSelect});

  factory NewProvinceModel.fromJson(Map<String,dynamic> json) {
    return NewProvinceModel(
        code: json["code"],
        name: json["name"],
        children: (json['children'] as List).map((e) => NewCityModel.fromJson(e)).toList(),
        isSelect: false
    );
  }
}



class NewCityModel {
  String? code;
  String? name;
  List<NewAreaModel>? children;
  bool? isSelect = false;

  NewCityModel({this.code,this.name,this.children,this.isSelect});

  factory NewCityModel.fromJson(Map<String,dynamic> json) {
    if ((json["children"] as List) != null) {
      return NewCityModel(
          code: json["code"],
          name: json["name"],
          children: (json["children"] as List).map((e) => NewAreaModel.fromJson(e)).toList(),
          isSelect: false
      );
    }else {
      return NewCityModel(
          code: json["code"],
          name: json["name"],
          isSelect: false
      );
    }
  }

}

class NewAreaModel {
  String? code;
  String? name;
  bool? isSelect = false;

  NewAreaModel({this.code,this.name,this.isSelect});
  factory NewAreaModel.fromJson(Map<String,dynamic> json) {
    return NewAreaModel(
        code: json['code'],
        name: json['name'],
        isSelect: false
    );
  }
}


class UploadImgTokenModel {
  String? token;
  UploadImgTokenModel({this.token});
  factory UploadImgTokenModel.formJson(Map<String,dynamic> json) {
    return UploadImgTokenModel(
      token: json['token'],
    );
  }
}

class HomeLikeStatusModel {
  int? like;
  int? mark;
  HomeLikeStatusModel({this.like,this.mark});
  factory HomeLikeStatusModel.fromJson(Map<String,dynamic> json) {
    return HomeLikeStatusModel(
      like: int.parse(json['like'].toString()),
      mark: int.parse(json['mark'].toString()),
    );
  }
}

class HomeCollectionStatusModel {
/*
var collection: Int?
    var mark: Int?

 */
  int? collection;
  int? mark;
  HomeCollectionStatusModel({this.collection,this.mark});
  factory HomeCollectionStatusModel.fromJson(Map<String,dynamic> json) {
    return HomeCollectionStatusModel(
      collection: int.parse(json['collection'].toString()),
      mark: int.parse(json['mark'].toString()),
    );
  }
}

class ContactModel {
  String? contact;
  ContactModel({this.contact});
  factory ContactModel.fromJson(Map<String,dynamic> json) {
    return ContactModel(
      contact: json['contact'],
    );
  }
}

class ImgIndexModel {
  String? url;
  int? index;

  ImgIndexModel({this.url,this.index});
  //
  // factory ImgIndexModel.fromJson(Map<String,dynamic> json) {
  //
  // }
}

class CityListModel {
  String? code;
  String? name;

  CityListModel({this.code, this.name});

  factory CityListModel.fromJson(Map<String, dynamic> json) {
    return CityListModel(
      code: json['code'],
      name: json['name']
    );
  }
}
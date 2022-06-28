import 'package:flutter/foundation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'UserModel.dart';
class HomePageModel {
  final  int topic_id;
  final  String content;
  final  UserInfoModel userInfo;
  final  List<String> imgs;
  final  String create_time;
  final  String update_time;
  final  int views_num;
  int likes_num;
  int collection_num;
  int commNum;
  final  String address_info;
  bool is_complete;
  final  List<int> tags;
  bool liked;
  bool collectioned;
  final  int user;
  final  List<TagModel> tagInfos;
  String contact_info;
  bool getedcontact;

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
  final int id;
  final String tag_name;
  
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
  final int id;
  final String keyword;

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

/*
struct ReleasePhotoModel: HandyJSON, Equatable {

var image: UIImage?
var isAdd: Bool = false // 是不是添加的图片
var progress: Float = 0
var complete: Bool = false
var photoKey: String = "\(Tool.shared.getTime())/\(String.et.random(ofLength: 8)).jpeg"
var photoUrl: String = ""

static func == (lhs: Self, rhs: Self) -> Bool {
return lhs.photoKey == rhs.photoKey
}
}
 */

class ReleasePhotoModel {
  bool isAdd = false;
  double progress = 0.0;
  bool complete = false;
  String photoKey = '';
  String photoUrl = '';
  Asset image;

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
  final int id;
  final String tag_name;
  final int tag_type;
  bool  isSelect = false;

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
  final List<ProvinceModel> children;
  final String id;
  final String pid;
  final String value;
  bool isSelect = false;
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
  final List<CityModel> children;
  final String id;
  final String pid;
  final String value;
  bool isSelect = false;
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
  final List<AreaModel> children;
  final String id;
  final String pid;
  final String value;
  bool isSelect = false;
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
  final String id;
  final String pid;
  final String value;
  bool isSelect = false;

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
  final String code;
  final String name;
  final List<NewCityModel> children;
  bool isSelect = false;

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
  final String code;
  final String name;
  final List<NewAreaModel> children;
  bool isSelect = false;

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
  final String code;
  final String name;
  bool isSelect = false;

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
  final String token;
  UploadImgTokenModel({this.token});
  factory UploadImgTokenModel.formJson(Map<String,dynamic> json) {
    return UploadImgTokenModel(
      token: json['token'],
    );
  }
}

class HomeLikeStatusModel {
  final int like;
  final int mark;
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
  final int collection;
  final int mark;
  HomeCollectionStatusModel({this.collection,this.mark});
  factory HomeCollectionStatusModel.fromJson(Map<String,dynamic> json) {
    return HomeCollectionStatusModel(
      collection: int.parse(json['collection'].toString()),
      mark: int.parse(json['mark'].toString()),
    );
  }
}

class ContactModel {
  final String contact;
  ContactModel({this.contact});
  factory ContactModel.fromJson(Map<String,dynamic> json) {
    return ContactModel(
      contact: json['contact'],
    );
  }
}

class ImgIndexModel {
  final String url;
  final int index;

  ImgIndexModel({this.url,this.index});
  //
  // factory ImgIndexModel.fromJson(Map<String,dynamic> json) {
  //
  // }
}
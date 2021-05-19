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
  final  int likes_num;
  final  int collection_num;
  final  int commNum;
  final  String address_info;
  final  bool is_complete;
  final  List<int> tags;
  final  bool liked;
  final  bool collectioned;
  final  int user;
  final  List<TagModel> tagInfos;
  final  String contact_info;
  final  bool getedcontact;

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
  TagInfoModel({this.id,this.tag_name, this.isSelect});
  final int id;
  final String tag_name;
  bool  isSelect = false;

  factory TagInfoModel.fromJson(Map<String,dynamic> json) {
    return TagInfoModel(
      id: json['id'],
      tag_name: json['tag_name'],
      isSelect: false,
    );
  }
}
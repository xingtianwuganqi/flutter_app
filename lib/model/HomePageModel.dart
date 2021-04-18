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
  final  int getedcontact;

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
      userInfo: UserInfoModel.fromJson(json['userInfo']),
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
      tagInfos: (json['tagInfos'] as List)?.map((e) => TagModel.fromJson(e)).toList(),
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
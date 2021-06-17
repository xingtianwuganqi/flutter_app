
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';

class UserInfoModel {
  final String username;
  final String avator;
  final String token;
  final String phone_number;
  final String email;
  final String create_time;
  final int id;
  final String wx_id;

  UserInfoModel({
    this.username,
    this.avator,
    this.token,
    this.phone_number,
    this.email,
    this.create_time,
    this.id,
    this.wx_id
  });

  factory UserInfoModel.fromJson(Map<String,dynamic> json){
    return UserInfoModel(
        username: json["username"],
      avator: json["avator"],
      token: json["token"],
      phone_number: json["phone_number"],
      email: json["email"],
      create_time: json["create_time"],
      id: json["id"],
      wx_id: json["wx_id"]
      );
  }

  Map<String,dynamic> toJson() => <String,dynamic> {
    "username": username,
    "avator" : avator,
    "token" : token,
    'phone_number': phone_number,
    'email':email,
    'create_time': create_time,
    'id':id,
    'wx_id': wx_id,
  };
}

/*
{
            "history_id": 5,
            "topic_id": 3,
            "topicInfo": {
                "content": "测试结果表明工地上被救助的小黑妹妹，目前正在中途家庭适应家庭生活，特别活泼粘人，喜欢让抱，是个跟屁虫，长大应该是中型犬的样子，适合领养，寻找不离不弃的领养家庭！北京同城，有稳定收入及住所，适龄绝育，办理狗证，签订协议，接受家访及回访！",
                "user": 1,
                "imgs": [
                    "1617348944/n3DN0ve2.jpeg",
                    "1617348945/Z7pDNY78.jpeg"
                ],
                "create_time": "2021-04-02T15:36:00.328855+08:00",
                "update_time": "2021-04-24T21:53:34.643819+08:00",
                "views_num": 76,
                "likes_num": 2,
                "collection_num": 1,
                "commNum": 14,
                "address_info": "北京.北京市.西城区",
                "contact_info": null,
                "is_complete": false,
                "getedcontact": false,
                "tags": [],
                "gambit_type": null,
                "topic_id": 3,
                "userInfo": {
                    "id": 1,
                    "avator": "1618061262/u5VrD7G2.jpeg",
                    "username": "测试酱",
                    "phone_number": "13689242201",
                    "email": "",
                    "create_time": "2021-03-28T22:01:29.934118+08:00",
                    "wx_id": ""
                },
                "liked": false,
                "collectioned": false,
                "tagInfos": []
            }
        }
 */

class AuthHistoryModel {
  final int history_id;
  final int topic_id;
  final HomePageModel topicInfo;

  AuthHistoryModel({
    this.history_id,
    this.topic_id,
    this.topicInfo,
  });

  factory AuthHistoryModel.fromJson(Map<String,dynamic> json) {
    return AuthHistoryModel(
      history_id: json['history_id'],
      topic_id: json['topic_id'],
      topicInfo: HomePageModel.fromJson(json['topicInfo'])
    );
  }
}

class AuthCollectRescueModel {
  final int collection_id;
  final int topic_id;
  final HomePageModel topicInfo;

  AuthCollectRescueModel({
    this.collection_id,
    this.topic_id,
    this.topicInfo
  });

  factory AuthCollectRescueModel.fromJson(Map<String,dynamic> json) {
    return AuthCollectRescueModel(
        collection_id: json['collection_id'],
        topic_id: json['topic_id'],
        topicInfo: HomePageModel.fromJson(json['topicInfo'])
    );
  }
}

class AuthCollectShowInfoModel {
  final int showcollect_id;
  final int topic_id;
  final ShowInfoModel showInfo;

  AuthCollectShowInfoModel({
    this.showcollect_id,
    this.topic_id,
    this.showInfo
  });

  factory AuthCollectShowInfoModel.fromJson(Map<String,dynamic> json) {
    return AuthCollectShowInfoModel(
        showcollect_id: json['showcollect_id'],
        topic_id: json['topic_id'],
        showInfo: ShowInfoModel.fromJson(json['showInfo'])
    );
  }
}


class ViolationModel {
  final int id;
  final String vio_name ;
  bool selected;

  ViolationModel({
    this.id,
    this.vio_name,
    this.selected,
  });

  factory ViolationModel.fromJson(Map<String,dynamic> json) {
    return ViolationModel(
      id: json['id'],
      vio_name: json['vio_name'],
      selected: false
    );
  }
}



///# 1.领养举报 2.领养评论 3.领养回复 4.秀宠举报 5.秀宠评论 6.秀宠回复
enum Report_type {
  rescue_page, // 1
  rescue_comment, // 2
  rescue_reply,// 3
  show_page,// 4
  show_comment,// 5
  show_reply,// 6
}


class UserPageModel {
  final String icon;
  final String title;
  int num;
  UserPageModel(
      this.icon,
      this.title,
      this.num
      );
}

class AppVersionModel {
  final int id;
  final String app_type;
  final int version;

  AppVersionModel({this.id,this.app_type,this.version});
  factory AppVersionModel.fromJson(Map<String,dynamic> json) {
    return AppVersionModel(
      id: json['id'],
      app_type: json['app_type'],
      version: json['version']
    );
  }
}
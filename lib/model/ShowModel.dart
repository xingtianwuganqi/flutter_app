import 'package:flutter_720yun/model/CommentModel.dart';

import 'MessageModel.dart';
import 'UserModel.dart';

class GambitModel {
  String? descript;
  int? id;
  int? selected;
  String? create_time;
  int? review_type;
  bool? isSelect;

  GambitModel({this.descript, this.id, this.selected,this.create_time,this.review_type,this.isSelect});

  factory GambitModel.fromJson(Map<String, dynamic> json) {
    return GambitModel(descript: json['descript'],
        id: json['id'],
        selected: 0,
        create_time: json['create_time'],
        review_type: json['review_type'],
        isSelect: false,
    );
  }

  get gambit_type => null;
}

class ShowInfoModel {
  int? show_id;
  UserInfoModel? user;
  List<String>? imgs;
  int? views_num;
  int? likes_num;
  int? collection_num;
  int? comments_num;
  String? instruction;
  int? open;
  bool? liked;
  bool? collectioned;
  String? create_time;
  MessageCommentModel? commentInfo;
  GambitModel? gambit_type;
  int? commNum;

  ShowInfoModel({
      this.show_id,
      this.user,
      this.imgs,
      this.views_num,
      this.likes_num,
      this.collection_num,
      this.comments_num,
      this.instruction,
      this.open,
      this.liked,
      this.collectioned,
      this.create_time,
      this.gambit_type,
      this.commNum,
    this.commentInfo
  });

  factory ShowInfoModel.fromJson(Map<String, dynamic> json) {
    return ShowInfoModel(
        show_id: json['show_id'],
        user: UserInfoModel.fromJson(json['user']),
        imgs: (json['imgs'] as List)?.map((e) => e as String)?.toList(),
        views_num: json['views_num'],
        likes_num: json['likes_num'],
        collection_num: json['collection_num'],
        comments_num: json['comments_num'],
        instruction: json['instruction'],
        open: json['open'],
        liked: json['liked'],
        collectioned: json['collectioned'],
        create_time: json['create_time'],
        gambit_type: json['gambit_type'] != null ? GambitModel.fromJson(json['gambit_type']): null,
        commNum: json['commNum'],
        commentInfo:json['commentInfo'] != null ? MessageCommentModel.fromJson(json['commentInfo']) : null,
    );
  }
}

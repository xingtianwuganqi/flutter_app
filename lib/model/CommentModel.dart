
// class CommentInfoModel {
//
// }

import 'package:flutter_720yun/model/MessageModel.dart';

import 'UserModel.dart';

class CommentInfoModel {
  final int comment_id;
  final String create_time;
  final int topic_id;
  final int topic_type; // 秀宠1，后面加领养的回复
  final String content;
  final int from_uid;
  final List<ReplyListModel> replys;
  bool isOpend; // 回复是否折叠，true 是全部展示,false 时展示折叠cell
  final List<ReplyListModel> showReply;
  final UserInfoModel userInfo;
  final int reply_count;
  int next_page;

  CommentInfoModel({
    this.comment_id,
    this.create_time,
    this.topic_id,
    this.topic_type,
    this.content,
    this.from_uid,
    this.replys,
    this.isOpend,
    this.showReply,
    this.userInfo,
    this.reply_count,
    this.next_page,
  });

  factory CommentInfoModel.fromJson(Map<String,dynamic> json) {
    return CommentInfoModel(
      comment_id: json['comment_id'],
      create_time: json['create_time'],
      topic_id: json['topic_id'],
      topic_type: json['topic_type'],
      content: json['content'] as String,
      from_uid: json['from_uid'],
      replys: (json['replys'] as List)?.map((e) => ReplyListModel.fromJson(e))?.toList(),//
      isOpend: (json['reply_count'] ?? 0) > json['replys'].length ? false : true,
      showReply: [],
      userInfo: UserInfoModel.fromJson(json['userInfo']),
      reply_count: json['reply_count'] ?? 0,
      next_page: 2,
    );
  }
}

class ReplyListModel {
  final int id;
  final int comment_id;
  final int reply_id; // #表示回复目标的 id，如果 reply_type 是 comment 的话，那么 reply_id ＝ commit_id，如果 reply_type 是 reply 的话，这表示这条回复的父回复。
  final int reply_type; // #表示回复的类型，因为回复可以是针对评论的回复（comment），也可以是针对回复的回复（reply）， 通过这个字段来区分两种情景。
  final String content;
  final int from_uid;
  final int to_uid;
  final UserInfoModel fromInfo;
  final UserInfoModel toInfo;
  final String create_time;

  ReplyListModel({
    this.id,
    this.comment_id,
    this.reply_id,
    this.reply_type,
    this.content,
    this.from_uid,
    this.to_uid,
    this.fromInfo,
    this.toInfo,
    this.create_time
  });

  factory ReplyListModel.fromJson(Map<String,dynamic> json) {
    return ReplyListModel(
      id: json['id'],
      comment_id: json['comment_id'],
      reply_id: json['reply_id'],
      reply_type: json['reply_type'],
      content: json['content'],
      from_uid: json['from_uid'],
      to_uid: json['to_uid'],
      fromInfo: UserInfoModel.fromJson(json['fromInfo']),
      toInfo: UserInfoModel.fromJson(json['toInfo']),
      create_time: json['create_time']
    );
  }
}

/// 评论类型
enum CommentType {
   topic_comment, // 1
   show_comment  // 2
}

class ComRepListModel {
  int type;
  final CommentInfoModel commentModel;
  final ReplyListModel replyModel;

  ComRepListModel({
    this.type,
    this.commentModel,
    this.replyModel
  });
}

enum ComTapType {
  comment,
  reply
}

class ComTapTypeInfo {
  ComTapType tapType;
  String name;
  ComTapTypeInfo({this.tapType,this.name});
}

/// 回复时的数据模型
class ReplyComModel {
  final String content;
  final int comment_id;
  final int reply_id;
  final int reply_type; //  1回复评论， 2回复回复, comment_id == replyId ? 1 : 2
  final int to_uid;

  ReplyComModel({
    this.content,
    this.comment_id,
    this.reply_id,
    this.reply_type,
    this.to_uid,
  });
}
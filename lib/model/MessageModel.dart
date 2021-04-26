import 'package:flutter/material.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';

import 'UserModel.dart';
/*
struct MessageListModel: HandyJSON {
    var id: Int?
    var create_time: String?
    var msg_type: Int?
    var msg_id: Int?
    var from_info: UserInfoModel?
    var to_info: UserInfoModel?
    var is_read: Int?
    var topicInfo: HomePageModel?
    var showInfo: ShowPageModel?
    var replyInfo: ReplyListModel?
    var commentInfo: CommentListModel?
    var reply_type: Int?
    var reply_id: Int?
}
 */
class MessageListModel {
  final int id;
  final String create_time;
  final int msg_type;
  final int msg_id;
  final UserInfoModel from_info;
  final UserInfoModel to_info;
  final int is_read;
  final HomePageModel topicInfo;
  final ShowInfoModel showInfo;
  final ReplyListModel replyInfo;
  final CommentListModel commentInfo;
  final int reply_type;
  final int reply_id;

  MessageListModel({
    this.id,
    this.create_time,
    this.msg_type,
    this.msg_id,
    this.from_info,
    this.to_info,
    this.is_read,
    this.topicInfo,
    this.showInfo,
    this.replyInfo,
    this.commentInfo,
    this.reply_type,
    this.reply_id
  });

  factory MessageListModel.fromJson(Map<String,dynamic> json) {
    return MessageListModel(
      id: json['id'],
      create_time: json['create_time'],
      msg_type: json['msg_type'],
      msg_id: json['msg_id'],
      from_info: UserInfoModel.fromJson(json['from_info']),
      to_info: UserInfoModel.fromJson(json['to_info']),
      is_read: json['is_read'],
      topicInfo: HomePageModel.fromJson(json['topicInfo']),
      showInfo: ShowInfoModel.fromJson(json['showInfo']),
      replyInfo: ReplyListModel.fromJson(json['replyInfo']),
      commentInfo: CommentListModel.fromJson(json['commentInfo']),
      reply_type: json['reply_type'],
      reply_id: json['reply_id']
    );
  }
}

/*
struct CommentListModel: HandyJSON {
    var comment_id: Int?
    var create_time : String?
    var topic_id : Int?
    var topic_type : Int? // 秀宠1，后面加领养的回复
    var content : String?
    var from_uid : Int?
    var replys: [ReplyListModel]?
    var isOpend: Bool? // 回复是否折叠，true 是全部展示,false 时展示折叠cell
    var showReply: [ReplyListModel]?
    var userInfo: UserInfoModel?
    var reply_count: Int?
    var next_page: Int = 2
 */

class CommentListModel {
  final int comment_id;
  final String create_time;
  final int topic_id;
  final int topic_type;
  final String content;
  final int from_uid;
  final List<ReplyListModel> replys;
  final List<ReplyListModel> showReply;
  final UserInfoModel userInfo;
  final int reply_count;
  final int next_page;

  CommentListModel({
    this.comment_id,
    this.create_time,
    this.topic_id,
    this.topic_type,
    this.content,
    this.from_uid,
    this.replys,
    this.showReply,
    this.userInfo,
    this.reply_count,
    this.next_page,
  });

  factory CommentListModel.fromJson(Map<String,dynamic> json) {
    return CommentListModel(
      comment_id: json['comment_id'],
      create_time: json['create_time'],
      topic_id: json['topic_id'],
      topic_type: json['topic_type'],
      content: json['content'],
      from_uid: json['from_uid'],
      replys: (json['replys'] as List)?.map((e) => ReplyListModel.fromJson(e)).toList(),
      showReply: (json['replys'] as List)?.map((e) => ReplyListModel.fromJson(e)).toList(),
      userInfo: UserInfoModel.fromJson(json['userInfo']),
      reply_count: json['reply_count'],
      next_page: json['next_page'],
    );
  }
}

/*
struct ReplyListModel: HandyJSON {
    var id: Int?
    var comment_id : Int?
    var reply_id : Int? // #表示回复目标的 id，如果 reply_type 是 comment 的话，那么 reply_id ＝ commit_id，如果 reply_type 是 reply 的话，这表示这条回复的父回复。
    var reply_type : Int? // #表示回复的类型，因为回复可以是针对评论的回复（comment），也可以是针对回复的回复（reply）， 通过这个字段来区分两种情景。
    var content : String?
    var from_uid : Int?
    var to_uid : Int?
    var fromInfo: UserInfoModel?
    var toInfo: UserInfoModel?
    var create_time: String?

 */
class ReplyListModel {
  final int id;
  final int comment_id;
  final int reply_id;
  final int reply_type;
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
      create_time: json['create_time'],
    );
  }

}

import 'package:flutter/material.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';

import 'CommentModel.dart';
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
  final bool is_read;
  final HomePageModel topicInfo;
  final ShowInfoModel showInfo;
  final ReplyListModel replyInfo;
  final MessageCommentModel commentInfo;
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
      from_info:json['from_info'] != null ? UserInfoModel.fromJson(json['from_info']) : null,
      to_info: json['to_info'] != null ? UserInfoModel.fromJson(json['to_info']) : null,
      is_read: json['is_read'],
      topicInfo: json['topicInfo'] != null ? HomePageModel.fromJson(json['topicInfo']) : null,
      showInfo: json['showInfo'] != null ? ShowInfoModel.fromJson(json['showInfo']) : null,
      replyInfo: json['replyInfo'] != null ? ReplyListModel.fromJson(json['replyInfo']) : null,
      commentInfo: json['commentInfo'] != null ? MessageCommentModel.fromJson(json['commentInfo']) : null,
      reply_type: json['reply_type'],
      reply_id: json['reply_id']
    );
  }
}

class MessageCommentModel {
  final int id;
  final String content;
  final int topic_id;
  final int topic_type;
  final int from_uid;
  final int to_uid;

  MessageCommentModel({
    this.id,
    this.content,
    this.topic_id,
    this.topic_type,
    this.from_uid,
    this.to_uid,
  });

  factory MessageCommentModel.fromJson(Map<String,dynamic> json) {
    return MessageCommentModel(
      id: json['id'],
      content: json['content'],
      topic_id: json['topic_id'],
      topic_type: json['topic_type'],
      from_uid: json['from_uid'],
      to_uid: json['to_uid']
    );
  }
}

class UnreadModel {
  UnreadModel({this.sys_unread, this.like_unread, this.collec_unread, this.com_unread, this.sys_un_list});
  final int sys_unread;
  final int like_unread;
  final int collec_unread;
  final int com_unread;
  final List<SysUnreadMsgModel> sys_un_list;
  factory UnreadModel.fromJson(Map<String,dynamic> json) {
    return UnreadModel(
      sys_unread: json['sys_unread'],
      like_unread: json['like_unread'],
      collec_unread: json['collec_unread'],
      com_unread: json['com_unread'],
      sys_un_list: (json['sys_un_list'] as List)?.map((e) => SysUnreadMsgModel.fromJson(e))?.toList(),
    );
  }
}

class SysUnreadMsgModel {
  /*
    未读消息列表
    platform: 平台 0 全部 ，1苹果，2安卓
    system_id: 系统消息的id
    version: 未读的系统，如果比这个系统数大，这条未读将不显示,0: 全部显示
    msg_type: 0. 公共通知    1.个人通知
    user_id: 个人user_id
    hidden: 隐藏：0：隐藏，1：显示
   */
  SysUnreadMsgModel({
    this.id,
    this.create_time,
    this.platform,
    this.system_id,
    this.version,
    this.msg_type,
    this.user_id,
    this.hidden
  });
  final int id;
  final String create_time;
  final int platform;
  final int system_id;
  final int version;
  final int msg_type;
  final int user_id;
  final int hidden;

  factory SysUnreadMsgModel.fromJson(Map<String,dynamic> json) {
    return SysUnreadMsgModel(
      id: json['id'],
      create_time: json['create_time'],
      platform: json['platform'],
      system_id: json['system_id'],
      version: json['version'],
      msg_type: json['msg_type'],
      user_id: json['user_id'],
      hidden: json['hidden']
    );
  }
}

class SystemMsgModel {
  final int id;
  final String create_time;
  final String content;
  final int msg_type;
  final int user_id;

  SystemMsgModel({this.id, this.create_time,this.content,this.msg_type,this.user_id});
  factory SystemMsgModel.fromJson(Map<String,dynamic> json)
  {
    return SystemMsgModel(
      id: json['id'],
      create_time: json['create_time'],
      content: json['content'],
      msg_type: json['msg_type'],
      user_id: json['user_id']
    );
  }
}

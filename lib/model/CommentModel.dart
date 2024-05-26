import 'UserModel.dart';

class CommentInfoModel {
  int? comment_id;
  String? create_time;
  int? topic_id;
  int? topic_type; // 秀宠1，后面加领养的回复
  String? content;
  int? from_uid;
  List<ReplyListModel>? replys;
  bool? isOpend; // 回复是否折叠，true 是全部展示,false 时展示折叠cell
  List<ReplyListModel>? showReply;
  UserInfoModel? userInfo;
  int? reply_count;
  int? next_page;

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
    var reply_count = json['reply_count'] ?? 0;
    var reply_length = (json['replys'] as List).length;
    print('=======');
    print(reply_count);
    print(reply_length);
    return CommentInfoModel(
      comment_id: json['comment_id'],
      create_time: json['create_time'],
      topic_id: json['topic_id'],
      topic_type: json['topic_type'],
      content: json['content'] as String,
      from_uid: json['from_uid'],
      replys: (json['replys'] as List).map((e) => ReplyListModel.fromJson(e)).toList(),//
      isOpend: reply_count > reply_length ? true : false,
      showReply: [],
      userInfo: UserInfoModel.fromJson(json['userInfo']),
      reply_count: json['reply_count'] ?? 0,
      next_page: 2,
    );
  }
}

class ReplyListModel {
  final int id;
  int? comment_id;
  int? reply_id; // #表示回复目标的 id，如果 reply_type 是 comment 的话，那么 reply_id ＝ commit_id，如果 reply_type 是 reply 的话，这表示这条回复的父回复。
  int? reply_type; // #表示回复的类型，因为回复可以是针对评论的回复（comment），也可以是针对回复的回复（reply）， 通过这个字段来区分两种情景。
  String? content;
  int? from_uid;
  int? to_uid;
  UserInfoModel? fromInfo;
  UserInfoModel? toInfo;
  String? create_time;

  ReplyListModel({
    required this.id,
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
      fromInfo: json['fromInfo'] != null ? UserInfoModel.fromJson(json['fromInfo']) : null,
      toInfo: json['toInfo'] != null ? UserInfoModel.fromJson(json['toInfo']) : null,
      create_time: json['create_time']
    );
  }
}

/// 评论类型
enum CommentType {
   topic_comment, // 1
   show_comment,  // 2
   find_comment, // 3
}

class ComRepListModel {
  int type;
  CommentInfoModel? commentModel;
  ReplyListModel? replyModel;

  ComRepListModel({
    required this.type,
    this.commentModel,
    this.replyModel
  });
}

enum ComTapType {
  comment,
  reply
}

class ComTapTypeInfo {
  ComTapType? tapType;
  String? name;
  ComTapTypeInfo({
    this.tapType,
    this.name
  });
}

/// 回复时的数据模型
class ReplyComModel {
  String? content;
  int? comment_id;
  int? reply_id;
  int? reply_type; //  1回复评论， 2回复回复, comment_id == replyId ? 1 : 2
  int? to_uid;

  ReplyComModel({
    this.content,
    this.comment_id,
    this.reply_id,
    this.reply_type,
    this.to_uid,
  });
}
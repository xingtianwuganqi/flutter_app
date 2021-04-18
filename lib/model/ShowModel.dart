import 'UserModel.dart';

class GambitModel {
  final String descript;
  final int id;
  final int selected;

  GambitModel({this.descript, this.id, this.selected});

  factory GambitModel.fromJson(Map<String, dynamic> json) {
    return GambitModel(descript: json['descript'], id: json['id'], selected: 0);
  }
}

class ShowInfoModel {
  final int show_id;
  final UserInfoModel user;
  final List<String> imgs;
  final int views_num;
  final int likes_num;
  final int collection_num;
  final int comments_num;
  final String instruction;
  final int open;
  final bool liked;
  final bool collectioned;
  final String create_time;
  // final commentInfo: CommentListModel?
  // final commentAttr: NSAttributedString?
  final int commNum;

  ShowInfoModel(
      {this.show_id,
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
      this.commNum});

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
        commNum: json['commNum']);
  }
}

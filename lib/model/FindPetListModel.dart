import 'UserModel.dart';
class FindPetListModel {

  final int findId;
  final String create_time;
  final String update_time;
  final int pet_type;

  final String address;
  final String address_info;
  final int user_id;
  final int is_delete;
  final int effective;
  final String desc;
  final String contact;
  final UserInfoModel userInfo;
  final int liked;
  final int collection;
  final int likeNum;
  final int collectionNum;
  final int commNum;
  //
  // // 自定义字段
  // var attribute: NSAttributedString?
  final bool open;
  //
  final String contact_info;
  final int getedcontact;
  //
  // var id: Int?

  FindPetListModel({
    this.findId,
    this.create_time,
    this.update_time,
    this.pet_type,
    this.address,
    this.address_info,
    this.user_id,
    this.is_delete,
    this.effective,
    this.desc,
    this.contact,
    this.liked,
    this.collection,
    this.likeNum,
    this.collectionNum,
    this.commNum,
    this.open,
    this.contact_info,
    this.getedcontact,
    this.userInfo
  });

  factory FindPetListModel.fromJson(Map<String,dynamic> json) {
    return FindPetListModel(
        findId: json["findId"],
        create_time: json["create_time"],
        update_time: json["update_time"],
        pet_type: json["pet_type"],
        address: json["address"],
        address_info: json["address_info"],
        user_id: json["user_id"],
        is_delete: json["is_delete"],
        effective: json["effective"],
        desc: json["desc"],
        contact: json["contact"],
        liked: json["liked"],
        collection: json["collection"],
        likeNum: json["likeNum"],
        collectionNum: json["collectionNum"],
        commNum: json["commNum"],
        open: json["open"],
        contact_info: json["contact_info"],
        getedcontact: json["getedcontact"],
        userInfo: UserInfoModel.fromJson(json["userInfo"])
    );
  }

}
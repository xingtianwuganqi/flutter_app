import 'UserModel.dart';

class FindPetListModel {

  int findId;
  String create_time;
  String update_time;
  int pet_type;

  String address;
  String address_info;
  int user_id;
  int is_delete;
  int effective;
  String desc;
  String contact;
  UserInfoModel userInfo;
  bool liked;
  bool collection;
  int likeNum;
  int collectionNum;
  int commNum;
  //
  // // 自定义字段
  // var attribute: NSAttributedString?
  bool open;
  //
  String contact_info;
  bool getedcontact;
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
        open: false,
        contact_info: json["contact_info"],
        getedcontact: json["getedcontact"],
        userInfo: UserInfoModel.fromJson(json["userInfo"])
    );
  }
}

class FindPetDetailModel {

  int id;
  String create_time;
  String update_time;
  int pet_type;

  String address;
  String address_info;
  int user_id;
  int is_delete;
  int effective;
  String desc;
  String contact;
  //
  // var id: Int?

  FindPetDetailModel({
    this.id,
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
  });

  factory FindPetDetailModel.fromJson(Map<String,dynamic> json) {
    return FindPetDetailModel(
        id: json["id"],
        create_time: json["create_time"],
        update_time: json["update_time"],
        pet_type: json["pet_type"],
        address: json["address"],
        address_info: json["address_info"],
        user_id: json["user_id"],
        is_delete: json["is_delete"],
        effective: json["effective"],
        desc: json["desc"],
        contact: json["contact"]
    );
  }
}
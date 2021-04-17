
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

// Map<String,dynamic> toJson() =>
// <String,dynamic> {
// "name": name,
// "id" : id,
// "url" : url
// };
}
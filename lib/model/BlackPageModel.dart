class BlackListModel {
  final int id;
  final String name;
  final String contact;
  final String desc;
  final String wx_num;
  final List<String> images;
  final int black_status;
  final int from_userId;
  final int black_type;

  BlackListModel({
    this.id,
    this.name,
    this.contact,
    this.desc,
    this.wx_num,
    this.images,
    this.black_status,
    this.from_userId,
    this.black_type
  });

  factory BlackListModel.fromJson(Map<String,dynamic> json) {
    return BlackListModel(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      desc: json['desc'],
      wx_num: json['wx_num'],
      // images: json['image'],
      black_status: json['black_status'],
      from_userId: json['from_userId'],
      black_type: json['black_type']
    );
  }
}

class BlackInfoModel {
  final String desc;
  final String placeholder;
  final String value;
  final int type;


  BlackInfoModel({
    this.desc,
    this.placeholder,
    this.value,
    this.type,
  });

  factory BlackInfoModel.fromJson(Map<String,dynamic> json) {
    return BlackInfoModel(
        desc: json['desc'],
        placeholder: json['placeholder'],
        value: json['value'],
        type: json['type']
    );
  }
}

/*

struct BlackInfoModel {
    var desc: String?
    var placeholder: String?
    var value: Any?
    var type: BlackDetailType?
}


struct ReleaseReportInfo {
    var phone: String?
    var wx_num: String?
    var name: String?
    var black_type: Int = 1
    var desc: String?
    var photos: [ReleasePhotoModel] = []
}
 */
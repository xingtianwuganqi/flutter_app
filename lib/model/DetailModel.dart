import 'package:flutter/material.dart';

class detailModel {

  final int pvCount;
  final int likeCount;
  final propertyModel property;
  final authorModel author;

  detailModel({
    this.pvCount,
    this.likeCount,
    this.property,
    this.author
  });

  factory detailModel.fromJson(Map<String,dynamic> json) {
    return detailModel(
      pvCount: json["pvCount"],
      likeCount: json["likeCount"],
      property: propertyModel.fromJson(json["property"]),
      author: authorModel.fromJson(json["author"])
    );
  }
}

class propertyModel {
  final int updateDate;
  final String keywords;
  final String name;
  final String remark;
  final String pid;
  final int id;
  final int type;
  final String thumbUrl;
  final int templateId;
  final int selected;
  final int createDate;
  final channelModel channel;

  propertyModel({
    this.updateDate,
    this.keywords,
    this.name,
    this.remark,
    this.pid,
    this.id,
    this.type,
    this.thumbUrl,
    this.templateId,
    this.selected,
    this.createDate,
    this.channel
  });

  factory propertyModel.fromJson(Map<String,dynamic> json) {
    return propertyModel(
      updateDate: json["updateDate"],
      keywords: json["keywords"],
      name: json["name"],
      remark: json["remark"],
      pid: json["pid"],
      id: json["id"],
      type: json["type"],
      thumbUrl: json["thumbUrl"],
      templateId: json["templateId"],
      selected: json["selected"],
      createDate: json["createDate"],
      channel: channelModel.fromJson(json["channel"])
    );
  }
}

class channelModel {
  final String name;
  final int id;
  final String remark;

  channelModel({
    this.name,
    this.id,
    this.remark
  });

  factory channelModel.fromJson(Map<String ,dynamic> json) {
    return channelModel(
      name: json["name"],
      id: json["id"],
      remark: json["remark"]
    );
  }
}

class authorModel {
  final String uid;
  final int expired;
  final String nickname;
  final int cert;
  final String avatar;
  final int id;

  authorModel({
    this.uid,
    this.expired,
    this.nickname,
    this.cert,
    this.avatar,
    this.id
  });

  factory authorModel.fromJson(Map<String,dynamic> json) {
    return authorModel(
      uid: json["uid"],
      expired: json["expired"],
      nickname: json["nickname"],
      cert: json["cert"],
      avatar: json["avatar"],
      id: json["id"]
    );
  }
}

class worthHeadModel {
  final String name;
  final String thumb;
  final String remark;

  worthHeadModel({this.name,this.thumb,this.remark});

  factory worthHeadModel.fromJson(Map<String,dynamic> json) {
    return worthHeadModel(
      name: json["name"],
      thumb: json["thumb"],
      remark: json["remark"]
    );
  }
}
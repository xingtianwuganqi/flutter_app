/*

    "thumb": "https://ssl-thumb.720static.com/@/pano/65cjrpmusk0/90e12819e1c06eda58833fa0784ce080.jpg",
		"name": "重庆师范大学附属实验小学",
		"member": {
			"uid": "dd829wf5ylr",
			"nickname": "小灰灰",
			"cert": 1,
			"vip": 0,
			"url": "https://720yun.com/u/dd829wf5ylr"
		},
		"channel": {
			"name": "中小学",
			"id": 37,
			"url": "https://720yun.com/channel/37"
		},
 */

import 'package:flutter/material.dart';

class ChannelModel {
  final String thumb;
  final String name;
  final channelModel channel;

  ChannelModel({
    this.thumb,
    this.name,
    this.channel
  });

  factory ChannelModel.fromJson(Map<String,dynamic> json){
    return ChannelModel(
      thumb: json["thumb"],
      name: json["name"],
      channel: channelModel.fromJson(json["channel"])
    );
  }
}

class channelModel {
  final String name;
  final int id;
  final String url;

  channelModel({
    this.name,
    this.id,
    this.url
  });

  factory channelModel.fromJson(Map<String,dynamic> json){
    return channelModel(
      name: json["name"],
      id: json["id"],
      url: json["url"]
    );
  }

  Map<String,dynamic> toJson() =>
      <String,dynamic> {
        "name": name,
        "id" : id,
        "url" : url
      };
}

class channel {
  final int channelId;
  final String channelName;
  final String channelThumb;

  channel({
    this.channelId,
    this.channelName,
    this.channelThumb
  });

  factory channel.fromJson(Map<String,dynamic> json) {
    return channel(
      channelId: json["channelId"],
      channelName: json["channelName"],
      channelThumb: json["channelThumb"]
    );
  }

  Map<String,dynamic> toJson() {
    return <String,dynamic> {
      "channelId": channelId,
      "channelName": channelName,
      "channelThumb": channelThumb
    };
  }
}

class FindBanner {
  final String link;
  final String name;
  final String thumb;

  FindBanner({
    this.link,
    this.name,
    this.thumb
  });

  factory FindBanner.fromJson(Map<String,dynamic> json) {
    return FindBanner(
      link: json["link"],
      name: json["name"],
      thumb: json["thumb"]
    );
  }

  Map<String,dynamic> toJson() {
    return <String,dynamic> {
      "link": link,
      "name": name,
      "thumb": thumb
    };
  }
}
/*
    categoryId = 1;
    categoryName = "\U5168\U666f\U4e13\U9898";
    dataId = 552;
    memberThumb = "https://ssl-avatar.720static.com/@/avatar/32e22ca5qer/0adb70f7cc8c6a6801d85c485ed6c0f9.jpg";
    nickname = "\U5b98\U65b9\U8d26\U6237";
    thumb = "https://ssl-offical2.720static.com/article/upload/5cdc56ad-fd2d-4838-a00e-8b0b85cebab3.jpg";
    title = "\U3010\U4eca\U65e5\U63a8\U8350\U3011VR\U5168\U666f\U770b\U6df1\U5733\U6587\U535a\U4f1a";
    viewCount = 58;
 */
class special {
  final int categoryId;
  final String categoryName;
  final String dataId;
  final String memberThumb;
  final String nickname;
  final String thumb;
  final String title;
  final int viewCount;

  special({
    this.categoryId,
    this.categoryName,
    this.dataId,
    this.memberThumb,
    this.nickname,
    this.thumb,
    this.title,
    this.viewCount
  });

  factory special.fromJson(Map<String,dynamic> json) {
    return special(
      categoryId: json["categoryId"],
      categoryName: json["categoryName"],
      dataId: json["dataId"],
      memberThumb: json["memberThumb"],
      nickname: json["nickname"],
      thumb: json["thumb"],
      title: json["title"],
      viewCount: json["viewCount"]
    );
  }
}
/*
    dataId = 3;
    memberCount = 28;
    thumb = "https://ssl-offical2.720static.com/member/category/upload/o_1cnqtvrp519uc1odo1l8d1j0r1rmb7.jpg";
    title = "\U4ece\U6f20\U6cb3\U5230\U5357\U6c99";
 */
class followed {
  final String dataId;
  final int memberCount;
  final String thumb;
  final String title;

  followed({
    this.dataId,
    this.memberCount,
    this.thumb,
    this.title
  });

  factory followed.fromJson(Map<String,dynamic> json) {
    return followed(
      dataId: json['dataId'],
      memberCount: json['memberCount'],
      thumb: json['thumb'],
      title: json['title']
    );
  }
}
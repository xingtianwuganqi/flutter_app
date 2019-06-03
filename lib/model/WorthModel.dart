import 'package:flutter/material.dart';

class worthModel {
  final String uid;
  final String thumb;
  final int popularity;
  final String nickname;
  final int selectCount;
  final String location;
  final String remark;
  final int id;
  final int productCount;
  final String url;
  final List<productsModel> products;

  worthModel({
    this.uid,
    this.thumb,
    this.popularity,
    this.nickname,
    this.selectCount,
    this.location,
    this.remark,
    this.id,
    this.productCount,
    this.url,
    this.products
  });

  factory worthModel.fromJson(Map<String,dynamic> json) {

    var list = json["products"] as List;
    List<productsModel> productsList = list.map((i) => productsModel.fromJson(i)).toList();

    return worthModel(
      uid: json["uid"],
      thumb: json["thumb"],
      popularity: json["popularity"],
      nickname: json["nickname"],
      selectCount: json["selectCount"],
      location: json["location"],
      remark: json["remark"],
      id: json["id"],
      productCount: json["productCount"],
      url: json["url"],
      products: productsList,
    );
  }

}

class productsModel {
  final String thumb;
  final String name;
  final String pid;
  final int id;
  final String url;

  productsModel({
    this.thumb,
    this.name,
    this.pid,
    this.id,
    this.url
  });

  factory productsModel.fromJson(Map<String,dynamic> json) {
    return productsModel(
      thumb: json["thumb"],
      name: json["name"],
      pid: json["pid"],
      id: json["id"],
      url: json["url"]
    );
  }
}
import 'package:flutter/material.dart';

class bannerModel {
  final String link;
  final String name;
  final String thumb;

  bannerModel({
    this.link,
    this.name,
    this.thumb
  });

  factory bannerModel. fromJson(Map<String,dynamic> json) {
    return bannerModel(
      link: json["json"],
      name: json["name"],
      thumb: json["thumb"],
    );
  }


}
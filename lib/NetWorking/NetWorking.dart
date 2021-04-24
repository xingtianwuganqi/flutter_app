
import 'package:dio/dio.dart';
import 'dart:async';

Dio dio = new Dio();

class NetWorking {

  static Future get(String url,{Map<String,dynamic> params}) async{
    try {
      var response = await dio.get(url,queryParameters: params);
      return response.data;
    }catch (e){
      return  e;
    }
  }

  static Future post(String url, {Map<String,dynamic> params}) async {
    try {
      var response = await dio.post(url,data:params);
      return response.data;
    }catch(e) {
      print(e);
      return e;
    }
  }

  static Future formDataPost(String url, FormData formData) async {
    try {
      var response = await dio.post(url,data: formData);
      return response.data;
    }catch(e){
      return e;
    }
  }
}

class NetWorkingConfig {
  static final UrlConfig urlConfig = UrlConfig.test;
  static String baseUrl() {
    switch (urlConfig) {
      case UrlConfig.formal:
        return 'https://rescue.rxswift.cn';
      case UrlConfig.test:
        return 'https://test.rxswift.cn';
      case UrlConfig.local:
        return 'http://127.0.0.1:8000';
      default:
        return '';
    }
  }
  static String get imgBaseUrl => 'http://img.rxswift.cn/';

  static String path(NetPath path) {
    var baseUrl = NetWorkingConfig.baseUrl();
    switch (path) {
      case NetPath.login:
        return baseUrl + '/api/v1/login/';
      case NetPath.register:
        return baseUrl + '/api/v1/register/';
      case NetPath.topiclist:
        return baseUrl + '/api/v1/topiclist/';
      case NetPath.gambitlist:
        return baseUrl + '/api/v1/gambitlist/';
      case NetPath.topicdetail:
        return baseUrl + '/api/v1/topicdetail/';
      case NetPath.search:
        return baseUrl + '/api/v1/search/';
      case NetPath.searchkeyword:
        return baseUrl + '/api/v1/searchkeywords/';
      case NetPath.showInfoList:
        return baseUrl + '/api/v1/showinfolist/';
      case NetPath.authcollection:
        return baseUrl + '/api/v1/authcollection/';
      case NetPath.authpublish:
        return baseUrl + '/api/v1/authpublishlist/';
      case NetPath.suggestion:
        return baseUrl + '/api/v1/suggestion/';
      case NetPath.authpublishshowinfo:
        return baseUrl + '/api/v1/authpublishshowinfo/';
      case NetPath.authcollectionshowinfo:
        return baseUrl + '/api/v1/authcollectionshowinfo/';
      case NetPath.authhistorylist:
        return baseUrl + '/api/v1/authhistorylist/';
      default:
        return "";
    }
  }
}

enum UrlConfig {
  formal,
  test,
  local
}

enum NetPath {
  login,
  register,
  topiclist,
  gambitlist,
  topicdetail,
  search,
  searchkeyword,
  showInfoList,
  authpublish,
  authcollection,
  suggestion,
  authpublishshowinfo,
  authcollectionshowinfo,
  authhistorylist,
}
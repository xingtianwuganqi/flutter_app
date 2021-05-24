
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';

Dio dio = new Dio();

typedef SuccessCallBack = void Function(dynamic data);
typedef FailureCallBack = void Function(dynamic error);

class NetWorking {

  static Future get(String url,SuccessCallBack successBack,FailureCallBack failBack,{Map<String,dynamic> params}) async{
    try {
      var response = await dio.get(url,queryParameters: params);
      successBack(response.data);
    }catch (e){
      failBack(e);
    }
  }

  static Future post(String url,SuccessCallBack successBack,FailureCallBack failBack,{Map<String,dynamic> params}) async {
    try {
      var response = await dio.post(url,data:params);
      successBack(response.data);
    }catch(e) {
      failBack(e);
    }
  }

  static Future formDataPost(String url, FormData formData,SuccessCallBack successBack,FailureCallBack failBack) async {
    try {
      var response = await dio.post(url,data: formData);
      // Map<String, dynamic> responseData =  jsonDecode(response.data);
      successBack(response.data);
    }catch(e){
      Printer.printMapJsonLog(e);
      if (e is DioError) {
        // 退出登录
        if (e.response.statusCode == 403) {
          EasyLoading.showToast('认证有误,请重新登录');
          UserManager.instance.logout();
        }
      }
      failBack(e);
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
  changePswd,
  updateUserInfo,
  authorMessage,
  violations,
  report,
  commentList,
  pushComment, // 发表评论
  replyComment, // 回复评论
  tagsInfo,
  pushGambit,
  qiniuToken,
  releaseTopicInfo,
  releaseShowInfo,
  homeLikeClick,
  homeCollectClick,
  showInfoLikeClick,
  showInfoCollectClick,
  addViewHistory,
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
      case NetPath.changePswd:
        return baseUrl + '/api/v1/updatetokenpassword/';
      case NetPath.updateUserInfo:
        return baseUrl + '/api/v1/updateuserinfo/';
      case NetPath.authorMessage:
        return baseUrl + '/api/v1/authmessage/';
      case NetPath.violations:
        return baseUrl + '/api/v1/violations/';
      case NetPath.report:
        return baseUrl + '/api/v1/report/';
      case NetPath.commentList:
        return baseUrl + '/api/v1/commentlist/';
      case NetPath.pushComment:
        return baseUrl + '/api/v1/commentaction/';
      case NetPath.replyComment:
        return baseUrl + '/api/v1/replycomment/';
      case NetPath.tagsInfo:
        return baseUrl + '/api/v1/gettaglist/';
      case NetPath.pushGambit:
        return baseUrl + '/api/v1/creategambitinfo/';
      case NetPath.qiniuToken:
        return baseUrl + '/api/v1/qiniu/';
      case NetPath.releaseTopicInfo:
        return baseUrl + '/api/v1/releasetopic/';
      case NetPath.releaseShowInfo:
        return baseUrl + "/api/v1/releaseshowinfo/";
      case NetPath.homeLikeClick:
        return baseUrl + '/api/v1/likeaction/';
      case NetPath.homeCollectClick:
        return baseUrl + '/api/v1/collection/';
      case NetPath.showInfoLikeClick:
        return baseUrl + '/api/v1/showinfolikeaction/';
      case NetPath.showInfoCollectClick:
        return baseUrl + '/api/v1/showcollectionaction/';
      case NetPath.addViewHistory:
        return baseUrl + '/api/v1/addviewhistory/';
      default:
        return "";
    }
  }
}


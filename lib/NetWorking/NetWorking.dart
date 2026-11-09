
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';


BaseOptions options = new BaseOptions(
  baseUrl: NetWorkingConfig.baseUrl(),
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 5),
);

Dio dio = new Dio(options);

typedef SuccessCallBack = void Function(dynamic data);
typedef FailureCallBack = void Function(dynamic error);

class NetWorking {

  static Future get(String url, Map<String,dynamic> params, SuccessCallBack successBack,FailureCallBack failBack) async{
    try {
      var response = await dio.get(url,queryParameters: params);
      successBack(response.data);
    }catch (e){
      failBack(e);
    }
  }

  static Future post(String url, Map<String,dynamic> params,SuccessCallBack successBack,FailureCallBack failBack) async {
    try {
      var response = await dio.post(url,data:params);
      successBack(response.data);
    }catch(e) {
      failBack(e);
    }
  }

  static Future formDataPost(String url, Map<String,dynamic> dic,SuccessCallBack successBack,FailureCallBack failBack) async {
    Printer.printMapJsonLog('😁😁😁');
    Printer.printMapJsonLog(url);
    Printer.printMapJsonLog(dic);
    try {
      FormData formData = FormData.fromMap(dic);
      var response = await dio.post(url,data: formData);
      Printer.printMapJsonLog('++++++++++');
      Printer.printMapJsonLog(response.data);
      successBack(response.data);
    }catch(e){
      failBack(e);
      Printer.printMapJsonLog("----======-----");
      Printer.printMapJsonLog(e);
      if (e is DioError) {
        // 退出登录
        if (e.response?.statusCode == 403) {
          EasyLoading.showToast('认证有误,请重新登录');
          UserManager.instance.logout();
        }
      }
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
  confirmPhoneInfo,
  loginUpdatePswd,
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
  moreReplyInfo,
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
  /// 服务协议的url
  pravicy,
  userAgreen,
  aboutUs,
  instruction,

  getContact,
  authUnreadMsg,
  systemMeg,
  completeRescue,
  appUpload,
  appdownload,

  // v2/getuserpublish/
  userIdGetUserPublish,
  getUserShowPublish,
  // 改变领养状态
  changeRescueState,
  // userid查询userInfo
  userIdGetUserInfo,
  // 黑名单
  blackList,
  // 黑名单详情
  blackDetail,
  // 举报
  blackCreate,
  // 获取验证码
  getVerificationCode,
  // 校验验证码
  checkVerificationCode,
  // 校验手机号
  checkPhoneStationCode,
  // 绑定手机号
  bindPhoneStationCode,
  /// 同城列表
  localCityList,
  /// 找宠列表
  findPetList,
  /// 查询是否已发布找宠信息
  loadFintPetInfo,
  /// 发布找宠信息
  createFindPet,
  /// 更新找宠信息是否有效
  changeFindPetEffective,
  /// 找宠列表点赞
  findPetLikeAction,
  /// 找宠列表收藏
  findPetCollectionAction,

}

enum ThumbType {
  thumbNail,
  thumbFour,
  thumbSeven,
}

class NetWorkingConfig {
  static final UrlConfig urlConfig = UrlConfig.formal;
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
  static String imgBaseUrl = 'http://img.rxswift.cn/';
  static String imgNailTail = "?imageView2/0/q/20";
  static String imgFourTail = "?imageView2/0/q/40";
  static String imgSevenTail = "?imageView2/0/q/70";
  static String path(NetPath path) {
    var baseUrl = NetWorkingConfig.baseUrl();
    switch (path) {
      case NetPath.login:
        return baseUrl + '/api/v1/login/';
      case NetPath.register:
        return baseUrl + '/api/v1/register/';
      case NetPath.confirmPhoneInfo:
        return baseUrl + '/api/v1/confirminfo/';
      case NetPath.loginUpdatePswd:
        return baseUrl + '/api/v1/updatepswd/';
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
      case NetPath.moreReplyInfo:
        return baseUrl + '/api/v1/replypageinfo/';
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
      case NetPath.pravicy:
        return baseUrl + "/api/pravicy/";
      case NetPath.userAgreen:
        return baseUrl + "/api/useragreen/";
      case NetPath.aboutUs:
        return baseUrl + "/api/aboutus/";
      case NetPath.getContact:
        return baseUrl + '/api/v1/getcontact/';
      case NetPath.authUnreadMsg:
        return baseUrl + '/api/v1/authunreadnum/';
      case NetPath.systemMeg:
        return baseUrl + '/api/v1/systemnotification/';
      case NetPath.completeRescue:
        return baseUrl + '/api/v1/completetopic/';
      case NetPath.appUpload:
        return baseUrl + '/api/app/upload/';
      case NetPath.appdownload:
        return baseUrl + '/api/download/';
      case NetPath.instruction:
        return baseUrl + '/api/instruction/';
      case NetPath.userIdGetUserPublish:
        return baseUrl + '/api/v2/getuserpublish/';
      case NetPath.getUserShowPublish:
        return baseUrl + '/api/v2/getusershowpublish/';
      case NetPath.changeRescueState:
        return baseUrl + '/api/v2/changecompletestatus/';
      case NetPath.userIdGetUserInfo:
        return baseUrl + '/api/v2/useridgetuserinfo/';
      case NetPath.blackList:
        return baseUrl + '/api/topic/black/list/';
      case NetPath.blackDetail:
        return baseUrl + '/api/topic/black/detail/';
      case NetPath.blackCreate:
        return baseUrl + '/api/topic/black/create/';
      case NetPath.getVerificationCode:
        return baseUrl + '/api/v2/tecent/code/';
      case NetPath.checkVerificationCode:
        return baseUrl + '/api/v2/tecent/check/';
      case NetPath.checkPhoneStationCode:
        return baseUrl + '/api/v2/login/checkphone/';
      case NetPath.bindPhoneStationCode:
        return baseUrl + '/api/v2/login/bindphone/';
      case NetPath.localCityList:
        return baseUrl + '/api/v2/addresstopiclist/';
      case NetPath.findPetList:
        return baseUrl + '/api/v2/findpet/list';
      case NetPath.loadFintPetInfo:
        return baseUrl + '/api/v2/searchpet/info';
      case NetPath.createFindPet:
        return baseUrl + '/api/v2/searchpet/create';
      case NetPath.changeFindPetEffective:
        return baseUrl + '/api/v2/searchpet/effective';
      case NetPath.findPetLikeAction:
        return baseUrl + '/api/v2/find/action/like';
      case NetPath.findPetCollectionAction:
        return baseUrl + '/api/v2/find/action/collect';
      default:
        return "";
    }
  }
}


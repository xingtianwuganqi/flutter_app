import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
class NewUserPublishListPage extends StatefulWidget {

  int pageType = 1;

  NewUserPublishListPage({Key key, this.pageType}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewUserPublishListPageState();
  }
}

class NewUserPublishListPageState extends State<NewUserPublishListPage> {

  List<HomePageModel> publishList = [];
  List<ShowInfoModel> showPublishList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.pageType == 1) {
      getUserPublishListNetworking();
    }else{
      getUserShowPublishListNetworking();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return Scaffold(
    //   body: Container(
    //
    //   ),
    // );
    return Container(
      child: Text('--'),
    );
  }

  Future<Null> getUserPublishListNetworking() async{
    final url = NetWorkingConfig.path(NetPath.userIdGetUserPublish);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['userId'] = UserManager.instance.userInfo.id;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var models = data[data].map((res) {
          var model = HomePageModel.fromJson(res);
          return model;
        });
        publishList = models;
        setState(() {

        });
      }
    }, (error) {
      // EasyLoading.showToast('获取token失败');
    });
  }

  Future<Null> getUserShowPublishListNetworking() async{
    final url = NetWorkingConfig.path(NetPath.getUserShowPublish);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['userId'] = UserManager.instance.userInfo.id;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var models = data[data].map((res) {
          var model = ShowInfoModel.fromJson(res);
          return model;
        });
        showPublishList = models;
        setState(() {

        });

      }
    }, (error) {
      // EasyLoading.showToast('获取token失败');
    });
  }
}
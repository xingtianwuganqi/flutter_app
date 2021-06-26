import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import '../model/HomePageModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../homepage/TopicDetail.dart';

class RescueCollectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RescueCollectState();
  }
}

class RescueCollectState extends State<RescueCollectWidget> with AutomaticKeepAliveClientMixin {

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var page = 1;
  var isFirstLoad = true;

  List<AuthCollectRescueModel> homeModels = [];
  ///加载图片的标识
  bool isLoadingImage = true;

  bool notificationFunction(Notification notification) {
    ///通知类型
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        Printer.printMapJsonLog("开始滚动");
        ///在这里更新标识 刷新页面 不加载图片
        isLoadingImage = false;
        break;
      case ScrollUpdateNotification:
        Printer.printMapJsonLog("正在滚动");
        break;
      case ScrollEndNotification:
        Printer.printMapJsonLog("滚动停止");

        ///在这里更新标识 刷新页面 加载图片
        setState(() {
          isLoadingImage = true;
        });
        break;
      case OverscrollNotification:
        Printer.printMapJsonLog("滚动到边界");
        break;
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // TODO: implement build
    return new Scaffold(
        appBar: null,
        body: refreshBody()
    );
  }

  Widget refreshBody() {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(
        enableInfiniteLoad:false,
      ),
      child: ListView.builder(
          itemCount: homeModels.length,
          itemBuilder: (context,index) {
            var data = homeModels[index];
            return  GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: homePageItemWidget(context, data.topicInfo,(topicId,value) {
                if (value is HomeLikeStatusModel) {
                  homeModels = homeModels.map((e) {
                    var newModel = e;
                    if (newModel.topic_id == topicId) {
                      newModel.topicInfo.liked = value.like == 1 ? true : false;
                      if (newModel.topicInfo.liked) {
                        newModel.topicInfo.likes_num += 1;
                      }else if (newModel.topicInfo.liked == false){
                        if(newModel.topicInfo.likes_num > 0) {
                          newModel.topicInfo.likes_num -= 1;
                        }
                      }
                    }
                    return newModel;
                  }).toList();
                }else if (value is HomeCollectionStatusModel){
                  homeModels = homeModels.map((e) {
                    var newModel = e;
                    if (newModel.topic_id == topicId) {
                      newModel.topicInfo.collectioned = value.collection == 1 ? true : false;
                      if (newModel.topicInfo.collectioned) {
                        newModel.topicInfo.collection_num += 1;
                      }else if (newModel.topicInfo.collectioned == false){
                        if(newModel.topicInfo.collection_num > 0) {
                          newModel.topicInfo.collection_num -= 1;
                        }
                      }
                    }
                    return newModel;
                  }).toList();
                }else if(value is int) {
                  homeModels = homeModels.map((e) {
                    var newModel = e;
                    if (newModel.topic_id == topicId) {
                      newModel.topicInfo.commNum = value;
                    }
                    return newModel;
                  }).toList();
                }
                setState(() {

                });
              }),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return TopicDetailWidget(topicId: data.topic_id);
                }));
              },
            );

          }
      ),
      firstRefresh: isFirstLoad,
      firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: homeModels.length > 0 ? null : EmptyPage(() async {
        await loadRescueCollectList(1);
      },title: '暂无数据',desc: '快去收藏领养吧'),
      onRefresh:() async {
        await loadRescueCollectList(1);
      },
      onLoad: () async{
        await loadRescueCollectList(page);
      },

    );
  }

  Future<Null> loadRescueCollectList(int num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authcollection);
    final dic = {'token': UserManager.instance.token,'page': page,'size': 10};
    print('resuce request');
    print(url);
    print(dic);
    await NetWorking.formDataPost(url, dic,(data){
      print(data);
      if (data['code'] == 200) {
        isFirstLoad = false;
        List<AuthCollectRescueModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new AuthCollectRescueModel.fromJson(models[i]));
        }
        page > 1 ? homeModels += datas : homeModels = datas;
        if (models.length > 0) {
          page += 1;
        }
        setState(() {

        });
      }else{
        isFirstLoad = false;
      }
    },(error){

    });

  }
}
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import '../model/HomePageModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../homepage/TopicDetail.dart';

class RescuePublishWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RescuePublishState();
  }
}

class RescuePublishState extends State<RescuePublishWidget> with AutomaticKeepAliveClientMixin {

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var page = 1;
  var isFirstLoad = true;

  List<HomePageModel> homeModels = [];
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
    // loadRescuePublishList(1);
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
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              child: Text('点击右上角更多，点击完成领养，即代表宠物已被领养，他人将无法获取你的联系方式',style: TextStyle(
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                  fontSize: FontUtil.fs(FontSize.desc)
              ),),
              color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
              padding: EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate( (context,index) {
                var data = homeModels[index];
                return publishCell(data);
              },
                childCount: homeModels.length,
              )
          )
        ],
      ),
      firstRefresh: isFirstLoad,
      firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: homeModels.length > 0 ? null : EmptyPage(() async{
        await loadRescuePublishList(1);
      },title: '暂无发布',desc: '快去发布送养吧'),
      onRefresh:() async {
        await loadRescuePublishList(1);
      },
      onLoad: () async{
        await loadRescuePublishList(page);
      },

    );
  }

  Widget publishCell (HomePageModel data) {
    return  GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: homePageItemWidget(context, data,(topicId,value){
        if (value is HomeLikeStatusModel) {
          homeModels = homeModels.map((e) {
            var newModel = e;
            if (newModel.topic_id == topicId) {
              newModel.liked = value.like == 1 ? true : false;
              if (newModel.liked) {
                newModel.likes_num += 1;
              }else if (newModel.liked == false){
                if(newModel.likes_num > 0) {
                  newModel.likes_num -= 1;
                }
              }
            }
            return newModel;
          }).toList();
        }else if (value is HomeCollectionStatusModel){
          homeModels = homeModels.map((e) {
            var newModel = e;
            if (newModel.topic_id == topicId) {
              newModel.collectioned = value.collection == 1 ? true : false;
              if (newModel.collectioned) {
                newModel.collection_num += 1;
              }else if (newModel.collectioned == false){
                if(newModel.collection_num > 0) {
                  newModel.collection_num -= 1;
                }
              }
            }
            return newModel;
          }).toList();
        }else if(value is int) {
          homeModels = homeModels.map((e) {
            var newModel = e;
            if (newModel.topic_id == topicId) {
              newModel.commNum = value;
            }
            return newModel;
          }).toList();
        }else if (value is bool) {
          if (value == true) {
            homeModels = homeModels.map((e) {
              var newModel = e;
              if (newModel.topic_id == topicId) {
                newModel.is_complete = true;
              }
              return newModel;
            }).toList();
          }
        }
        setState(() {

        });
      },fromInfo: 'publish'),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return TopicDetailWidget(topicId: data.topic_id);
        }));
      },
    );
  }

  Future<Null> loadRescuePublishList(int num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authpublish);
    final dic = {'token': UserManager.instance.token,'page': page,'size': 10};
    await NetWorking.formDataPost(url, dic,(data){
      if (data['code'] == 200) {
        isFirstLoad = false;
        List<HomePageModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new HomePageModel.fromJson(models[i]));
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
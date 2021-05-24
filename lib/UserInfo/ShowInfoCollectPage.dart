import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoListPage.dart';

class ShowCollectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowCollectState();
  }
}

class ShowCollectState extends State<ShowCollectWidget> with AutomaticKeepAliveClientMixin {

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var page = 1;
  var isFirstLoad = true;
  List<AuthCollectShowInfoModel> showInfoLists = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false,
        ),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget: showInfoLists.length > 0 ? null :
        EmptyPage((){
          showCollectListNetWroking(1);
        },title: '暂无数据',desc: '快去收藏秀宠吧'),
        child: ListView.builder(
            itemCount: showInfoLists.length,
            itemBuilder: (context, index) {
              var data = showInfoLists[index];
              return showInfoItem(context,data.showInfo,(showId,value) {
                if (value is HomeLikeStatusModel) {
                  showInfoLists = showInfoLists.map((e) {
                    var newModel = e;
                    if (newModel.showInfo.show_id == showId) {
                      newModel.showInfo.liked = value.like == 1 ? true : false;
                      if (newModel.showInfo.liked) {
                        newModel.showInfo.likes_num += 1;
                      }else if (newModel.showInfo.liked == false){
                        if(newModel.showInfo.likes_num > 0) {
                          newModel.showInfo.likes_num -= 1;
                        }
                      }
                    }
                    return newModel;
                  }).toList();
                }else if (value is HomeCollectionStatusModel){
                  showInfoLists = showInfoLists.map((e) {
                    var newModel = e;
                    if (newModel.showInfo.show_id == showId) {
                      newModel.showInfo.collectioned = value.collection == 1 ? true : false;
                      if (newModel.showInfo.collectioned) {
                        newModel.showInfo.collection_num += 1;
                      }else if (newModel.showInfo.collectioned == false){
                        if(newModel.showInfo.collection_num > 0) {
                          newModel.showInfo.collection_num -= 1;
                        }
                      }
                    }
                    return newModel;
                  }).toList();
                }
                setState(() {

                });
              });
            }
        ),
        onRefresh: () async {
          await showCollectListNetWroking(1);
        },
        onLoad: () async {
          await showCollectListNetWroking(page);
        },
      ),
    );
  }



  Future<Null> showCollectListNetWroking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authcollectionshowinfo);
    final dic = {"page": page,"size": 10,'token': UserManager.instance.token};
    FormData formData = FormData.fromMap(dic);

    print('show request');
    print(dic);
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      print(data);
      if (data['code'] == 200) {
        List<AuthCollectShowInfoModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new AuthCollectShowInfoModel.fromJson((models[i])));
        }
        page > 1 ? showInfoLists += datas : showInfoLists = datas;
        if (models.length > 0) {
          page += 1;
        }
        setState(() {
          isFirstLoad = false;
        });
      }else{
        isFirstLoad = false;
      }
    },(error){

    });

  }
}
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';
import 'ShowInfoListPage.dart';

class ShowInfoSingleWidget extends StatefulWidget {
  final int showId;
  final int gambitId;

  ShowInfoSingleWidget({this.showId,this.gambitId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowInfoSingleState();
  }
}

class ShowInfoSingleState extends State<ShowInfoSingleWidget> with AutomaticKeepAliveClientMixin {
  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var isFirstLoad = true;
  var page = 1;

  List<ShowInfoModel> showInfoLists = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text('秀宠'),
          elevation: 0.5,
        ),
        body: (widget.showId != null) ? noFooterWidget() : hadFooterWidget(),
      )
    );
  }

  Widget hadFooterWidget() {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(
        enableInfiniteLoad: false,
      ),
      firstRefresh: isFirstLoad,
      firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: showInfoLists.length > 0 ? null : EmptyPage((){
        showInfoListNetWroking(1);
      }),
      child: ListView.builder(
          itemCount: showInfoLists.length,
          itemBuilder: (context, index) {
            var data = showInfoLists[index];
            return showInfoItem(context,data,(showId,value) {
              if (value is HomeLikeStatusModel) {
                showInfoLists = showInfoLists.map((e) {
                  var newModel = e;
                  if (newModel.show_id == showId) {
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
                showInfoLists = showInfoLists.map((e) {
                  var newModel = e;
                  if (newModel.show_id == showId) {
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
              }else if (value is int) {
                showInfoLists = showInfoLists.map((e) {
                  var newModel = e;
                  if (newModel.show_id == showId) {
                    newModel.commNum = value;
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
        await showInfoListNetWroking(1);
      },
      onLoad: () async {
        await showInfoListNetWroking(page);
      },
    );
  }

  Widget noFooterWidget() {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(
        enableInfiniteLoad: false,
      ),
      firstRefresh: isFirstLoad,
      firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: showInfoLists.length > 0 ? null : EmptyPage((){
        showInfoListNetWroking(1);
      }),
      child: ListView.builder(
          itemCount: showInfoLists.length,
          itemBuilder: (context, index) {
            var data = showInfoLists[index];
            return showInfoItem(context,data,(showId,value){
              if (value is HomeLikeStatusModel) {
                showInfoLists = showInfoLists.map((e) {
                  var newModel = e;
                  if (newModel.show_id == showId) {
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
                showInfoLists = showInfoLists.map((e) {
                  var newModel = e;
                  if (newModel.show_id == showId) {
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
              }else if (value is int) {
                showInfoLists = showInfoLists.map((e) {
                  var newModel = e;
                  if (newModel.show_id == showId) {
                    newModel.commNum = value;
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
        await showInfoListNetWroking(1);
      },
    );
  }

  Future<Null> showInfoListNetWroking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.showInfoList);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["page"] = page;
    dic["size"] = 10;
    dic['show_id'] = widget.showId;
    dic['gambit_id'] = widget.gambitId;

    FormData formData = FormData.fromMap(dic);

    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      if (data['code'] == 200) {
        List<ShowInfoModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new ShowInfoModel.fromJson(models[i]));
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


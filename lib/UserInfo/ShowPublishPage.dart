import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoListPage.dart';

class ShowPublishWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowPublishState();
  }
}

class ShowPublishState extends State<ShowPublishWidget> with AutomaticKeepAliveClientMixin {

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var page = 1;
  var isFirstLoad = true;
  List<ShowInfoModel> showInfoLists = [];

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
            showInfoListNetWroking(1);
          },title: '暂无发布',desc: '快去发布秀宠吧'),
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
      ),
    );
  }



  Future<Null> showInfoListNetWroking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authpublishshowinfo);
    final dic = {"page": page,"size": 10,'token': UserManager.instance.token};
    FormData formData = FormData.fromMap(dic);

    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      print(data);
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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
        body: EasyRefresh(
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
                  child: homePageItemWidget(context, data.topicInfo),
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
          emptyWidget: homeModels.length > 0 ? null : EmptyPage((){
            loadRescueCollectList(1);
          },title: '暂无发布',desc: '快去收藏领养吧'),
          onRefresh:() async {
            await loadRescueCollectList(1);
          },
          onLoad: () async{
            await loadRescueCollectList(page);
          },

        )
    );
  }

  Future<Null> loadRescueCollectList(int num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authcollection);
    final dic = {'token': UserManager.instance.token,'page': page,'size': 10};
    FormData formData = FormData.fromMap(dic);
    print('resuce request');
    print(url);
    print(dic);
    await NetWorking.formDataPost(url, formData,(data){
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
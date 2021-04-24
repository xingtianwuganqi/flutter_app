import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
                  child: homePageItemWidget(context, data),
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
            loadRescuePublishList(1);
          },title: '暂无发布',desc: '快去发布送养吧'),
          onRefresh:() async {
            await loadRescuePublishList(1);
          },
          onLoad: () async{
            await loadRescuePublishList(page);
          },

        )
    );
  }

  Future<Null> loadRescuePublishList(int num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authpublish);
    final dic = {'token': UserManager.instance.token,'page': page,'size': 10};
    FormData formData = FormData.fromMap(dic);
    var data = await NetWorking.formDataPost(url, formData);
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
  }
}
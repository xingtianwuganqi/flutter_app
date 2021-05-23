import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:dio/dio.dart';
import 'package:flutter_720yun/homepage/TopicDetail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Common/CommonPage.dart';
import '../model/UserModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';

class BrowseListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BrowseListState();
  }
}

class BrowseListState extends State<BrowseListWidget> {
  var page = 1;
  bool isFirstLoad = true;
  List<AuthHistoryModel> hisModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('浏览记录'),
        elevation: 0.5,
      ),
      body: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad:false,
        ),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget: hisModels.length > 0 ? null : EmptyPage((){
          authHistoryNetWroking(1);
        }),
        child:ListView.builder(
            itemCount: hisModels.length,
            itemBuilder: (context,index){
              var data = hisModels[index];
              return  GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: homePageItemWidget(context, data.topicInfo,(value){

                }),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return TopicDetailWidget(topicId: data.topicInfo.topic_id);
                  }));
                },
              );
            }),
        onRefresh: () async {
          await authHistoryNetWroking(1);
        },
        onLoad: () async {
          await authHistoryNetWroking(page);
        },
      )
    );
  }

  ///authhistorylist
  Future<Null> authHistoryNetWroking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authhistorylist);
    final dic = {"page": page,"size": 10,'token': UserManager.instance.token};
    FormData formData = FormData.fromMap(dic);

    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      print(data);
      if (data['code'] == 200) {
        List<AuthHistoryModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new AuthHistoryModel.fromJson(models[i]));
        }
        page > 1 ? hisModels += datas : hisModels = datas;

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
import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:dio/dio.dart';
import '../Common/CommonPage.dart';
import '../model/UserModel.dart';
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
  List<AuthHistoryModel> homeModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authHistoryNetWroking(1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('浏览记录'),
        elevation: 0.5,
      ),
      body: ListView.builder(
        itemCount: homeModels.length,
          itemBuilder: (context,index){
            return Text('$index');
          }),
    );
  }

  ///authhistorylist
  Future<Null> authHistoryNetWroking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authhistorylist);
    final dic = {"page": page,"size": 10,'token': UserManager.instance.token};
    FormData formData = FormData.fromMap(dic);

    ///创建Map 封装参数
    var data = await NetWorking.formDataPost(url, formData);
    print(data);
    if (data['code'] == 200) {
      List<AuthHistoryModel> datas = [];
      var models = data['data'];
      for (int i = 0;i < models.length; i++ ){
        datas.add(new AuthHistoryModel.fromJson(models[i]));
      }
      page > 1 ? homeModels += datas : homeModels = datas;

      if (models.length > 0) {
        page += 1;
      }
      setState(() {
        isFirstLoad = false;
      });
    }else{
      isFirstLoad = false;
    }
  }
}
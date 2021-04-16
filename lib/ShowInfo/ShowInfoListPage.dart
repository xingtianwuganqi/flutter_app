// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/ShowInfo/Models.dart';
import '../NetWorking/NetWorking.dart';


class ShowInfoListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowInfoListState();
  }
}

class ShowInfoListState extends State<ShowInfoListWidget> with SingleTickerProviderStateMixin {


  List<ShowInfoModel> showInfoLists = [];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    showInfoListNetWroking();
  }

  Widget showInfoItem(ShowInfoModel data) {

    List<Container> imgWidgets = data.imgs.map((e) => Container(
      child: Image.network(e),
    ));


    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(data.user.avator),
                  child: Container(
                    alignment: Alignment(0, .5),
                    width: 30,
                    height: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Text(data.user.name,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis),
                      Text(data.create_time,style: TextStyle(color: Colors.black12,fontSize: 12),overflow: TextOverflow.ellipsis)
                    ],
                  )),
                Expanded(
                    child: Container(

                    )),
                IconButton(icon: Icon(Icons.more_horiz_outlined), onPressed: (){}),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: PageView(
              children: imgWidgets,
            ),
          ),
          // instraction
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15,top: 10,right: 10,bottom: 0),
            child: Text(data.instruction,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14,color: Colors.black),
            ),
          ),
          // 评论
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15,top: 10,right: 15),
            child: Text('添加评论',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: Colors.black),
            ),
          ),
          // 点赞，收藏，评论
          commentWidget(data),
          Divider(thickness: 10,color: Colors.grey[100],)
        ],
      ),
    );
  }

  Widget commentWidget(ShowInfoModel data) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text(data.likes_num > 0 ? data.likes_num.toString() : "点赞"),
                onPressed: (){},
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text(data.collection_num > 0 ? data.collection_num.toString() : "收藏"),
                onPressed: (){},
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text(data.commNum > 0 ? data.commNum.toString() : "收藏"),
                onPressed: (){},
              )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: showInfoLists.length,
          itemBuilder: (context, index) {
            var data = showInfoLists[index];
            return showInfoItem(data);
          }
      ),
    );
  }


  Future<Null> showInfoListNetWroking() async {
    final url = 'https://test.rxswift.cn/api/v1/showinfolist/';
    final dic = {"page": 1,"size": 10};
    FormData formData = FormData.fromMap(dic);

    ///创建Map 封装参数
    var data = await NetWorking.formDataPost(url, formData);
    print(data);
    if (data['code'] == 200) {
      List<ShowInfoModel> datas = [];
      var models = data['data'];
      for (int i = 0;i < models.length; i++ ){
        datas.add(new ShowInfoModel.fromJson(models[i]));
      }
      showInfoLists = datas;
      setState(() {

      });
    }else{

    }
  }
}
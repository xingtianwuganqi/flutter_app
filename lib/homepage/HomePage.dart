import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_720yun/homepage/SearchPage.dart';
import '../NetWorking/NetWorking.dart';
import '../model/HomePageModel.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {


  List<HomePageModel> homeModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePageListNetWroking();
  }

  Widget userInfoWidget(HomePageModel data) {
    return Container(
      padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage("http://img.rxswift.cn/" + data.userInfo.avator),
            child: Container(
              alignment: Alignment(0, .5),
              width: 40,
              height: 40,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.userInfo.username ?? "",textAlign: TextAlign.left,style: TextStyle(color: Colors.black,fontSize: 14),overflow: TextOverflow.ellipsis),
                  Padding(padding: EdgeInsets.all(3)),
                  Text(data.create_time ?? "",style: TextStyle(color: Colors.black12,fontSize: 12),overflow: TextOverflow.ellipsis)
                ],
              )),
          Expanded(
              child: Container(

              )),
          IconButton(icon: Icon(Icons.more_horiz_outlined), onPressed: (){}),
        ],
      ),
    );
  }

  /// 便签文字区
  Widget textInfoWidget(HomePageModel data) {
    /// 标签
    List<Widget> tags = [];

    if (data.tagInfos != null ) {
      if (data.tagInfos.isNotEmpty) {
        tags = data.tagInfos.map((e) => Container(
          color: Colors.blue,
          padding: EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
          child: Text(e.tag_name ?? ""),
        )).toList();
      }
    }
    return Container(
      child: Column(
        children: [
          // 标签
          Container(
            // ignore: null_aware_before_operator
            padding: EdgeInsets.only(left: 60,right: 15,top: 2,bottom: 2),
            alignment: Alignment.centerLeft,
            height: tags.length > 0 ? 30 : 3,
            child: Row(
              children: tags,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 60,right: 10,top: 5,bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(data.content ?? ''),
          ),
        ],
      ),
    );
  }

  Widget imagesWidget(HomePageModel data) {
    if (data.imgs?.length > 4) {
      return Container(
        padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
        height: 250,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 5,bottom: 5),
                        child: Image.network(
                          'http://img.rxswift.cn/' + data.imgs[0],
                          fit:BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity
                          // width: (MediaQuery.of(context).size.width - 100) / 2,
                          // height: 120,
                        ),
                      ),
                    ),
                    Expanded(child:
                    Container(
                      padding: EdgeInsets.only(left:5,bottom: 5),
                      child: Image.network(
                          'http://img.rxswift.cn/' + data.imgs[1],
                        fit:BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity
                      ),

                    )
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child:
                        Container(
                          padding: EdgeInsets.only(right:5,top: 5),
                          child: Image.network(
                              'http://img.rxswift.cn/' + data.imgs[2],
                              fit:BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity
                            // height: 120,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left:5,top: 5),
                            child: Image.network(
                                'http://img.rxswift.cn/' + data.imgs[3],
                              fit:BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity
                              // height: 120,

                            ),
                          )
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      );
    }else if (data.imgs?.length == 3) {
    return Container(
      padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
      // width: MediaQuery.of(context).size.width - 65,
      height: 170,
      child: Row(
        children: [
          Expanded(
            child:
             Container(
                padding: EdgeInsets.only(right: 5),
                child: Image.network(
                    'http://img.rxswift.cn/' + data.imgs[0],
                  fit:BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity
                ),
              ),
          ),
          Expanded(
              child:
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child:
                      Container(
                        padding: EdgeInsets.only(left:5,bottom: 5),
                        child: Image.network(
                            'http://img.rxswift.cn/' + data.imgs[1],
                          fit:BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left:5,top: 5),
                          child: Image.network(
                              'http://img.rxswift.cn/' + data.imgs[2],
                            fit:BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity
                          ),
                        )
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
    }else if (data.imgs.length == 2) {
    return Container(
      padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
      // width: MediaQuery.of(context).size.width - 65,
      height: 170,
      child: Row(
        children: [
          Expanded(
            child:
            Container(
              padding: EdgeInsets.only(right: 5),
              child: Image.network(
                  'http://img.rxswift.cn/' + data.imgs[0],
                fit:BoxFit.cover,
                width: double.infinity,
                height: double.infinity
              ),
            ),
          ),
          Expanded(
            child:
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Image.network(
                  'http://img.rxswift.cn/' + data.imgs[1],
                fit:BoxFit.cover,
                width: double.infinity,
                height: double.infinity
              ),
            ),
          ),
        ],
      ),
    );
    }else if (data.imgs?.length == 1) {
      return Container(
        padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
        // width: MediaQuery.of(context).size.width - 65,
        height: 170,
        child: Image.network(
            'http://img.rxswift.cn/' + data.imgs[0],
          fit:BoxFit.cover,
          width: double.infinity,
          height: double.infinity
        ),
      );
    }
  }

  Widget addressWidget(HomePageModel data) {
    return Container(
      padding: EdgeInsets.only(left: 60,right: 15,top: 5,bottom: 5),
      alignment: Alignment.centerLeft,
      child: Text('地址'),
    );
  }

  Widget commentWidget(HomePageModel data) {
    return Container(
      padding: EdgeInsets.only(left: 60,right: 15),
      height: 40,
      child: Row(
        children: [
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text((data.likes_num ?? 0) > (0) ? data.likes_num.toString() : "点赞"),
                onPressed: (){},
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text((data.collection_num ?? 0) > (0) ? data.collection_num.toString() : "收藏"),
                onPressed: (){},
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:Icon(Icons.panorama),
                label: Text((data.commNum ?? 0) > (0) ? data.commNum.toString() : "收藏"),
                onPressed: (){},
              )
          ),
        ],
      ),
    );
  }



  Widget homePageItemWidget(HomePageModel data) {
    return Container(
      child: Column(
        children: [
          userInfoWidget(data),
          textInfoWidget(data),
          imagesWidget(data),
          addressWidget(data),
          commentWidget(data),
          Divider(height: 1,),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          padding: EdgeInsets.only(left: 20,right: 20),
          width: double.infinity,
          height: 40,
          child:TextButton(
            child: Text('搜索'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SearchPageWidget();
              }));
            },
          ),
        )
      ),
      body: ListView.builder(
        itemCount: homeModels.length,
          itemBuilder: (context,index) {
           var data = homeModels[index];
            return homePageItemWidget(data);
          }
      ),
    );
  }

  Future<Null> homePageListNetWroking() async {
    final url = 'https://test.rxswift.cn/api/v1/topiclist/';
    final dic = {"page": 1,"size": 10};
    FormData formData = FormData.fromMap(dic);
    ///创建Map 封装参数
    var data = await NetWorking.formDataPost(url, formData);
    print(data);
    if (data['code'] == 200) {
      List<HomePageModel> datas = [];
      var models = data['data'];
      for (int i = 0;i < models.length; i++ ){
        datas.add(new HomePageModel.fromJson(models[i]));
      }
      homeModels = datas;
      setState(() {

      });
    }else{

    }
  }
}


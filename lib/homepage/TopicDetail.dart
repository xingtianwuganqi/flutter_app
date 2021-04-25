import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../NetWorking/NetWorking.dart';
import '../model/HomePageModel.dart';
import 'package:dio/dio.dart';
import '../Common/CommonPage.dart';
import 'HomePage.dart';

class TopicDetailWidget extends StatefulWidget {

  final int topicId;

  TopicDetailWidget({
    Key key,
    @required this.topicId
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TopicDetailState();
  }
}

class TopicDetailState extends State<TopicDetailWidget> {

  HomePageModel homeModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePageListNetWroking();
  }

  /// 用户信息
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
          Expanded(
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.userInfo.username ?? "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: ColorsUtil.fromEnmu(ColorEnum.title),
                            fontSize: FontUtil.fs(FontSize.title)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      Text((data.address_info ?? "") + (data.create_time ?? ""),
                          style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
                              fontSize: FontUtil.fs(FontSize.desc)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  )
              ),
          ),
          Container(
            width: 30,
            child: IconButton(icon: Icon(Icons.more_horiz_outlined,
              color: ColorsUtil.fromEnmu(ColorEnum.content),
            ), onPressed: (){}),
          )

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

          decoration: BoxDecoration(
              color: ColorsUtil.fromEnmu(ColorEnum.system),
              borderRadius: BorderRadius.all(Radius.circular(3.0))
          ),
          padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
          child: Text(e.tag_name ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        )).toList();
      }
    }
    return Container(
      child: Column(
        children: [
          // 标签
          Container(
            // ignore: null_aware_before_operator
            padding: EdgeInsets.only(left: 15,right: 15,top: 2,bottom: 2),
            alignment: Alignment.centerLeft,
            height: tags.length > 0 ? 26 : 3,
            child: Row(
              children: tags,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(data.content ?? '',
              maxLines: 7,
              style: TextStyle(
                fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content),
              ),
            ),
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
        ],
      ),
    );
  }

  List<Widget> imageWidgets(HomePageModel model) {
    if ((model?.imgs?.length ?? 0) == 0) {
      return [];
    }else{
      List<Widget> data = [];
      var imgWidgets = model.imgs?.map(
              (e) =>
              Container(
                padding: EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
                child: CachedNetworkImage(
                  imageUrl:  NetWorkingConfig.imgBaseUrl + e,
                  placeholder: (context,url) => Container(
                    color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                  ),
                ),
              ))?.toList();
      data.add(userInfoWidget(homeModel));
      data.add(textInfoWidget(homeModel));
      data += imgWidgets;
      return data;
    }

  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
          title: Text('详情',),
        elevation: 0.5,
      ),
      body:
      SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                    children: imageWidgets(homeModel),
                  )
              ),
              Container(
                child: Column(
                  children: [
                      Container(
                          color: ColorsUtil.fromEnmu(ColorEnum.system),
                          height: 50,
                          width: MediaQuery.of(context).size.width - 30,
                          child: TextButton(
                            child: Text('点击获取联系方式',
                              style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                                  color: Colors.white),
                            ),
                            onPressed: () {

                            },
                          ),
                        ),

                    commentWidget(15,context,homeModel),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Future<Null> homePageListNetWroking() async {
    final url = NetWorkingConfig.path(NetPath.topicdetail);
    final dic = {"topic_id": widget.topicId,"token": UserManager.instance.token ?? ""};
    FormData formData = FormData.fromMap(dic);
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      print(data);
      if (data['code'] == 200) {
        var model = data['data'];
        homeModel = HomePageModel.fromJson(model);
        print(homeModel.imgs);
        setState(() {

        });
      }else{

      }
    },(error){

    });

  }
}


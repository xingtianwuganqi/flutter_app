import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../NetWorking/NetWorking.dart';
import '../model/HomePageModel.dart';
import 'package:dio/dio.dart';
import '../Common/CommonPage.dart';
import 'HomePage.dart';
import 'package:flutter/services.dart';


class TopicDetailWidget extends StatefulWidget {

  final int topicId;

  // 反向传值


  TopicDetailWidget({
    Key key,
    @required this.topicId
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: it createState
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
    addViewHistoryNetWorking();
  }

  /// 用户信息
  Widget userInfoWidget(HomePageModel data) {
    return Container(
      padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: (data.userInfo.avator != null && data.userInfo.avator.length > 0) ? CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + data.userInfo.avator): AssetImage('assets/icons/icon_plh.png'),
            child: Container(
              alignment: Alignment(0, .5),
              width: 40,
              height: 40,
            ),
          ),
          Expanded(
              child:
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                      Text((data.address_info ?? "") + "  " + (ToolConfig.timeT(data.create_time)),// ?? "")
                          style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
                              fontSize: FontUtil.fs(FontSize.desc)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  )
              ),
          ),
          // Container(
          //   width: 30,
          //   child: IconButton(icon: Icon(Icons.more_horiz_outlined,
          //     color: ColorsUtil.fromEnmu(ColorEnum.content),
          //   ), onPressed: (){}),
          // )

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
          margin: EdgeInsets.only(right: 10),
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
              maxLines: null,
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
    var contactInfo = '点击获取联系方式';
    if (homeModel != null && homeModel.getedcontact == true && homeModel.contact_info.length > 0) {
      contactInfo = homeModel.contact_info;
    }
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
                            child: Text(contactInfo,
                              style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              lazyAuthToDoThings(context, (){
                                if (homeModel != null && homeModel.getedcontact == true && homeModel.contact_info.length > 0) {
                                  /// 已经获取了联系方式
                                  //复制
                                  Future.delayed(Duration(milliseconds: 100),(){
                                    Clipboard.setData(ClipboardData(text: homeModel.contact_info));
                                  });
                                  EasyLoading.showToast('已复制');
                                  return;
                                }else{
                                  getTopicInfoContactNetworking();
                                  return;
                                }
                              });
                            },
                          ),
                        ),

                    commentWidget(15,context,homeModel,(comIndex) {
                      if (comIndex == -1) { // 点赞
                        var liked = homeModel.liked == true ?  0 :  1;
                        HomeNetworking.homeLikeClickAction(liked, homeModel.topic_id, (topicId,value) {
                          updateState(topicId,value);
                        });
                      }else if (comIndex == -2) { // 收藏
                        var collected = homeModel.collectioned == true ?  0 :  1;
                        HomeNetworking.homeCollectClickAction(collected, homeModel.topic_id, (topicId,value) {
                          updateState(topicId,value);
                        });
                      }else{
                        updateState(homeModel.topic_id, comIndex);
                      }
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  void updateState(int topicId,dynamic value) {
    if (value is HomeLikeStatusModel) {
        if (homeModel.topic_id == topicId) {
          homeModel.liked = value.like == 1 ? true : false;
          if (homeModel.liked) {
            homeModel.likes_num += 1;
          }else if (homeModel.liked == false){
            if(homeModel.likes_num > 0) {
              homeModel.likes_num -= 1;
            }
          }
        }
    }else if (value is HomeCollectionStatusModel){
      // homeModels = homeModels.map((e) {
      //   var newModel = e;
        if (homeModel.topic_id == topicId) {
          homeModel.collectioned = value.collection == 1 ? true : false;
          if (homeModel.collectioned) {
            homeModel.collection_num += 1;
          }else if (homeModel.collectioned == false){
            if(homeModel.collection_num > 0) {
              homeModel.collection_num -= 1;
            }
          }
        }
    }else if (value is int) {
      if (homeModel.topic_id == topicId) {
        homeModel.commNum = value;
      }
    }
    setState(() {

    });
  }

  Future<Null> homePageListNetWroking() async {
    EasyLoading.show();
    final url = NetWorkingConfig.path(NetPath.topicdetail);
    final dic = {"topic_id": widget.topicId,"token": UserManager.instance.token ?? ""};
    FormData formData = FormData.fromMap(dic);
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        var model = data['data'];
        homeModel = HomePageModel.fromJson(model);
        print(homeModel.imgs);
        setState(() {

        });
      }else{

      }
    },(error){
      EasyLoading.dismiss();
    });

  }

  Future<Null> addViewHistoryNetWorking() async {
    final url = NetWorkingConfig.path(NetPath.addViewHistory);
    var dic = Map.from(paramDic);
    dic['topic_id'] = widget.topicId;
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      print(data);
      if (data['code'] == 200) {

      }
    }, (error) {

    });
  }

  Future<Null> getTopicInfoContactNetworking() async {
    final url = NetWorkingConfig.path(NetPath.getContact);
    var dic = Map.from(paramDic);
    dic['topic_id'] = widget.topicId;
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      if (data['code'] == 200) {
        var model = ContactModel.fromJson(data['data']);
        homeModel.getedcontact = true;
        homeModel.contact_info = model.contact;
        setState(() {

        });
      }else{
        EasyLoading.showToast(data['message'] ?? '获取联系方式失败');
      }
    }, (error) {
      EasyLoading.showToast('网络出错');
    });
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_720yun/CommonWidget/PhotoViewGalleryScreen.dart';
import 'package:flutter_720yun/UserInfo/WebviewPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../NetWorking/NetWorking.dart';
import '../model/HomePageModel.dart';
import 'package:dio/dio.dart';
import '../Common/CommonPage.dart';
import 'HomePage.dart';
import 'package:flutter/services.dart';
import 'TopicShareWidget.dart';


class TopicDetailWidget extends StatefulWidget {

  final int topicId;
  MyPageType pageType = MyPageType.otherPage;
  // 反向传值
  ValueChanged statusChanged;
  TopicDetailWidget({
    Key key,
    @required this.topicId,
    this.pageType,
    this.statusChanged,
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
      padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: (data.userInfo.avator != null && data.userInfo.avator.length > 0) ?
            CachedNetworkImageProvider(ToolConfig.showHeadImg(data.userInfo.avator)):
            AssetImage('assets/icons/icon_plh.png'),
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
          padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
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
            height: tags.length > 0 ? null : 1,
              child:  Column(
                children: [
                  Wrap(
                    spacing: 10,
                    children:tags,
                  )
                ],
              ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 2,bottom: 2),
            alignment: Alignment.centerLeft,
            child: Text((data.content ?? '').trim(),
              maxLines: null,
              style: TextStyle(
                fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content),
                height: 1.4
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

  Widget remindTextWidget() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 5),
        child: Text('点击右上角更多按钮，可修改送养状态。(点击完成领养，即代表宠物已被领养，他人将无法获取你的联系方式)',
        style: TextStyle(
          fontSize: FontUtil.fs(FontSize.mark),
          color: ColorsUtil.fromEnmu(ColorEnum.mark),
        ),),
      ),
    );
  }

  List<Widget> imageWidgets(HomePageModel model) {
    if (model != null && model.imgs != null && (model.imgs.length > 0)) {
      List<Widget> data = [];
      List<ImgIndexModel> imgs = [];
      List<ImgIndexModel> originImgs = [];
      for (int i = 0;i < model.imgs.length;i ++ ) {
        var img = new ImgIndexModel(url: NetWorkingConfig.imgBaseUrl + model.imgs[i] + NetWorkingConfig.imgTailUrl,index: i);
        imgs.add(img);
      }

      for (int i = 0;i < model.imgs.length;i ++ ) {
        var img = new ImgIndexModel(url: NetWorkingConfig.imgBaseUrl + model.imgs[i],index: i);
        originImgs.add(img);
      }
      void tapClick(int index) {
        var imgUrls = originImgs.map((e) => e.url).toList();
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return PhotoViewGalleryScreen(
            images:imgUrls,//传入图片list
            index: index,//传入当前点击的图片的index
          );
        }));
      }
      var imgWidgets = imgs.map(
              (e) {
                print(e.url);
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: CachedNetworkImage(
                      imageUrl: e.url,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          Container(
                            color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          ),
                    ),
                  ),
                  onTap: () {
                    tapClick(e.index);
                  },
                );
              }
      )?.toList();
      if (widget.pageType == MyPageType.myPage) {
        data.add(remindTextWidget());
      }
      data.add(userInfoWidget(homeModel));
      data.add(textInfoWidget(homeModel));
      data += imgWidgets;
      return data;
    }else{
      return [];
    }

  }

  @override
  Widget build(BuildContext context) {
    var contactInfo = '点击获取联系方式';
    // 已经完成领养
    if (homeModel != null && homeModel.is_complete == true) {
      contactInfo = '已完成领养';
    }else{
      if (homeModel != null && homeModel.getedcontact == true && homeModel.contact_info != null) {
        contactInfo = homeModel.contact_info;
      }
    }

    rightActions() {
      var desc = "";
      var buttonStr = "";
      String isComplete = "0";
      if (homeModel != null && homeModel.is_complete) {
        desc = "点击未完成领养，即代表宠物未被领养，他人可以获取你的联系方式，确定改成未完成领养吗？";
        buttonStr = "未完成领养";
        isComplete = "0";
      }else if (homeModel != null && homeModel.is_complete == false) {
        desc = "点击完成领养，即代表宠物已被领养，他人将无法获取你的联系方式，确定改成完成领养吗？";
        buttonStr = '完成领养';
        isComplete = "1";
      }
      if (widget.pageType == MyPageType.myPage) {
        return [
          IconButton(icon: Icon(Icons.more_horiz_rounded,color: ColorsUtil.fromEnmu(ColorEnum.content),), onPressed: (){
            showModalBottomSheet(
              context: context,
              isScrollControlled: false,
              builder: (context){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 190,
                  color: Colors.white,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(desc,
                          style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),fontSize: FontUtil.fs(FontSize.content),
                          ),),
                        ),
                      ),
                      Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        changeRescueState(isComplete);
                      }, child: Text(buttonStr,style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                      Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text('取消',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                    ],
                  ),
                );
              },
            );
          }),
          IconButton(icon: Icon(Icons.share_rounded,color: ColorsUtil.fromEnmu(ColorEnum.content)), onPressed: (){
            showShareSheetView();
          }),
        ];
      }else{
        return [
          IconButton(icon: Icon(Icons.share_rounded,color: ColorsUtil.fromEnmu(ColorEnum.content)), onPressed: (){
            showShareSheetView();
          }),
        ];
      }
    }
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
          title: Text('详情',),
        elevation: 0.5,
        actions: rightActions(),
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
                          height: 45,
                          width: MediaQuery.of(context).size.width - 30,
                          child: TextButton(
                            child: Text(contactInfo,
                              style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              lazyAuthToDoThings(context, (){
                                if (homeModel != null && homeModel.is_complete == true) {
                                  EasyLoading.showToast('已完成领养');
                                }else{
                                  if (homeModel != null && homeModel.getedcontact == true && homeModel.contact_info != null) {
                                    /// 已经获取了联系方式
                                    //复制
                                    Future.delayed(Duration(milliseconds: 100),(){
                                      Clipboard.setData(ClipboardData(text: homeModel.contact_info));
                                    });
                                    EasyLoading.showToast('已复制');
                                    return;
                                  }else{
                                    // getTopicInfoContactNetworking();
                                    showAlert();
                                    return;
                                  }
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

  Future<Widget> showAlert() async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            scrollable: true,
            title: Text('领养须知'),
            content: StatefulBuilder(builder: (context, StateSetter setState){
              return Text('        不要相信任何理由的提前转账要求，如定金、运费等。'
                  '若是红包领养，请当面给送养人。领养更多是一种爱心行为，'
                  '一些必要的程序，如领养协议、互换身份证复印件等必不可少。'
                  '宠物是生命不是物品或工具，一切领养活动都应在为生命负责的态度下进行。'
              );
            }),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('取消',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.urlColor)))),
              TextButton(onPressed: (){
                Navigator.pop(context);
                getTopicInfoContactNetworking();
              }, child: Text('继续获取',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.urlColor)))),
            ],
          );
        }
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
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, dic,(data){
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        var model = data['data'];
        homeModel = HomePageModel.fromJson(model);
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
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['topic_id'] = widget.topicId;
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {

      }
    }, (error) {

    });
  }

  Future<Null> getTopicInfoContactNetworking() async {
    EasyLoading.show();
    final url = NetWorkingConfig.path(NetPath.getContact);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['topic_id'] = widget.topicId;
    await NetWorking.formDataPost(url, dic, (data) {
      EasyLoading.dismiss();
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

  // 改变领养状态
  Future<Null> changeRescueState(isComplete) async{
    /*
    /api/v2/changecompletestatus/
      Post
      参数：
      token
      topic_id
      isComplete: String  “1” / “0"
     */
    final url = NetWorkingConfig.path(NetPath.changeRescueState);
    var dic = new Map<String,dynamic>.from(paramDic);
    dic["token"] = UserManager.instance.token;
    dic["topic_id"] = widget.topicId;
    dic["isComplete"] = isComplete;
    await NetWorking.formDataPost(url, dic, (data) {
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        String contact = homeModel.contact_info;
        homeModel.is_complete = isComplete == "1" ? true : false;
        homeModel.contact_info = contact;
        if (widget.statusChanged != null) {
          widget.statusChanged(homeModel);
        }
        setState(() {

        });
      }else{
        EasyLoading.showToast(data['message'] ?? '网络错误');
      }
    }, (error) {
      EasyLoading.showToast('网络出错');
    });
  }

   showShareSheetView() {
     showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context){
        return TopicShareWidget((value) {
          Navigator.pop(context);
          if (value == -1) {
            return;
          } else if (value == 0) { // 生成海报

          } else if (value == 1) { // 分享

          } else if (value == 2) { // 复制

          }
        });
      },
    );
  }
}


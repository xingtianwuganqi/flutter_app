import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_720yun/Comment/CommentPage.dart';
import 'package:flutter_720yun/homepage/ReleaseTopicPage.dart';
import 'package:flutter_720yun/homepage/SearchPage.dart';
import 'package:flutter_720yun/homepage/TopicDetail.dart';
import 'package:flutter_720yun/model/CommentModel.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';
import '../model/HomePageModel.dart';
import '../Common/CommonPage.dart';
import '../UserInfo/ViolationsListPage.dart';
import '../CommonWidget/PhotoViewGalleryScreen.dart';
import 'package:expandable_text/expandable_text.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {


  List<HomePageModel> homeModels = [];
  var isFirstLoad = true;
  var page = 1;

  ///加载图片的标识
  bool isLoadingImage = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool notificationFunction(Notification notification) {
    ///通知类型
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        Printer.printMapJsonLog("开始滚动");
        ///在这里更新标识 刷新页面 不加载图片
        isLoadingImage = false;
        break;
      case ScrollUpdateNotification:
        Printer.printMapJsonLog("正在滚动");
        break;
      case ScrollEndNotification:
        Printer.printMapJsonLog("滚动停止");

        ///在这里更新标识 刷新页面 加载图片
        setState(() {
          isLoadingImage = true;
        });

        break;
      case OverscrollNotification:
        Printer.printMapJsonLog("滚动到边界");
        break;
    }
    return true;
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
          height: 35,
          child:TextButton.icon(
            icon: Image.asset('assets/icons/icon_wx_search.png'),
            label: Text('搜索',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc)),),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SearchPageWidget();
              }));
            },
          ),
        ),
        elevation: 0.5,
      ),
      floatingActionButton: FloatingActionButton(
        child:
        Image.asset('assets/icons/icon_home_write.png'),
        // IconButton(
        //   icon: Image.asset('assets/icons/icon_home_write.png'),
        // ),
        backgroundColor: ColorsUtil.fromEnmu(ColorEnum.system),
        onPressed: (){
          lazyAuthToDoThings(context, (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ReleaseTopicPage();
            })).then((value) async {
              if (value == 'refresh') {
                await homePageListNetWroking(1);
              }
            });
          });
        },
        tooltip: 'Increment',
      ),
      body: refreshBody()
    );
  }

  // NotificationListener(
  // ///子Widget中的滚动组件滑动时就会分发滚动通知
  // child: refreshBody(),
  // ///每当有滑动通知时就会回调此方法
  // onNotification: notificationFunction,
  // ),

  Widget refreshBody() {
    return EasyRefresh(
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
              child: homePageItemWidget(context, data, (topicId,value) {
                if (value is HomeLikeStatusModel) {
                  homeModels = homeModels.map((e) {
                    var newModel = e;
                    if (newModel.topic_id == topicId) {
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
                  homeModels = homeModels.map((e) {
                    var newModel = e;
                    if (newModel.topic_id == topicId) {
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
                }else if(value is int) {
                  homeModels = homeModels.map((e) {
                    var newModel = e;
                    if (newModel.topic_id == topicId) {
                      newModel.commNum = value;
                    }
                    return newModel;
                  }).toList();
                }
                setState(() {

                });
              }),
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
        homePageListNetWroking(1);
      }),
      onRefresh:() async {
        await homePageListNetWroking(1);
      },
      onLoad: () async{
        await homePageListNetWroking(page);
      },

    );
  }

  Future<Null> homePageListNetWroking(int num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.topiclist);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['page'] = page;
    dic['size'] = 10;
    print(dic);
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, dic,(data){
      if (data['code'] == 200) {
        var models = data['data'];
        var datas = (models as List).map((e) => HomePageModel.fromJson(e)).toList();
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
    },(error){

    });

  }
}


class HomeNetworking {
  static Future<Null> homeLikeClickAction(int likeMark,int topicId,commentInfoChanged changed) async {
    final url = NetWorkingConfig.path(NetPath.homeLikeClick);
    final dic = {
      'token': UserManager.instance.token,
      'like_mark': likeMark,
      'topic_id': topicId,
    };

    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = HomeLikeStatusModel.fromJson(data['data']);
        changed(topicId,model);
      }else{
        var model = HomeLikeStatusModel.fromJson(data['data']);
        changed(topicId,model);
      }
    }, (error) {
      print(error);
      // changed(topicId,error);
    });
  }


  static Future<Null> homeCollectClickAction(int collectMark,int topicId,commentInfoChanged changed) async {
    /*
parameter["token"] = UserManager.shared.token
            parameter["collect_mark"] = collect_mark
            parameter["topic_id"] = topicId

 */
    final url = NetWorkingConfig.path(NetPath.homeCollectClick);
    var dic = {
      'token': UserManager.instance.token,
      'collect_mark': collectMark,
      'topic_id': topicId,
    };

    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = HomeCollectionStatusModel.fromJson(data['data']);
        changed(topicId,model);
      }else{
        var model = HomeCollectionStatusModel.fromJson(data['data']);
        changed(topicId,model);
      }
    }, (error) {
      print(error);
    });
  }

  static Future<Null> homeCompleteNetWorking(int topicId,commentInfoChanged changed) async{
    final url = NetWorkingConfig.path(NetPath.completeRescue);
    var dic = Map<String,dynamic>.from(paramDic);
    dic['topic_id'] = topicId;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        changed(topicId,true);
      }else{
        changed(topicId,false);
      }
    }, (error) {
      changed(topicId,false);
    });
  }
}


/// UI
Widget homePageItemWidget(BuildContext context, HomePageModel data,commentInfoChanged changed,{String fromInfo = '' }) {
  return
    // GestureDetector(
    // child:
    Container(
      child: Column(
        children: [
          userInfoWidget(context,data,fromInfo: fromInfo,clicked: (value) {
            if (value == -3) {
              HomeNetworking.homeCompleteNetWorking(data.topic_id, (id, info) {
                changed(id,info);
              });
            }
          }),
          textInfoWidget(data),
          imagesWidget(context,data),
          addressWidget(data),
          commentWidget(60, context, data, (comIndex){
            if (comIndex == -1) { // 点赞
              var liked = data.liked == true ?  0 :  1;
              HomeNetworking.homeLikeClickAction(liked, data.topic_id, (topicId,value) {
                changed(topicId,value);
              });
            }else if (comIndex == -2) { // 收藏
              var collected = data.collectioned == true ?  0 :  1;
              HomeNetworking.homeCollectClickAction(collected, data.topic_id, (topicId,value) {
                changed(topicId,value);
              });
            }else {
              changed(data.topic_id,comIndex);
            }
          }),
          Divider(height: 1,),
        ],
      ),
    // ),
    // onTap: () {
    //   Navigator.push(context, MaterialPageRoute(builder: (context){
    //     return TopicDetailWidget(topicId: data.topic_id);
    //   }));
    // },
  );
}

/// 用户信息
Widget userInfoWidget(BuildContext context, HomePageModel data, {String fromInfo = '',clickChange clicked}) {
  return Container(
    padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage:
          // isLoadingImg ?
          ((data.userInfo.avator != null && data.userInfo.avator.length > 0) ?
          CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + data.userInfo.avator + NetWorkingConfig.imgTailUrl,) :
          AssetImage('assets/icons/icon_plh.png')),
          //   :
          // AssetImage('assets/icons/icon_plh.png'),
          child: Container(
            alignment: Alignment(0, 0),
            width: 36,
            height: 36,
          ),
        ),

        Expanded(
            child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(data.userInfo.username ?? "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: ColorsUtil.fromEnmu(ColorEnum.title),
                            fontWeight: FontWeight.w600,
                            fontSize: FontUtil.fs(FontSize.title)),
                        overflow: TextOverflow.ellipsis),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(ToolConfig.timeT(data.create_time) ?? "",
                        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
                            fontSize: FontUtil.fs(FontSize.time)),
                        overflow: TextOverflow.ellipsis)
                  ],
                )
            ),
        ),
        data.is_complete == true ?
        Container(
          height: 45,
          width: 45,
          child: Image.asset('assets/icons/icon_complete.png'),
        ) :
        IconButton(icon: Icon(Icons.more_horiz_outlined,
          color: ColorsUtil.fromEnmu(ColorEnum.mark),
        ), onPressed: (){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 110,
                color: Colors.white,
                child: ListView(
                  children: [
                    // TextButton(onPressed: (){
                    //
                    // }, child: Text('屏蔽/拉黑',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                    Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                    fromInfo == 'publish' ?
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      clicked(-3);
                    }, child: Text('完成领养',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)) :
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      lazyAuthToDoThings(context, (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ViolationsListWidget(reportType: Report_type.rescue_page,reportId: data.topic_id);
                        }));
                      });
                    }, child: Text('投诉举报',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
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
        padding: EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
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
          padding: EdgeInsets.only(left: 60,right: 15,top: 2,bottom: 2),
          alignment: Alignment.centerLeft,
          height: tags.length > 0 ? null : 1,
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                children:tags,
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 60,right: 10,top: 2,bottom: 2),
          alignment: Alignment.centerLeft,
          child:
          //禁止点击
          IgnorePointer(
            child: ExpandableText(
              data.content ?? '',
              style: TextStyle(
                fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content),
                height: 1.3,
              ),
              expandText: '全文',
              maxLines: 7,
              linkColor: Colors.blue,
              linkEllipsis: false,
              expanded: false,
            ),
          )

        ),
      ],
    ),
  );
}

Widget imagesWidget(BuildContext context, HomePageModel data) {
  var imgContentH = (MediaQuery.of(context).size.width - 80) * 0.618;

  // if (!isLoadingImg) {
  //   return Container(
  //     padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
  //     height: imgContentH,
  //     child: Container(
  //       color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
  //     ),
  //   );
  // }

  var imgs = data.imgs.map((e) {
    return NetWorkingConfig.imgBaseUrl + e + NetWorkingConfig.imgTailUrl;
  }).toList();

  var originImgs = data.imgs.map((e) => NetWorkingConfig.imgBaseUrl + e).toList();

  void tapClick(int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return PhotoViewGalleryScreen(
        images:originImgs,//传入图片list
        index: index,//传入当前点击的图片的index
      );
    }));
  }
  // var imgContentW = MediaQuery.of(context).size.height - 80;

  if (data.imgs?.length >= 4) {
    var num = data.imgs.length - 4;
    return Container(
      padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
      height: imgContentH,
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child:  GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(right: 2.5,bottom: 2.5),
                        child: CachedNetworkImage(
                          imageUrl: imgs[0],
                          placeholder: (context,url) => Container(
                            color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          ),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      onTap: () {
                        tapClick(0);
                      },
                    )
      // :
      //               Container(
      //                 color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
      //               )
                  ),
                  Expanded(child:
                      // isLoadingImg ?
                      GestureDetector(
                        child:  Container(
                          padding: EdgeInsets.only(left:2.5,bottom: 2.5),
                          child: CachedNetworkImage(
                            imageUrl: imgs[1],
                            placeholder: (context,url) => Container(
                              color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                            ),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        onTap: () {
                          tapClick(1);
                        },
                      )
      // :
      //                 Container(
      //                   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
      //                 )
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
                          // isLoadingImg ?
                          GestureDetector(
                            child:Container(
                              padding: EdgeInsets.only(right:2.5,top: 2.5),
                              child: CachedNetworkImage(
                                imageUrl: imgs[2],
                                placeholder: (context,url) => Container(
                                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                                ),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            onTap: () {
                              tapClick(2);
                            },
                          )
                            // :
                          // Container(
                          //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          // )
                    ),
                    Expanded(
                        child:
                          // isLoadingImg ?
                          GestureDetector(
                            child: num > 1 ? Container(
                              padding: EdgeInsets.only(left:2.5,top: 2.5),
                              child: Stack(
                                alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: imgs[3],
                                    fit: BoxFit.cover,
                                    placeholder: (context,url) => Container(
                                      color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                                    ),
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  Positioned(
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      // color: Colors.black12,
                                      decoration: BoxDecoration(color: Color(0x30000000)),
                                      alignment: Alignment.center,
                                      child: Text('+$num',style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontUtil.fs(FontSize.big)
                                      ),),
                                    ),
                                  )
                                ],
                              ),
                            ):
                            Container(
                              padding: EdgeInsets.only(left:2.5,top: 2.5),
                              child: CachedNetworkImage(
                                imageUrl: imgs[3],
                                fit: BoxFit.cover,
                                placeholder: (context,url) => Container(
                                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                                ),
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            onTap: () {
                              tapClick(3);
                            },
                          )
                            // :
                          // Container(
                          //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          // )
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
      height: imgContentH,
      child: Row(
        children: [
          Expanded(
            child:
                // isLoadingImg ?
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 2.5),
                    child: CachedNetworkImage(
                      imageUrl: imgs[0],
                      placeholder: (context,url) => Container(
                        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  onTap: () {
                    tapClick(0);
                  },
                )
                  // :
                // Container(
                //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                // )
          ),
          Expanded(
              child:
              Container(
                child: Column(
                  children: [
                    Expanded(
                      child:
                          // isLoadingImg ?
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.only(left:2.5,bottom: 2.5),
                              child: CachedNetworkImage(
                                imageUrl: imgs[1],
                                placeholder: (context,url) => Container(
                                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                                ),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            onTap: (){
                              tapClick(1);
                            },
                          )
                            // :
                          // Container(
                          //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          // )
                    ),
                    Expanded(
                        child:
                          // isLoadingImg ?
                          GestureDetector(
                            child:  Container(
                              padding: EdgeInsets.only(left:2.5,top: 2.5),
                              child: CachedNetworkImage(
                                imageUrl: imgs[2],
                                placeholder: (context,url) => Container(
                                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                                ),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            onTap: () {
                              tapClick(2);
                            },
                          )
                            // :
                          // Container(
                          //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          // )
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
      height: imgContentH,
      child: Row(
        children: [
          Expanded(
            child:
                // isLoadingImg ?
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 2.5),
                    child: CachedNetworkImage(
                      imageUrl: imgs[0],
                      placeholder: (context,url) => Container(
                        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  onTap: () {
                    tapClick(0);
                  },
                )
                // :
                // Container(
                //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                // )
            ,
          ),
          Expanded(
            child:
                // isLoadingImg ?
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(left: 2.5),
                    child: CachedNetworkImage(
                      imageUrl: imgs[1],
                      placeholder: (context,url) => Container(
                        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  onTap: () {
                    tapClick(1);
                  },
                )
                  // :
                // Container(
                //   color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                // )
          ),
        ],
      ),
    );
  }else if (data.imgs?.length == 1) {
    return
      // isLoadingImg ?
    GestureDetector(
      child:  Container(
        padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
        // width: MediaQuery.of(context).size.width - 65,
        height: imgContentH,
        child: CachedNetworkImage(
          imageUrl: imgs[0],
          placeholder: (context,url) => Container(
            color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
          ),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
      onTap: () {
        tapClick(0);
      },
    );
  // : Container(
  //     padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
  //     height: imgContentH,
  //     child: Container(
  //       color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
  //     )
  //   );
  }
}

Widget addressWidget(HomePageModel data) {
  return Container(
    padding: EdgeInsets.only(left: 60,right: 15,top: 5,bottom: 5),
    alignment: Alignment.centerLeft,
    child: Text(data.address_info,
      style: TextStyle(
        fontSize: FontUtil.fs(FontSize.mark),
        color: ColorsUtil.fromEnmu(ColorEnum.mark),
      ),
    ),
  );
}

Widget commentWidget(double leftNum,BuildContext context, HomePageModel data, clickChange clicked) {
  return Container(
    padding: EdgeInsets.only(left: leftNum,right: 15),
    height: 40,
    child: Row(
      children: [
        Expanded(
            child: TextButton.icon(
              icon: (data?.liked ?? false) ? Image.asset('assets/icons/icon_zan_se.png') : Image.asset('assets/icons/icon_zan_un.png'),
              label: Text((data?.likes_num ?? 0) > (0) ? data.likes_num.toString() : "点赞",
                style: TextStyle(
                  fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),              ),
              onPressed: (){
                lazyAuthToDoThings(context, () {
                  clicked(-1); // 点击了点赞
                });
              },
            )
        ),
        Expanded(
            child: TextButton.icon(
              icon: (data?.collectioned ?? false) ? Image.asset('assets/icons/icon_collection_se.png') : Image.asset('assets/icons/icon_collection_un.png'),
              label: Text((data?.collection_num ?? 0) > (0) ? data.collection_num.toString() : "收藏",
                style: TextStyle(
                  fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),
              ),
              onPressed: (){
                lazyAuthToDoThings(context, () {
                  clicked(-2); // 点击了收藏
                });
              },
            )
        ),
        Expanded(
            child: TextButton.icon(
              icon:Image.asset('assets/icons/icon_sh_commen.png'),
              label: Text((data?.commNum ?? 0) > (0) ? data.commNum.toString() : "评论",
                style: TextStyle(
                  fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),
              ),
              onPressed: (){
                lazyAuthToDoThings(context, (){
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context){
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.8,
                        color: Colors.white,
                        child: CommentInfoWidget(commentType: CommentType.topic_comment,topicId: data.topic_id,toUid: data.userInfo.id,changed: (value){
                          clicked(value);
                        },),
                      );
                    },
                  );
                });
              },
            )
        ),
      ],
    ),
  );
}
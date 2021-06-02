// import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Comment/CommentPage.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/ShowInfo/ReleaseShowInfoPage.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoSinglePage.dart';
import 'package:flutter_720yun/UserInfo/ViolationsListPage.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_720yun/model/CommentModel.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../NetWorking/NetWorking.dart';
import 'PageControlView.dart';


class ShowInfoListWidget extends StatefulWidget {
  final int showId;
  final int gambitId;

  ShowInfoListWidget({this.showId,this.gambitId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowInfoListState();
  }
}

class ShowInfoListState extends State<ShowInfoListWidget> with AutomaticKeepAliveClientMixin {
  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  var isFirstLoad = true;
  var page = 1;

  List<ShowInfoModel> showInfoLists = [];

  @override
  void initState() {
    super.initState();
    // 创建Controller
    // double width =MediaQuery.of(context).size.width;
    // print(width);
    // showInfoListNetWroking(1);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Image.asset('assets/icons/icon_home_write.png'),
        ),
        backgroundColor: ColorsUtil.fromEnmu(ColorEnum.system),
        onPressed: (){
          lazyAuthToDoThings(context, (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ReleaseShowInfoPage();
            })).then((value) async {
              if (value == 'refresh') {
                await showInfoListNetWroking(1);
              }
            });
          });
        },
        tooltip: 'Increment',
        heroTag: 'Second',
      ),
      body:
        EasyRefresh(
          header: MaterialHeader(),
          footer: MaterialFooter(
              enableInfiniteLoad: false,
          ),
          firstRefresh: isFirstLoad,
          firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
          emptyWidget: showInfoLists.length > 0 ? null : EmptyPage((){
            showInfoListNetWroking(1);
          }),
          child: ListView.builder(
              itemCount: showInfoLists.length,
              itemBuilder: (context, index) {
                var data = showInfoLists[index];
                return showInfoItem(context,data,(showId,value) {
                  if (value is HomeLikeStatusModel) {
                    showInfoLists = showInfoLists.map((e) {
                      var newModel = e;
                      if (newModel.show_id == showId) {
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
                    showInfoLists = showInfoLists.map((e) {
                      var newModel = e;
                      if (newModel.show_id == showId) {
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
                  }else if (value is int) {
                    showInfoLists = showInfoLists.map((e) {
                      var newModel = e;
                      if (newModel.show_id == showId) {
                        newModel.commNum = value;
                      }
                      return newModel;
                    }).toList();
                  }
                  setState(() {

                  });
                });
              }
          ),
          onRefresh: () async {
            showInfoListNetWroking(1);
          },
          onLoad: () async {
            showInfoListNetWroking(page);
          },
        ),
    );
  }


  Future<Null> showInfoListNetWroking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.showInfoList);
    final dic = {
      "page": page,
      "size": 10,
      'token': UserManager.instance.token,
      'show_id': widget.showId,
      'gambit_id': widget.gambitId
    };
    print("page");
    print(page);
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, dic,(data){
      if (data['code'] == 200) {
        Printer.printMapJsonLog(data);
        var models = data['data'];
        var datas = (models as List).map((e) => ShowInfoModel.fromJson(e)).toList();
        page > 1 ? showInfoLists += datas : showInfoLists = datas;
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

class ShowInfoActionNetworking {
  /*
  dic["token"] = UserManager.shared.token
            dic["like_mark"] = like_mark
            dic["show_id"] = showId
   */
  static Future<Null> showInfoLikeClickAction(int likeMark,int showId,commentInfoChanged changed) async {
    final url = NetWorkingConfig.path(NetPath.showInfoLikeClick);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['like_mark'] = likeMark;
    dic['show_id'] = showId;
    print(dic);
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = HomeLikeStatusModel.fromJson(data['data']);
        changed(showId,model);
      }else{
        var model = HomeLikeStatusModel.fromJson(data['data']);
        changed(showId,model);
      }
    }, (error) {
      print(error);
      // changed(topicId,error);
    });
  }


  static Future<Null> showInfoCollectClickAction(int collectMark,int showId,commentInfoChanged changed) async {

    final url = NetWorkingConfig.path(NetPath.showInfoCollectClick);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['collect_mark'] = collectMark;
    dic['show_id'] = showId;
    print(url);
    print(dic);
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = HomeCollectionStatusModel.fromJson(data['data']);
        changed(showId,model);
      }else{
        var model = HomeCollectionStatusModel.fromJson(data['data']);
        changed(showId,model);
      }
    }, (error) {
      print(error);
    });
  }
}

Widget showInfoItem(BuildContext context, ShowInfoModel data,commentInfoChanged changed) {
  int currentIndex = 0;
  var imgWidgets = data.imgs.map((e) => Container(
    child: CachedNetworkImage(imageUrl: NetWorkingConfig.imgBaseUrl + e,)
  )).toList();

  return Container(
    child: Column(
      children: [
        /// 个人信息
        Container(
          padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: (data.user.avator != null && data.user.avator.length > 0) ? CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + data.user.avator): AssetImage('assets/icons/icon_plh.png'),
                child: Container(
                  alignment: Alignment(0, .5),
                  width: 40,
                  height: 40,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.user.username ?? "",
                        style: TextStyle(
                          color: ColorsUtil.fromEnmu(ColorEnum.title),
                          fontWeight: FontWeight.w600,
                          fontSize: FontUtil.fs(FontSize.title),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      Text( ToolConfig.timeT(data.create_time) ?? "",
                          style: TextStyle(
                              color: ColorsUtil.fromEnmu(ColorEnum.desc),
                              fontSize: FontUtil.fs(FontSize.time)),
                          overflow: TextOverflow.ellipsis)
                    ],
                  )),
              Expanded(
                  child: Container(

                  )),
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
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            lazyAuthToDoThings(context, (){
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return ViolationsListWidget(reportType: Report_type.show_page,reportId: data.show_id);
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
        ),
        /// 话题
        Container(
          height: data.gambit_type != null ? 38 : 1,
          alignment: Alignment.centerLeft,
          child:data.gambit_type == null ? null : Row(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 10),
                  padding: EdgeInsets.only(left: 10,right: 10),
                  height: 28 ,//data.gambit_type != null ? 24 : 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icons/icon_show_gb.png',width: 16,height: 16,),
                      Padding(padding: EdgeInsets.only(left: 6)),
                      Text((data.gambit_type != null && (data.gambit_type?.descript?.length ?? 0) > 0) ? data.gambit_type.descript:'',
                        style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),
                          color: ColorsUtil.fromEnmu(ColorEnum.system),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ShowInfoSingleWidget(gambitId: data.gambit_type.id);
                  }));
                },
              ),
            ],
          )
        ),
        /// pageView
        PageControlWidget(imgWidget: imgWidgets),
        /// instraction
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15,top: 10,right: 10,bottom: 0),
          child: Text(data.instruction ?? "",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content)),
          ),
        ),
        /// 评论
        GestureDetector(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15,top: 10,right: 15),
            child: Text('添加评论...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: FontUtil.fs(FontSize.desc),
                  color: ColorsUtil.fromEnmu(ColorEnum.desc)
              ),
            ),
          ),
          onTap: () {
            lazyAuthToDoThings(context, (){
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: Colors.white,
                    child: CommentInfoWidget(commentType: CommentType.show_comment,topicId: data.show_id,toUid: data.user.id,changed: (commNum) {
                      changed(data.show_id,commNum);
                    },),
                  );
                },
              );
            });
          },
        ),
        /// 点赞，收藏，评论
        commentWidget(context,data,(index) {
          if (index == -1) { // 点击了点赞
            var likeMark = data.liked == true ? 0 : 1;
            ShowInfoActionNetworking.showInfoLikeClickAction(likeMark, data.show_id, (showId, info) {
              changed(showId,info);
            });
          }else if (index == -2) { // 点击了收藏
            var collectMark = data.collectioned ? 0 : 1;
            print("collectMark");
            print(collectMark);
            ShowInfoActionNetworking.showInfoCollectClickAction(collectMark, data.show_id, (showId, info) {
              changed(showId,info);
            });
          }else{
            changed(data.show_id,index);
          }
        }),
        Divider(thickness: 10,color: Colors.grey[100],)
      ],
    ),
  );
}

Widget commentWidget(BuildContext context, ShowInfoModel data,clickChange clicked) {
  return Container(
    height: 40,
    child: Row(
      children: [
        Expanded(
            child: TextButton.icon(
              icon:(data?.liked ?? false) ? Image.asset('assets/icons/icon_zan_se.png') : Image.asset('assets/icons/icon_zan_un.png'),
              label: Text((data?.likes_num ?? 0) > (0) ? data.likes_num.toString() : "点赞",
                style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),
              ),
              onPressed: (){
                lazyAuthToDoThings(context, (){
                  clicked(-1);
                });
              },
            )
        ),
        Expanded(
            child: TextButton.icon(
              icon:(data?.collectioned ?? false) ? Image.asset('assets/icons/icon_collection_se.png') : Image.asset('assets/icons/icon_collection_un.png'),
              label: Text((data?.collection_num ?? 0) > (0) ? data.collection_num.toString() : "收藏",
                style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),
              ),
              onPressed: (){
                clicked(-2);
              },
            )
        ),
        Expanded(
            child: TextButton.icon(
              icon:Image.asset('assets/icons/icon_sh_commen.png'),
              label: Text((data?.commNum ?? 0) > (0) ? data.commNum.toString() : "评论",
                style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
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
                        child: CommentInfoWidget(commentType: CommentType.show_comment,topicId: data.show_id,toUid: data.user.id,changed: (value){
                          clicked(value);
                        }),
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

// ignore: must_be_immutable
class PageControlWidget extends StatefulWidget {

  //类变量,作为调用类时的参数
  final List<Widget> imgWidget;

  PageControlWidget({this.imgWidget});
  GlobalKey<DWPageViewState> _childViewKey = new GlobalKey<DWPageViewState>();


  @override
  State<StatefulWidget> createState() {
    return _PageControlState();
  }
}

class _PageControlState extends State<PageControlWidget> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            children: widget.imgWidget,
            onPageChanged: (int index) {
              widget._childViewKey.currentState.selectedIndex(index);
            },
          ),
          Positioned(
            bottom: 20,
            child: DWPageView(
              key: widget._childViewKey,
              width: (widget.imgWidget.length * 10 + 5).toDouble(),
              height: 10,
              numberOfPages: widget.imgWidget.length > 1 ? widget.imgWidget.length : 0,
            ),
          )
        ],
      ),
    );
  }
}

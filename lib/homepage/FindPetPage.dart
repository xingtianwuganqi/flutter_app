import 'package:anythink_sdk/at_interstitial.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/FindPetDetailPage.dart';
import 'package:flutter_720yun/manager/interstitial_sdk.dart';
import 'package:flutter_720yun/model/FindPetListModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Comment/CommentPage.dart';
import '../Login/CheckCodePage.dart';
import '../UserInfo/NewUserInfoPage.dart';
import '../UserInfo/ViolationsListPage.dart';
import '../configuration_sdk.dart';
import '../model/CommentModel.dart';
import '../model/HomePageModel.dart';
import '../model/UserModel.dart';



class FindPetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FindPetState();
  }
}

class FindPetState extends State<FindPetPage> {
  List<FindPetListModel> _findList = [];
  int _page = 1;
  bool isFirstLoad = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasInterstitialAdReady();
  }

  hasInterstitialAdReady() async {
    await ATInterstitialManager.hasInterstitialAdReady(
      placementID: Configuration.interstitialPlacementID,
    ).then((value) {
      if (value == true) {
        InterstitialManager.showSceneInterstitialAd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false
        ),
        child: ListView.builder(
          itemCount: _findList.length,
          itemBuilder: (context,index){
          var data = _findList[index];
          if (data.findId == -1) {
            return findHeaderWidget();
          }else{
            return findPetItem(data);
          }
          }),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget:
        _findList.length > 0 ? null : EmptyPage(() async {
        await findPetListNetworking(1);
        }),
        // null,
        onRefresh:() async {
        await findPetListNetworking(1);
        },
        onLoad: () async{
        await findPetListNetworking(_page);
        },
        )
      ],
    );
    // TODO: implement build
  }

  Widget findHeaderWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15,top: 10,right: 15, bottom: 10),
      height: 60,
        decoration: BoxDecoration(
          color: ColorsUtil.fromEnmu(ColorEnum.system),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 15)),
          Text("找宠小助手",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w700),),
          Expanded(child: Container()),
          Stack(
            children: [
              Image.asset('assets/icons/icon_find_line.png',width: 200,height: 70,fit: BoxFit.fitWidth,),
              Positioned(
                height: 60,
                width: 110,
                right: 15,
                  child:
                Container(
                  alignment: Alignment.center,
                  child:Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                        style: ButtonStyle(textStyle: MaterialStateProperty.all(
                          TextStyle(color: ColorsUtil.hexColor(0x683A3B),fontWeight: FontWeight.w700,fontSize: 14)),
                          backgroundColor: MaterialStateProperty.all(ColorsUtil.hexColor(0xFFF0D6))
                          ),
                          icon: Icon(Icons.arrow_circle_right_sharp,color: ColorsUtil.hexColor(0x6D4241),size: 20,),
                          label: Text("去找宠"),
                        onPressed: (){
                          lazyAuthToDoThings(context, (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return FindPetDetailPage(changed: (value) {
                                if (value is int) {
                                  if (value == 1) {
                                    findPetListNetworking(1);
                                  }
                                }else if (value is FindPetDetailModel) {
                                  _findList.removeWhere((element) => element.findId == value.id);
                                  setState(() {

                                  });
                                }
                              },);
                            }));
                          });
                        },
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget findPetItem(FindPetListModel data) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 15,bottom: 10),
        child: Column(
          children: [
            userInfoWidget(data),
            petTypeWdiget(data),
            textDescWidget(data),
            contactButton(data),
            statusWidget(data),
            lineWidget(),
          ],
        ),
      ),
    );
  }
  
  Widget userInfoWidget(FindPetListModel data) {
    var width = MediaQuery.of(context).size.width - 112;
    return Container(
      child: Row(
        children: [
          GestureDetector(
            child: CircleAvatar(
              radius: 18,
              backgroundImage:
              ((data.userInfo.avator != null && data.userInfo.avator.length > 0) ?
              CachedNetworkImageProvider(ToolConfig.loadImgUrl(data.userInfo.avator,bType: ThumbType.thumbNail)) :
              AssetImage('assets/icons/icon_plh.png')),
              //   :
              // AssetImage('assets/icons/icon_plh.png'),
              child: Container(
                alignment: Alignment(0, 0),
                width: 36,
                height: 36,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return NewUserInfoPage(pageType: MyPageType.otherPage,userId: data.userInfo.id);
              }));
            },
          ),
          Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 10,bottom: 2),child:  Text(data.userInfo.username ?? "",style:
                TextStyle(fontSize: FontUtil.fs(FontSize.title),fontWeight: FontWeight.w600,color: ColorsUtil.fromEnmu(ColorEnum.title)),),),
                Padding(padding: EdgeInsets.only(left: 10,top: 2),child:  Text(ToolConfig.timeT(data.update_time) ?? "",style:
    TextStyle(fontSize: FontUtil.fs(FontSize.time),color: ColorsUtil.fromEnmu(ColorEnum.desc)),)),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.more_horiz_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    color: Colors.white,
                    child: ListView(
                      children: [
                        Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                          lazyAuthToDoThings(context, (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return ViolationsListWidget(reportType: Report_type.find_pet_list,reportId: data.findId);
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
            },
          )
        ],
      ),
    );
  }

  Widget petTypeWdiget(FindPetListModel model) {
    return Container(
      padding: EdgeInsets.only(left: 46, top: 2,bottom: 2),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.only(right: 5),
            child: Text("想领养",style:
            TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content)),
            ),
          ),
          Wrap(
            spacing: 10,
            children:
              [Container(
                decoration: BoxDecoration(
                    color: ColorsUtil.fromEnmu(ColorEnum.system),
                    borderRadius: BorderRadius.all(Radius.circular(3.0))
                ),
                padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                child: Text(model.pet_type == 1 ? "猫咪" : "狗狗",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              )]
            ),
        ],
      ),
    );
  }

  // 文本
  Widget textDescWidget(FindPetListModel data) {
    return Container(
      padding: EdgeInsets.only(left: 46, top: 2,bottom: 2,right: 15),
      alignment: Alignment.centerLeft,
      child:
      ExpandableText(
        data.desc ?? "" ,
        style: TextStyle(
            fontSize: FontUtil.fs(FontSize.content),
            color: ColorsUtil.fromEnmu(ColorEnum.content),
            height: 1.6
        ),
        expandText: '展开',
        collapseText: '收起',
        maxLines: 7,
        linkColor: Colors.blue,
        linkEllipsis: false,
        expanded: false,
        expandOnTextTap: false,
        collapseOnTextTap: false,
      )
      // Text(data.desc,
      //   style: TextStyle(fontSize: FontUtil.fs(FontSize.content,),
      //       color: ColorsUtil.fromEnmu(ColorEnum.content),
      //     height: 1.6
      //   ),
      // ),
    );
  }
  
  // 获取联系方式按钮
  Widget contactButton(FindPetListModel data) {
    return Container(
      padding: EdgeInsets.only(left: 46,right: 15,top: 2,bottom: 2),
      height: 36,
      child:
      SizedBox.expand(
          child: TextButton(
            child: Text(data.getedcontact ? data.contact_info : '获取TA的联系方式',style:
            TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ColorsUtil.fromEnmu(ColorEnum.system).withOpacity(0.6)),
            ),
            onPressed: () {
              lazyAuthToDoThings(context, (){
                if (data.getedcontact == true) {
                  /// 已经获取了联系方式
                  //复制
                  Future.delayed(Duration(milliseconds: 100),(){
                    Clipboard.setData(ClipboardData(text: data.contact_info ?? ""));
                  });
                  EasyLoading.showToast('已复制');
                  return;
                }else{
                  getContactNetworking(data);
                }
              });

            },
          )
      )
      ,
    );
  }


  // 点赞收藏评论 按钮
  Widget statusWidget(FindPetListModel data) {
    return Container(
      padding: EdgeInsets.only(left: 46,right: 15),
      height: 36,
      child: Row(
        children: [
          Expanded(
              child: TextButton.icon(
                icon:(data?.liked ?? false) ? Image.asset('assets/icons/icon_zan_se.png') : Image.asset('assets/icons/icon_zan_un.png'),
                label: Text((data?.likeNum ?? 0) > (0) ? data.likeNum.toString() : "点赞",
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
                    color: ColorsUtil.fromEnmu(ColorEnum.mark),
                  ),
                ),
                onPressed: (){
                  lazyAuthToDoThings(context, () {
                    findPetLikeAction(data, data.liked ? 1 : 0);
                  });
                },
              )
          ),
          Expanded(
              child: TextButton.icon(
                icon:(data?.collection ?? false) ? Image.asset('assets/icons/icon_collection_se.png') : Image.asset('assets/icons/icon_collection_un.png'),
                label: Text((data?.collectionNum ?? 0) > (0) ? data.collectionNum.toString() : "收藏",
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),
                    color: ColorsUtil.fromEnmu(ColorEnum.mark),
                  ),
                ),
                onPressed: (){
                  lazyAuthToDoThings(context, (){
                    findPetCollectionAction(data, data.collection ? 1 : 0);
                  });
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
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return CommentInfoWidget(commentType: CommentType.find_comment,topicId: data.findId,toUid: data.userInfo.id,changed: (value){
                        // clicked(value);
                      },);
                    }));
                  });
                },
              )
          ),
        ],
      ),
    );
  }

  // 线
  Widget lineWidget() {
    return Container(
      child: Divider(
        indent: 46,
        endIndent: 15,
        color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
      ),
    );
  }

  Future<void> findPetListNetworking(int page) async {
    _page = page;
    final url = NetWorkingConfig.path(NetPath.findPetList);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["page"] = page;
    dic["size"] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var models = data['data'];
        var dataSourses = (models as List).map((e) => FindPetListModel.fromJson(e)).toList();
        if (_page == 1) {
          var findHeader = FindPetListModel(findId: -1);
          _findList = [findHeader] + dataSourses;
        }else{
          _findList = _findList + dataSourses;
        }
        if (dataSourses.length > 0) {
          _page += 1;
        }

      }
      isFirstLoad = false;
      setState(() {

      });
    }, (error) {
      setState(() {

      });
    });
  }

  // 点赞
  Future<void> findPetLikeAction(FindPetListModel model, int like_mark) async {
    final mark = like_mark == 0 ? 1 : 0;
    final url = NetWorkingConfig.path(NetPath.findPetLikeAction);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['token'] = UserManager.instance.token;
    dic['like_mark'] = mark;
    dic['find_id'] = model.findId;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        // 点赞或取消点赞成功
        // 更新数据源
        _findList = _findList.map((e){
          if (e.findId == model.findId) {
            e.liked = (mark == 1);
            if (mark == 1) {
              e.likeNum = (e.likeNum ?? 0) + 1;
            }else {
              if (e.likeNum > 1) {
                e.likeNum = e.likeNum - 1;
              } else {
                e.likeNum = 0;
              }
            }
          }
          return e;
        }).toList();
        setState(() {

        });
      }else{

      }
    }, (error) {

    });
  }

  // 收藏
  Future<void> findPetCollectionAction(FindPetListModel model, int collection_mark) async {
    final mark = collection_mark == 0 ? 1 : 0;
    final url = NetWorkingConfig.path(NetPath.findPetCollectionAction);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['token'] = UserManager.instance.token;
    dic['collect_mark'] = mark;
    dic['find_id'] = model.findId;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        // 点赞或取消点赞成功
        // 更新数据源
        _findList = _findList.map((e){
          if (e.findId == model.findId) {
            e.collection = (mark == 1);
            if (mark == 1) {
              e.collectionNum = (e.collectionNum ?? 0) + 1;
            }else {
              if (e.collectionNum > 1) {
                e.collectionNum = e.collectionNum - 1;
              } else {
                e.collectionNum = 0;
              }
            }
          }
          return e;
        }).toList();
        setState(() {

        });
      }else{

      }
    }, (error) {

    });
  }

  /// 获取联系方式
  Future<void> getContactNetworking(FindPetListModel model) async {
    final url = NetWorkingConfig.path(NetPath.getContact);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['token'] = UserManager.instance.token;
    dic['topic_id'] = model.findId;
    dic['topic_type'] = 2;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var contactModel = ContactModel.fromJson(data['data']);

        // 获取联系方式成功
        _findList = _findList.map((e){
          if (e.findId == model.findId) {
            e.getedcontact = true;
            e.contact_info = model.contact;
          }
          return e;
        }).toList();
        setState(() {

        });
      }else{
        EasyLoading.showToast(data['message'] ?? '获取联系方式失败');
        // 延时跳转
        Future.delayed(Duration(milliseconds: 100),(){
          if (data['code'] == 210) { // 未校验手机号
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return CheckCodePage(CodeFromType.checkPhone,phone: UserManager.instance.userInfo.phone_number);
            }));
          }else if (data['code'] == 209) { // 未绑定手机号
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return CheckCodePage(CodeFromType.bindPhone);
            }));
          }
        });
      }
    }, (error) {

    });
  }
}
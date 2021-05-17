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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';
import '../model/HomePageModel.dart';
import 'package:dio/dio.dart';
import '../Common/CommonPage.dart';
import '../Login/LoginPage.dart';
import '../UserInfo/ViolationsListPage.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homePageListNetWroking(1);
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
        child: IconButton(
          icon: Image.asset('assets/icons/icon_home_write.png'),
        ),
        backgroundColor: ColorsUtil.fromEnmu(ColorEnum.system),
        onPressed: (){
          lazyAuthToDoThings(context, (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ReleaseTopicPage();
            }));
          });
        },
        tooltip: 'Increment',
      ),
      body: EasyRefresh(
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
                child: homePageItemWidget(context, data),
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

      )
    );
  }

  Future<Null> homePageListNetWroking(int num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.topiclist);
    final dic = {"page": page,"size": 10};
    FormData formData = FormData.fromMap(dic);
    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      if (data['code'] == 200) {
        isFirstLoad = false;
        List<HomePageModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new HomePageModel.fromJson(models[i]));
        }
        page > 1 ? homeModels += datas : homeModels = datas;
        if (models.length > 0) {
          page += 1;
        }
        setState(() {

        });
      }else{
        isFirstLoad = false;
      }
    },(error){

    });

  }
}

/// UI
Widget homePageItemWidget(BuildContext context, HomePageModel data) {
  return
    // GestureDetector(
    // child:
    Container(
      child: Column(
        children: [
          userInfoWidget(context,data),
          textInfoWidget(data),
          imagesWidget(data),
          addressWidget(data),
          commentWidget(60, context, data),
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
Widget userInfoWidget(BuildContext context, HomePageModel data) {
  return Container(
    padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: (data.userInfo.avator != null && data.userInfo.avator.length > 0) ?  CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + data.userInfo.avator) : AssetImage('assets/icons/icon_plh.png'),
          child: Container(
            alignment: Alignment(0, 0),
            width: 36,
            height: 36,
          ),
        ),
        // Container(
        //     alignment: Alignment.centerLeft,
        //     padding: EdgeInsets.only(left: 10),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(data.userInfo.username ?? "",
        //             textAlign: TextAlign.left,
        //             style: TextStyle(
        //                 color: ColorsUtil.fromEnmu(ColorEnum.title),
        //                 fontSize: FontUtil.fs(FontSize.title)),
        //             overflow: TextOverflow.ellipsis),
        //         Padding(padding: EdgeInsets.all(3)),
        //         Text(ToolConfig.timeT(data.create_time) ?? "",
        //             style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
        //                 fontSize: FontUtil.fs(FontSize.desc)),
        //             overflow: TextOverflow.ellipsis)
        //       ],
        //     )),
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
                            color: ColorsUtil.fromEnmu(ColorEnum.content),
                            fontWeight: FontWeight.w500,
                            fontSize: FontUtil.fs(FontSize.title)),
                        overflow: TextOverflow.ellipsis),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(ToolConfig.timeT(data.create_time) ?? "",
                        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc),
                            fontSize: FontUtil.fs(FontSize.desc)),
                        overflow: TextOverflow.ellipsis)
                  ],
                )
            ),
        ),
        IconButton(icon: Icon(Icons.more_horiz_outlined,
          color: ColorsUtil.fromEnmu(ColorEnum.mark),
        ), onPressed: (){
          showModalBottomSheet(
            context: context,
            builder: (context){
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Colors.white,
                child: ListView(
                  children: [
                    TextButton(onPressed: (){

                    }, child: Text('屏蔽/拉黑',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                    Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
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
          padding: EdgeInsets.only(left: 60,right: 15,top: 2,bottom: 2),
          alignment: Alignment.centerLeft,
          height: tags.length > 0 ? 26 : 3,
          child: Row(
            children: tags,
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 60,right: 10,top: 5,bottom: 5),
          alignment: Alignment.centerLeft,
          child: Text(data.content ?? '',
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
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

Widget imagesWidget(HomePageModel data) {
  if (data.imgs?.length >= 4) {
    return Container(
      padding: EdgeInsets.only(left: 60,right: 20,top: 5,bottom: 5),
      height: 170,
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 2.5,bottom: 2.5),
                      child: CachedNetworkImage(
                        imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[0],
                        placeholder: (context,url) => Container(
                          color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                        ),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  Expanded(child:
                  Container(
                    padding: EdgeInsets.only(left:2.5,bottom: 2.5),
                    child: CachedNetworkImage(
                      imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[1],
                      placeholder: (context,url) => Container(
                        color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
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
                        padding: EdgeInsets.only(right:2.5,top: 2.5),
                        child: CachedNetworkImage(
                          imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[2],
                          placeholder: (context,url) => Container(
                            color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          ),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left:2.5,top: 2.5),
                          child: CachedNetworkImage(
                            imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[3],
                            fit: BoxFit.cover,
                            placeholder: (context,url) => Container(
                              color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                            ),
                            width: double.infinity,
                            height: double.infinity,
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
              padding: EdgeInsets.only(right: 2.5),
              child: CachedNetworkImage(
                imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[0],
                placeholder: (context,url) => Container(
                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
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
                        padding: EdgeInsets.only(left:2.5,bottom: 2.5),
                        child: CachedNetworkImage(
                          imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[1],
                          placeholder: (context,url) => Container(
                            color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                          ),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left:2.5,top: 2.5),
                          child: CachedNetworkImage(
                            imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[2],
                            placeholder: (context,url) => Container(
                              color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                            ),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
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
              padding: EdgeInsets.only(right: 2.5),
              child: CachedNetworkImage(
                imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[0],
                placeholder: (context,url) => Container(
                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Expanded(
            child:
            Container(
              padding: EdgeInsets.only(left: 2.5),
              child: CachedNetworkImage(
                imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[1],
                placeholder: (context,url) => Container(
                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
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
      child: CachedNetworkImage(
        imageUrl:NetWorkingConfig.imgBaseUrl + data.imgs[0],
        placeholder: (context,url) => Container(
          color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
        ),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
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

Widget commentWidget(double leftNum,BuildContext context, HomePageModel data) {
  return Container(
    padding: EdgeInsets.only(left: leftNum,right: 15),
    height: 40,
    child: Row(
      children: [
        Expanded(
            child: TextButton.icon(
              icon:Image.asset('assets/icons/icon_zan_un.png'),
              label: Text((data?.likes_num ?? 0) > (0) ? data.likes_num.toString() : "点赞",
                style: TextStyle(
                  fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),              ),
              onPressed: (){
                lazyAuthToDoThings(context, (){
                  print('is login');
                });
              },
            )
        ),
        Expanded(
            child: TextButton.icon(
              icon:Image.asset('assets/icons/icon_collection_un.png'),
              label: Text((data?.collection_num ?? 0) > (0) ? data.collection_num.toString() : "收藏",
                style: TextStyle(
                  fontSize: FontUtil.fs(FontSize.mark),
                  color: ColorsUtil.fromEnmu(ColorEnum.mark),
                ),
              ),
              onPressed: (){
                lazyAuthToDoThings(context, (){

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
                        child: CommentInfoWidget(commentType: CommentType.topic_comment,topicId: data.topic_id,toUid: data.userInfo.id,),
                      );
                    },
                  );
                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                  //   return CommentWidget(commentType: CommentType.topic_comment,topicId: data.topic_id,);
                  // }));
                });
              },
            )
        ),
      ],
    ),
  );
}
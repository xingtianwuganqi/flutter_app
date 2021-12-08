import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoSinglePage.dart';
import 'package:flutter_720yun/homepage/TopicDetail.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
class NewUserPublishListPage extends StatefulWidget {

  final pageType;

  NewUserPublishListPage({Key key, @required this.pageType}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewUserPublishListPageState();
  }
}

class NewUserPublishListPageState extends State<NewUserPublishListPage> with AutomaticKeepAliveClientMixin {

  List<dynamic> publishList = [];
  // List<ShowInfoModel> showPublishList = [];
  int pageNum = 1;
  bool isFirstLoad = true;

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listNetworking(pageNum);
  }

  void listNetworking(page) {
    if (widget.pageType == 1) {
      getUserPublishListNetworking(page);
    }else{
      getUserShowPublishListNetworking(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsUtil.fromEnmu(ColorEnum.backColor),
      padding: EdgeInsets.only(left: 15,right: 15),
      child: refreshBody()
    );
  }

  Widget refreshBody() {
    return EasyRefresh(
      // header: MaterialHeader(),
      header: null,
      footer: MaterialFooter(
        enableInfiniteLoad:false,
      ),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        childAspectRatio: 0.73,
      ), itemBuilder: (context,index){
        var model = publishList[index];
        return Container(
          child: GestureDetector(
            onTap: () {
              if (widget.pageType == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return TopicDetailWidget(topicId: model.topic_id,pageType: MyPageType.myPage);
                    })
                );
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ShowInfoSingleWidget(showId: model.show_id);
                }));
              }
            },
            child: rescuePublishItem(model),
          ),
        );
      },itemCount: publishList.length,
        physics: CustomBouncingScroll(),
        padding: EdgeInsets.only(top: 15),
      ),
      firstRefresh: isFirstLoad,
      firstRefreshWidget: FirstLoadWidget(),
      emptyWidget: publishList.length > 0 ? null : EmptyPage(() async {
        listNetworking(1);
      }),
      onRefresh: null,
      onLoad: () async{
        listNetworking(pageNum);
      },
      topBouncing: false,

    );
  }

  Widget rescuePublishItem(model) {

    HomePageModel homeModel;
    ShowInfoModel showModel;
    if (model is HomePageModel) {
      homeModel = model;
    }else if (model is ShowInfoModel){
      showModel = model;
    }

    var imgContentH = (MediaQuery.of(context).size.width - 40) / 2;
    var img = NetWorkingConfig.imgBaseUrl + model.imgs[0];
    var content = widget.pageType == 1 ? homeModel.content : showModel.instruction;
    var avator = widget.pageType == 1 ? homeModel.userInfo.avator : showModel.user.avator;
    var username = widget.pageType == 1 ? homeModel.userInfo.username : showModel.user.username;
    var complete = widget.pageType == 1 ? homeModel.is_complete : false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // CachedNetworkImage(
            //   imageUrl: img,
            //   placeholder: (context,url) => Container(
            //     color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
            //   ),
            //   fit: BoxFit.cover,
            //   width: double.infinity,
            //   height: imgContentH,
            // )
            Container(
              width: double.infinity,
              height: imgContentH,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  CachedNetworkImage(
                    imageUrl: img,
                    placeholder: (context,url) => Container(
                      color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: complete == true ? Container(
                      decoration: BoxDecoration(
                        color: ColorsUtil.fromEnmu(ColorEnum.system),
                        borderRadius: BorderRadius.circular(14)
                      ),
                      width: 44,
                      height: 18,
                      alignment: Alignment.center,
                      child: Text('已完成',style: TextStyle(color: Colors.white,
                          fontSize: FontUtil.fs(FontSize.desc),
                          fontWeight: FontWeight.w500)),
                    ): Container(),
                  )
                ],
              ),
            ),
            Expanded(child: Container(
                child: Column(
                  children: [
                    Expanded(child:
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(content,maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title),
                            fontSize: FontUtil.fs(FontSize.content)),
                      ),
                    )
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      height: 30,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage:
                            // isLoadingImg ?
                            ((avator != null && avator.length > 0) ?
                            CachedNetworkImageProvider(ToolConfig.showHeadImg(avator)) :
                            AssetImage('assets/icons/icon_plh.png')),
                            //   :
                            // AssetImage('assets/icons/icon_plh.png'),
                            child: Container(
                              alignment: Alignment(0, 0),
                              width: 20,
                              height: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child:Text(username),
                          )
                        ],
                      ),
                    )
                  ],
                )
            ))
          ],
        ),
      ),
    );
  }

  Future<Null> getUserPublishListNetworking(int page) async{
    pageNum = page;
    final url = NetWorkingConfig.path(NetPath.userIdGetUserPublish);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['userId'] = UserManager.instance.userInfo.id;
    dic['page'] = pageNum;
    dic['size'] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        if (data['data'].length > 0) {
          var models = (data['data'] as List).map<dynamic>((res) {
            var model = HomePageModel.fromJson(res);
            return model;
          }).toList();
          if (pageNum ==1 ) {
            publishList = models;
          }else{
            publishList = publishList + models;
          }
          pageNum += 1;
          setState(() {

          });
        }

      }
    }, (error) {
      // EasyLoading.showToast('获取token失败');
    });
  }

  Future<Null> getUserShowPublishListNetworking(int page) async{
    final url = NetWorkingConfig.path(NetPath.getUserShowPublish);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['userId'] = UserManager.instance.userInfo.id;
    dic['page'] = pageNum;
    dic['size'] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        if (data['data'].length > 0) {
          var models = (data['data'] as List).map<dynamic>((res) {
            var model = ShowInfoModel.fromJson(res);
            return model;
          }).toList();
          if (pageNum ==1 ) {
            publishList = models;
          }else{
            publishList = publishList + models;
          }
          pageNum += 1;
          setState(() {

          });
        }

      }
    }, (error) {
      // EasyLoading.showToast('获取token失败');
    });
  }
}


class CustomBouncingScroll extends BouncingScrollPhysics {

  /// Creates scroll physics that bounce back from the edge.

  const CustomBouncingScroll({ScrollPhysics parent}) : super(parent: parent);

  @override

  CustomBouncingScroll applyTo(ScrollPhysics ancestor) {

    return CustomBouncingScroll(parent: buildParent(ancestor));

  }

// 重构弹性范围，只有当上滑的时候才有弹性，下拉去除

  @override

  double applyBoundaryConditions(ScrollMetrics position, double value) {

    if (value < position.pixels &&

        position.pixels <= position.minScrollExtent) // underscroll

      return value - position.pixels;

    if (value < position.minScrollExtent &&

        position.minScrollExtent < position.pixels) // hit top edge

      return value - position.minScrollExtent;

    return 0.0;

  }

}

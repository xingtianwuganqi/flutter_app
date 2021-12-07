import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
class NewUserPublishListPage extends StatefulWidget {

  int pageType = 1;

  NewUserPublishListPage({Key key, this.pageType}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewUserPublishListPageState();
  }
}

class NewUserPublishListPageState extends State<NewUserPublishListPage> with AutomaticKeepAliveClientMixin {

  List<HomePageModel> publishList = [];
  List<ShowInfoModel> showPublishList = [];
  int pageNum = 1;

  //导航栏切换时保持原有状态
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.pageType == 1) {
      getUserPublishListNetworking(pageNum);
    // }else{
    //   getUserShowPublishListNetworking(pageNum);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsUtil.fromEnmu(ColorEnum.backColor),
      padding: EdgeInsets.only(left: 15,right: 15),
      child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        childAspectRatio: 0.73,
      ), itemBuilder: (context,index){
        var model = publishList[index];
        return Container(
          child: rescuePublishItem(model),
        );
      },itemCount: publishList.length,
        physics: CustomBouncingScroll(),
        padding: EdgeInsets.only(top: 15),
      )
    );
  }

  Widget rescuePublishItem(HomePageModel model) {
    var imgContentH = (MediaQuery.of(context).size.width - 40) / 2;
    var img = NetWorkingConfig.imgBaseUrl + model.imgs[0];

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: img,
              placeholder: (context,url) => Container(
                color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
              ),
              fit: BoxFit.cover,
              width: double.infinity,
              height: imgContentH,
            ),
            Expanded(child: Container(
                child: Column(
                  children: [
                    Expanded(child:
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(model.content,overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
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
                            ((model.userInfo.avator != null && model.userInfo.avator.length > 0) ?
                            CachedNetworkImageProvider(ToolConfig.showHeadImg(model.userInfo.avator)) :
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
                            child:Text(model.userInfo.username),
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
        var models = (data['data'] as List).map((res) {
          var model = HomePageModel.fromJson(res);
          return model;
        }).toList();
        publishList = models;
        setState(() {

        });
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
        var datas = data['data'];
        var models = (datas as List).map((res) {
          var model = ShowInfoModel.fromJson(res);
          return model;
        }).toList();
        showPublishList = models;
        setState(() {

        });

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

// import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../NetWorking/NetWorking.dart';


class ShowInfoListWidget extends StatefulWidget {
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
    showInfoListNetWroking(1);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return showInfoItem(context,data);
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
    final dic = {"page": page,"size": 10,'token': UserManager.instance.token};
    FormData formData = FormData.fromMap(dic);

    ///创建Map 封装参数
    await NetWorking.formDataPost(url, formData,(data){
      if (data['code'] == 200) {
        List<ShowInfoModel> datas = [];
        var models = data['data'];
        for (int i = 0;i < models.length; i++ ){
          datas.add(new ShowInfoModel.fromJson(models[i]));
        }
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

Widget showInfoItem(BuildContext context, ShowInfoModel data) {

  var imgWidgets = data.imgs.map((e) => Container(
    child: Image.network('http://img.rxswift.cn/' + e),
  ));


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
                backgroundImage: NetworkImage(((data.user.avator ?? "").length > (0)) ? ('http://img.rxswift.cn/' + data.user.avator) : ''),
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
                          fontSize: FontUtil.fs(FontSize.title),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(padding: EdgeInsets.all(3)),
                      Text( ToolConfig.timeT(data.create_time) ?? "",
                          style: TextStyle(
                              color: ColorsUtil.fromEnmu(ColorEnum.desc),
                              fontSize: 12),
                          overflow: TextOverflow.ellipsis)
                    ],
                  )),
              Expanded(
                  child: Container(

                  )),
              IconButton(icon: Icon(Icons.more_horiz_outlined), onPressed: (){}),
            ],
          ),
        ),
        /// pageView
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: PageView(
            children: imgWidgets.toList(),
          ),
        ),
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
        Container(
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
        /// 点赞，收藏，评论
        commentWidget(context,data),
        Divider(thickness: 10,color: Colors.grey[100],)
      ],
    ),
  );
}

Widget commentWidget(BuildContext context, ShowInfoModel data) {
  return Container(
    height: 40,
    child: Row(
      children: [
        Expanded(
            child: TextButton.icon(
              icon:Image.asset('assets/icons/icon_zan_un.png'),
              label: Text((data?.likes_num ?? 0) > (0) ? data.likes_num.toString() : "点赞",
                style: TextStyle(fontSize: 14,color: ColorsUtil.hexColor(0x707070)),
              ),
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
                style: TextStyle(fontSize: 14,color: ColorsUtil.hexColor(0x707070)),
              ),
              onPressed: (){},
            )
        ),
        Expanded(
            child: TextButton.icon(
              icon:Image.asset('assets/icons/icon_sh_commen.png'),
              label: Text((data?.commNum ?? 0) > (0) ? data.commNum.toString() : "评论",
                style: TextStyle(fontSize: 14,color: ColorsUtil.hexColor(0x707070)),
              ),
              onPressed: (){},
            )
        ),
      ],
    ),
  );
}
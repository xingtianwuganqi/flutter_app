import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/Message/MessagePage.dart';
import 'package:flutter_720yun/UserInfo/WebviewPage.dart';
import 'package:flutter_720yun/UserInfo/BrowseListPage.dart';
import 'package:flutter_720yun/UserInfo/UserCollectionPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/BlackListPage.dart';

class HomeDrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeDrawerPageState();
  }
}

class HomeDrawerPageState extends State<HomeDrawerPage> {

  List<MessagePageModel> datas = [
    MessagePageModel(icon: '',name: '',type: 1,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_view_hist.png',name: '浏览记录',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_mi_collection.png',name: '我的收藏',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_me_black.png',name: '黑名单',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_ado_about.png',name: '领养相关',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_mi_upload.png',name: '检测更新',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_mi_xy.png',name: '用户协议',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_pravicy.png',name: '隐私政策',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_mi_about.png',name: '关于我们',type: 0,unreadNum: 0)
  ];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: ListView(
        children: datas.map((e) {
          return listItem(e);
        }).toList(),
      ),
    );
  }

  Widget listItem(MessagePageModel model) {
    var userInfo = UserManager.instance.userInfo;
    if (model.type == 1){
      return Container(
        width: double.infinity,
        height: 80,
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 15)),
            CircleAvatar(
              radius: 25,
              backgroundImage:
              ((userInfo != null && userInfo.avator != null && userInfo.avator.length > 0) ?
              CachedNetworkImageProvider(ToolConfig.loadImgUrl(userInfo.avator)) :
              AssetImage('assets/icons/icon_plh.png')),
              child: Container(
                alignment: Alignment(0, 0),
                width: 50,
                height: 50,
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text((userInfo != null && userInfo.username != null && userInfo.username.length > 0) ?
            userInfo.username : "注册/登录",style:
            (userInfo != null && userInfo.username != null && userInfo.username.length > 0) ? TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content)) : TextStyle(fontSize: FontUtil.fs(FontSize.title),
                color: ColorsUtil.fromEnmu(ColorEnum.title),fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }else {
      // return Container(
      //     width: double.infinity,
      //     height: 50,
      //     child: Row(
      //       children: [
      //         Padding(padding: EdgeInsets.only(left: 15, right: 10),
      //           child: Image.asset('assets/icons/icon_show_gb.png'),),
      //         Text(model.name, style:
      //         TextStyle(fontSize: FontUtil.fs(FontSize.content),
      //             color: ColorsUtil.fromEnmu(ColorEnum.content)),
      //         ),
      //       ],
      //     )
      // );
      return ListTile(
        leading: Image.asset(model.icon),
        title:
        Container(
        transform: Matrix4.translationValues(-25, 0.0, 0.0),
        child:Text(model.name, style:
            TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.content)),
            ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (model.name == '浏览记录') {
            lazyAuthToDoThings(context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return BrowseListWidget();
              }));
            });
          }else if (model.name == '我的收藏') {
            lazyAuthToDoThings(context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return UserCollectionWidget();
              }));
            });
          }else if (model.name == "黑名单") {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return BlackListPage();
            }));
          }else if (model.name == '领养说明') {
            Navigator.push(context,MaterialPageRoute(builder: (context){
              return WebViewPage(url: NetWorkingConfig.path(NetPath.instruction));
            }));
          }
          else if (model.name == '用户协议') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return WebViewPage(url: NetWorkingConfig.path(NetPath.userAgreen));
            }));
          }else if (model.name == '隐私政策') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return WebViewPage(url: NetWorkingConfig.path(NetPath.pravicy));
            }));
          }else if (model.name == '关于我们') {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return WebViewPage(url: NetWorkingConfig.path(NetPath.aboutUs));
            }));
          }else if (model.name == "检测更新") {
            // if (data.num == 1) {
            //   showModalBottomSheet(
            //     context: context,
            //     isScrollControlled: true,
            //     builder: (context){
            //       return uploadAlert();
            //     },
            //   );
            // }else{
            //   isTap = true;
            //   uploadNetWorking();
            // }
          }
        },
      );
    }
  }


}
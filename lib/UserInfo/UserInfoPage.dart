import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/UserInfo/BrowseListPage.dart';
import 'package:flutter_720yun/UserInfo/EditUserInfoPage.dart';
import 'package:flutter_720yun/UserInfo/SettingInfoPage.dart';
import 'package:flutter_720yun/UserInfo/UserCollectionPage.dart';
import 'package:flutter_720yun/UserInfo/UserPublishPage.dart';
import 'package:provider/provider.dart';
import '../NetWorking/NetWorking.dart';

class UserInfoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserInfoWidgetState();
  }
}

class UserInfoWidgetState extends State<UserInfoWidget> {

  Widget dividerH = Divider(
    color: Colors.grey[100],
  );
  Widget dividerDefult = Divider(
    color: Colors.grey[600],
  );

  String titleStr = "";

  List<UserPageModel> listData = [
    UserPageModel('assets/icons/icon_view_hist.png', '浏览记录'),
    UserPageModel('assets/icons/icon_mi_publish.png', '我的发布'),
    UserPageModel('assets/icons/icon_mi_collection.png', '我的收藏'),
    // UserPageModel('icon', "empty"),
    UserPageModel('assets/icons/icon_mi_upload.png', '检测更新'),
    // UserPageModel('assets/icons/icon_mi_pf.png', '应用评分'),
    UserPageModel('assets/icons/icon_mi_xy.png', '用户协议'),
    UserPageModel('assets/icons/icon_pravicy.png', '隐私政策'),
    UserPageModel('assets/icons/icon_mi_about.png', '关于我们'),
  ];

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (_scrollController.offset > 80) {
        titleStr = "";
      }else{
        titleStr = '我的';
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget titleCell(UserPageModel data) {
      List<Widget> datas = [];
      if (data.title == "我的收藏"){
        datas = [
          Padding(
          padding: EdgeInsets.only(left: 5,right: 5),
          child: ListTile(
              title: Container(
                transform: Matrix4.translationValues(-20, 0.0, 0.0),
                  child: Text(data.title,style: TextStyle(fontSize: 14,color: Colors.black)),
                ),
              leading: Image.asset(data.icon),
              trailing: Icon(Icons.keyboard_arrow_right,color: ColorsUtil.fromEnmu(ColorEnum.mark))
          ),
        ),
          Divider(thickness: 10.0,color: Colors.grey[100],)
        ];
      }else{
        datas = [
          Padding(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: ListTile(
                title: Container(
                  transform: Matrix4.translationValues(-20, 0.0, 0.0),
                  child: Text(data.title,style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content))),
                ),
                leading: Image.asset(data.icon),
                trailing: Icon(Icons.keyboard_arrow_right,color: ColorsUtil.fromEnmu(ColorEnum.mark))
            ),
          ),
          new Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),),
        ];
      }
      return GestureDetector(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 0,right: 0),
          child: Column(
              children: datas
          ),
        ),
        onTap: () {
          didClickAction(data);
        },
      );
    }

    Widget UserInfoWidget() {
      return GestureDetector(
        child: Container(
          color: Colors.black12,
          alignment: Alignment(0, .7),
          padding: EdgeInsets.only(left: 10,right: 6),
          child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: context.watch<UserProviderModel>().isLogin ? CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + (UserManager.instance.userInfo.avator ?? "")) : AssetImage('assets/icons/icon_plh.png'),
                child: Container(
                    alignment: Alignment(0, .5),
                    width: 50,
                    height: 50,
                ),
              ),
              title: context.watch<UserProviderModel>().isLogin ? Text(UserManager.instance.userInfo.username ?? "",
                style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: Colors.white),) : Text('注册/登录',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: Colors.white),),
              trailing:  Icon(Icons.keyboard_arrow_right,color: Colors.white),
          ),
        ),
        onTap: () {
          lazyAuthToDoThings(context, (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return new EditUserWidget();
            }));
          });
        },
      );
    }

    return Material(
      child:
      CustomScrollView(
        // controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: Text(titleStr),
            pinned: true,
            floating: false,
            stretch: true,
            expandedHeight: 150.0,
            backgroundColor: ColorsUtil.hexColor(0xffa500),
            shadowColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: UserInfoWidget()
            ),
            actions: [
              TextButton(
                  onPressed: () {},
                  child: IconButton(icon: Icon(Icons.settings,color: Colors.white,),onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context){
                          return SettingPageWidget();
                        })
                    );
                  },))
            ],
          ),
          //List
          new SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context,index){
                    return titleCell(listData[index]);
              },childCount: listData.length)
          )
        ],
      ),
    );
  }

  void didClickAction(UserPageModel data) {
    if (data.title == '浏览记录') {
      lazyAuthToDoThings(context, () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return BrowseListWidget();
        }));
      });
    }else if (data.title == '我的发布') {
      lazyAuthToDoThings(context, () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return UserPublishWidget();
        }));
      });
    }else if (data.title == '我的收藏') {
      lazyAuthToDoThings(context, () {
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return UserCollectionWidget();
        }));
      });
    }
  }
}

class UserPageModel {
  final String icon;
  final String title;

  UserPageModel(
      this.icon,
      this.title
      );
}
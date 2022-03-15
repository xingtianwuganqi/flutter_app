import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/UserInfo/NewUserPublishListPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/UserInfo/SettingInfoPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_720yun/UserInfo/EditUserInfoPage.dart';
// import
class NewUserInfoPage extends StatefulWidget {
  final MyPageType pageType;
  int userId;
  NewUserInfoPage({
    Key key,
    @required this.pageType,
    @required this.userId
  }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewUserInfoPageState();
  }
}

class NewUserInfoPageState extends State<NewUserInfoPage> with SingleTickerProviderStateMixin {
  List<String> tabs = ["领养","秀宠"];
  TabController _tabController;
  ScrollController _scrollController;
  bool isShowTitle = false;

  /// 请求回来的uerInfo
  UserInfoModel otherUserInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && isShowTitle == false) {
        setState(() {
          isShowTitle = true;
        });
      }else if (_scrollController.offset <= 100 && isShowTitle == true){
        setState(() {
          isShowTitle = false;
        });
      }
    });

    // 监听用户登录
    Provider.of<UserProviderModel>(context,listen: false).addListener(() {
      if (Provider.of<UserProviderModel>(context,listen: false).user != null) {
        if (widget.pageType == MyPageType.myPage) {
          widget.userId = Provider.of<UserProviderModel>(context,listen: false).user.id;
          setState(() {

          });
        }

      }else{
        if (widget.pageType == MyPageType.myPage) {
          widget.userId = 0;
          setState(() {

          });
        }
      }
    });
    if (widget.pageType == MyPageType.otherPage) {
      userIdGetUserInfo();
    }
  }
  @override
  Widget build(BuildContext context) {
    // if (widget.pageType == MyPageType.myPage && UserManager.instance.userInfo.id != null) {
    //   widgetuserId = UserManager.instance.userInfo.id;
    // }
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context ,bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                pinned: true,
                elevation: 0.5,
                floating: false,
                title: isShowTitle ? Text('我的') : null,
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings,color: isShowTitle ? Colors.black: Colors.white),
                    onPressed: () {
                      lazyAuthToDoThings(context, () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) {
                          return SettingPageWidget();
                        }));
                      });
                    },
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: widget.pageType == MyPageType.myPage ? UserInfoWidget() : OtherUserInfoWidget(),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  child: TabBar(
                    // labelColor: ColorsUtil.fromEnmu(ColorEnum.title),
                    // unselectedLabelColor: ColorsUtil.fromEnmu(ColorEnum.note),
                    labelStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title),fontSize: 17,fontWeight: FontWeight.w600),
                    unselectedLabelStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.note),fontSize: 16),
                    controller: _tabController,
                    indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4,
                    tabs: tabs.map((e) => Tab(text: e)).toList(),
                  ),
                ),
              ),
            ];
          },
            body: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  NewUserPublishListPage(pageType:widget.pageType, netType: 1,userId: widget.userId),
                  NewUserPublishListPage(pageType:widget.pageType, netType: 2,userId: widget.userId),
                ],
              ),
            ),
        ),
      ),
    );
  }

  Widget UserInfoWidget() {
    return GestureDetector(
      child: Container(
        color: ColorsUtil.fromEnmu(ColorEnum.system),
        alignment: Alignment(0, .7),
        padding: EdgeInsets.only(left: 10,right: 6),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: context.watch<UserProviderModel>().isLogin ?
            ((UserManager.instance.userInfo.avator != null && UserManager.instance.userInfo.avator.length > 0) ?
            CachedNetworkImageProvider(ToolConfig.loadImgUrl(UserManager.instance.userInfo.avator)) :
            AssetImage('assets/icons/icon_plh.png')
            ) :
            AssetImage('assets/icons/icon_plh.png'),
            child: Container(
              alignment: Alignment(0, .5),
              width: 50,
              height: 50,
            ),
          ),
          title: context.watch<UserProviderModel>().isLogin ?
          Text(UserManager.instance.userInfo.username ?? "",
            style: TextStyle(fontSize: FontUtil.fs(FontSize.content),fontWeight: FontWeight.w500,color: Colors.white),) :
          Text('注册/登录',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),fontWeight: FontWeight.w500,color: Colors.white),),
          trailing:  Icon(Icons.keyboard_arrow_right,color: Colors.white),
        ),
      ),
      onTap: () {
        lazyAuthToDoThings(context, (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return new EditUserWidget(from: 'userinfo');
          }));
        });
      },
    );
  }

  Widget OtherUserInfoWidget() {
    return Container(
      color: ColorsUtil.fromEnmu(ColorEnum.system),
      alignment: Alignment(0, .7),
      padding: EdgeInsets.only(left: 10,right: 6),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          backgroundImage: otherUserInfo != null ?
          CachedNetworkImageProvider(ToolConfig.loadImgUrl(otherUserInfo.avator)) :
          AssetImage('assets/icons/icon_plh.png'),
          child: Container(
            alignment: Alignment(0, .5),
            width: 50,
            height: 50,
          ),
        ),
        title: otherUserInfo != null ?
        Text(otherUserInfo.username ?? "",
          style: TextStyle(fontSize: FontUtil.fs(FontSize.content),fontWeight: FontWeight.w500,color: Colors.white),) :
        Text('--',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),fontWeight: FontWeight.w500,color: Colors.white),),
        trailing:  Icon(Icons.keyboard_arrow_right,color: Colors.white),
      ),
    );
  }

  Future<Null> userIdGetUserInfo() async {
    final url = NetWorkingConfig.path(NetPath.userIdGetUserInfo);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['userId'] = widget.userId;
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var info = UserInfoModel.fromJson(data["data"]);
        otherUserInfo = info;
        setState(() {

        });
      }
    }, (error) {
      // EasyLoading.showToast('获取token失败');
    });
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: this.child,
    );
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
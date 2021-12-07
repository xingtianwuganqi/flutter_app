import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/UserInfo/NewUserPublishListPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_720yun/UserInfo/EditUserInfoPage.dart';
// import
class NewUserInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewUserInfoPageState();
  }
}

class NewUserInfoPageState extends State<NewUserInfoPage> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context ,bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                flexibleSpace: UserInfoWidget(),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  child: TabBar(
                    labelColor: ColorsUtil.fromEnmu(ColorEnum.title),
                    unselectedLabelColor: ColorsUtil.fromEnmu(ColorEnum.note),
                    controller: _tabController,
                    indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4,
                    tabs: <Widget>[
                      Tab(text: '领养'),
                      Tab(text: '秀宠'),
                    ],
                  ),
                ),
              ),
            ];
          },
            body: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  NewUserPublishListPage(),
                  NewUserPublishListPage(),
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
        color: Colors.black12,
        alignment: Alignment(0, .7),
        padding: EdgeInsets.only(left: 10,right: 6),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: context.watch<UserProviderModel>().isLogin ?
            ((UserManager.instance.userInfo.avator != null && UserManager.instance.userInfo.avator.length > 0) ?
            CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + (UserManager.instance.userInfo.avator ?? "") + NetWorkingConfig.imgTailUrl) :
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
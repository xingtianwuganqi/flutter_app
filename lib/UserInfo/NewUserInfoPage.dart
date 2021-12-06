import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/UserInfo/NewUserPublishListPage.dart';
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
                expandedHeight: 230.0,
                pinned: true,
                flexibleSpace: 
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 8),
                //   child: PageView(),
                // ),
                Container(
                  color: ColorsUtil.fromEnmu(ColorEnum.system),
                )
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  child: TabBar(
                    labelColor: Colors.black,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(text: '资讯'),
                      Tab(text: '技术'),
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
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).backgroundColor,
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
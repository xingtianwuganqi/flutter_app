import 'package:flutter/material.dart';
import 'package:flutter_720yun/homepage/HomePage.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'SearchPage.dart';
class HomeMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeMainPageState();
  }
}

class HomeMainPageState extends State<HomeMainPage> with SingleTickerProviderStateMixin {
  List tabs = ["推荐","同城"];
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
        bottom: AppBarBottomComponent(tabController: _tabController,tabs: tabs),
        // TabBar(
        //   controller: _tabController, // 4 需要配置 controller！！！
        //   // isScrollable: true,
        //   tabs:tabs.map((e) => Tab(text: e)).toList(),
        //   // labelColor: ColorsUtil.fromEnmu(ColorEnum.title),
        //   // unselectedLabelColor: ColorsUtil.fromEnmu(ColorEnum.content),
        //   labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: ColorsUtil.fromEnmu(ColorEnum.title)),
        //   unselectedLabelStyle: TextStyle(fontSize: 16,color: ColorsUtil.fromEnmu(ColorEnum.content)),
        //   indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
        //   indicatorSize: TabBarIndicatorSize.label,
        //   indicatorWeight: 6,
        //   isScrollable: true,
        // ),
        // PreferredSizeWidget(
        //
        // ),
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          controller: _tabController,
          children: [
            HomePage(),
            HomePage()
          ],
        ),
      ),
    );
  }
}

class AppBarBottomComponent extends StatelessWidget implements PreferredSizeWidget {

  final TabController tabController;
  final List tabs;

  AppBarBottomComponent({
    Key key,
    @required this.tabController,
    this.tabs
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: tabController, // 4 需要配置 controller！！！
        // isScrollable: true,
        tabs:tabs.map((e) => Tab(text: e)).toList(),
        // labelColor: ColorsUtil.fromEnmu(ColorEnum.title),
        // unselectedLabelColor: ColorsUtil.fromEnmu(ColorEnum.content),
        labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: ColorsUtil.fromEnmu(ColorEnum.title)),
        unselectedLabelStyle: TextStyle(fontSize: 16,color: ColorsUtil.fromEnmu(ColorEnum.content)),
        indicatorColor: ColorsUtil.fromEnmu(ColorEnum.system),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 4,
        isScrollable: true,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(40.0);
}
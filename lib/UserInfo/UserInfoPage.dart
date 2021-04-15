import 'package:flutter/material.dart';
import 'package:flutter_720yun/UserInfo/EditUserInfoPage.dart';
import 'package:flutter_720yun/UserInfo/SettingInfoPage.dart';

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
    UserPageModel('icon', '浏览记录'),
    UserPageModel('icon', '我的发布'),
    UserPageModel('icon', '我的收藏'),
    // UserPageModel('icon', "empty"),
    UserPageModel('icon', '检测更新'),
    UserPageModel('icon', '应用评分'),
    UserPageModel('icon', '用户协议'),
    UserPageModel('icon', '隐私政策'),
    UserPageModel('icon', '关于我们'),
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
          padding: EdgeInsets.only(left: 10,right: 10),
          child: ListTile(
              title: Text(data.title),
              leading: Icon(Icons.email),
              trailing: Icon(Icons.keyboard_arrow_right)
          ),
        ),
          Divider(thickness: 10.0,color: Colors.grey[100],)
        ];
      }else{
        datas = [
          Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: ListTile(
                title: Text(data.title),
                leading: Icon(Icons.email),
                trailing: Icon(Icons.keyboard_arrow_right)
            ),
          ),
          Divider(height: .0,)];
      }
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 0,right: 0),
        child: Column(
          children: datas
        ),
      );
    }

    Widget UserInfoWidget() {
      return GestureDetector(
        child: Container(
          color: Colors.black12,
          alignment: Alignment(0, .7),
          padding: EdgeInsets.only(left: 15,right: 12),
          child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage("https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"),
                child: Container(
                    alignment: Alignment(0, .5),
                    width: 50,
                    height: 50,
                ),
              ),
              title: Text('昵称'),
              trailing: Icon(Icons.keyboard_arrow_right)
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return new EditUserWidget();
          }));
        },
      );
    }

    return Material(
      child: CustomScrollView(
        // controller: _scrollController,
        slivers: [
          SliverAppBar(
            title: Text(titleStr),
            pinned: true,
            floating: false,
            stretch: true,
            expandedHeight: 150.0,
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
      // Scaffold(
      //   appBar: AppBar(
      //     title: Text("我的"),
      //   ),
      //   body:   ListView.builder(
      //       // itemExtent: 60,
      //         itemCount: listData.length,
      //         // ignore: missing_return
      //         itemBuilder: (context,index) {
      //           if (listData[index].title == 'empty') {
      //             return Container(
      //               height: 10,
      //               color: Colors.transparent,
      //             );
      //           }else{
      //             return titleCell(listData[index]);
      //           }
      //         }),
      // );
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
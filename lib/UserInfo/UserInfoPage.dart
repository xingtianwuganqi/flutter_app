import 'package:flutter/material.dart';
import 'package:flutter_720yun/UserInfo/EditUserInfoPage.dart';

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

  List<UserPageModel> listData = [
    UserPageModel('icon', '浏览记录'),
    UserPageModel('icon', '我的发布'),
    UserPageModel('icon', '我的收藏'),
    UserPageModel('icon', "empty"),
    UserPageModel('icon', '检测更新'),
    UserPageModel('icon', '应用评分'),
    UserPageModel('icon', '用户协议'),
    UserPageModel('icon', '隐私政策'),
    UserPageModel('icon', '关于我们'),
  ];

  @override
  Widget build(BuildContext context) {

    Widget titleCell(UserPageModel data) {
      List<Widget> datas = [];
      if (data.title == "我的收藏"){
        datas = [ListTile(
            title: Text(data.title),
            leading: Icon(Icons.email),
            trailing: Icon(Icons.keyboard_arrow_right)
        )];
      }else{
        datas = [ListTile(
            title: Text(data.title),
            leading: Icon(Icons.email),
            trailing: Icon(Icons.keyboard_arrow_right)
        ),
        Divider(height: .0,)];
      }
      return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: datas
        ),
      );
    }

    return
      Scaffold(
        appBar: AppBar(
          title: Text("我的"),
        ),
        body:   ListView.builder(
            // itemExtent: 60,
              itemCount: listData.length,
              // ignore: missing_return
              itemBuilder: (context,index) {
                if (listData[index].title == 'empty') {
                  return Container(
                    height: 10,
                    color: Colors.transparent,
                  );
                }else{
                  return titleCell(listData[index]);
                }
              }),
      );
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
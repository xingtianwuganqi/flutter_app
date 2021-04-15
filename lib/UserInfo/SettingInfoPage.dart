import 'package:flutter/material.dart';
import '../UserInfo/UserInfoPage.dart';
class SettingPageWidget extends StatelessWidget {

  List<UserPageModel> datas = [
    UserPageModel('icon', '修改密码'),
    UserPageModel('icon', '意见反馈'),
    UserPageModel('', "退出登录")
    // UserPageModel('', title)
  ];

  @override
  Widget build(BuildContext context) {

    Widget settingWidget(UserPageModel data) {
      List<Widget> arrs = [];
      if (data.title == "意见反馈"){
        arrs = [
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
        arrs = [
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
      if (data.title == '退出登录'){
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 15,bottom: 15),
          child: Text(data.title),
        );
      }else{
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 0,right: 0),
          child: Column(
              children: arrs
          ),
        );
      }

    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),

      ),
      body: ListView.builder(
        itemBuilder: (context,index){
            return settingWidget(datas[index]);
        },
        itemCount: 3,
      ),
    );
  }
}
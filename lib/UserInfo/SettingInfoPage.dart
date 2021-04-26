import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/UserInfo/ChangePswdPage.dart';
import '../UserInfo/UserInfoPage.dart';
import 'package:provider/provider.dart';

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
                title: Container(
                  transform: Matrix4.translationValues(-25, 0.0, 0.0),
                  child: Text(data.title,style: TextStyle(fontSize: 14,color: Colors.black)),
                ),
                leading: Image.asset('assets/icons/icon_setting_fk.png'),
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
                title: Container(
                    transform: Matrix4.translationValues(-25, 0.0, 0.0),
                    child: Text(data.title,style: TextStyle(fontSize: 14,color: Colors.black)),
                  ),
                leading: Image.asset('assets/icons/icon_setting_pswd.png'),
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
        elevation: 0.5,

      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          itemBuilder: (context,index){
            var data = datas[index];
            return GestureDetector(
              child: settingWidget(data),
              onTap: () {
                if (data.title == "修改密码"){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return new ChangePswdWidget();
                  }));
                }else if (data.title == '意见反馈'){

                }else{
                  /// 退出登录
                  UserManager.instance.logout();
                  Provider.of<UserProviderModel>(context, listen: false).user = null;
                }
              },
            );
          },
          itemCount: 3,
        ),
      )
    );
  }
}
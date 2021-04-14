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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Scaffold(
        appBar: AppBar(
          title: Text("我的"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: TextButton(
                child: Text('编辑信息'),
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context){
                        return EditUserWidget();
                      }));
                },
              ),
            )
          ],
        ),
      );
  }
}
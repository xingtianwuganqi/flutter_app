import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EditUserWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditUserWidgetState();
  }
}

class EditUserWidgetState extends State<EditUserWidget> {

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();

  TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNodeUserName.addListener(() {
      _focusNodeListener();
    });

    _nicknameController.addListener(() {
      print(_nicknameController.text);
    });
  }

  //   // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
    }
  }

  @override
  Widget build(BuildContext context) {
    
    Widget headWidget() {
      return new Container(
        padding: EdgeInsets.only(left: 16,top: 10,right: 16,bottom: 5),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage("https://tva1.sinaimg.cn/large/006y8mN6gy1g7aa03bmfpj3069069mx8.jpg"),
              child: Container(
                alignment: Alignment(0, .5),
                width: 60,
                height: 60,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15,bottom: 15),
              child: Text("点击更换头像",style: TextStyle(fontSize: 14),),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            )
          ],
        ),
      );
    }

    Widget nickNameWidget() {
      return Container(
        padding: EdgeInsets.only(left: 16,right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text('昵称'),
                Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: TextField(maxLines: 1,
                    focusNode: _focusNodeUserName,
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      hintText: "请输入昵称",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(fontSize: 15),


                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              height: 0.5,
              color: Colors.black12,
            )
          ],
        )

      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑个人信息'),
        actions: [
          TextButton(
              onPressed: () {

              },
              child: Text('保存',style: TextStyle(color: Colors.white,fontSize: 16),))
        ],
        elevation: 0.5,
      ),
      body:new GestureDetector(
        onTap: () {
          _focusNodeUserName.unfocus();
        },
        child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10),
            children: [
              headWidget(),
              nickNameWidget()
            ]
        ),
      )
    );
  }
}
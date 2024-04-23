import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateGambitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateGambitState();
  }
}

class CreateGambitState extends State<CreateGambitPage> {

  FocusNode _focusNode = FocusNode();
  TextEditingController _comController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _focusNode.addListener(() {
    //   _focusNodeListener();
    // });
  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    // _focusNode.removeListener(_focusNodeListener);
    _comController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    /// 失去焦点时，去掉输入框中的问题
    if (!_focusNode.hasFocus) {
      // // 取消密码框的焦点状态
      // _replyComModel = null;
      // _comController.clear();
      // setState(() {
      //   _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: ColorsUtil.fromEnmu(ColorEnum.defIcon),
      appBar: AppBar(
        title: Text('发起话题'),
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: () {
                _focusNode.unfocus();
                pushNetworking();
              },
              child: Text('提交',
                style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.system),
                    fontSize: FontUtil.fs(FontSize.content)),
              )
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10,left: 15,right: 15),
                decoration: new BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //设置四周边框
                  // border: new Border.all(width: 1, color: Colors.red),
                ),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Image.asset('assets/icons/icon_show_gb.png'),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(child:
                      TextField(maxLines: 1,
                        style: TextStyle(fontSize: 15,textBaseline: TextBaseline.alphabetic),
                        focusNode: _focusNode,
                        cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                        controller: _comController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "发起一个有趣的话题",
                            hintStyle: TextStyle(color: Colors.black12)
                          // enabledBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.transparent),
                          // ),
                          // focusedBorder: UnderlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.transparent),
                          // ),
                        ),
                      ),
                    )
                  ],
                ),

              ),
              // 提示语
              bottomRemindText(),
            ],
          ),
        ),
        onTap: () {
          _focusNode.unfocus();
        },
      ),
    );
  }

  Widget bottomRemindText() {
    return Container(
      padding: EdgeInsets.only(bottom: 10,top: 15,left: 15,right: 15),
      child: Text('发起话题后需要审核，审核通过后将展示在话题列表，禁止出现商业广告，低俗，色情，暴力，具有侮辱性语言或与宠物无关的内容！',
        style: TextStyle(
            fontSize: 15,
            color: ColorsUtil.fromEnmu(ColorEnum.desc)),
      ),
    );
  }

  Future<Null> pushNetworking() async {

    if (_comController.text == null || _comController.text.length == 0) {
      EasyLoading.showToast('请输入要发起的话题');
      return;
    }

    final url = NetWorkingConfig.path(NetPath.pushGambit);
    final dic = {
      'descript': _comController.text,
      'user_id': UserManager.instance.userInfo?.id,
      'review_type': 1,
      'token': UserManager.instance.token
    };
    print(url);
    print(dic);
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        EasyLoading.showToast("提交成功");
        Future.delayed(Duration(seconds: 1),()
        {
          _comController.clear();
          Navigator.pop(context);
        });
      }else{
        EasyLoading.showToast("提交失败");
      }
    }, (error) {
      EasyLoading.showToast("提交失败");
    });
  }
}
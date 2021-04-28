import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SuggesstionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SuggestionState();
  }
}

class SuggestionState extends State<SuggesstionWidget> {

  FocusNode _sugFocus = FocusNode();
  FocusNode _contactFocus = FocusNode();

  TextEditingController _sugController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('意见反馈'),
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: (){

              }, child: Text('提交',
            style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.system)),)
          )
        ],
      ),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('请输入您的建议',
                  style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                      fontSize: FontUtil.fs(FontSize.content)
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                  constraints: BoxConstraints(maxHeight: 200, minHeight: 200),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(
                        width: 1,
                        color: ColorsUtil.fromEnmu(ColorEnum.tableBack)
                    )
                  ),
                  child: TextField(
                    maxLines: null,
                    focusNode: _sugFocus,
                    controller: _sugController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                      fontSize: FontUtil.fs(FontSize.content)),
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: "您的意见对我们非常重要",
                      hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
                          fontSize: FontUtil.fs(FontSize.content)
                      ),
                    ),
                  ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 15),
                child: Text('请输入您的联系方式',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                    fontSize: FontUtil.fs(FontSize.content)
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 1,left: 5,right: 5,bottom: 1),
                constraints: BoxConstraints(maxHeight: 45, minHeight: 45),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    border: Border.all(
                        width: 1,
                        color: ColorsUtil.fromEnmu(ColorEnum.tableBack)
                    )
                ),
                child: TextField(
                  maxLines: 1,
                  focusNode: _contactFocus,
                  controller: _contactController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                      fontSize: FontUtil.fs(FontSize.content)),
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: "请输入您的联系方式",
                    hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
                        fontSize: FontUtil.fs(FontSize.content)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          _sugFocus.unfocus();
        },
      )
    );
  }

  void suggestionClick() {
    if (_sugController.text.length == 0) {
      EasyLoading.showToast('请输入您的建议');
      return;
    }
    if (_contactController.text.length == 0) {
      EasyLoading.showToast('请输入您的联系方式');
      return;
    }
    suggestionNetworking();
  }

  Future<Null> suggestionNetworking() async{
    final url = NetWorkingConfig.path(NetPath.suggestion);
    final dic = {'token': UserManager.instance.token,'content': _sugController.text,'contact': _contactController.text};
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      if (data['code'] == 200) {
        EasyLoading.showToast('提交成功');
        Future.delayed(Duration(seconds: 2), (){
          Navigator.of(context).pop();
        });
      }else{
        EasyLoading.showToast('提交失败');
      }
    }, (error) {
      EasyLoading.showToast('提交失败');
    });
  }
}
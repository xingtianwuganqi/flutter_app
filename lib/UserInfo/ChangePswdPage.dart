import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChangePswdWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChangePswdState();
  }
}

class ChangePswdState extends State<ChangePswdWidget> {

  FocusNode _originPswd = FocusNode();
  FocusNode _password   = FocusNode();
  FocusNode _confirmPswd = FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _originController = new TextEditingController();
  TextEditingController _pswdController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _originPswd.addListener(() {
      _focusNodeListener();
    });

    _password.addListener(() {
      _focusNodeListener();
    });

    _confirmPswd.addListener(() {
      _focusNodeListener();
    });

  }

  //   // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_originPswd.hasFocus){
      // 取消密码框的焦点状态
      _password.unfocus();
      _confirmPswd.unfocus();
    }
    if (_password.hasFocus) {
      // 取消用户名框焦点状态
      _originPswd.unfocus();
      _confirmPswd.unfocus();
    }
    if (_confirmPswd.hasFocus) {
      // 取消用户名框焦点状态
      _originPswd.unfocus();
      _password.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修改密码"),
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: () {
                _saveClick();
              },
              child: Text('保存',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.system),fontSize: FontUtil.fs(FontSize.content)),))
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 15,right: 15),
              child: TextField(
                focusNode: _originPswd,
                controller: _originController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "请输入原密码",
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  suffixIcon: _originController.text.length > 0 ? IconButton(icon: Icon(Icons.clear),
                      onPressed: (){
                        setState(() {
                          _originController.text = null;
                        });
                      }
                  ): null,
                ),
              ),
            ),
            Container(
              height: 0.5,
              padding: EdgeInsets.only(left: 15,right: 15),
              color: ColorsUtil.fromEnmu(ColorEnum.defIcon) ,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 15,right: 15),
              child: TextField(
                focusNode: _password,
                controller: _pswdController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "请输入新密码（不少于6位）",
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  suffixIcon: _pswdController.text.length > 0 ? IconButton(icon: Icon(Icons.clear),
                      onPressed: (){
                        setState(() {
                          _pswdController.text = null;
                        });
                      }
                  ): null,
                ),
              ),
            ),
            Container(
              height: 0.5,
              padding: EdgeInsets.only(left: 15,right: 15),
              color: ColorsUtil.fromEnmu(ColorEnum.defIcon) ,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.only(left: 15,right: 15),
              child: TextField(
                focusNode: _confirmPswd,
                controller: _confirmController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "请确认新密码",
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  suffixIcon: _confirmController.text.length > 0 ? IconButton(icon: Icon(Icons.clear),
                      onPressed: (){
                        setState(() {
                          _confirmController.text = null;
                        });
                      }
                  ): null,
                ),
              ),
            ),
            Container(
              height: 0.5,
              padding: EdgeInsets.only(left: 15,right: 15),
              color: ColorsUtil.fromEnmu(ColorEnum.defIcon) ,
            ),
          ],
        ),
        onTap: () {
          _originPswd.unfocus();
          _password.unfocus();
          _confirmPswd.unfocus();
        },
      )
    );
  }

  Future<Null> changePswdNetworking() async {
    if (_originController.text.length == 0) {
      return;
    }
    if (_pswdController.text.length == 0) {
      return;
    }
    if (_confirmController.text.length == 0) {
      return;
    }
    final url = NetWorkingConfig.path(NetPath.changePswd);
    final dic = {'origin_pswd':_originController.text,'password': _pswdController.text,'confirm_pswd': _confirmController.text,'token': UserManager.instance.token};
    print(_originController.text);
    print(_pswdController.text);
    print(_confirmController.text);
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData,(data){
      print(data);
      if (data['code'] == 200) {
        /// 成功
        EasyLoading.showToast('修改成功');
        Future.delayed(Duration(seconds: 2), (){
          Navigator.of(context).pop();
        });
      }else{
        var msg = data['message'];
        if (msg != null) {
          EasyLoading.showToast(msg);
        }else{
          EasyLoading.showToast('修改失败');
        }
        /// 失败
      }
    },(error){
      EasyLoading.showToast('请求失败');
    });

  }

  void _saveClick() {
    _originPswd.unfocus();
    _password.unfocus();
    _confirmPswd.unfocus();
    if (_originController.text.length == 0) {
      EasyLoading.showToast('请输入原密码');
      return;
    }
    if (_pswdController.text.length == 0) {
      EasyLoading.showToast('请输入新密码');
      return;
    }
    if (_confirmController.text.length == 0) {
      EasyLoading.showToast('请输入确认密码');
      return;
    }
    if (_originController.text == _pswdController.text) {
      EasyLoading.showToast('输入的原密码与新密码一致');
      return;
    }
    if (_pswdController.text.length < 6) {
      EasyLoading.showToast('请输入6位或6位以上新密码');
      return;
    }

    if (_pswdController.text != _confirmController.text) {
      EasyLoading.showToast('确认密码与新密码不一致');
      return;
    }
    changePswdNetworking();
  }
}

/*
dic["token"] = UserManager.shared.token
            dic["origin_pswd"] = origin
            dic["password"] = newPswd
            dic["confirm_pswd"] = confirm
 */
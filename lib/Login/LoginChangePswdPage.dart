import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_720yun/Login/LoginCheckPhonePage.dart';
import 'package:flutter_720yun/Login/RegisterPage.dart';
import 'package:flutter_720yun/UserInfo/WebviewPage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'dart:ui';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/NetWorking/Encryption.dart';
import 'package:provider/provider.dart';
import '../Common/CommonPage.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';



class LoginChangePswdPage extends StatefulWidget {

  String phoneStr;

  LoginChangePswdPage(this.phoneStr);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginChangePswdState();
  }
}

class LoginChangePswdState extends State<LoginChangePswdPage> {

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _userPswdController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _username = '';//用户名
  var _password = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _proSelect = true;
  var _deviceName = '';
  late UserInfoModel _userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNodeUserName.addListener(() {
      _focusNodeListener();
    });

    _focusNodePassWord.addListener(() {
      _focusNodeListener();
    });

    _userNameController.addListener(() {
      print(_userNameController.text);
      _username = _userNameController.text;
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      }else{
        _isShowClear = false;
      }
      setState(() {

      });
    });

    _userPswdController.addListener(() {
      _password = _userPswdController.text;
      setState(() {

      });
    });

  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    _userPswdController.dispose();
    super.dispose();
  }

  Future<Null> changeNetWorking() async {
    _focusNodeUserName.unfocus();
    _focusNodePassWord.unfocus();
    EasyLoading.show(status: '正在修改...');
    if (_username.length == 0 || _username.length < 6)  {
      EasyLoading.showToast('请输入6位或6位以上新密码');
      return;
    }
    if (_username != _password)  {
      EasyLoading.showToast('确认密码与密码不一致');
      return;
    }
    final url = NetWorkingConfig.path(NetPath.loginUpdatePswd);
    /*
    parameter["phoneNum"] = phone
            parameter["email"] = email
            parameter["password"] = pswd
            parameter["confirm_password"] = confirm
     */
    var dic = {
      "password":generateMD5(_username),
      "confirm_password":generateMD5(_password),
    };
    if (ToolConfig.isEmail(widget.phoneStr)) {
      dic['email'] = widget.phoneStr;
    }else{
      dic['phoneNum'] = widget.phoneStr;
    }
    print(dic);
    await NetWorking.post(url,dic, (data) {
      EasyLoading.dismiss();
      if (data["code"] == 200) {
        var model = data["data"];
        var userModel = UserInfoModel.fromJson(model);
        _userModel = userModel;
        Provider.of<UserProviderModel>(context, listen: false).user = _userModel;
        /// 修改成功
        EasyLoading.showToast('修改成功');
        Future.delayed(Duration(seconds: 1) ,(){
          // 返回到上上个页面
          Navigator.of(context)..pop()..pop();
        });
      }else{
        /// 修改失败
        EasyLoading.showToast(data['message'] ?? '修改失败');
      }
    }, (error) {
      EasyLoading.dismiss();
    });
  }



  //   // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    Widget logoWidget = new Container(
      alignment: Alignment.topCenter,
      child: Text("真命天喵",style: TextStyle(fontSize: 28,color: ColorsUtil.fromEnmu(ColorEnum.system),fontWeight: FontWeight.w700,fontStyle: FontStyle.italic)),
    );


    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: new Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
                focusNode: _focusNodeUserName,
                controller: _userNameController,
              cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
              keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "请输入6位或6位以上新密码",
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  prefixIcon: Icon(Icons.phone_android_outlined,color: ColorsUtil.fromEnmu(ColorEnum.mark)), //Image.asset('assets/icons/icon_login_phone.png')
                  //尾部添加清除按钮
                  suffixIcon:(_isShowClear)
                      ? IconButton(
                    icon: Icon(Icons.clear,size: 20),
                    onPressed: (){
                      // 清空输入框内容
                      _userNameController.clear();
                    },
                  )
                      : null ,
                ),
                onSaved: (name) {
                  _username = name ?? "";
                },

            ), TextFormField(
              obscureText: !_isShowPwd,
              focusNode: _focusNodePassWord,
              controller: _userPswdController,
              cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "请再次输入新密码",
                hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                ),
                prefixIcon: Icon(Icons.lock_outline,color: ColorsUtil.fromEnmu(ColorEnum.mark),),
                suffixIcon: _password.length == 0 ? null : ((_isShowPwd) ? IconButton(icon: Icon(Icons.visibility_off_outlined,size: 20),
                    onPressed: (){
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    }
                ): IconButton(icon: Icon(Icons.visibility_outlined,size: 20),
                  onPressed: () {
                    setState(() {
                      _isShowPwd = !_isShowPwd;
                    });
                  },
                )),
              ),
              onSaved: (name) {
                _password = name ?? "";
              },
              // 校验用户名（不能为空）
              validator: (v) {
                if (v != null) {
                  return v.trim().isNotEmpty ? null : "请输入6位或6位以上密码";
                }
                return null;
              },
            )
          ],
        ),
      ),
    );

    Widget loginBtn = new Container(
      height: 45,
      decoration: BoxDecoration(
        color: ColorsUtil.fromEnmu(ColorEnum.system),
      ),
      child: TextButton(
        child: Text("确定",style: TextStyle(color: Colors.white,fontSize: FontUtil.fs(FontSize.title)),),
        onPressed: changeNetWorking,
      ),
      margin: EdgeInsets.only(left: 20,right: 20),
    );



    return new Scaffold(
        appBar: new AppBar(
          title: Text('登录'),
          elevation: 0.5,
        ),
        body: new GestureDetector(
          onTap: () {
            _focusNodeUserName.unfocus();
            _focusNodePassWord.unfocus();
          },
          child: new ListView(
            children: <Widget>[
              new SizedBox(height: 40),
              logoWidget,
              new SizedBox(height: 40),
              inputTextArea,
              new SizedBox(height: 30),
              loginBtn,
              new SizedBox(height: 30,),
            ],
          ),
        )
    );
  }
}















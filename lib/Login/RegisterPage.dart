import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/UserInfo/EditUserInfoPage.dart';
import 'package:flutter_720yun/UserInfo/WebviewPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../model/UserModel.dart';
import '../NetWorking/NetWorking.dart';
import '../NetWorking/Encryption.dart';
import '../Common/CommonPage.dart';
import '../tabbar.dart';

class RegisterWidget extends StatefulWidget {
  final String phone;
  RegisterWidget({this.phone});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterState();
  }
}

class _RegisterState extends State<RegisterWidget> {

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();
  FocusNode _focusNodeConfirm  = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController;
  TextEditingController _userPswdController = new TextEditingController();
  TextEditingController _confirmController  = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = '';//密码
  var _username = '';//用户名
  var _confirm  = '';// 确认密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _isShowConfirm = false;
  var _proSelect = true;
  UserInfoModel _userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameController = new TextEditingController(text: widget.phone);
    startSet();

  }

  void startSet() {
    _focusNodeUserName.addListener(() {
      _focusNodeListener();
    });

    _focusNodePassWord.addListener(() {
      _focusNodeListener();
    });

    _focusNodeConfirm.addListener(() {
      _focusNodeListener();
    });

    _userNameController.addListener(() {
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

    _confirmController.addListener(() {
      _confirm = _confirmController.text;
      setState(() {

      });
    });
  }



  Future<Null> loginNetWorking() async {
    _focusNodeUserName.unfocus();
    _focusNodePassWord.unfocus();
    _focusNodeConfirm.unfocus();
    EasyLoading.show(status: '正在注册...');
    if (!_proSelect) {
      EasyLoading.showToast('请阅读并勾选用户协议与隐私协议');
      return ;
    }
    if (_username.length == 0)  {
      EasyLoading.showToast('请输入手机号码或邮箱');
      return;
    }
    if (_password.length == 0 || _password.length < 6)  {
      EasyLoading.showToast('请输入6位或6位以上密码');
      return;
    }
    if (_confirm != _password)  {
      EasyLoading.showToast('确认密码与密码不一致');
      return;
    }
    String deviceInfo = await ToolConfig.deviceName();
    final url = NetWorkingConfig.path(NetPath.register);
    /*
                parameter["phoneNum"] = phone
            parameter["email"] = email
            parameter["password"] = pswd
            parameter["confirm_password"] = confrim
            parameter["phone_type"] = PhoneType.getDeviceModel()

     */
    var dic = {
      "password":generateMD5(_password),
      "confirm_password": generateMD5(_confirm),
      "phone_type":deviceInfo
    };
    if (ToolConfig.isEmail(_username)) {
      dic['email'] = _username;
    }else{
      dic['phoneNum'] = _username;
    }
    await NetWorking.post(url, (data) {
      EasyLoading.dismiss();
      if (data["code"] == 200) {
        var model = data["data"];
        var userModel = UserInfoModel.fromJson(model);
        // jpush.setAlias('${userModel.id}').then((map) { });
        _userModel = userModel;
        Provider.of<UserProviderModel>(context, listen: false).user = _userModel;
        /// 注册成功
        EasyLoading.showToast("注册成功");
        Future.delayed(Duration(seconds: 1),(){
          // 退出到根目录
          // Navigator.of(context).popUntil((route) => route.isFirst);
          // Navigator.of(context).pushAndRemoveUntil(newRoute, (route) => false)

          Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => new EditUserWidget(from: 'register',)),
                (route) => route.isFirst,
          );
        });
      }else{
        EasyLoading.showToast(data['message'] ?? '登录失败');
      }
    }, (error) {
      /// 登录失败
      EasyLoading.showToast('登录失败');
    },params: dic);

  }

  //   // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    Widget logoWidget = new Container(
      alignment: Alignment.topCenter,
      child: Text("真命天喵",style: TextStyle(fontSize: 28,color: ColorsUtil.fromEnmu(ColorEnum.system),fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),),
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
                enabled: widget.phone != null ? false : true,
                focusNode: _focusNodeUserName,
                controller: _userNameController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "请输入手机号码或邮箱",
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  prefixIcon: Icon(Icons.phone_android_outlined,color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  //尾部添加清除按钮
                  suffixIcon:(_isShowClear)
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: (){
                      // 清空输入框内容
                      _userNameController.clear();
                    },
                  )
                      : null ,
                ),
                onSaved: (String name) {
                  _username = name;
                },
                // 校验用户名（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty ? null : "请输入正确的用户名";
                }
            ), TextFormField(
              obscureText: !_isShowPwd,
              focusNode: _focusNodePassWord,
              controller: _userPswdController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "请输入6位或6位以上密码",
                hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                ),
                prefixIcon: Icon(Icons.lock_outline,color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                suffixIcon: _password.length == 0 ? null : ((_isShowPwd) ? IconButton(icon: Icon(Icons.visibility_off_outlined,size: 20,),
                    onPressed: (){
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    }
                ): IconButton(icon: Icon(Icons.visibility_outlined,size: 20,),
                    onPressed: (){
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    }
                )),
              ),
              onSaved: (String name) {
                _password = name;
              },
              // 校验用户名（不能为空）
              validator: (v) {
                return v.trim().isNotEmpty ? null : "请输入6位或6位以上密码";
              },
            ),TextFormField(
                obscureText: !_isShowConfirm,
                focusNode: _focusNodeConfirm,
                controller: _confirmController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "请再次输入密码",
                  hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                  ),
                  prefixIcon: Icon(Icons.lock_outline,color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  //尾部添加清除按钮
                  suffixIcon:_confirm.length == 0 ? null : ((_isShowPwd) ? IconButton(icon: Icon(Icons.visibility_off_outlined,size: 20,),
                      onPressed: (){
                        setState(() {
                          _isShowConfirm = !_isShowConfirm;
                        });
                      }
                  ): IconButton(icon: Icon(Icons.visibility_outlined,size: 20,),
                      onPressed: (){
                        setState(() {
                          _isShowConfirm = !_isShowConfirm;
                        });
                      }
                  )),
                ),
                onSaved: (String name) {
                  _username = name;
                },
                // 校验用户名（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty ? null : "请输入正确的";
                }
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
        child: Text("注册并登录",style: TextStyle(color: Colors.white,fontSize: FontUtil.fs(FontSize.title)),),
        onPressed: loginNetWorking,
      ),
      margin: EdgeInsets.only(left: 20,right: 20),
    );

    Widget protocalArea = new Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: _proSelect ? Icon(Icons.check_box,color: ColorsUtil.fromEnmu(ColorEnum.system),) : Icon(Icons.check_box_outline_blank,color: ColorsUtil.fromEnmu(ColorEnum.system),),
              iconSize:20,
              onPressed: (){
                setState(() {
                  _proSelect = !_proSelect;
                });
              },
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "阅读并同意",
                    style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                  ),
                  TextSpan(
                    text: "用户协议、",
                    style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.system)),
                    // 设置点击事件
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return WebViewPage(url: NetWorkingConfig.path(NetPath.userAgreen));
                        }));
                      },
                  ),
                  TextSpan(
                    text: "隐私协议",
                    style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.system)),
                    // 设置点击事件
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return WebViewPage(url: NetWorkingConfig.path(NetPath.pravicy));
                        }));
                      },
                  ),
                ],
              ),
            ),
          ],
        )
    );




    return new Scaffold(
        appBar: new AppBar(
            title: Text('注册'),
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
              protocalArea,
            ],
          ),
        )
    );
  }
}
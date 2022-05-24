import 'dart:async';

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

import '../tabbar.dart';

enum CodeFromType {
  register,
  findPswd,
  bindPhone,
  checkPhone
}


class CheckCodePage extends StatefulWidget {

  CodeFromType fromType;
  CheckCodePage(this.fromType);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CheckCodeState();
  }
}

class _CheckCodeState extends State<CheckCodePage> {

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userPhoneController = new TextEditingController();
  TextEditingController _userCodeController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _code = '';//验证码
  var _phone = '';//手机号
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _proSelect = true;

  // 倒计时的秒数
  var _timeNum = 61;

  // 倒计时期间还是未获取，timeStatus = false， 未开始倒计时；timeStatus = true, 开始倒计时
  var timeStatus = false;

  ///声明变量
  Timer _timer;

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

    _userPhoneController.addListener(() {
      _phone = _userPhoneController.text;
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userPhoneController.text.length > 0) {
        _isShowClear = true;
      }else{
        _isShowClear = false;
      }
      setState(() {

      });
    });

    _userCodeController.addListener(() {
      _code = _userCodeController.text;
      setState(() {

      });
    });


  }

  // 开始倒计时
  void startTime() {
    ///循环执行
    ///间隔1秒
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      ///定时任务
      _timeNum = _timeNum - 1;
      setState(() {
        if (_timeNum == 0) {
          _timer.cancel();
          timeStatus = false;
          _timeNum = 61;
        }
      });
    });
  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userPhoneController.dispose();
    _userCodeController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<Null> getCodeNetWorking() async {
    _focusNodeUserName.unfocus();
    _focusNodePassWord.unfocus();
    EasyLoading.show(status: '正在登录...');
    if (!_proSelect) {
      EasyLoading.showToast('请阅读并勾选用户协议与隐私协议');
      return ;
    }
    if (_phone.length == 0)  {
      EasyLoading.showToast('请输入手机号');
      return;
    }
    if (_code.length == 0)  {
      EasyLoading.showToast('请输入验证码');
      return;
    }
    String deviceInfo = await ToolConfig.deviceName();
    final url = NetWorkingConfig.path(NetPath.getVerificationCode);
    /*
    parameter["phoneNum"] = phone
            parameter["email"] = email
            parameter["password"] = pswd
            parameter["phone_type"] = PhoneType.getDeviceModel()
     */
    var dic = {
      "code":_code,
      "phone": _phone
    };
    await NetWorking.post(url, (data) {
      EasyLoading.dismiss();
      if (data["code"] == 200) {
        EasyLoading.showToast("获取成功");
      }else{
        /// 登录失败
        EasyLoading.showToast(data['message'] ?? '获取失败');
      }
    }, (error) {
      EasyLoading.dismiss();
    },params: dic);
  }

  // Future<String> getDeviceInfo() async{
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //   Printer.printMapJsonLog(androidInfo.model);
  //   return androidInfo.model.toString();
  // }

  Future<Null> loginNetWorking() async {

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

    String pageTitle = '';
    if (widget.fromType == CodeFromType.register){
      pageTitle = '获取验证码';
    }else if (widget.fromType == CodeFromType.findPswd){
      pageTitle = '获取验证码';
    }else if (widget.fromType == CodeFromType.bindPhone) {
      pageTitle = '绑定手机号';
    }else if (widget.fromType == CodeFromType.checkPhone) {
      pageTitle = '校验手机号';
    }

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
                controller: _userPhoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "请输入手机号码",
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
                      _userPhoneController.clear();
                    },
                  )
                      : null ,
                ),
                onSaved: (String name) {
                  _phone = name;
                },
                // 校验用户名（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty ? null : "请输入正确手机号";
                }
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                TextFormField(
                  focusNode: _focusNodePassWord,
                  controller: _userCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "请输入验证码",
                    hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                    ),
                    prefixIcon: Icon(Icons.lock_outline,color: ColorsUtil.fromEnmu(ColorEnum.mark),),
                  ),
                  onSaved: (String name) {
                    _code = name;
                  },
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : "请输入6位或6位以上密码";
                  },
                ),
                Positioned(
                    right: 0,
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 32,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: new Border.all(width: 1, color: timeStatus == false ? ColorsUtil.fromEnmu(ColorEnum.system) : ColorsUtil.fromEnmu(ColorEnum.desc)),
                        ),
                        child: Text(timeStatus == false ? '获取验证码' : _timeNum.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color:  timeStatus == false ? ColorsUtil.fromEnmu(ColorEnum.system) : ColorsUtil.fromEnmu(ColorEnum.desc)),),
                      ),
                      onTap: () {
                        if (timeStatus == true) {
                          return;
                        }
                        timeStatus = true;
                        startTime();
                      },
                    )
                )
              ],
            )

            // Container(
            //   color: Colors.blue,
            //   height: 60,
            //   child: Row(
            //     children: [
            //       ,
            //       GestureDetector(
            //         child: Container(
            //           decoration: new BoxDecoration(
            //             borderRadius: BorderRadius.all(Radius.circular(5)),
            //             color: ColorsUtil.fromEnmu(ColorEnum.system),
            //           ),
            //           child: Text('获取验证码'),
            //         ),
            //       )
            //     ],
            //   ),
            // )
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
        child: Text(pageTitle,style: TextStyle(color: Colors.white,fontSize: FontUtil.fs(FontSize.title)),),
        onPressed: loginNetWorking,
      ),
      margin: EdgeInsets.only(left: 20,right: 20),
    );


    Widget registerArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TextButton(
            child: Text('忘记密码？',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.system)),),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return LoginCheckPhonePage();
              }));
            },
          ),
          Expanded(
            flex: 1,
            child: Container(

            ),
          ),
          TextButton(
            child: Text('新用户注册',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.system)),),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context){
                    return RegisterWidget();
                  })
              );
            },
          )
        ],
      ),
    );

    Widget protocalArea = new Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: _proSelect ?
              Icon(Icons.check_box,color: ColorsUtil.fromEnmu(ColorEnum.system),) :
              Icon(Icons.check_box_outline_blank,color: ColorsUtil.fromEnmu(ColorEnum.system),),
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
          title: Text(pageTitle),
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
              new SizedBox(height: 1),
              // registerArea,
              // new SizedBox(height: 30,),
              // protocalArea,
              // new SizedBox(height: 30,),
            ],
          ),
        )
    );
  }
}















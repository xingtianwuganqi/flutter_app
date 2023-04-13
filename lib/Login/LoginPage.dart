import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_720yun/Login/CheckCodePage.dart';
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



class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends State<LoginWidget> {

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _userPswdController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = '';//用户名
  var _username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _proSelect = true;
  var _deviceName = '';
  UserInfoModel _userModel;

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

  Future<Null> loginNetWorking() async {
    _focusNodeUserName.unfocus();
    _focusNodePassWord.unfocus();
    EasyLoading.show(status: '正在登录...');
    if (!_proSelect) {
      EasyLoading.showToast('请阅读并勾选用户协议与隐私协议');
      return ;
    }
    if (_username.length == 0)  {
      EasyLoading.showToast('请输入手机号');
      return;
    }
    if (_password.length == 0 || _password.length < 6)  {
      EasyLoading.showToast('请输入6位或6位以上密码');
      return;
    }
    String deviceInfo = await ToolConfig.deviceName();
    final url = NetWorkingConfig.path(NetPath.login);
    /*
    parameter["phoneNum"] = phone
            parameter["email"] = email
            parameter["password"] = pswd
            parameter["phone_type"] = PhoneType.getDeviceModel()
     */
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["password"] = generateMD5(_password);
    dic["phone_type"] = "android";
    if (ToolConfig.isEmail(_username)) {
      EasyLoading.showToast('暂不支持邮箱登录');
      return;
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
        /// 登录成功
        EasyLoading.showToast("登录成功");
        Future.delayed(Duration(seconds: 1),(){
          Navigator.pop(context);
        });
      }else{
        /// 登录失败
        EasyLoading.showToast(data['message'] ?? '登录失败');
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
                //尾部添加清除按钮import 'package:flutter/gestures.dart';
                // import 'package:flutter/material.dart';
                // import 'package:flutter/services.dart';
                // import 'package:flutter_720yun/Login/LoginCheckPhonePage.dart';
                // import 'package:flutter_720yun/Login/RegisterPage.dart';
                // import 'package:flutter_720yun/UserInfo/WebviewPage.dart';
                // import 'package:flutter_720yun/model/UserModel.dart';
                // import 'package:flutter_easyloading/flutter_easyloading.dart';
                // import 'package:flutter_printer/flutter_printer.dart';
                // import 'dart:ui';
                // import 'package:flutter_720yun/NetWorking/NetWorking.dart';
                // import 'package:flutter_720yun/NetWorking/Encryption.dart';
                // import 'package:provider/provider.dart';
                // import '../Common/CommonPage.dart';
                // import 'package:device_info/device_info.dart';
                // import 'dart:io';
                //
                // import '../tabbar.dart';
                //
                //
                //
                // class LoginWidget extends StatefulWidget {
                //   @override
                //   State<StatefulWidget> createState() {
                //     // TODO: implement createState
                //     return _LoginWidgetState();
                //   }
                // }
                //
                // class _LoginWidgetState extends State<LoginWidget> {
                //
                //   //焦点
                //   FocusNode _focusNodeUserName = new FocusNode();
                //   FocusNode _focusNodePassWord = new FocusNode();
                //
                //   //用户名输入框控制器，此控制器可以监听用户名输入框操作
                //   TextEditingController _userNameController = new TextEditingController();
                //   TextEditingController _userPswdController = new TextEditingController();
                //
                //   //表单状态
                //   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
                //
                //   var _password = '';//用户名
                //   var _username = '';//密码
                //   var _isShowPwd = false;//是否显示密码
                //   var _isShowClear = false;//是否显示输入框尾部的清除按钮
                //   var _proSelect = true;
                //   var _deviceName = '';
                //   UserInfoModel _userModel;
                //
                //   @override
                //   void initState() {
                //     // TODO: implement initState
                //     super.initState();
                //     _focusNodeUserName.addListener(() {
                //       _focusNodeListener();
                //     });
                //
                //     _focusNodePassWord.addListener(() {
                //       _focusNodeListener();
                //     });
                //
                //     _userNameController.addListener(() {
                //       _username = _userNameController.text;
                //       // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
                //       if (_userNameController.text.length > 0) {
                //         _isShowClear = true;
                //       }else{
                //         _isShowClear = false;
                //       }
                //       setState(() {
                //
                //       });
                //     });
                //
                //     _userPswdController.addListener(() {
                //       _password = _userPswdController.text;
                //       setState(() {
                //
                //       });
                //     });
                //
                //   }
                //
                //   void dispose() {
                //     // TODO: implement dispose
                //     // 移除焦点监听
                //     _focusNodeUserName.removeListener(_focusNodeListener);
                //     _focusNodePassWord.removeListener(_focusNodeListener);
                //     _userNameController.dispose();
                //     _userPswdController.dispose();
                //     super.dispose();
                //   }
                //
                //   Future<Null> loginNetWorking() async {
                //     _focusNodeUserName.unfocus();
                //     _focusNodePassWord.unfocus();
                //     EasyLoading.show(status: '正在登录...');
                //     if (!_proSelect) {
                //       EasyLoading.showToast('请阅读并勾选用户协议与隐私协议');
                //       return ;
                //     }
                //     if (_username.length == 0)  {
                //       EasyLoading.showToast('请输入手机号');
                //       return;
                //     }
                //     if (_password.length == 0 || _password.length < 6)  {
                //       EasyLoading.showToast('请输入6位或6位以上密码');
                //       return;
                //     }
                //     String deviceInfo = await ToolConfig.deviceName();
                //     final url = NetWorkingConfig.path(NetPath.login);
                //     /*
                //     parameter["phoneNum"] = phone
                //             parameter["email"] = email
                //             parameter["password"] = pswd
                //             parameter["phone_type"] = PhoneType.getDeviceModel()
                //      */
                //     var dic = {
                //       "password":generateMD5(_password),
                //       "phone_type": deviceInfo
                //     };
                //     if (ToolConfig.isEmail(_username)) {
                //       dic['email'] = _username;
                //     }else{
                //       dic['phoneNum'] = _username;
                //     }
                //     await NetWorking.post(url, (data) {
                //       EasyLoading.dismiss();
                //       if (data["code"] == 200) {
                //         var model = data["data"];
                //         var userModel = UserInfoModel.fromJson(model);
                //         // jpush.setAlias('${userModel.id}').then((map) { });
                //         _userModel = userModel;
                //         Provider.of<UserProviderModel>(context, listen: false).user = _userModel;
                //         /// 登录成功
                //         EasyLoading.showToast("登录成功");
                //         Future.delayed(Duration(seconds: 1),(){
                //           Navigator.pop(context);
                //         });
                //       }else{
                //         /// 登录失败
                //         EasyLoading.showToast(data['message'] ?? '登录失败');
                //       }
                //     }, (error) {
                //       EasyLoading.dismiss();
                //     },params: dic);
                //   }
                //
                //   // Future<String> getDeviceInfo() async{
                //   //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                //   //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                //   //   Printer.printMapJsonLog(androidInfo.model);
                //   //   return androidInfo.model.toString();
                //   // }
                //
                //
                //
                //   //   // 监听焦点
                //   Future<Null> _focusNodeListener() async{
                //     if(_focusNodeUserName.hasFocus){
                //       // 取消密码框的焦点状态
                //       _focusNodePassWord.unfocus();
                //     }
                //     if (_focusNodePassWord.hasFocus) {
                //       // 取消用户名框焦点状态
                //       _focusNodeUserName.unfocus();
                //     }
                //   }
                //
                //   @override
                //   Widget build(BuildContext context) {
                //
                //     // TODO: implement build
                //     Widget logoWidget = new Container(
                //       alignment: Alignment.topCenter,
                //       child: Text("真命天喵",style: TextStyle(fontSize: 28,color: ColorsUtil.fromEnmu(ColorEnum.system),fontWeight: FontWeight.w700,fontStyle: FontStyle.italic)),
                //     );
                //
                //
                //     Widget inputTextArea = new Container(
                //       margin: EdgeInsets.only(left: 20, right: 20),
                //       decoration: new BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(8)),
                //         color: Colors.white,
                //       ),
                //       child: new Form(
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: <Widget>[
                //             TextFormField(
                //               focusNode: _focusNodeUserName,
                //               controller: _userNameController,
                //               keyboardType: TextInputType.emailAddress,
                //               decoration: InputDecoration(
                //                 hintText: "请输入手机号码",
                //                 hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                //                 enabledBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                //                 ),
                //                 focusedBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                //                 ),
                //                 prefixIcon: Icon(Icons.phone_android_outlined,color: ColorsUtil.fromEnmu(ColorEnum.mark)), //Image.asset('assets/icons/icon_login_phone.png')
                //                 //尾部添加清除按钮
                //                 suffixIcon:(_isShowClear)
                //                     ? IconButton(
                //                   icon: Icon(Icons.clear,size: 20),
                //                   onPressed: (){
                //                     // 清空输入框内容
                //                     _userNameController.clear();
                //                   },
                //                 )
                //                     : null ,
                //               ),
                //               onSaved: (String name) {
                //                 _username = name;
                //               },
                //             // 校验用户名（不能为空）
                //               validator: (v) {
                //               return v.trim().isNotEmpty ? null : "请输入正确的用户名";
                //               }
                //             ), TextFormField(
                //               obscureText: !_isShowPwd,
                //               focusNode: _focusNodePassWord,
                //               controller: _userPswdController,
                //               keyboardType: TextInputType.emailAddress,
                //               decoration: InputDecoration(
                //                 hintText: "请输入6位或6位以上密码",
                //                 hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                //                 enabledBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                //                 ),
                //                 focusedBorder: UnderlineInputBorder(
                //                   borderSide: BorderSide(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),width: 0.5),
                //                 ),
                //                 prefixIcon: Icon(Icons.lock_outline,color: ColorsUtil.fromEnmu(ColorEnum.mark),),
                //                 suffixIcon: _password.length == 0 ? null : ((_isShowPwd) ? IconButton(icon: Icon(Icons.visibility_off_outlined,size: 20),
                //                   onPressed: (){
                //                     setState(() {
                //                       _isShowPwd = !_isShowPwd;
                //                     });
                //                   }
                //                 ): IconButton(icon: Icon(Icons.visibility_outlined,size: 20),
                //                   onPressed: () {
                //                     setState(() {
                //                       _isShowPwd = !_isShowPwd;
                //                     });
                //                   },
                //                 )),
                //               ),
                //               onSaved: (String name) {
                //                 _password = name;
                //               },
                //           // 校验用户名（不能为空）
                //               validator: (v) {
                //                 return v.trim().isNotEmpty ? null : "请输入6位或6位以上密码";
                //               },
                //             )
                //           ],
                //         ),
                //       ),
                //     );
                //
                //     Widget loginBtn = new Container(
                //       height: 45,
                //       decoration: BoxDecoration(
                //         color: ColorsUtil.fromEnmu(ColorEnum.system),
                //       ),
                //       child: TextButton(
                //         child: Text("登录",style: TextStyle(color: Colors.white,fontSize: FontUtil.fs(FontSize.title)),),
                //         onPressed: loginNetWorking,
                //       ),
                //       margin: EdgeInsets.only(left: 20,right: 20),
                //     );
                //
                //
                //     Widget registerArea = new Container(
                //       margin: EdgeInsets.only(left: 20,right: 20),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.max,
                //         children: <Widget>[
                //           TextButton(
                //             child: Text('忘记密码？',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.system)),),
                //             onPressed: () {
                //               Navigator.push(context, MaterialPageRoute(builder: (context){
                //                 return LoginCheckPhonePage();
                //               }));
                //             },
                //           ),
                //           Expanded(
                //             flex: 1,
                //             child: Container(
                //
                //             ),
                //           ),
                //           TextButton(
                //             child: Text('新用户注册',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.system)),),
                //             onPressed: () {
                //               Navigator.push(context,
                //                   new MaterialPageRoute(builder: (context){
                //                     return RegisterWidget();
                //                   })
                //               );
                //             },
                //           )
                //         ],
                //       ),
                //     );
                //
                //     Widget protocalArea = new Container(
                //       alignment: Alignment.center,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           IconButton(
                //             icon: _proSelect ?
                //             Icon(Icons.check_box,color: ColorsUtil.fromEnmu(ColorEnum.system),) :
                //             Icon(Icons.check_box_outline_blank,color: ColorsUtil.fromEnmu(ColorEnum.system),),
                //             iconSize:20,
                //             onPressed: (){
                //               setState(() {
                //                 _proSelect = !_proSelect;
                //               });
                //             },
                //           ),
                //           Text.rich(
                //             TextSpan(
                //               children: [
                //                 TextSpan(
                //                   text: "阅读并同意",
                //                   style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                //                 ),
                //                 TextSpan(
                //                   text: "用户协议、",
                //                   style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.system)),
                //           // 设置点击事件
                //                   recognizer: TapGestureRecognizer()
                //                   ..onTap = () {
                //                     Navigator.push(context, MaterialPageRoute(builder: (context){
                //                       return WebViewPage(url: NetWorkingConfig.path(NetPath.userAgreen));
                //                     }));
                //                     },
                //                 ),
                //                 TextSpan(
                //                   text: "隐私协议",
                //                   style: TextStyle(fontSize: FontUtil.fs(FontSize.desc), color: ColorsUtil.fromEnmu(ColorEnum.system)),
                //                   // 设置点击事件
                //                   recognizer: TapGestureRecognizer()
                //                     ..onTap = () {
                //                       Navigator.push(context, MaterialPageRoute(builder: (context){
                //                         return WebViewPage(url: NetWorkingConfig.path(NetPath.pravicy));
                //                       }));
                //                     },
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       )
                //     );
                //
                //
                //
                //
                //     return new Scaffold(
                //         appBar: new AppBar(
                //             title: Text('登录'),
                //           elevation: 0.5,
                //         ),
                //         body: new GestureDetector(
                //           onTap: () {
                //             _focusNodeUserName.unfocus();
                //             _focusNodePassWord.unfocus();
                //           },
                //           child: new ListView(
                //             children: <Widget>[
                //               new SizedBox(height: 40),
                //               logoWidget,
                //               new SizedBox(height: 40),
                //               inputTextArea,
                //               new SizedBox(height: 30),
                //               loginBtn,
                //               new SizedBox(height: 1),
                //               registerArea,
                //               new SizedBox(height: 30,),
                //               protocalArea,
                //               new SizedBox(height: 30,),
                //             ],
                //           ),
                //         )
                //     );
                //   }
                // }
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
              cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
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
              onSaved: (String name) {
                _password = name;
              },
          // 校验用户名（不能为空）
              validator: (v) {
                return v.trim().isNotEmpty ? null : "请输入6位或6位以上密码";
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
        child: Text("登录",style: TextStyle(color: Colors.white,fontSize: FontUtil.fs(FontSize.title)),),
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
                return CheckCodePage(CodeFromType.findPswd);
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
                    return CheckCodePage(CodeFromType.register);
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
                        String filePath = 'assets/files/privacyPolicy.html';
                        return WebViewPage(filePath: filePath);
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
              new SizedBox(height: 1),
              registerArea,
              new SizedBox(height: 30,),
              protocalArea,
              new SizedBox(height: 30,),
            ],
          ),
        )
    );
  }
}















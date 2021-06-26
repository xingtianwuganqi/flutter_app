import 'package:flutter/material.dart';
import 'package:flutter_720yun/Login/LoginChangePswdPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../Common/CommonPage.dart';
class LoginCheckPhonePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginCheckPhoneState();
  }
}

class LoginCheckPhoneState extends State<LoginCheckPhonePage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  var _username = '';// 用户名
  var _isShowClear = false;//是否显示输入框尾部的清除按钮

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNodeUserName.addListener(() {
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

  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  Future<Null> confirmPhoneNetWorking() async {
    _focusNodeUserName.unfocus();
    EasyLoading.show(status: '环境检测中...');
    if (_username.length == 0)  {
      EasyLoading.showToast('请输入手机号码或邮箱');
      return;
    }
    String deviceInfo = await ToolConfig.deviceName();
    final url = NetWorkingConfig.path(NetPath.confirmPhoneInfo);
    /*
    parameter["phone_or_email"] = contact
            parameter["phone_type"] = PhoneType.getDeviceModel()
     */
    final dic = {
      "phone_or_email": _username,
      "phone_type": deviceInfo
    };

    await NetWorking.post(url, (data) {
      print(data);
      EasyLoading.dismiss();
      if (data["code"] == 200) {
        /// 验证成功
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return LoginChangePswdPage(phoneStr: _username);
        }));
      }else{
        /// 验证失败
        EasyLoading.showToast('验证失败');
      }
    }, (error) {
      EasyLoading.showToast('验证失败');
    },params: dic);


  }

  //   // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      // _focusNodePassWord.unfocus();
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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "请输入手机号码或邮箱",
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
        child: Text("确认",style: TextStyle(color: Colors.white,fontSize: FontUtil.fs(FontSize.title)),),
        onPressed: (){
          confirmPhoneNetWorking();
        },
      ),
      margin: EdgeInsets.only(left: 20,right: 20),
    );


    return new Scaffold(
        appBar: new AppBar(
          title: Text('找回密码'),
          elevation: 0.5,
        ),
        body: new GestureDetector(
          onTap: () {
            _focusNodeUserName.unfocus();
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
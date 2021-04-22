import 'package:flutter/material.dart';
import '../model/UserModel.dart';
import '../NetWorking/NetWorking.dart';
import '../NetWorking/Encryption.dart';

class RegisterWidget extends StatefulWidget {
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
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _userPswdController = new TextEditingController();
  TextEditingController _confirmController  = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = '';//密码
  var _username = '';//用户名
  var _confirm  = '';// 确认密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _proSelect = false;
  UserInfoModel _userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loginNetWorking();

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
      print(_userPswdController.text);
      _password = _userPswdController.text;

    });

    _confirmController.addListener(() {
      print(_confirmController.text);
      _confirm = _confirmController.text;
    });
  }



  Future<Null> loginNetWorking() async {
    print(_username);
    print(_password);
    if (_username.length == 0)  {
      print('========');
      return;
    }
    if (_password.length == 0)  {
      print('--------');
      return;
    }
    final url = "https://test.rxswift.cn/api/v1/login/";
    final dic = {"phoneNum": _username,"password":generateMD5(_password),"phone_type":"iPhone 7"};
    print(dic);
    var data = await NetWorking.post(url,params: dic);
    print(data);
    if (data["code"] == 200) {
      var model = data["data"];
      var userModel = UserInfoModel.fromJson(model);
      print(model);
      _userModel = userModel;
      print(_userModel.phone_number);
    }
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
      child: Text("喜乐排行",style: TextStyle(fontSize: 28,color: Colors.blue),),
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "请输入用户名",
                  prefixIcon: Icon(Icons.person),
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
              focusNode: _focusNodePassWord,
              controller: _userPswdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.person),
                suffixIcon: (_isShowPwd) ? IconButton(icon: Icon(Icons.panorama_fish_eye),
                    onPressed: (){
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    }
                ): null,
              ),
              onSaved: (String name) {
                _password = name;
              },
              // 校验用户名（不能为空）
              validator: (v) {
                return v.trim().isNotEmpty ? null : "请输入6位或6位以上密码";
              },
            ),TextFormField(
                focusNode: _focusNodeConfirm,
                controller: _confirmController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "请再次输入密码",
                  prefixIcon: Icon(Icons.person),
                  //尾部添加清除按钮
                  suffixIcon:(_isShowClear)
                      ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: (){
                      // 清空输入框内容
                      setState(() {
                        // _isShowPwd = !_isShowPwd;
                      });
                    },
                  )
                      : null ,
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
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: TextButton(
        child: Text("注册并登录",style: TextStyle(color: Colors.white),),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
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
              icon: _proSelect ? Icon(Icons.check_box) : Icon(Icons.check_box_outline_blank),
              iconSize:20,
              onPressed: (){
                setState(() {
                  _proSelect = !_proSelect;
                });
              },
            ),
            Text('阅读并同意用户协议、隐私协议',
              style: TextStyle(fontSize: 12,color: Colors.blue),
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
              new SizedBox(height: 60),
              logoWidget,
              new SizedBox(height: 60),
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
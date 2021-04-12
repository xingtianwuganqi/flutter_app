import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_720yun/Login/UserModel.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/NetWorking/Encryption.dart';
// import 'package:flutter_720yun/Login/UserModel.dart'

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

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = '';//用户名
  var _username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var _proSelect = false;
  UserInfoModel _userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginNetWorking();
  }

  Future<Null> loginNetWorking() async {
    final password = generateMD5("123456");
    final url = "http://127.0.0.1:8000/api/v1/login/";
    final dic = {"phoneNum": "13689242201","password":"123456","phone_type":"iPhone 7"};

    var data = await NetWorking.post(url,params: dic);
    print(data);
    if (data["code"] == 200) {
      var model = data["data"];
      var userModel = UserInfoModel.fromJson(model);
      print(model);
      _userModel = userModel;
      print(_userModel.phone_number);
    }

    // setState(() {
    //
    // });
  }
  @override
  Widget build(BuildContext context) {
 
    // TODO: implement build
    Widget logoWidget = new Container(
      alignment: Alignment.topCenter,
      child: Text("真命天喵",style: TextStyle(fontSize: 28,color: Colors.blue),),
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),

              ),
              onSaved: (String name) {
                _username = name;
              },
            ), TextFormField(
              focusNode: _focusNodePassWord,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.person),

              ),
              onSaved: (String name) {
                _username = name;
              },
            )
          ],
        ),
      ),
    );

    Widget loginBtn = new Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: FlatButton(
        textColor: Colors.blue,
        child: Text("登录",style: TextStyle(color: Colors.white),),
        onPressed: loginNetWorking,
      ),
      margin: EdgeInsets.only(left: 20,right: 20),
    );
    
    Widget rescueWidget = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image(image:
                NetworkImage(
                  "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2151136234,3513236673&fm=26&gp=0.jpg"
                ),
                width: 36,
                height: 36
              ),
              Text(
                "昵称",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget registerArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FlatButton(
            child: Text('忘记密码？',style: TextStyle(fontSize: 12,color: Colors.blue),),
          ),
          Expanded(
            flex: 1,
            child: Container(

            ),
          ),
          FlatButton(
            child: Text('新用户注册',style: TextStyle(fontSize: 12,color: Colors.blue),),
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
            title: Text('登录')
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
              new SizedBox(height: 1),
              registerArea,
              new SizedBox(height: 30,),
              protocalArea,
              new SizedBox(height: 30,),
              rescueWidget,
            ],
          ),
        )
    );
  }
}



class ColorsUtil {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  static Color hexColor(int hex,{double alpha = 1}){
    if (alpha < 0){
      alpha = 0;
    }else if (alpha > 1){
      alpha = 1;
    }
    return Color.fromRGBO((hex & 0xFF0000) >> 16 ,
        (hex & 0x00FF00) >> 8,
        (hex & 0x0000FF) >> 0,
        alpha);
  }
}











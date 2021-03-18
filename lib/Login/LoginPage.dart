import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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


  @override
  Widget build(BuildContext context) {
    ////     ScreenUtil.instance = ScreenUtil(width:750,height:1334)..init(context);
    //设置尺寸（填写设计中设备的屏幕尺寸）如果设计基于360dp * 690dp的屏幕
    // ScreenUtil.init(
    //     BoxConstraints(
    //         maxWidth: MediaQuery.of(context).size.width,
    //         maxHeight: MediaQuery.of(context).size.height),
    //     designSize: Size(360, 690),
    //     allowFontScaling: false,
    //     orientation: Orientation.portrait);
    // ScreenUtilInit(
    //   designSize: Size(750,1334),
    //   allowFontScaling:false,
    // );
    // TODO: implement build
    Widget logoWidget = new Container(
      alignment: Alignment.topCenter,
      child: Text("真命天喵"),
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
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),

              ),
              onSaved: (String name) {
                _username = name;
              },
            ), TextFormField(
              focusNode: _focusNodeUserName,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "密码",
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
              new SizedBox(height: 80),
              logoWidget,
              new SizedBox(height: 70),
              inputTextArea,
            ],
          ),
        )
    );
  }
}















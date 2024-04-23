import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/homepage/HomeMainPage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'UserInfo/WebviewPage.dart';
import 'homepage/HomePage.dart';
import 'Message/MessagePage.dart';
import 'package:flutter_720yun/ShowInfo/ShowInfoPage.dart';
import 'package:flutter_720yun/UserInfo/NewUserInfoPage.dart';
// JPush jpush = new JPush();

class tabbar extends StatefulWidget {

  @override
  tabbarState createState() {
    // TODO: implement createState
    return new tabbarState();
  }
}

class tabbarState extends State<tabbar> {
  int _selectedIndex = 0;
  int _unreadNum = 0;
  int _newVersion = 0;
  List<Widget> pages = [];

  TapGestureRecognizer _tgr1 = new TapGestureRecognizer();
  TapGestureRecognizer _tgr2 = new TapGestureRecognizer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _authUnreadMsgNetworking();
    _loadConfig();
    int? userId = 0;
    if (UserManager.instance.userInfo != null) {
      userId = UserManager.instance.userInfo?.id;
    }
    // pages.add(HomePage());
    pages.add(HomeMainPage());
    pages.add(ShowInfoPageWidget());
    pages.add(MessagePage( (value){
      _unreadNum = value;
      setState(() {

      });
    },));
    pages.add(NewUserInfoPage(pageType: MyPageType.myPage, userId: userId));

    // 加载广告
    // setUPAD();
    getUserAgreeStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tgr1.dispose();
    _tgr2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: IndexedStack(index: _selectedIndex,children: pages,),
      bottomNavigationBar: bottomTabbars()
    );
  }

  Widget bottomTabbars() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        // ignore: deprecated_member_use
        BottomNavigationBarItem(icon: _selectedIndex == 0 ?
        Image.asset('assets/icons/icon_tabbar_cat_se.png',width: 25,height: 25) :
        Image.asset('assets/icons/icon_tabbar_cat_un.png', width: 25, height: 25,),
          label: "首页",
        ),
        BottomNavigationBarItem(icon: _selectedIndex == 1 ?
        Image.asset('assets/icons/icon_tabbar_dog_se.png',width: 25,height: 25) :
        Image.asset('assets/icons/icon_tabbar_dog_un.png', width: 25, height: 25,)
            ,label: "秀宠"),

        BottomNavigationBarItem(icon: unreadSelectIcon(_selectedIndex == 2)
            ,label: "消息"),
        BottomNavigationBarItem(icon: newVersionIcon(_selectedIndex == 3),
            label: "我的")
      ],
      currentIndex: _selectedIndex,
      fixedColor: ColorsUtil.fromEnmu(ColorEnum.system),
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: ColorsUtil.hexColor(0x707070),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 25,
      elevation: 2.0,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget unreadSelectIcon(bool isSelect) {
    var num = "";
    if (_unreadNum > 0 && _unreadNum < 99) {
      num = '$_unreadNum';
    }else{
      num = '...';
    }
    return Stack(
      children: [
        isSelect ?
        Image.asset('assets/icons/icon_tabbar_msg_se.png',width: 25,height: 25):
        Image.asset('assets/icons/icon_tabbar_msg_un.png', width: 25, height: 25,),
        Positioned(
          child: _unreadNum > 0 ? Container(
            height: 16,
            width: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.redAccent,
            ),
            child: Text(num,style: TextStyle(color: Colors.white,fontSize: 10),),
          ) : Container(color: Colors.transparent,width: 2,height: 2,),
          top: 0,
          right: 0,
        )
      ],
    );
  }

  Widget newVersionIcon(bool isSelect) {
    var num = "";
    if (_newVersion > 0) {
      num = '$_newVersion';
    }else{
      num = '';
    }
    return Stack(
      children: [
        isSelect ?
        Image.asset('assets/icons/icon_tabbar_mi_se.png',width: 25,height: 25):
        Image.asset('assets/icons/icon_tabbar_mi_un.png', width: 25, height: 25,),
        Positioned(
          child: _newVersion > 0 ? Container(
            height: 16,
            width: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.redAccent,
            ),
            child: Text(num,style: TextStyle(color: Colors.white,fontSize: 10),),
          ) : Container(color: Colors.transparent,width: 2,height: 2,),
          top: 0,
          right: 0,
        )
      ],
    );
  }

  // void jpushConfig() {
  //   jpush.addEventHandler(
  //   // 接收通知回调方法。
  //     onReceiveNotification: (Map<String, dynamic> message) async {
  //       print("flutter onReceiveNotification: $message");
  //     },
  //   // 点击通知回调方法。
  //     onOpenNotification: (Map<String, dynamic> message) async {
  //       print("flutter onOpenNotification: $message");
  //     },
  //   // 接收自定义消息回调方法。
  //     onReceiveMessage: (Map<String, dynamic> message) async {
  //       print("flutter onReceiveMessage: $message");
  //     },
  //   );
  //
  //   jpush.setup(
  //     appKey: "d3d833b59e00683a1cba7323",
  //     channel: "theChannel",
  //     production: false,
  //     debug: false, // 设置是否打印 debug 日志
  //   );
  //
  //   jpush.getRegistrationID().then((rid) { });
  //
  // }

  void _loadConfig() {

    if (NetWorkingConfig.urlConfig == UrlConfig.formal) {
      Printer.enable = false;
    }else{
      Printer.enable = true;
    }

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..indicatorColor = ColorsUtil.fromEnmu(ColorEnum.system)
      ..indicatorSize = 40.0
      ..radius = 10.0
      ..progressColor = ColorsUtil.fromEnmu(ColorEnum.system)
      ..backgroundColor = Colors.black54
      ..textColor = Colors.white
      ..lineWidth = 3
      ..toastPosition = EasyLoadingToastPosition.center
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  void getUserAgreeStatus() {
    ToolConfig.getUserGreenStatus().then((value) {
      if (value == 1) {

      }else{
        userAgreenDialog();
      }
    });
  }

  void userAgreenDialog() {
    String userPrivateProtocol = '''，帮助您了解我们为您提供的服务，我们将如何处理个人信息以及您享有的权利。我们将会严格按照相关法律法规要求，采取各种安全措施来保护您的个人信息。\n点击"同意"按钮，表示您已知情并同意以下协议和以下约定：\n1.为了保障软件的安全运行和账号安全，我们会申请收集您的设备信息。\n2.上传图片需要申请您的相册或存储权限。\n3.申请设备信息，方便为您推荐个性化广告。\n4.我们尊重您的选择权，您可以访问修改，删除您的个人信息并管理您的授权。''';
    var alert = AlertDialog(
      title: Text("个人隐私保护提示"),
      titlePadding: EdgeInsets.all(10),
      //标题文本样式
      titleTextStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.title), fontSize: 16,fontWeight: FontWeight.bold),
      //中间显示的内容
      content:
       Container(
         height: 200,
         width: double.infinity,
         child: SingleChildScrollView(
           child: RichText(
             text: TextSpan(
                 text: '欢迎使用真命天喵！我们将通过',style:TextStyle(
                 color: ColorsUtil.fromEnmu(ColorEnum.content),
                 fontSize: 16,
                 height: 1.5
             ),
                 children: [
                   TextSpan(
                     text: '《用户协议》',style:TextStyle(
                       color: ColorsUtil.fromEnmu(ColorEnum.urlColor),
                       fontSize: 16,
                       height: 1.5
                   ),
                     recognizer: _tgr1..onTap = () {
                       Navigator.push(context, MaterialPageRoute(builder: (context){
                         return WebViewPage(url: NetWorkingConfig.path(NetPath.userAgreen));
                       }));
                   }
                   ),
                   TextSpan(text: '和',style:TextStyle(
                       color: ColorsUtil.fromEnmu(ColorEnum.content),
                       fontSize: 16,
                       height: 1.5
                   )),
                   TextSpan(text: '《隐私协议》',style:TextStyle(
                       color: ColorsUtil.fromEnmu(ColorEnum.urlColor),
                       fontSize: FontUtil.fs(FontSize.content),
                       height: 1.5
                   ),recognizer: _tgr2..onTap = () {
                     Navigator.push(context, MaterialPageRoute(builder: (context){
                       // return WebViewPage(url: NetWorkingConfig.path(NetPath.pravicy));
                       String filePath = 'assets/files/privacyPolicy.html';
                       return WebViewPage(filePath: filePath);
                     }));                   }
                   ),
                   TextSpan(text: userPrivateProtocol,style:TextStyle(
                       color: ColorsUtil.fromEnmu(ColorEnum.content),
                       fontSize: 16,
                       height: 1.5
                   )),
                 ]
             ),
           ),
         )
         // child: ,
       ),
      //中间显示的内容边距
      //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
      contentPadding: EdgeInsets.all(10),
      //中间显示内容的文本样式
      contentTextStyle: TextStyle(color: Colors.black54, fontSize: 14),
      scrollable: true,
      //底部按钮区域
      actions: <Widget>[
        TextButton(
          child: Text("不同意",
            style: TextStyle(
              color: ColorsUtil.fromEnmu(ColorEnum.title),
              fontSize: FontUtil.fs(FontSize.content),
              fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            // Navigator.of(context).pop(false);
            exit(0);
            // ToolConfig.setUserAgreenStatus(0);
          },
        ),
        TextButton(
          child: Text("同意",
            style: TextStyle(
              color: ColorsUtil.fromEnmu(ColorEnum.title),
              fontSize: FontUtil.fs(FontSize.content),
                fontWeight: FontWeight.bold
            ),
          ),
          onPressed: () {
            //关闭 返回true
            Navigator.of(context).pop(true);
            ToolConfig.setUserAgreenStatus(1);
          },
        ),
      ],
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: alert,
        );
      },
    );
  }

  // Future<void> _loadHtmlFromAssets(PrivacyDetailType type) async {

    // String filePath = 'assets/files/user_privacy.html';

    // String fileText = await rootBundle.loadString(filePath);
    // _webViewController.loadUrl(Uri.dataFromString      fileText,
    //
    //     mimeType: 'text/html',
    //
    //     encoding: Encoding.getByName('utf-8')
    // ).toString());
  // }




}
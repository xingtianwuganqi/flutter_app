import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/UserInfo/ChangePswdPage.dart';
import 'package:flutter_720yun/UserInfo/SuggestionPage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:provider/provider.dart';
import 'WebviewPage.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:flutter_720yun/UserInfo/BrowseListPage.dart';
import 'package:flutter_720yun/UserInfo/UserPublishPage.dart';
import 'package:flutter_720yun/UserInfo/UserCollectionPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'dart:io';

class SettingPageWidget extends StatefulWidget {
  final ValueChanged changed;

  SettingPageWidget({Key key,this.changed}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPageWidget> {

  List<UserPageModel> datas = [
    UserPageModel('assets/icons/icon_view_hist.png', '浏览记录',0),
    UserPageModel('assets/icons/icon_mi_collection.png', '我的收藏',0),
    UserPageModel('line', '', 0),
    UserPageModel('assets/icons/icon_setting_pswd.png', '修改密码',0),
    UserPageModel('assets/icons/icon_setting_fk.png', '意见反馈',0),
    UserPageModel('line', '', 0),
    UserPageModel('assets/icons/icon_mi_sm.png', '领养说明',0),
    UserPageModel('assets/icons/icon_mi_upload.png', '检测更新',0),
    UserPageModel('assets/icons/icon_mi_xy.png', '用户协议',0),
    UserPageModel('assets/icons/icon_pravicy.png', '隐私政策',0),
    UserPageModel('assets/icons/icon_mi_about.png', '关于我们',0),
    UserPageModel('line', '', 0),
    UserPageModel('', "退出登录",0)
  ];
// 是不是点击了检测更新
  bool isTap = false;

  AppVersionModel appVersionInfo;
  ScrollController _scrollController = ScrollController();

  // final ValueChanged changed;


  @override
  Widget build(BuildContext context) {

    Widget settingWidget(UserPageModel data) {
      List<Widget> arrs = [];
      arrs = [
        Padding(
          padding: EdgeInsets.only(left: 5,right: 5),
          child: ListTile(
              title: Container(
                  transform: Matrix4.translationValues(-20, 0.0, 0.0),
                  child: Text(data.title,style: TextStyle(fontSize: 14,color: Colors.black)),
                ),
              leading: Image.asset(data.icon),
              trailing: Icon(Icons.keyboard_arrow_right)
          ),
        ),
        Divider(height: .0,)
      ];
      if (data.title == '退出登录'){
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 15,bottom: 15),
          child: Text(data.title),
        );
      }else if (data.icon == 'line') {
        return Divider(thickness: 10.0,color: Colors.grey[100]);
      }else{
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 0,right: 0),
          child: Column(
              children: arrs
          ),
        );
      }

    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
        elevation: 0.5,

      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          itemBuilder: (context,index){
            var data = datas[index];
            return GestureDetector(
              child: settingWidget(data),
              onTap: () {
                if (data.title == '浏览记录') {
                  lazyAuthToDoThings(context, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return BrowseListWidget();
                    }));
                  });
                }else if (data.title == '我的发布') {
                  lazyAuthToDoThings(context, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return UserPublishWidget();
                    }));
                  });
                }else if (data.title == '我的收藏') {
                  lazyAuthToDoThings(context, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return UserCollectionWidget();
                    }));
                  });
                }else if (data.title == '领养说明') {
                  Navigator.push(context,MaterialPageRoute(builder: (context){
                    return WebViewPage(url: NetWorkingConfig.path(NetPath.instruction));
                  }));
                }
                else if (data.title == '用户协议') {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return WebViewPage(url: NetWorkingConfig.path(NetPath.userAgreen));
                  }));
                }else if (data.title == '隐私政策') {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return WebViewPage(url: NetWorkingConfig.path(NetPath.pravicy));
                  }));
                }else if (data.title == '关于我们') {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return WebViewPage(url: NetWorkingConfig.path(NetPath.aboutUs));
                  }));
                }else if (data.title == "检测更新") {
                  if (data.num == 1) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context){
                        return uploadAlert();
                      },
                    );
                  }else{
                    isTap = true;
                    uploadNetWorking();
                  }
                }else if (data.title == "修改密码"){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return new ChangePswdWidget();
                  }));
                }else if (data.title == '意见反馈'){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return new SuggesstionWidget();
                  }));
                }else if (data.title == "退出登录"){
                  /// 退出登录
                  Provider.of<UserProviderModel>(context, listen: false).user = null;
                  UserManager.instance.logout();
                  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                  //   return TabBar();
                  // }), (route) => false);
                }
              },
            );
          },
          itemCount: datas.length,
        ),
      )
    );
  }

  Future<Null> uploadNetWorking() async{
    final url = NetWorkingConfig.path(NetPath.appUpload);
    var dic = new Map<String, dynamic>.from(paramDic);
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var model = data['data'];
        var info = AppVersionModel.fromJson(model);
        appVersionInfo = info;
        var localVersion = dic['androidVersion'];
        if (info.version > int.parse(localVersion)) {
          var list = datas.map((e) {
            var newValue = e;
            if (e.title == "检测更新") {
              newValue.num = 1;
            }
            return newValue;
          }).toList();
          datas = list;
          // widget.changed(info.version);
          // setState(() {
          //
          // });
        }else{
          if (isTap == true) {
            EasyLoading.showToast("当前是最新版本");
            isTap = false;
          }
        }

      }
    }, (error) {

    });
  }

  // /// 检查是否有权限，用于安卓
  // Future<bool> checkPermission() async {
  //   if (_flatform == 'android') {
  //     PermissionStatus permission = await PermissionHandler()
  //         .checkPermissionStatus(PermissionGroup.storage);
  //     if (permission != PermissionStatus.granted) {
  //       Map<PermissionGroup, PermissionStatus> permissions =
  //       await PermissionHandler()
  //           .requestPermissions([PermissionGroup.storage]);
  //       if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }

  /// 下载安卓更新包
  Future<File> downloadAndroid(String url) async {
    /// 创建存储文件
    Directory storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir.path;

    var dic = new Map<String, dynamic>.from(paramDic);
    var localVersion = dic['appVersion'];

    File file = new File('$storagePath/zmtmv$localVersion.apk');

    if (!file.existsSync()) {
      file.createSync();
    }

    try {
      /// 发起下载请求
      Response response = await Dio().get(url,
          onReceiveProgress: showDownloadProgress,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));
      file.writeAsBytesSync(response.data);
      return file;
    } catch (e) {
      Printer.printMapJsonLog(e);
    }
  }

  // 安装apk
  Future<Null> installApk(String url) async {
    File _apkFile = await downloadAndroid(url);
    String _apkFilePath = _apkFile.path;

    if (_apkFilePath.isEmpty) {
      Printer.printMapJsonLog('make sure the apk file is set');
      return;
    }

    InstallPlugin.installApk(_apkFilePath, "com.rescue.flutter_720yun")
        .then((result) {
      Printer.printMapJsonLog('install apk $result');
      EasyLoading.dismiss();
    }).catchError((error) {
      Printer.printMapJsonLog('install apk error: $error');
      EasyLoading.dismiss();
    });
  }

  /// 展示下载进度
  void showDownloadProgress(num received, num total) {
    if (total != -1) {
      double _progress =
      double.parse('${(received / total).toStringAsFixed(2)}');
      EasyLoading.showProgress(_progress);
    }
  }

  Widget rightIcon(int num) {
    return Container(
      height: 40,
      width: 40,
      child: Row(
        children: [
          Container(
            height: 16,
            width: 16,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color:(num != null && num > 0 ) ? Colors.redAccent : Colors.transparent,
            ),
            child: Text( (num != null && num > 0 )?'$num': '',style: TextStyle(color: Colors.white,fontSize: 10),),
          ),
          // Expanded(child: Padding(padding: EdgeInsets.only(left: 5)),),
          Icon(Icons.keyboard_arrow_right,color: ColorsUtil.fromEnmu(ColorEnum.mark),)
        ],
      ),
    );
  }

  Widget uploadAlert() {
    return Container(
      width: double.infinity,
      height: 160,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: Text('有新版本更新啦，快快下载使用吧！',style: TextStyle(
              fontSize: FontUtil.fs(FontSize.content),
              color: ColorsUtil.fromEnmu(ColorEnum.content),
            ),),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.redAccent
            ),
            child: TextButton(onPressed: (){
              Navigator.pop(context);
              installApk(NetWorkingConfig.path(NetPath.appdownload));
            }, child: Container(
              child: Text('立刻更新',style: TextStyle(
                fontSize: FontUtil.fs(FontSize.content),
                color: Colors.white,
              ),),

            ),
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              //
              // ),

            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
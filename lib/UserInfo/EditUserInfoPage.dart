import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/Common/SingletonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/UserModel.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


class EditUserWidget extends StatefulWidget {
  String from;
  EditUserWidget({Key key,this.from}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditUserWidgetState();
  }
}

class EditUserWidgetState extends State<EditUserWidget> {

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();

  TextEditingController _nicknameController = TextEditingController();

  /// 上传图片
  // 创建 storage 对象
  Storage storage = Storage();
  // 创建 Controller 对象
  PutController putController = PutController();

  String _token;

  AssetEntity _assetInfo;
  String _avator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNodeUserName.addListener(() {
      _focusNodeListener();
    });

    _nicknameController.addListener(() {

    });

    if (UserManager.instance.isLogin) {
      _nicknameController.text = UserManager.instance.userInfo.username;
      _avator = UserManager.instance.userInfo.avator;
    }

    // 添加任务进度监听
    putController.addProgressListener((double percent) {
    });
    // 添加文件发送进度监听
    putController.addSendProgressListener((double percent) {
    });
    // 添加任务状态监听
    putController.addStatusListener((StorageStatus status) {
      if (status == StorageStatus.Success) {
        // 上传成功

      }
    });

  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _nicknameController.removeListener(_focusNodeListener);
    _focusNodeUserName.dispose();
    _nicknameController.dispose();
    super.dispose();
  }
  //   // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      // 取消密码框的焦点状态
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget headImage() {
      if (_assetInfo != null ) {
        return Container(
          child: AssetEntityImage(_assetInfo,height: 80,width: 80,fit: BoxFit.cover,) ,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          clipBehavior: Clip.antiAlias,
        );
      }else{
        return CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          backgroundImage:
          (UserManager.instance.isLogin ?
          ((UserManager.instance.userInfo.avator != null && UserManager.instance.userInfo.avator.length > 0) ?
          CachedNetworkImageProvider(ToolConfig.loadImgUrl((UserManager.instance.userInfo.avator ?? ""),bType: ThumbType.thumbNail)) :
          AssetImage('assets/icons/icon_plh.png')
          ):
          Image.asset('assets/icons/icon_plh.png')),
          child: Container(
            alignment: Alignment(0, .5),
            width: 80,
            height: 80,
          ),
        );
      }
    }

    Widget headWidget() {
      return GestureDetector(
        child: new Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              headImage(),
              Padding(padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Text("点击更换头像",style: TextStyle(fontSize: FontUtil.fs(FontSize.desc)),),
              ),
              Divider(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),height: 0.5,)
            ],
          ),
        ),
        onTap: () {
          /// 点击更换头型
          loadAssets();
        },
      );
    }



    Widget nickNameWidget() {
      return Container(
        height: 50,
        child: Column(
          children: [
            Expanded(child:
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 15)),
                  Text('昵称: ',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                      fontSize: FontUtil.fs(FontSize.content))),
                  Expanded(
                    child: TextField(maxLines: 1,
                      focusNode: _focusNodeUserName,
                      controller: _nicknameController,
                      cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                      decoration: InputDecoration(
                          hintText: "请输入昵称",
                          border: InputBorder.none
                      ),
                      style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content), fontSize: FontUtil.fs(FontSize.content)),

                    ),
                  )
                ],
              ),
            ),
            Divider(color: ColorsUtil.fromEnmu(ColorEnum.defIcon),height: 0.5,)
          ],
        )

      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑个人信息'),
        actions: [
          TextButton(
              onPressed: () {
                _focusNodeUserName.unfocus();
                if (_nicknameController.text == null || _nicknameController.text.length == 0) {
                  EasyLoading.showToast('请输入昵称');
                  return;
                }

                /// 如果没有选新头像
                if (_assetInfo != null) {
                  if (_token != null) {
                    uploadImgToQiNiu(_token);
                  } else {
                    // 先获取token，再上传
                    getQiNiuToken();
                  }
                }else{
                  updateUserInfoNetworking(_avator);
                }
              },
              child: Text('保存',
                style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.system),
                    fontSize: FontUtil.fs(FontSize.content)),)
          )
        ],
        elevation: 0.5,
      ),
      body:new GestureDetector(
        onTap: () {
          _focusNodeUserName.unfocus();
        },
        child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10),
            children: [
              headWidget(),
              nickNameWidget()
            ]
        ),
      )
    );
  }
//  选择头像
  Future<void> loadAssets() async {
    List<AssetEntity> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await ImagePicker.instance.selectAssets(context, 1);
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    if (resultList.length > 0 ){
      _assetInfo = resultList.first;
    }
    setState(() {

    });
  }

  Future<Null> getQiNiuToken() async {
    final url = NetWorkingConfig.path(NetPath.qiniuToken);
    var dic = new Map<String, dynamic>.from(paramDic);
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        var model = UploadImgTokenModel.formJson(data['data']);
        _token = model.token;
        uploadImgToQiNiu(_token);
      }
    }, (error) {
      EasyLoading.showToast('获取token失败');
    });
  }

  // /// 上传图片到七牛
  Future<Null> uploadImgToQiNiu(String token) async {
    EasyLoading.show(status:'上传图片...');
    // 使用 storage 的 putFile
    String photoKey = comPhotoKey;
    File file = await _assetInfo.file;
    storage.putFile(file, token, options: PutOptions(
      controller: putController,
      key: photoKey,
    )).then((value) {
      // 上传成功
      _avator = value.key;
      updateUserInfoNetworking(_avator);
    });
  }

  Future<Null> updateUserInfoNetworking(String avator) async {
    EasyLoading.show(status: '更新用户信息...');
    final url = NetWorkingConfig.path(NetPath.updateUserInfo);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['username'] = _nicknameController.text;
    dic['avator'] = avator;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        Printer.printMapJsonLog(data['data']);
        EasyLoading.showToast('更新成功');
        Future.delayed(Duration(milliseconds: 1500),() {
          EasyLoading.dismiss();
          // 返回到根目录
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
        var info = UserInfoModel.fromJson(data['data']);
        Provider.of<UserProviderModel>(context, listen: false).user = info;

      }
    }, (error) {
      EasyLoading.showToast('更新失败');
    });
  }
}
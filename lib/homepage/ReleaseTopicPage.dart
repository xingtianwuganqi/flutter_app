import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Login/CheckCodePage.dart';
import 'package:flutter_720yun/UserInfo/WebviewPage.dart';
import 'package:flutter_720yun/homepage/AddressSelectPage.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import '../Common/SingletonPage.dart';
import '../model/HomePageModel.dart';
import '../Common/CommonPage.dart';
import '../NetWorking/NetWorking.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'TagInfoPage.dart';


typedef StatefulWidgetBuilder = Widget Function(BuildContext context, StateSetter setState);


class ReleaseTopicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReleaseTopicState();
  }
}

class ReleaseTopicState extends State<ReleaseTopicPage> {

  List<TagInfoModel> tags = [];
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  TextEditingController _contentController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  int textCount = 0;

  List<ReleasePhotoModel> _releasePhotos = [
    ReleasePhotoModel(
      isAdd: true,
      progress: 0.0,
      complete: true,
      photoKey: '',
      photoUrl: '',
      // image: null
  )];

  late OverlayEntry overlayEntry;

  String _addressInfo = '';

  /// 上传图片
  // 创建 storage 对象
  Storage storage = Storage();
  // 创建 Controller 对象
  PutController putController = PutController();
  /// 图片的token
  late String _token;
  /// 不再提示
  bool _isSelectRemind = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _contentFocusNode.addListener(() {
      if (_contentFocusNode.hasFocus) {
        // showOverlay(context);
      } else {
        // removeOverlay();
      }
    });

    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        // showOverlay(context);
      } else {
        // removeOverlay();
      }
    });

    // 添加任务进度监听
    putController.addProgressListener((double percent) {
      print('任务进度变化：已发送：$percent');
    });
    // 添加文件发送进度监听
    putController.addSendProgressListener((double percent) {
      print('已上传进度变化：已发送：$percent');
    });
    // 添加任务状态监听
    putController.addStatusListener((StorageStatus status) {
      print('状态变化: 当前任务状态：$status');
      if (status == StorageStatus.Success) {
        // 上传成功

      }
    });

    _contentController.addListener(() {
      if (_contentController.text.length > 0) {
        textCount = _contentController.text.length;
      }else{
        textCount = 0;
      }
      setState(() {

      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _contentFocusNode.removeListener(() { });
    _phoneFocusNode.removeListener(() { });
    _contentController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    // final double screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('发布送养信息'),
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: () {
                clickPushButton();
              },
              child: Text('发布',
                style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.system),
                    fontSize: FontUtil.fs(FontSize.content)),)
          )
        ],
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: gestureWidget(),
      )
    );
  }

  Widget gestureWidget() {
    return GestureDetector(
      child: contentWidget(),
      onTap: () {
        _contentFocusNode.unfocus();
        _phoneFocusNode.unfocus();
      },
    );
  }

  Widget contentWidget() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double safeBottomHeight = MediaQuery.of(context).padding.bottom;
    final double screenH = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
      height:  screenH - statusBarHeight - kToolbarHeight - safeBottomHeight,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: tags.length > 0 ? tagsWidget() :
                GestureDetector(
                  child: Container(
                    width: 100,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text('添加标签 >',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                      color: ColorsUtil.fromEnmu(ColorEnum.system),),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      )
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return TagInfoPage(tags, (List<TagInfoModel> value) {
                          tags = value;
                          setState(() {

                          });
                        });
                      }));
                    },
                  ),
          ),
          Expanded(
              child:
                  Stack(
                    children: [
                      TextField(
                        focusNode: _contentFocusNode,
                        controller: _contentController,
                        cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                        maxLines: null,
                        decoration: InputDecoration.collapsed(
                            hintText: "请简单介绍下宠物，例如：\n名字：xxx\n年龄：xxx\n性别：xxx\n品种：xxx\n健康信息：xxx\n领养要求：xxx",
                            hintStyle: TextStyle(color: Colors.black12,fontSize: FontUtil.fs(FontSize.content))
                        ),
                        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),fontSize: FontUtil.fs(FontSize.content)),
                      ),
                      Positioned(
                        child: Text('$textCount/1000',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
                        right: 5,
                        bottom: 5,
                      )
                    ],
                  )
          ),
          photosWidget(),
          phoneWidget(),
          addressWidget(),
          bottomRemindText()
        ],
      ),
    );
  }

  Widget tagsWidget() {
    if (tags.length > 0) {
      return GestureDetector(
        child: Container(
            child: Column(
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  children: List.generate(tags.length, (index) {
                    var data = tags[index];
                    return RawChip(
                        label: Text(data.tag_name ?? "",
                            style: TextStyle(color:  Colors.white)),
                        backgroundColor: ColorsUtil.fromEnmu(ColorEnum.system)
                    );
                  }),
                ),
              ],
            )
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return TagInfoPage(tags, (List<TagInfoModel> value) {
              tags = value;
              setState(() {

              });
            });
          }));
        },
      );
    }else{
      return Container();
    }
  }

  Widget photosWidget() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      height: _releasePhotos.length > 3 ? ((MediaQuery.of(context).size.width - 50) / 3 + 10) * 2 : (MediaQuery.of(context).size.width - 50) / 3 + 10,
      child: GridView.builder(
          physics: new NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount:_releasePhotos.length,
          itemBuilder: (context,index){
            var item = _releasePhotos[index];
            if (item.isAdd ?? false) {
              return GestureDetector(
                child: Container(
                  // width: 20,
                  // height: 20,
                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                  child: Image.asset('assets/icons/icon_hw_navi_add.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                onTap: () async {
                  resignFirstFocus();
                  await loadAssets();
                },
              );
            }else{
              if (item.image != null) {
                return Container(
                    child: Stack(
                      children: [
                        AssetEntityImage(item.image!,
                          width: ((MediaQuery.of(context).size.width - 50) / 3 + 10).toDouble(),
                          height: ((MediaQuery.of(context).size.width - 50) / 3 + 10).toDouble(),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          child: IconButton(icon: Icon(Icons.cancel_rounded,color: Colors.black54,size: 20,), onPressed: () {
                            // 删除数据
                            var isRemove = _releasePhotos.remove(_releasePhotos[index]);
                            if (isRemove) {
                              setState(() {

                              });
                            }

                          },),
                          top: -10,
                          right: -10,
                        ),
                      ],
                    )
                );
              }else{
                return Container();
              }

            }

          }),
    );
  }

  Widget phoneWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 45,
      padding: EdgeInsets.only(left: 10),
      child:TextField(
        maxLines: 1,
        controller: _phoneController,
        focusNode: _phoneFocusNode,
        cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
          fontSize: FontUtil.fs(FontSize.content)
        ),
        decoration: InputDecoration.collapsed(
          hintText: '请输入联系方式,例如：手机号：xxx 或 微信：xxx',
            hintStyle: TextStyle(color: Colors.black26,fontSize: FontUtil.fs(FontSize.content))
        ),
      ),
    );
  }

  Widget addressWidget() {
    Widget address;
    if (_addressInfo != null && _addressInfo.length > 0) {
      address = Text(_addressInfo,
        style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
          fontSize: FontUtil.fs(FontSize.content)),
        maxLines: 1,overflow: TextOverflow.ellipsis);
    }else{
      address = Text('请选择地区',
          style: TextStyle(color: Colors.black26,
              fontSize: FontUtil.fs(FontSize.content))
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 45,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: TextButton(
          style: ButtonStyle(
            alignment: Alignment.centerLeft
          ),
          child: address,
          onPressed: () {
            resignFirstFocus();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context){
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                  child: AddressSelectPage((address) {
                    _addressInfo = address;
                    setState(() {

                    });
                  },),
                );
              },
            );
          },
        ),
      )
    );
  }

  Widget bottomRemindText() {
    return Container(
      padding: EdgeInsets.only(bottom: 10,top: 5),
      child: Text('禁止出现商业广告，低俗，色情，暴力，具有侮辱性语言或与宠物无关的内容，违规者帖子会被删除',
        style: TextStyle(
            fontSize: FontUtil.fs(FontSize.desc),
            color: ColorsUtil.fromEnmu(ColorEnum.desc)),
      ),
    );
  }

  Future<Future> showAlert() async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            scrollable: true,
            title: Text('发布提示'),
            content: StatefulBuilder(builder: (context, StateSetter setState){
              return SingleChildScrollView(
                child:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "请详细阅读",
                              style: TextStyle(fontSize: FontUtil.fs(FontSize.mark), color: ColorsUtil.fromEnmu(ColorEnum.content)),
                            ),
                            TextSpan(
                              text: "用户协议",
                              style: TextStyle(fontSize: FontUtil.fs(FontSize.mark), color: ColorsUtil.fromEnmu(ColorEnum.urlColor)),
                              // 设置点击事件
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return WebViewPage(NetWorkingConfig.path(NetPath.pravicy));
                                  }));
                                },
                            ),
                            TextSpan(
                              text: '，特别是用户权利和义务部分，发布内容时请严格遵守用户协议。\n禁止出现商业广告、低俗、色情、暴力、具有侮辱性语音或与宠物无关等内容，违规者帖子会被删除！',
                              style: TextStyle(fontSize: FontUtil.fs(FontSize.mark), color: ColorsUtil.fromEnmu(ColorEnum.content)),

                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(onPressed: (){
                      _isSelectRemind = !_isSelectRemind;
                      setState(() {

                      });
                    },
                        icon: _isSelectRemind ?
                        Icon(Icons.check_box,color: ColorsUtil.fromEnmu(ColorEnum.system),size: 20,) :
                        Icon(Icons.check_box_outline_blank,color: ColorsUtil.fromEnmu(ColorEnum.system),size: 20,),
                        label: Text('不再提示',style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.desc)),))
                  ],
                ),
              );
            }),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('取消',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.urlColor)))),
              TextButton(onPressed: (){
                if (_isSelectRemind == true) {
                  UserManager.instance.saveRescueRemind('pushResRemind');
                }
                Navigator.pop(context);
                beginPushNetworking();
              }, child: Text('确定发布',style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.urlColor)))),
            ],
          );
        }
        );
  }

  void clickPushButton() {
    resignFirstFocus();
    if (!isCanPushInfo()) {
      return;
    }
    var isSave = UserManager.instance.getSaveRescueRemind('pushResRemind');
    isSave.then((value) {
      if (value == true) {
        beginPushNetworking();
      }else{
        _isSelectRemind = false;
        showAlert();
      }
    });
  }

  void beginPushNetworking() {
    if (_token == null || _token.length == 0) {
      getQiNiuToken();
    }else{
      uploadImgToQiNiu(_token);
    }
  }

  Future<void> loadAssets() async {
    if (_releasePhotos.length > 6) {
      return;
    }
    List<AssetEntity>? resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await ImagePicker.instance.selectAssets(context, 7 - _releasePhotos.length);
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    if (!mounted) return;

    setState(() {
      var photos = resultList?.map((e) => ReleasePhotoModel(
        isAdd: false,
        progress: 0.0,
        complete: false,
        photoUrl: '',
        photoKey: comPhotoKey,
        image: e
      )).toList();
      _releasePhotos.insertAll(0, photos as Iterable<ReleasePhotoModel>);
    });
  }

  Future<Null> releaseTopicNetworking() async {
    /*
    parameter["content"] = content
            parameter["imgs"] = imgs
            parameter["address_info"] = address
            parameter["contact"] = contact
            parameter["token"] = UserManager.shared.token
            parameter["tags"] = tags
     */
    EasyLoading.show(status:'发布中...');
    List<ReleasePhotoModel> photos = [];
    for(int i = 0;i < _releasePhotos.length;i++) {
      var item = _releasePhotos[i];
      if (item.isAdd == false) {
        photos.add(item);
      }
    }
    String imgStr = photos.map((e) => e.photoUrl).toList().join(',');
    String tagStr = tags.map((e) => '${e.id}').toList().join(',');
    final url = NetWorkingConfig.path(NetPath.releaseTopicInfo);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['content'] = _contentController.text.trim(); // 去掉首尾的空格和换行
    dic['address_info'] = _addressInfo;
    dic['contact'] = _phoneController.text;
    dic['tags'] = tagStr;
    dic['imgs'] = imgStr;
    print('content的length');
    print(_contentController.text.trim().length);
    print(dic);
    /*
    parameter["content"] = content
            parameter["imgs"] = imgs
            parameter["address_info"] = address
            parameter["contact"] = contact
            parameter["token"] = UserManager.shared.token
            parameter["tags"] = tags
     */
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) {
        EasyLoading.showToast('发布成功');
        // 发送通知，更新个人中心页面
        bus.emit('topReleaseSuccess');
        Future.delayed(Duration(milliseconds: 1500),(){
          Navigator.pop(context,"refresh");
        });
      }else if (data['code'] == 209) { // 未绑定手机号
        EasyLoading.showToast(data['message'] ?? '未绑定手机号');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CheckCodePage(CodeFromType.bindPhone);
        }));
      }else if (data['code'] == 210) { // 未校验手机号
        EasyLoading.showToast(data['message'] ?? '未校验手机号');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CheckCodePage(CodeFromType.checkPhone, phone: UserManager.instance.userInfo?.phone_number);
        }));
      }else{
        EasyLoading.showToast(data['message'] ?? '发布失败');
      }
    }, (error) {
      EasyLoading.showToast('发布失败');
    });
  }

  Future<Null> getQiNiuToken() async {
    EasyLoading.show(status:'上传图片...');
    final url = NetWorkingConfig.path(NetPath.qiniuToken);
    var dic = new Map<String, dynamic>.from(paramDic);
    print(dic);
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = UploadImgTokenModel.formJson(data['data']);
        _token = model.token ?? "";
        uploadImgToQiNiu(_token);
      }
    }, (error) {
      EasyLoading.showToast('获取token失败');
    });
  }

  /// 上传图片到七牛
  void uploadImgToQiNiu(String token) {
    EasyLoading.show(status:'上传图片...');
    for (int i = 0; i < _releasePhotos.length; i++) {
      var item = _releasePhotos[i];
      updateImg(item);
    }
  }

  Future<Null> updateImg(ReleasePhotoModel item) async {
    if (item.isAdd == false) {
      File? file = await item.image?.file;
      if (file != null) {
        storage.putFile(file, _token, options: PutOptions(
          controller: putController,
          key: item.photoKey,
        )).then((value) {
          // 更新模型的数据
          _releasePhotos = _releasePhotos.map((e) {
            var newModel = e;
            if (e.photoKey == value.key) {
              newModel.complete = true;
              newModel.photoUrl = value.key;
            }
            return newModel;
          }).toList();
          // 判断_releasePhotos 是不是所有的complete 都变成了true；
          int isComplete = 0;
          for (int i = 0; i < _releasePhotos.length; i++) {
            var item = _releasePhotos[i];
            if (item.complete == false) {
              isComplete = 1;
              break;
            }
          }
          if (isComplete == 0) { // 说明全部传成功了
            releaseTopicNetworking();
            return;
          }
        });
      }
    }
  }

  bool isCanPushInfo() {
    if (_contentController.text == null || _contentController.text.length == 0) {
      EasyLoading.showToast('请输入介绍');
      return false;
    }

    if (_releasePhotos.length == 1 && _releasePhotos.first.isAdd == true) {
      EasyLoading.showToast('请选择图片');
      return false;
    }

    if (_phoneController == null || _phoneController.text.length == 0) {
      EasyLoading.showToast('请输入联系方式');
      return false;
    }

    if (_addressInfo == null || _addressInfo.length == 0) {
      EasyLoading.showToast('请选择地区');
      return false;
    }
    return true;
  }

  void resignFirstFocus() {
    _contentFocusNode.unfocus();
    _phoneFocusNode.unfocus();
  }
}

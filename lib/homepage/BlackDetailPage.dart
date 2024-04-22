import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/BlackPageModel.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';
import '../Common/SingletonPage.dart';
import '../CommonWidget/PhotoViewGalleryScreen.dart';
import '../model/HomePageModel.dart';
import '../Common/CommonPage.dart';
import '../NetWorking/NetWorking.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
//废弃
// import 'package:multi_image_picker/multi_image_picker.dart';

import 'TagInfoPage.dart';

enum BlackType {
  detail,
  create
}

class BlackDetailPage extends StatefulWidget {
  BlackType blackType;
  int? blackId;
  BlackDetailPage(
    this.blackType,
     {this.blackId}
  );

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlackDetailState();
  }
}

class BlackDetailState extends State<BlackDetailPage> {

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _wxNumController = new TextEditingController();
  TextEditingController _nickNameController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();

  // 领养人还是送养人
  bool isSwitch = false;

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  BlackListModel? blackModel;
  List<BlackInfoModel> blackList = [];

  List<ReleasePhotoModel> _releasePhotos = [
    ReleasePhotoModel(
        isAdd: true,
        progress: 0.0,
        complete: true,
        photoKey: '',
        photoUrl: '',
        image: null
    )];

  /// 上传图片
  // 创建 storage 对象
  Storage storage = Storage();
  // 创建 Controller 对象
  PutController putController = PutController();
  /// 图片的token
  String? _token;
  /// pushInfo
  ReleaseReportInfo? _pushInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.blackType == BlackType.detail) {
      blackDetailNetworking();
    }else {
      loadBlackList();
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('举报'),
        elevation: 0.5,
        actions: widget.blackType == BlackType.detail ? [] :  [
          TextButton(
              onPressed: (){
                pushButtonClick();
              }, child: Text('提交',
            style: TextStyle(fontSize: FontUtil.fs(FontSize.content),
                color: ColorsUtil.fromEnmu(ColorEnum.system)),)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: blackList.length,
        cacheExtent: 60,
        itemBuilder: (context,index) {
          var data = blackList[index];
          if (data.desc == "line") {
            return Divider(thickness: 10,height: 10,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),);
          }else if (data.desc == "手机号" || data.desc == "微信号" || data.desc == "微信昵称") {
            TextEditingController currentController = TextEditingController();
            if (data.desc == "手机号") {
              currentController = _phoneController;
            }else if ( data.desc == "微信号" ) {
              currentController = _wxNumController;
            }else if (data.desc == "微信昵称") {
              currentController = _nickNameController;
            }
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15,right: 15),
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(data.desc ?? "",style: TextStyle(
                          fontSize: FontUtil.fs(FontSize.content),
                          color: ColorsUtil.fromEnmu(ColorEnum.content)
                      ),),
                      Expanded(
                        child: TextField(
                          enabled: widget.blackType == BlackType.detail ? false: true,
                          textAlign: TextAlign.right,
                          cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                          controller: currentController,
                          style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                              fontSize: FontUtil.fs(FontSize.content)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: data.placeholder,
                            hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark),
                                fontSize: FontUtil.fs(FontSize.content)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                )
              ],
            );
          }else if (data.desc == "身份") {
            return Container(
              padding: EdgeInsets.only(left: 15,right: 15),
              height: 50,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(data.desc ?? ""),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('领养人',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.note),
                            fontSize: FontUtil.fs(FontSize.content))),
                        Switch(
                          value: isSwitch,
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.blue,
                          onChanged: (value) {
                            if (widget.blackType == BlackType.detail) {
                              return;
                            }
                            isSwitch = !isSwitch;
                            setState(() {

                            });
                          },
                        ),
                        Text("送养人",style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.note),
                            fontSize: FontUtil.fs(FontSize.content)))
                      ],
                    ),
                  )
                ],
              ),
            );
          }else if (data.desc == "举报理由"){
            return Container(
              padding: EdgeInsets.only(left: 15,right: 15),
              height: widget.blackType == BlackType.detail ? null : 140,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(data.desc ?? ""),
                  ),
                  widget.blackType == BlackType.detail ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                      alignment: Alignment.topLeft,
                      child: TextField(
                        enabled: widget.blackType == BlackType.detail ? false: true,
                        controller: _reasonController,
                        cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                        maxLength: null,
                        decoration: InputDecoration.collapsed(
                            border: InputBorder.none,
                            hintText: "请输入举报理由",
                            hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark),
                                fontSize: FontUtil.fs(FontSize.content)
                            )
                        ),
                      )
                  ) : Expanded(
                    child:
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                        constraints: BoxConstraints(maxHeight: 100, minHeight: 100),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                                width: 1,
                                color: ColorsUtil.fromEnmu(ColorEnum.tableBack)
                            )
                        ),
                        child: TextField(
                          enabled: widget.blackType == BlackType.detail ? false: true,
                          controller: _reasonController,
                          cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
                          maxLength: null,
                          decoration: InputDecoration.collapsed(
                          border: InputBorder.none,
                          hintText: "请输入举报理由",
                          hintStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.mark),
                              fontSize: FontUtil.fs(FontSize.content)
                          )
                          ),
                        )
                    )
                  )
                ],
              ),
            );
          }else{
            return Container(
              padding: EdgeInsets.only(left: 15,right: 15),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Text(data.desc ?? ""),
                  ),
                  photosWidget()
                ],
              ),
            );
          }
        }
        ),
    );
  }


  Future<Null> blackDetailNetworking() async {
    EasyLoading.show();
    final url = NetWorkingConfig.path(NetPath.blackDetail);
    var dic = new Map<String,dynamic>.from(paramDic);
    dic['blackId'] = widget.blackId;
    NetWorking.formDataPost(url, dic, (data) {
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        var model = data['data'];
        var blackInfo = BlackListModel.fromJson(model);
        blackModel = blackInfo;
        loadBlackList();
      }
    }, (error) {
      EasyLoading.dismiss();
    });
  }

  void loadBlackList() {

    var contact = widget.blackType == BlackType.create ? null: blackModel?.contact;
    var wx_num = widget.blackType == BlackType.create ? null: blackModel?.wx_num;
    var nickName = widget.blackType == BlackType.create ? null: blackModel?.name;
    var body = widget.blackType == BlackType.create ? null: (blackModel?.black_type == 1 ? "领养人" : "送养人");
    var reason = widget.blackType == BlackType.create ? null: blackModel?.desc;
    var images = widget.blackType == BlackType.create ? null: blackModel?.images;

    if (widget.blackType == BlackType.detail) {
      _phoneController.text = contact ?? "";
      _wxNumController.text = wx_num ?? "";
      _nickNameController.text = nickName ?? "";
      blackModel?.black_type == 1 ? isSwitch = false : isSwitch = true;
      _reasonController.text = reason ?? "";
      print(blackModel?.images);
      _releasePhotos = blackModel!.images!.map((e) {
        return ReleasePhotoModel(
            isAdd: false,
            progress: 0.0,
            complete: true,
            photoKey: '',
            photoUrl: e,
            // image: null
        );
      }).toList();
    }

    var list =
     [
       BlackInfoModel(desc: "手机号",placeholder: "请输入失信人手机号",value: contact,type: widget.blackType),
       BlackInfoModel(desc: "微信号",placeholder: "请输入失信人微信号",value: wx_num,type: widget.blackType),
       BlackInfoModel(desc: "微信昵称",placeholder: "请输入失信人微信昵称",value: nickName,type: widget.blackType),
       BlackInfoModel(desc: "line",placeholder: "",value: null,type: widget.blackType),
       BlackInfoModel(desc: "身份",placeholder: "",value: body,type: widget.blackType),
       BlackInfoModel(desc: "line",placeholder: "",value: null,type: widget.blackType),
       BlackInfoModel(desc: "举报理由",placeholder: "请输入失信人手机号",value: reason,type: widget.blackType),
       BlackInfoModel(desc: "line",placeholder: "",value: null,type: widget.blackType),
       BlackInfoModel(desc: "举报证据",placeholder: "",value: images,type: widget.blackType)
    ];

    blackList = list;
    setState(() {

    });

  }

  // 举报按钮点击
  void pushButtonClick() {

    var info = isCanPush();
    if (info == null) {
      return;
    }
    _pushInfo = info;
    getQiNiuToken();

  }

  ReleaseReportInfo? isCanPush() {
    String phone;
    String wx_num = "";
    String nickName = "";
    int blackType;
    String reason;
    if (_phoneController.text.trim().length == 0) {
      EasyLoading.showToast("请输入失信人手机号");
      return null ;
    }else{
      phone = _phoneController.text.trim();
    }

    if (_wxNumController.text.trim().length > 0) {
      wx_num = _wxNumController.text.trim();
    }

    blackType = (isSwitch == false) ? 1 : 2;

    if (_reasonController.text.trim().length == 0) {
      EasyLoading.showToast("请输入举报理由");
      return null;
    }else {
      reason = _reasonController.text.trim();
    }

    if (_releasePhotos.length == 1 && _releasePhotos.first.isAdd == true) {
      EasyLoading.showToast('请选择图片');
      return null;
    }

    var reportInfo = ReleaseReportInfo(
        phone: phone,
        wx_num: wx_num,
        name: nickName,
        black_type: blackType,
        desc: reason,
        photos: '',
    );
    return reportInfo;
  }


  Widget photosWidget() {

    void tapClick(int index) {
      var imgUrls = _releasePhotos.map((e) => ToolConfig.loadImgUrl(e.photoUrl ?? "")).toList();
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return PhotoViewGalleryScreen(imgUrls, index);
      }));
    }

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
                  await loadAssets();
                },
              );
            }else{
              return widget.blackType == BlackType.detail ?
              GestureDetector(
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: ToolConfig.loadImgUrl(item.photoUrl ?? ''),
                    placeholder: (context,url) => Container(
                      color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                    ),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ) ,
                onTap: (){
                  tapClick(index);
                },
              )
                  : Container(
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
            }

          }),
    );
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

  Future<Null> getQiNiuToken() async {
    EasyLoading.show(status:'上传图片...');
    final url = NetWorkingConfig.path(NetPath.qiniuToken);
    var dic = new Map<String, dynamic>.from(paramDic);
    print(dic);
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = UploadImgTokenModel.formJson(data['data']);
        _token = model.token;
        if (_token != null) {
          uploadImgToQiNiu(_token!);
        }
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
    if (item.isAdd == false && _token != null) {
      File? file = await item.image?.file;
      if (file != null) {
        storage.putFile(file!, _token!, options: PutOptions(
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
          if (isComplete == 0 && _pushInfo != null) { // 说明全部传成功了
            pushInfo(_pushInfo!);
            return;
          }
        });
      }
    }
  }

  // 开始发布
  Future<Null> pushInfo(ReleaseReportInfo info) async {

    List<ReleasePhotoModel> photos = [];
    for(int i = 0;i < _releasePhotos.length;i++) {
      var item = _releasePhotos[i];
      if (item.isAdd == false) {
        photos.add(item);
      }
    }
    String imgStr = photos.map((e) => e.photoUrl).toList().join(',');

    if (imgStr.length == 0) {
      return;
    }

    var url = NetWorkingConfig.path(NetPath.blackCreate);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic["name"] = info.name;
    dic["contact"] = info.phone;
    dic["wx_num"] = info.wx_num;
    dic["desc"] = info.desc;
    dic["imgs"] = imgStr;
    dic["black_type"] = info.black_type;
    dic["from_userId"] = UserManager.instance.userInfo?.id ?? 0;
    await NetWorking.formDataPost(url, dic, (data) {
      if (data['code'] == 200) { // 发布成功
        EasyLoading.showToast('提交成功，请等待审核');
        Future.delayed(Duration(milliseconds: 1500),(){
          Navigator.pop(context);
        });
      }
    }, (error) {

    });
  }
}
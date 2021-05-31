import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:qiniu_flutter_sdk/qiniu_flutter_sdk.dart';

import 'GambitSelectPage.dart';

class ReleaseShowInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReleaseShowInfoState();
  }
}

class ReleaseShowInfoState extends State<ReleaseShowInfoPage> {

  GambitModel _gambitModel;
  FocusNode _contentFocusNode = FocusNode();
  TextEditingController _contentController = TextEditingController();

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
  String _token;

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

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _contentFocusNode.removeListener(() { });
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('秀宠'),
        elevation: 0.5,
        actions: [
          TextButton(
              onPressed: () {
                _contentFocusNode.unfocus();
                if (!isCanPushInfo()) {
                  return;
                }
                if (_token == null || _token.length == 0) {
                  getQiNiuToken();
                }else{
                  uploadImgToQiNiu(_token);
                }
              },
              child: Text('发布',
                style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.system),
                    fontSize: FontUtil.fs(FontSize.content)),)
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: gestureWidget(),
        ),
      )
    );
  }

  Widget gestureWidget() {
    return GestureDetector(
      child: contentWidget(),
      onTap: () {
        _contentFocusNode.unfocus();
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
            child: _gambitModel != null ? gambitWidget() :
            GestureDetector(
              child: Container(
                  width: 100,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: Text('添加话题 >',style: TextStyle(fontSize: 15,
                    color: ColorsUtil.fromEnmu(ColorEnum.system),),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  )
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return GambitSelectPage(changed: (value){
                    print('value');
                    print(value);
                    _gambitModel = value;
                    setState(() {

                    });
                  },);
                }));
              },
            ),
          ),
          photosWidget(),
          Expanded(
              child: TextField(
                focusNode: _contentFocusNode,
                controller: _contentController,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                    hintText: "请输入简单说明",
                    hintStyle: TextStyle(color: Colors.black12)
                ),
                style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content)),
              )
          ),
          bottomRemindText()
        ],
      ),
    );
  }

  Widget gambitWidget() {
    return /// 话题
      Container(
          height:  38,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 10,top: 0,bottom: 10),
                  padding: EdgeInsets.only(left: 10,right: 10),
                  height: 28 ,//data.gambit_type != null ? 24 : 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/icons/icon_show_gb.png',width: 16,height: 16,),
                      Padding(padding: EdgeInsets.only(left: 6)),
                      Text(_gambitModel.descript,
                        style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),
                          color: ColorsUtil.fromEnmu(ColorEnum.system),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return GambitSelectPage(defGambit: _gambitModel, changed: (value){
                      _gambitModel = value;
                      setState(() {

                      });
                    });
                  }));
                },
              ),
            ],
          )
      );
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
            if (item.isAdd) {
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
                  _contentFocusNode.unfocus();
                  await loadAssets();
                },
              );
            }else{
              return Container(
                child:
                Stack(
                  children: [
                    AssetThumb(asset: item.image,width: ((MediaQuery.of(context).size.width - 50) / 3 + 10).toInt(),height: ((MediaQuery.of(context).size.width - 50) / 3 + 10).toInt()),
                    Positioned(
                      child: IconButton(icon: Icon(Icons.cancel_rounded,color: Colors.white,size: 20,), onPressed: () {
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

  Widget bottomRemindText() {
    return Container(
      padding: EdgeInsets.only(bottom: 10,top: 5),
      child: Text('禁止出现商业广告，低俗，色情，暴力，具有侮辱性语言或与宠物无关的内容，违规者帖子会被删除',
        style: TextStyle(
            fontSize: 15,
            color: ColorsUtil.fromEnmu(ColorEnum.desc)),
      ),
    );
  }

  Future<void> loadAssets() async {
    if (_releasePhotos.length > 6) {
      return;
    }
    List<Asset> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 7 - _releasePhotos.length,
        enableCamera: false,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: '#ffa500',
            actionBarTitle: "App",
            allViewTitle: "All Photos",
            useDetailsView: true,
            selectCircleStrokeColor: "#666666",
            startInAllView: true),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    if (!mounted) return;

    setState(() {
      var photos = resultList.map((e) => ReleasePhotoModel(
          isAdd: false,
          progress: 0.0,
          complete: false,
          photoUrl: '',
          photoKey: comPhotoKey,
          image: e
      )).toList();
      _releasePhotos.insertAll(0, photos);
    });
  }


  Future<Null> releaseShowNetworking() async {
    /*
    dic["token"] = UserManager.shared.token
            dic["instruction"] = instrction
            dic["imgs"] = imgs
            dic["gambit_id"] = gambit_id

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
    final url = NetWorkingConfig.path(NetPath.releaseShowInfo);
    var dic = paramDic;
    dic['instruction'] = _contentController.text;
    dic['gambit_id'] = _gambitModel == null ? null : _gambitModel.id.toString();
    dic['imgs'] = imgStr;

    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      if (data['code'] == 200) {
        EasyLoading.showToast('发布成功');
        Future.delayed(Duration(milliseconds: 1500),(){
          Navigator.pop(context,"refresh");
        });
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
    final dic = paramDic;
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      print(data);
      if (data['code'] == 200) {
        var model = UploadImgTokenModel.formJson(data['data']);
        _token = model.token;
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
      final filePath = await FlutterAbsolutePath.getAbsolutePath(item.image.identifier);
      File file = File(filePath);
      storage.putFile(file, _token, options: PutOptions(
        controller: putController,
        key: item.photoKey,
      )).then((value) {
        // 上传成功
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
        for (int i = 0;i < _releasePhotos.length;i++) {
          var item = _releasePhotos[i];
          if (item.complete == false) {
            isComplete = 1;
            break;
          }
        }
        if (isComplete == 0) { // 说明全部传成功了
          releaseShowNetworking();
          return;
        }
      });
    }
  }

  bool isCanPushInfo() {
    if (_contentController.text == null || _contentController.text.length == 0) {
      EasyLoading.showToast('请输入简单说明');
      return false;
    }

    if (_releasePhotos.length == 1 && _releasePhotos.first.isAdd == true) {
      EasyLoading.showToast('请选择图片');
      return false;
    }

    return true;
  }
}
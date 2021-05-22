import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/model/HomePageModel.dart';
import 'package:flutter_720yun/model/ShowModel.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
  // FocusNode _phoneFocusNode = FocusNode();
  List<ReleasePhotoModel> _releasePhones = [
    ReleasePhotoModel(
        isAdd: true,
        progress: 0.0,
        complete: false,
        photoKey: '',
        photoUrl: '',
        image: null
    )];

  OverlayEntry overlayEntry;

  String _addressInfo = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('秀宠'),
        elevation: 0.5,
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
      height: _releasePhones.length > 3 ? ((MediaQuery.of(context).size.width - 50) / 3 + 10) * 2 : (MediaQuery.of(context).size.width - 50) / 3 + 10,
      child: GridView.builder(
          physics: new NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount:_releasePhones.length,
          itemBuilder: (context,index){
            var item = _releasePhones[index];
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
                  await loadAssets();
                },
              );
            }else{
              return Container(
                child:
                AssetThumb(asset: item.image,width: ((MediaQuery.of(context).size.width - 50) / 3 + 10).toInt(),height: ((MediaQuery.of(context).size.width - 50) / 3 + 10).toInt()),
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
    if (_releasePhones.length > 6) {
      return;
    }
    List<Asset> resultList = [];
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: false,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
            actionBarColor: '#ffa500',
            actionBarTitle: "App",
            allViewTitle: "All Photos",
            useDetailsView: true,
            selectCircleStrokeColor: "#000000",
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
          photoUrl: DateTime.now().millisecondsSinceEpoch.toString() + '/' + ToolConfig.random() + '.png',
          photoKey: '',
          image: e
      ));
      _releasePhones.insertAll(0, photos);
    });
  }
}
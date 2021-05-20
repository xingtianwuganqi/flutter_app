import 'package:flutter/material.dart';
import 'package:flutter_720yun/homepage/AddressSelectPage.dart';
import '../model/HomePageModel.dart';
import '../Common/CommonPage.dart';
import '../NetWorking/NetWorking.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'TagInfoPage.dart';

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


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('发布送养信息'),
        elevation: 0.5,
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: gestureWidget(screenH,statusBarHeight),
      )
    );
  }

  Widget gestureWidget(double screenH,double statusBarHeight) {
    return GestureDetector(
      child: contentWidget(screenH,statusBarHeight),
      onTap: () {
        _contentFocusNode.unfocus();
        _phoneFocusNode.unfocus();
      },
    );
  }

  Widget contentWidget(double screenH,double statusBarHeight) {
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
      height:  screenH - statusBarHeight - kToolbarHeight,
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
                    child: Text('添加标签 >',style: TextStyle(fontSize: 15,
                      color: ColorsUtil.fromEnmu(ColorEnum.system),),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      )
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return TagInfoPage(tags: tags,changed: (List<TagInfoModel> value) {
                          tags = value;
                          setState(() {

                          });
                        });
                      }));
                    },
                  ),
            // TextButton(
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context){
            //         return TagInfoPage(changed: (List<TagInfoModel> value) {
            //           tags = value;
            //           setState(() {
            //
            //           });
            //         });
            //       }));
            //     }, child: Text('添加标签 >',
            //   style: TextStyle(fontSize: 15,
            //     color: ColorsUtil.fromEnmu(ColorEnum.system),),
            //     textAlign: TextAlign.left,
            //     overflow: TextOverflow.ellipsis,
            //   ),
            // ),
          ),
          Expanded(
              child: TextField(
                focusNode: _contentFocusNode,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                    hintText: "请简单介绍下宠物，例如：\n名字：xxx\n年龄：xxx\n性别：xxx\n品种：xxx\n健康信息：xxx\n领养要求：xxx",
                  hintStyle: TextStyle(color: Colors.black12)
                ),
                style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content)),
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
                        label: Text(data.tag_name,
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
            return TagInfoPage(tags: tags,changed: (List<TagInfoModel> value) {
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

  Widget phoneWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
      ),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 50,
      padding: EdgeInsets.only(left: 10),
      child:TextField(
        maxLines: 1,
        focusNode: _phoneFocusNode,
        decoration: InputDecoration.collapsed(
          hintText: '请输入联系方式',
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
      height: 50,
      child: TextButton(
        child: address,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context){
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                color: Colors.white,
                child: AddressSelectPage(changed: (address) {
                  _addressInfo = address;
                  setState(() {

                  });
                },),
              );
            },
          );
        },
      ),
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
        maxImages: 7 - _releasePhones.length,
        enableCamera: false,
        selectedAssets: resultList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "App",
            allViewTitle: "All Photos",
            useDetailsView: false,
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

class InputDoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: MaterialButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Text("Done",
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

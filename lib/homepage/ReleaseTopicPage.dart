import 'package:flutter/material.dart';
import '../model/HomePageModel.dart';
import '../Common/CommonPage.dart';
import '../NetWorking/NetWorking.dart';

class ReleaseTopicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReleaseTopicState();
  }
}

class ReleaseTopicState extends State<ReleaseTopicPage> {

  List<TagModel> tags = [];
  FocusNode _contentFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  OverlayEntry overlayEntry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _contentFocusNode.addListener(() {
      if (_contentFocusNode.hasFocus) {
        showOverlay(context);
      } else {
        removeOverlay();
      }
    });

    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus) {
        showOverlay(context);
      } else {
        removeOverlay();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('发布送养信息'),
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child:Container(
          padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: tags.length > 0 ? tagsWidget() : TextButton(
                    onPressed: () {

                    }, child: Text('添加标签 >',style: TextStyle(fontSize: 15,color: ColorsUtil.fromEnmu(ColorEnum.system)))),
              ),
              Expanded(
                  child: TextField(
                    focusNode: _contentFocusNode,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                        hintText: "请简单介绍下宠物，例如：\n名字\n年龄"),

                  )
              ),
              Container(
                height: 100,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount:3,
                    itemBuilder: (context,index){
                      return Container(
                        // width: 20,
                        // height: 20,
                        color: Colors.blue,
                      );
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
                ),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 5,bottom: 5),
                height: 50,
                padding: EdgeInsets.only(left: 10),
                child:TextField(
                  focusNode: _phoneFocusNode,
                  decoration: InputDecoration.collapsed(
                    hintText: '请输入联系方式',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: ColorsUtil.fromEnmu(ColorEnum.tableBack),
                ),
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 5,bottom: 5),
                height: 50,
                child: TextButton(
                  child: Text('请选择地区',style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.desc)),),
                  onPressed: () {

                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10,top: 5),
                child: Text('禁止出现商业广告，低俗，色情，暴力，具有侮辱性语言或与宠物无关的内容，违规者帖子会被删除',style: TextStyle(fontSize: 15,color: ColorsUtil.fromEnmu(ColorEnum.desc)),),
              ),
            ],
          ),
        ),
        onTap: () {
          _contentFocusNode.unfocus();
          _phoneFocusNode.unfocus();
        },
      )
    );
  }

  List<Widget> tagsWidget() {
    if (tags.length > 0) {
      return tags.map((e) => Container(
        decoration: BoxDecoration(
            color: ColorsUtil.fromEnmu(ColorEnum.system),
            borderRadius: BorderRadius.all(Radius.circular(3.0))
        ),
        padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
        child: Text(e.tag_name ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      )).toList();
    }else{
      return [];
    }
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
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

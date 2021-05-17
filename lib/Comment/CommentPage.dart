import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../model/CommentModel.dart';

class CommentWidget extends StatefulWidget {

  CommentType commentType;
  int topicId;
  
  CommentWidget({Key key,@required this.commentType,@required this.topicId}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentState();
  }
}

class CommentState extends State<CommentWidget> {

  List<CommentInfoModel> dataSource = [];
  int _page = 1;
  List<ComRepListModel> listData = [];
  bool _firstRefresh = true;
  FocusNode _focusNode;
  TextEditingController _comController;

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        title: Text('评论'),
        elevation: 0.5,
      ),
      body: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
            enableInfiniteLoad:false
        ),
        firstRefresh: _firstRefresh,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget: listData.length > 0 ? null : EmptyPage((){
          commentListNetWorking(1);
        }),
        child: listViewWidget(),
        onRefresh: () async {
          await commentListNetWorking(1);
        },
        onLoad: () async{
          await commentListNetWorking(_page);
        },
      ),
    );
  }

  Widget listViewWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context,index) {
        var data = listData[index];
        if (data.type == 1) {
          return Container(
            child: commentCell(data),
          );
        }else if (data.type == 2){
          return Container(
            child: replyCell(data),
          );
        }else{
          return moreItemCell();
        }
      },
      itemCount: listData.length,
    );
  }

  Widget sliverListView() {
    return SliverList(delegate: SliverChildBuilderDelegate((content, index) {
      var data = listData[index];
      if (data.type == 1) {
        return Container(
          child: commentCell(data),
        );
      }else if (data.type == 2){
        return Container(
          child: replyCell(data),
        );
      }else{
        return moreItemCell();
      }
    }, childCount: listData.length));
  }

  Widget inputWidget() {
    return Container(
        child: TextField(maxLines: 1,
          focusNode: _focusNode,
          controller: _comController,
          decoration: InputDecoration(
            hintText: "请输入评论",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: TextStyle(fontSize: 15),
        )
    );
  }

  /// 列表网络请求
  Future<Null> commentListNetWorking(int page) async {
    _page = page;
    int commentType = 1;
    switch (widget.commentType) {
      case CommentType.topic_comment:
        commentType = 1;
        break;
      case CommentType.show_comment:
        commentType = 2;
        break;
      default:
        commentType = 1;
        break;
    };

    final url = NetWorkingConfig.path(NetPath.commentList);
    final dic = {
      'topic_type': commentType,
      'topic_id': widget.topicId,
      'page': _page,
      'size': 10
    };

    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      // Printer.printMapJsonLog(data);
      if (data['code'] == 200) {
        var models = data['data'];
        Printer.printMapJsonLog(models);
        if (_page == 1) {
          dataSource = [];
          listData = [];
        }
        for (int i = 0;i < models.length; i++) {
          var model = models[i];
          var info = CommentInfoModel.fromJson(model);
          dataSource.add(info);
          commentListData(info);
        }
        if (models.length > 0) {
          _page += 1;
        }
        setState(() {
          if (listData.length > 0) {
            _firstRefresh = false;
          }
        });
      }else{

      }
    }, (error) {

    });
  }

  // 处理数据
  void commentListData(CommentInfoModel model) {
    var comModel = ComRepListModel(type: 1,commentModel: model);
    listData.add(comModel);
    if (model.replys.length > 0) {
      var replyInfos = model.replys.map((e) => ComRepListModel(type: 2,replyModel: e)).toList();
      listData.addAll(replyInfos);
    }

    /// 如果replys有5个或5个以上，则可能还有下一页
    if (model.replys.length >= 5) {
      var com = ComRepListModel(type: 3);
      listData.add(com);
    }

  }
  
  Widget commentCell(ComRepListModel model) {
    return Container(
      child: GestureDetector(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left:15,top: 5,bottom: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: (model.commentModel.userInfo.avator != null && model.commentModel.userInfo.avator.length > 0) ?  CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + model.commentModel.userInfo.avator) : AssetImage('assets/icons/icon_plh.png'),
                      child: Container(
                        alignment: Alignment(0, 0),
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                        child: Text((model.commentModel.userInfo.username != null && model.commentModel.userInfo.username.length > 0) ? model.commentModel.userInfo.username : '佚名',
                          style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
                    ),
                    IconButton(icon: Icon(Icons.more_horiz_outlined,
                    color: ColorsUtil.fromEnmu(ColorEnum.mark),
                    ), onPressed: (){})
                  ],
                ),
              ),
              // 内容
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 45,right: 10,top: 3,bottom: 3),
                child: Text((model.commentModel.content != null && model.commentModel.content.length > 0) ? model.commentModel.content : '--',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content)),
                ),
              ),
              // 时间
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 45,right: 10,top: 3,bottom: 3),
                child: Text((model.commentModel.create_time != null && model.commentModel.create_time.length > 0) ? ToolConfig.timeT(model.commentModel.create_time) : '--',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                ),
              ),
              Divider(height: 0.5,indent: 45,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),)
            ],
          ),
        ),
      ),
    );
  }

  Widget replyCell(ComRepListModel model) {
    var userTitle = '';
    var fromName = '';
    var toName = '';
    if (model.replyModel.fromInfo.username != null && model.replyModel.fromInfo.username.length > 0) {
      fromName = model.replyModel.fromInfo.username;
    }

    if (model.replyModel.toInfo.username != null && model.replyModel.toInfo.username.length > 0) {
      toName = model.replyModel.toInfo.username;
    }

    userTitle = fromName + '  回复  ' + toName;

    return Container(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(left: 45),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: (model.replyModel.fromInfo.avator != null && model.replyModel.fromInfo.avator.length > 0) ?  CachedNetworkImageProvider(NetWorkingConfig.imgBaseUrl + model.replyModel.fromInfo.avator) : AssetImage('assets/icons/icon_plh.png'),
                      child: Container(
                        alignment: Alignment(0, 0),
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Text(userTitle,
                        style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
                    ),
                    IconButton(icon: Icon(Icons.more_horiz_outlined,
                      color: ColorsUtil.fromEnmu(ColorEnum.mark),
                    ), onPressed: (){})
                  ],
                ),
              ),
              // 内容
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30,right: 10,top: 3,bottom: 3),
                child: Text((model.replyModel.content != null && model.replyModel.content.length > 0) ? model.replyModel.content : '--',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content)),
                ),
              ),
              // 时间
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30,right: 10,top: 3,bottom: 3),
                child: Text((model.replyModel.create_time != null && model.replyModel.create_time.length > 0) ? ToolConfig.timeT(model.replyModel.create_time) : '--',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(indent: 30,height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),)
            ],
          ),
        ),
      ),
    );
  }

  Widget moreItemCell() {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 75),
            height: 50,
            alignment: Alignment.center,
            child: Text('查看更多回复 >',
              style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.urlColor)),
            ),
          ),
          Divider(indent: 75,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),height: 0.5,)
        ],
      )
    );
  }
}
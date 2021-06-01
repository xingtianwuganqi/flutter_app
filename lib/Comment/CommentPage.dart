import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/UserInfo/ViolationsListPage.dart';
import 'package:flutter_720yun/model/MessageModel.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../model/CommentModel.dart';

class CommentInfoWidget extends StatefulWidget {

  final CommentType commentType;
  final int topicId;
  final int toUid;
  final ValueChanged changed;

  CommentInfoWidget({Key key,@required this.commentType,@required this.topicId,@required this.toUid,this.changed}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentState();
  }
}

class CommentState extends State<CommentInfoWidget> {

  List<CommentInfoModel> dataSource = [];
  int _page = 1;
  List<ComRepListModel> listData = [];
  bool _firstRefresh = true;
  FocusNode _focusNode = FocusNode();
  TextEditingController _comController = TextEditingController();
  // 回复时的模型
  ReplyComModel _replyComModel;

  /// 点击的类型
  ComTapTypeInfo _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _focusNode.addListener(() {
      _focusNodeListener();
    });
  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNode.removeListener(_focusNodeListener);
    _comController.dispose();
    super.dispose();
  }


    // 监听焦点
  Future<Null> _focusNodeListener() async{
    /// 失去焦点时，去掉输入框中的问题
    if(!_focusNode.hasFocus){
      // 取消密码框的焦点状态
      _replyComModel = null;
      _comController.clear();
      setState(() {
        _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: ColorsUtil.fromEnmu(ColorEnum.defIcon),
      appBar: AppBar(
        title: Text('评论'),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: GestureDetector(
          child: columnWidget(),
          onTap: (){
            if(_focusNode.hasFocus)  {
              _focusNode.unfocus();
              // _replyComModel = null;
              // _comController.clear();
              // setState(() {
              //   _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');
              // });
            }
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget columnWidget() {
    return Column(
      children: [
        Expanded(
            child: Container(
              child: refreshView(),
            )
        ),
        inputWidget()
      ],
    );
  }


  Widget refreshView() {
    return EasyRefresh(
      header: MaterialHeader(),
      footer: MaterialFooter(
          enableInfiniteLoad:false
      ),
      firstRefresh: _firstRefresh,
      firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
      emptyWidget: listData.length > 0 ? null : EmptyPage((){
        commentListNetWorking(1);
      },title: '暂无评论',desc:'快去发布第一条评论吧!'),
      child: listViewWidget(),
      onRefresh: () async {
        await commentListNetWorking(1);
      },
      onLoad: () async{
        await commentListNetWorking(_page);
      },
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
      color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child:
              Container(
                margin: EdgeInsets.only(left:10,right: 10,top: 5,bottom: 5),
                decoration: new BoxDecoration(
                  //背景
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //设置四周边框
                  // border: new Border.all(width: 1, color: Colors.red),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(maxLines: 1,
                  style: TextStyle(fontSize: 15,textBaseline: TextBaseline.alphabetic),
                  focusNode: _focusNode,
                  controller: _comController,
                  decoration: InputDecoration.collapsed(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: _tapType.name,
                  ),
                ),
              ),
            ),
            TextButton(onPressed: (){
              if (_replyComModel != null) {
                replyCommentNetworking(_replyComModel);
              }else{
                pushCommentNetworking();
              }
            }, child: Text('发送',
              style: TextStyle(color: Colors.white),),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorsUtil.fromEnmu(ColorEnum.system))),
            ),
            Padding(padding: EdgeInsets.only(left: 10),)
          ],
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
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['topic_type'] = commentType;
    dic['topic_id'] = widget.topicId;
    dic['page'] = _page;
    dic['size'] = 10;

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
    if (listData.length > 0 && widget.changed != null) {
      widget.changed(listData.length);
    }
  }

  /// 发表评论
  Future<Null> pushCommentNetworking() async{

    if (_comController.text.length == 0) {
      EasyLoading.showToast("请输入评论");
      return;
    }

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
    final url = NetWorkingConfig.path(NetPath.pushComment);
    final dic = {
      'token': UserManager.instance.token,
      'content': _comController.text,
      'topic_id': widget.topicId,
      'topic_type': commentType,
      'from_uid': UserManager.instance.userInfo.id,
      'to_uid': widget.toUid
    };
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      if (data['code'] == 200) {
        EasyLoading.showToast('发表成功');
        /// 刷新数据
        var json = data['data'];
        var model = CommentInfoModel.fromJson(json);
        addPushCommentInfo(model);
        setState(() {
          // 清空输入框
          _focusNode.unfocus();
          // _comController.clear();
          // _replyComModel = null;
          // _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');
        });
      }else{
        EasyLoading.showToast('发表失败');
      }
    }, (error) {
      EasyLoading.showToast('发表失败');

    });
  }

  /// 发表评论处理数据
  void addPushCommentInfo(CommentInfoModel model) {
    dataSource.insert(0, model);
    listData = [];
    for (int i = 0;i < dataSource.length; i++){
      commentListData(dataSource[i]);
    }

  }

  /// 回复评论
  Future<Null> replyCommentNetworking(ReplyComModel model) async {
    final url = NetWorkingConfig.path(NetPath.replyComment);
    final dic = {
      'token': UserManager.instance.token,
      'content': _comController.text,
      'comment_id': model.comment_id,
      'reply_id': model.reply_id,
      'reply_type': model.reply_type,
      'to_uid': model.to_uid,
      'from_uid': UserManager.instance.userInfo.id,
    };

    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      if (data['code'] == 200) {
        EasyLoading.showToast("发表成功");
        var json = data['data'];
        var model = ReplyListModel.fromJson(json);
        addReplyCommentInfo(model);
        setState(() {
          // 清空输入框
          _focusNode.unfocus();
          // _comController.clear();
          // _replyComModel = null;
          // _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');
        });
      }else{
        EasyLoading.showToast("发表失败");

      }
    }, (error) {
      EasyLoading.showToast("发表失败");
    });
  }

  /// 添加回复处理数据
  void addReplyCommentInfo(ReplyListModel model) {
    for (int i = 0;i < dataSource.length; i++){
      var data = dataSource[i];
      if (data.comment_id == model.comment_id) {
        data.replys.insert(0, model);
        dataSource[i] = data;
      }
    }
    /// 情况listData
    listData = [];
    for (int i = 0;i < dataSource.length; i++){
      commentListData(dataSource[i]);
    }
  }
  
  Widget commentCell(ComRepListModel model) {
    return Container(
      color: Colors.white,
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
                    ), onPressed: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            color: Colors.white,
                            child: ListView(
                              children: [
                                // TextButton(onPressed: (){
                                //
                                // }, child: Text('屏蔽/拉黑',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                                Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                                TextButton(onPressed: (){
                                  var report_type = Report_type.rescue_comment;
                                  if (widget.commentType == CommentType.topic_comment) {
                                    report_type = Report_type.rescue_comment;
                                  }else{
                                    report_type = Report_type.show_comment;
                                  }
                                  Navigator.pop(context);
                                  lazyAuthToDoThings(context, (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ViolationsListWidget(reportType: report_type,reportId: model.commentModel.comment_id);
                                    }));
                                  });
                                }, child: Text('投诉举报',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                                Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text('取消',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                              ],
                            ),
                          );
                        },
                      );
                    })
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
        onTap: () {
          // 点击评论
          FocusScope.of(context).requestFocus(_focusNode);// 获取焦点
          _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: "回复${model.commentModel.userInfo.username}");

          /// 回复时需要的数据
          _replyComModel = ReplyComModel(
              comment_id: model.commentModel.comment_id,
              reply_id: model.commentModel.comment_id,
              reply_type: 1,
              to_uid: model.commentModel.userInfo.id
          );

          setState(() {

          });
        },
        // behavior: HitTestBehavior.opaque,
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
      color: Colors.white,
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
                    ), onPressed: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (context){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            color: Colors.white,
                            child: ListView(
                              children: [
                                // TextButton(onPressed: (){
                                //
                                // }, child: Text('屏蔽/拉黑',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                                Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                                TextButton(onPressed: (){
                                  var report_type = Report_type.rescue_reply;
                                  if (widget.commentType == CommentType.topic_comment) {
                                    report_type = Report_type.rescue_reply;
                                  }else{
                                    report_type = Report_type.show_reply;
                                  }
                                  Navigator.pop(context);
                                  lazyAuthToDoThings(context, (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ViolationsListWidget(reportType: report_type,reportId: model.replyModel.reply_id);
                                    }));
                                  });
                                }, child: Text('投诉举报',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                                Divider(height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),),
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text('取消',style: TextStyle(fontSize: FontUtil.fs(FontSize.title)),)),
                              ],
                            ),
                          );
                        },
                      );
                    })
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
        onTap: () {
          // 点击回复
          FocusScope.of(context).requestFocus(_focusNode);// 获取焦点
          /// 点击了回复
          _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: "回复${model.replyModel.fromInfo.username}");

          /// 回复时需要的数据
          _replyComModel = ReplyComModel(
              comment_id: model.replyModel.comment_id,
              reply_id: model.replyModel.reply_id,
              reply_type: 2,
              to_uid: model.replyModel.from_uid
          );

          setState(() {

          });
        },
        // behavior: HitTestBehavior.opaque,
      ),
    );
  }

  Widget moreItemCell() {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            color: Colors.white,
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
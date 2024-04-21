import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/UserInfo/NewUserInfoPage.dart';
import 'package:flutter_720yun/UserInfo/ViolationsListPage.dart';
import 'package:flutter_720yun/model/UserModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Login/CheckCodePage.dart';
import '../model/CommentModel.dart';

class CommentInfoWidget extends StatefulWidget {

  CommentType? commentType;
  int? topicId;
  int? toUid;
  ValueChanged? changed;

  CommentInfoWidget({required Key key,this.commentType,this.topicId, this.toUid, this.changed}): super(key:key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentState();
  }
}

class CommentState extends State<CommentInfoWidget> with WidgetsBindingObserver{

  List<CommentInfoModel> dataSource = [];
  int _page = 1;
  List<ComRepListModel> listData = [];
  bool _firstRefresh = true;
  FocusNode _focusNode = FocusNode();
  TextEditingController _comController = TextEditingController();
  // 回复时的模型
  ReplyComModel? _replyComModel;

  /// 点击的类型
  ComTapTypeInfo _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: '请输入评论');

  double _height = 0;// 这个很简单，就是获取高度，获取的底部安全区域的高度
  bool _keyboard = false;//键盘的弹起、收回状态
  // TextEditingController editingController = new TextEditingController();//输入框的编辑

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _focusNode.addListener(() {
      _focusNodeListener();
    });
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // MediaQuery.of(context).viewInsets.bottom大于0就是代表键盘弹起，0位收回
        _keyboard = MediaQuery.of(context).viewInsets.bottom > 0;
        _height = MediaQuery.of(context).viewInsets.bottom;
        print(_keyboard);
        print(_height);

      });
    });
  }

  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNode.removeListener(_focusNodeListener);
    _comController.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
      emptyWidget: listData.length > 0 ? null : EmptyPage(() async {
        await commentListNetWorking(1);
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
          return moreItemCell(data);
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
        return moreItemCell(data);
      }
    }, childCount: listData.length));
  }

  Widget inputWidget() {
    return Container(
      color: ColorsUtil.fromEnmu(ColorEnum.defIcon),
        padding: EdgeInsets.only(bottom: _keyboard ? _height : 0),
        child: Row(
          children: [
            Expanded(
              child:
              Container(
                height: 40,
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
                  cursorColor: ColorsUtil.fromEnmu(ColorEnum.desc),
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
      case CommentType.find_comment:
        commentType = 3;
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

    await NetWorking.formDataPost(url, dic, (data) {
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

  Future<Null> moreReplyNetworking(CommentInfoModel? model) async{
    final url = NetWorkingConfig.path(NetPath.moreReplyInfo);
    var dic = Map<String,dynamic>.from(paramDic);
    dic['comment_id'] = model?.comment_id;
    dic['page'] = model?.next_page;

    await NetWorking.formDataPost(url, dic, (data) {
      Printer.printMapJsonLog('-----');
      Printer.printMapJsonLog(data);
      if (data['code'] == 200) {
        var models = data['data'] as List;
        var moreReply =  models.map((e) => ReplyListModel.fromJson(e)).toList();
        /// 先清空所有的数据
        listData = [];
        for (int i=0;i<dataSource.length;i++) {
          var comInfo = dataSource[i];
          if (comInfo.comment_id == model?.comment_id) {
            comInfo.replys?.addAll(moreReply as Iterable<ReplyListModel>);
            if (models.length > 0) {
              comInfo.next_page = comInfo.next_page ?? 0 + 1;
              comInfo.isOpend = comInfo.reply_count == (comInfo.replys?.length ?? 0);
            }
          }
          dataSource[i] = comInfo;
          commentListData(comInfo);
        }
        setState(() {

        });

      }
    }, (error) {

    });
  }

  // 处理数据
  void commentListData(CommentInfoModel model) {
    var comModel = ComRepListModel(type: 1,commentModel: model);
    listData.add(comModel);
    if ((model.replys?.length ?? 0) > 0) {
      var replyInfos = model.replys?.map((e) => ComRepListModel(type: 2,replyModel: e)).toList();
      listData.addAll(replyInfos as Iterable<ComRepListModel>);
    }

    if (model.isOpend ?? false) {
      var com = ComRepListModel(type: 3,commentModel: model);
      listData.add(com);
    }
    if (listData.length > 0 && widget.changed != null) {
      if (widget.changed != null) {
        widget.changed!(listData.length);
      }
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
      case CommentType.find_comment:
        commentType = 3;
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
      'from_uid': UserManager.instance.userInfo?.id,
      'to_uid': widget.toUid
    };
    await NetWorking.formDataPost(url, dic, (data) {
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
      }else if (data['code'] == 209) { // 未绑定手机号
        EasyLoading.showToast(data['message'] ?? '未绑定手机号');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CheckCodePage(CodeFromType.bindPhone);
        }));
      }else if (data['code'] == 210) { // 未校验手机号
        EasyLoading.showToast(data['message'] ?? '未校验手机号');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CheckCodePage(CodeFromType.checkPhone, phone: UserManager.instance.userInfo?.phone_number ?? 0);
        }));
      } else{
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
  Future<Null> replyCommentNetworking(ReplyComModel? model) async {
    final url = NetWorkingConfig.path(NetPath.replyComment);
    final dic = {
      'token': UserManager.instance.token,
      'content': _comController.text,
      'comment_id': model?.comment_id,
      'reply_id': model?.reply_id,
      'reply_type': model?.reply_type,
      'to_uid': model?.to_uid,
      'from_uid': UserManager.instance.userInfo?.id,
    };

    await NetWorking.formDataPost(url, dic, (data) {
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
        data.replys?.insert(0, model);
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
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 12,
                        backgroundImage:
                        // (model.commentModel.userInfo.avator != null && model.commentModel.userInfo.avator.length > 0) ?
                        CachedNetworkImageProvider(ToolConfig.loadImgUrl(model.commentModel!.userInfo?.avator ?? "",bType: ThumbType.thumbNail)),
                        // AssetImage('assets/icons/icon_plh.png'),
                        child: Container(
                          alignment: Alignment(0, 0),
                          width: 24,
                          height: 24,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return NewUserInfoPage(pageType: MyPageType.otherPage,userId: model.commentModel?.from_uid ?? 0);
                        }));
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                        child: Text(model.commentModel?.userInfo?.username  ?? '佚名',
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
                                  }else if (widget.commentType == CommentType.show_comment){
                                    report_type = Report_type.show_comment;
                                  }else if (widget.commentType == CommentType.find_comment) {
                                    report_type = Report_type.find_pet_comment;
                                  }
                                  Navigator.pop(context);
                                  lazyAuthToDoThings(context, (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ViolationsListWidget(reportType: report_type,reportId: model.commentModel?.comment_id ?? 0);
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
                padding: EdgeInsets.only(left: 50,right: 10,top: 3,bottom: 3),
                child: Text(model.commentModel?.content ?? '--',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content)),
                ),
              ),
              // 时间
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 50,right: 10,top: 3,bottom: 3),
                child:
                // Text((model.commentModel.create_time != null && model.commentModel.create_time.length > 0) ? ToolConfig.timeT(model.commentModel.create_time) : '--',
                //   style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                // ),
                Row(
                  children: [
                    Text(ToolConfig.timeT(model.commentModel?.create_time ?? "--"),
                      style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 24,
                        width: 50,
                        alignment: Alignment.center,
                        child:  Text('回复',style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
                      ),
                      onTap: (){
                        tapCommentButton(model);
                      },
                    )
                  ],
                ),
              ),
              Divider(height: 0.5,indent: 45,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),)
            ],
          ),
        ),
        onTap: () {
          tapCommentButton(model);
        },
        // behavior: HitTestBehavior.opaque,
      ),
    );
  }

  void tapCommentButton(ComRepListModel model) {
    // 点击评论
    FocusScope.of(context).requestFocus(_focusNode);// 获取焦点
    _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: "回复${model.commentModel?.userInfo?.username}");

    /// 回复时需要的数据
    _replyComModel = ReplyComModel(
        comment_id: model.commentModel?.comment_id,
        reply_id: model.commentModel?.comment_id,
        reply_type: 1,
        to_uid: model.commentModel?.userInfo?.id
    );

    setState(() {

    });
  }

  Widget replyCell(ComRepListModel model) {
    var userTitle = '';
    var fromName = '';
    var toName = '';
    if (model.replyModel?.fromInfo?.username != null && (model.replyModel?.fromInfo?.username?.length ?? 0) > 0) {
      fromName = model.replyModel?.fromInfo?.username ?? "";
    }

    if (model.replyModel?.toInfo?.username != null && (model.replyModel?.toInfo?.username?.length ?? 0) > 0) {
      toName = model.replyModel?.toInfo?.username ?? "";
    }

    userTitle = fromName + '  回复  ' + toName;

    return Container(
      color: Colors.white,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(left: 50),
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage:
                        // (model.replyModel?.fromInfo?.avator != null && (model.replyModel?.fromInfo?.avator?.length ?? 0) > 0) ?
                        CachedNetworkImageProvider(ToolConfig.loadImgUrl(model.replyModel?.fromInfo?.avator ?? "",bType: ThumbType.thumbNail)),
                        // AssetImage('assets/icons/icon_plh.png'),
                        child: Container(
                          alignment: Alignment(0, 0),
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return NewUserInfoPage(pageType: MyPageType.otherPage,userId: model.replyModel?.from_uid ?? 0);
                        }));
                      },
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
                                  }else if (widget.commentType == CommentType.show_comment){
                                    report_type = Report_type.show_reply;
                                  }else if (widget.commentType == CommentType.find_comment) {
                                    report_type = Report_type.find_pet_reply;
                                  }
                                  Navigator.pop(context);
                                  lazyAuthToDoThings(context, (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ViolationsListWidget(reportType: report_type,reportId: model.replyModel?.reply_id ?? 0);
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
                child: Text(model.replyModel?.content ??  '--',
                  style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content)),
                ),
              ),

              // 时间
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 30,right: 10,top: 3,bottom: 3),
                child: Row(
                  children: [
                    Text(ToolConfig.timeT(model.replyModel?.create_time ?? ""),
                      style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.mark)),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 24,
                        width: 50,
                        alignment: Alignment.center,
                        child:  Text('回复',style: TextStyle(fontSize: FontUtil.fs(FontSize.mark),color: ColorsUtil.fromEnmu(ColorEnum.mark)),),
                      ),
                      onTap: (){
                        tapReplyButton(model);
                      },
                    ),
                  ]
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(indent: 30,height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),)
            ],
          ),
        ),
        onTap: () {
          tapReplyButton(model);
        },
        // behavior: HitTestBehavior.opaque,
      ),
    );
  }

  void tapReplyButton(ComRepListModel model) {
    // 点击回复
    FocusScope.of(context).requestFocus(_focusNode);// 获取焦点
    /// 点击了回复
    _tapType = ComTapTypeInfo(tapType: ComTapType.comment,name: "回复${model.replyModel?.fromInfo?.username}");

    /// 回复时需要的数据
    _replyComModel = ReplyComModel(
        comment_id: model.replyModel?.comment_id,
        reply_id: model.replyModel?.reply_id,
        reply_type: 2,
        to_uid: model.replyModel?.from_uid
    );

    setState(() {

    });
  }

  Widget moreItemCell(ComRepListModel model) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 75),
            height: 50,
            alignment: Alignment.center,
            child: Text('查看更多回复',
              style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),color: ColorsUtil.fromEnmu(ColorEnum.urlColor)),
            ),
          ),
          Divider(indent: 75,color: ColorsUtil.fromEnmu(ColorEnum.tableBack),height: 0.5,)
        ],
      ),
      onTap: () async {

        await moreReplyNetworking(model.commentModel);
      },
    );
  }
}
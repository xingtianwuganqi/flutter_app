import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_printer/flutter_printer.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentListNetWorking();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        title: Text('评论'),
        elevation: 0.5,
      ),
      body: Center(
        child: Text('评论'),
      ),
    );
  }

  /// 列表网络请求
  Future<Null> commentListNetWorking() async {
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
      Printer.printMapJsonLog(data);
    }, (error) {

    });
  }

}
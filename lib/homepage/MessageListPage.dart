import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../model/MessageModel.dart';
class MessageListWidget extends StatefulWidget {

  final String title;
  final int msgType;

  MessageListWidget(
      this.title,
      this.msgType,
      {Key key}
      ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessageListState();
  }
}

class MessageListState extends State<MessageListWidget> {

  bool isFirstLoad = true;
  List<MessageListModel> msgList = [];
  int page = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.5,
      ),
      body: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableHapticFeedback: true,
        ),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: FirstLoadWidget(),
        emptyWidget: msgList.length > 0 ? null : EmptyPage((){
          
        }),
        child: ListView.builder(
          itemCount: msgList.length,
            itemBuilder: (context,index){
              return Text('');
            }),
        onRefresh: () async{
          await messageListNetworking(1);
        },
        onLoad: () async {
          await messageListNetworking(page);
        },
      ),
    );
  }
  /*
  dic["token"] = UserManager.shared.token
            dic["page"] = page
            dic["size"] = size
            dic["msg_type"] = msgType
   */
  Future<Null> messageListNetworking(num) async {
    page = num;
    final url = NetWorkingConfig.path(NetPath.authorMessage);
    final dic = {'page': page,'size': 10,'token': UserManager.instance.token,'msg_type': widget.msgType};
    FormData formData = FormData.fromMap(dic);
    await NetWorking.formDataPost(url, formData, (data) {
      print(data);
      if (data['code'] == 200) {
        var models = data['data'];
        // var items = (models as List)?.map((e) => MessageListModel.fromJson(e));
        List<MessageListModel> items = [];
        for (int i = 0;i < models.length;i ++) {
          items.add(MessageListModel.fromJson(models[i]));
        }
        print('items');
        print(items);
        page > 1 ? msgList += items : msgList = items;
        if (items.length > 0) {
          page += 1;
        }
      }else{

      }
      setState(() {
        isFirstLoad=false;
      });
    }, (error) {
      setState(() {
        isFirstLoad=false;
      });
    });
  }
}
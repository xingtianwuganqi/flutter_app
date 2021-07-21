import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/Common/CommonPage.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/model/MessageModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageSystemPage extends StatefulWidget {
  final ValueChanged changed;
  MessageSystemPage(
      this.changed,
      {Key key}
      ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessageSystemState();
  }
}

class MessageSystemState extends State<MessageSystemPage> {

  bool _isFirst = true;
  List<SystemMsgModel> sysDatas = [];
  int _page = 1;

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    widget.changed(1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('系统消息'),
        elevation: 0.1,
      ),
      body: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false,
        ),
        firstRefresh: _isFirst,
        firstRefreshWidget: FirstLoadWidget(),
        emptyWidget: sysDatas.length > 0 ? null : EmptyPage(() async{
          await systemNetWorking(1);
        }),
        child: ListView.builder(
            itemCount: sysDatas.length,
            cacheExtent: 50,
            itemBuilder: (context,index) {
              var data = sysDatas[index];
              return systemCell(data);
            }),
        onRefresh: () async {
            await systemNetWorking(1);
        },
        onLoad: () async {
          await systemNetWorking(_page);
        },
      ),
    );
  }

  Widget titleInfoWidget(SystemMsgModel data) {
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text('公告',style: TextStyle(fontSize: FontUtil.fs(FontSize.title),
              color: ColorsUtil.fromEnmu(ColorEnum.title),fontWeight: FontWeight.w600),
          )),
          Text(ToolConfig.timeT(data.create_time),style: TextStyle(fontSize: FontUtil.fs(FontSize.desc),
            color: ColorsUtil.fromEnmu(ColorEnum.desc)),
          )
        ],
      ),
    );
  }
  
  Widget systemCell(SystemMsgModel data) {
    return  Container(
      child: Column(
        children: [
          titleInfoWidget(data),
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 3,bottom: 10),
            child:
            LinkText(
              data.content,
              textStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
                  fontSize: FontUtil.fs(FontSize.content)
              ),
              linkStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.urlColor)),
              onLinkTap: (url) async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Printer.printMapJsonLog('error');
                }
              },
            )
            // Linkify(
            //   onOpen: (link) async {
            //     if (await canLaunch(link.url)) {
            //       await launch(link.url);
            //     } else {
            //       Printer.printMapJsonLog('error');
            //     }
            //   },
            //   text: data.content,
            //   style: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.content),
            //       fontSize: FontUtil.fs(FontSize.content)
            //   ),
            //   linkStyle: TextStyle(color: ColorsUtil.fromEnmu(ColorEnum.urlColor)),
            // )
          ),
          Divider(indent: 15,height: 0.5,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),)
        ],
      ),
    );
  }

  Future<Null> systemNetWorking(int page) async{
    _page = page;
    final url = NetWorkingConfig.path(NetPath.systemMeg);
    var dic = new Map<String, dynamic>.from(paramDic);
    dic['page'] = page;
    dic['size'] = 10;
    await NetWorking.formDataPost(url, dic, (data) {
      print(data);
      if (data['code'] == 200) {
        var models = data['data'];
        var messages = (models as List).map((e) => SystemMsgModel.fromJson(e)).toList();
        page > 1 ? sysDatas = sysDatas += messages : sysDatas = messages;
        if (messages.length > 0) {
          page += 1;
        }
        setState(() {

        });
      }else{

      }
    }, (error) {

    });
  }
}
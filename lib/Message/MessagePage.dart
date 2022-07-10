import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_720yun/NetWorking/NetWorking.dart';
import 'package:flutter_720yun/Message/MessageListPage.dart';
import 'package:flutter_720yun/model/MessageModel.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Common/CommonPage.dart';
import '../main.dart';
import 'MessageSystemPage.dart';

class MessagePage extends StatefulWidget {

  final ValueChanged changed;

  MessagePage({Key key,@required this.changed});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MessagePageState();
  }
}

class MessagePageState extends State<MessagePage> with RouteAware {

  Widget dividerH = Divider(
    color: Colors.grey[100],
  );
  Widget dividerDefult = Divider(
    color: Colors.grey[600],
  );

  static const loadingTag = "##loading##";

  var isFirstLoad = true;
  
  List<MessagePageModel> datas = [
    MessagePageModel(icon: 'assets/icons/icon_message_sys.png',name: '系统消息',type: 0,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_message_like.png',name: '点赞',type: 1,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_message_collect.png',name: '收藏',type: 2,unreadNum: 0),
    MessagePageModel(icon: 'assets/icons/icon_message_com.png',name: '评论',type: 3,unreadNum: 0),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authUnreadMsgNetworking();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // MyApp.routeObserver.subscribe(this, ModalRoute.of(context));

  }

  @override
  void dispose() {
    // TODO: implement dispose
    // MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    print('============');
    if (bool) {
      _authUnreadMsgNetworking();
    }

  }

  // @override
  // void didPopNext() {
    // Covering route was popped off the navigator.
    // 需要在MyApp中注册routerObserver,在disChange方法中subscribe，在dispose 中unsubscribe,才会监听到didPopNext方法；
    // super.didPopNext();
    // _authUnreadMsgNetworking();
  // }

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
        elevation: 0.5,
      ),
      body: EasyRefresh(
        header: MaterialHeader(),
        footer: MaterialFooter(
          enableInfiniteLoad: false,
        ),
        firstRefresh: isFirstLoad,
        firstRefreshWidget: SpinKitRing(color: ColorsUtil.fromEnmu(ColorEnum.system),size: 30,lineWidth: 3,),
        emptyWidget: null,
        child:ListView.builder (
          itemCount: datas.length,
          itemExtent: 60,
          // itemExtent: 60,
          itemBuilder: (context,index) {
            var data = datas[index];
            return GestureDetector(
              child: messageItem(datas[index]),
              onTap: () {
                if (data.type != 0) {
                  lazyAuthToDoThings(context, () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) {
                      return MessageListWidget(data.name, data.type,(value) {
                        _authUnreadMsgNetworking();
                      });
                    }));
                  });
                }else{
                  Navigator.push(context,MaterialPageRoute(builder: (context) {
                    return MessageSystemPage((value){
                      _authUnreadMsgNetworking();
                    });
                  }));
                }
              },
            );
          },
        ),
        onRefresh: () async {
          // 开始刷新
          await _authUnreadMsgNetworking();
        }
      ),
    );
  }

  Widget messageItem(MessagePageModel model) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 5,right: 0),
      child: new Column(
        children: <Widget>[
          ListTile(
            title:
            // Text(model.name,style: TextStyle(fontSize: 14,color: Colors.black)),
            Container(
              transform: Matrix4.translationValues(-5, 0.0, 0.0),
              child: Text(model.name,style: TextStyle(fontSize: FontUtil.fs(FontSize.content),color: ColorsUtil.fromEnmu(ColorEnum.content))),
            ),
            leading: Image.asset(model.icon),
            trailing: rightIcon(model.unreadNum),
          ),
          new Divider(height: 0.5,indent: 70,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),),
        ],
      ),
    );
  }

  Widget rightIcon(int num) {
    return Container(
      height: 40,
      width: 40,
      child: Row(
        children: [
          Container(
              height: 16,
              width: 16,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color:(num != null && num > 0 ) ? Colors.redAccent : Colors.transparent,
              ),
              child: Text( (num != null && num > 0 )?'$num': '',style: TextStyle(color: Colors.white,fontSize: 10),),
            ),
          // Expanded(child: Padding(padding: EdgeInsets.only(left: 5)),),
          Icon(Icons.keyboard_arrow_right,color: ColorsUtil.fromEnmu(ColorEnum.mark),)
        ],
      ),
    );
  }

  Future<Null> _authUnreadMsgNetworking() async{
    final url = NetWorkingConfig.path(NetPath.authUnreadMsg);
    var dic = new Map<String, dynamic>.from(paramDic);
    await NetWorking.formDataPost(url, dic, (data) async {
      if (data['code'] == 200) {
        var model = UnreadModel.fromJson(data['data']);
        // 先判断是否是当前平台
        var sysunread = await ToolConfig.getSystemUnreadNumber(model.sys_un_list);
        datas[0].unreadNum = sysunread;
        datas[1].unreadNum = model.like_unread;
        datas[2].unreadNum = model.collec_unread;
        datas[3].unreadNum = model.com_unread;
        var num = sysunread + (model.collec_unread ?? 0) + (model.like_unread ?? 0) + (model.com_unread ?? 0);
        widget.changed(num);
        setState(() {

        });
      }else{
        widget.changed(0);
      }
    }, (error) {
      widget.changed(0);
    });
  }
}

class MessagePageModel {
  final String icon;
  final String name;
  final int type;
  int unreadNum;
  MessagePageModel({
    this.icon,
    this.name,
    this.type,
    this.unreadNum,
  });
}
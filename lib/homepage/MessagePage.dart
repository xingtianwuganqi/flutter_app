import 'package:flutter/material.dart';
import 'package:flutter_720yun/homepage/MessageListPage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Common/CommonPage.dart';

class MessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MessagePageState();
  }
}

class MessagePageState extends State<MessagePage> {

  Widget dividerH = Divider(
    color: Colors.grey[100],
  );
  Widget dividerDefult = Divider(
    color: Colors.grey[600],
  );

  static const loadingTag = "##loading##";

  var isFirstLoad = true;
  
  List<MessagePageModel> datas = [
    MessagePageModel(icon: 'assets/icons/icon_message_sys.png',name: '系统消息',type: 0),
    MessagePageModel(icon: 'assets/icons/icon_message_like.png',name: '点赞',type: 1),
    MessagePageModel(icon: 'assets/icons/icon_message_collect.png',name: '收藏',type: 2),
    MessagePageModel(icon: 'assets/icons/icon_message_com.png',name: '评论',type: 3),
  ];

  @override
  Widget build(BuildContext context) {
    
    
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
              trailing: Icon(Icons.keyboard_arrow_right,color: ColorsUtil.fromEnmu(ColorEnum.mark),),
            ),
            new Divider(height: 0.5,indent: 70,color: ColorsUtil.fromEnmu(ColorEnum.defIcon),),
          ],
        ),
      );
    }
    
     
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
                      return MessageListWidget(data.name, data.type);
                    }));
                  });
                }
              },
            );
          },
        ),
        onRefresh: () async {
          // 开始刷新
          // await GambitListNetWroking();
        }
      ),
    );
  }
}

class MessagePageModel {
  final String icon;
  final String name;
  final int type;
  MessagePageModel({
    this.icon,
    this.name,
    this.type,
  });
}
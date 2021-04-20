import 'package:flutter/material.dart';
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

  List<String> names = ["系统消息","点赞","收藏","评论"];

  List<Icon> icons = <Icon>[
    Icon(Icons.message),
    Icon(Icons.school),
    Icon(Icons.video_collection_rounded),
    Icon(Icons.comment_bank_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    
    
    Widget messageItem(String name) {
      return new Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: new Column(
          children: <Widget>[
            ListTile(
              title:Container(
                transform: Matrix4.translationValues(-25, 0.0, 0.0),
                  child: Text(name,style: TextStyle(fontSize: 14,color: Colors.black)),
                ),
              leading: Icon(Icons.email),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            new Divider(height: .0,),
          ],
        ),
      );
    }
    
     
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
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
          itemCount: names.length,
          // itemExtent: 60,
          itemBuilder: (context,index) {
            return messageItem(names[index]);
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
import 'package:flutter/material.dart';

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
              title: Text(name),
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
      body: ListView.builder (
          itemCount: names.length,
           // itemExtent: 60,
            itemBuilder: (context,index) {
              if (names[index] == loadingTag) {
                return new Container(
                  padding: const EdgeInsets.only(top: 16),
                  alignment: Alignment.center,
                  child: Text("没有更多了",style: TextStyle(color: Colors.grey ),),
                );
              }else{
                return messageItem(names[index]);
              }
            },
        ),
    );
  }
}
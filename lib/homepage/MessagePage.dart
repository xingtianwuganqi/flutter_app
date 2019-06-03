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


  List<String> names = ["获得的赞","收到的评论","收到的说一说","被收藏的作品","我的粉丝","系统消息",loadingTag];

  List<Icon> icons = <Icon>[
    Icon(Icons.message),
    Icon(Icons.school),
    Icon(Icons.list),
    Icon(Icons.business),
    Icon(Icons.home),
    Icon(Icons.add)
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("消息"),
      ),
      body: ListView.builder (
          padding: EdgeInsets.all(10.0),
          itemCount: names.length,
//            itemExtent: 70,
            itemBuilder: (context,index) {
              if (names[index] == loadingTag) {
                return new Container(
                  padding: const EdgeInsets.only(top: 16),
                  alignment: Alignment.center,
                  child: Text("没有更多了",style: TextStyle(color: Colors.grey ),),
                );
              }else{
                return new Container(
                  child: new Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(names[index]),
                        leading: icons[index],
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                      new Divider(height: .0,),
                    ],
                  ),
                );
              }
            },
        ),
    );
  }
}
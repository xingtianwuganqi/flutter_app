import 'package:flutter/material.dart';

class GambitListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GambitListState();
  }
}

class GambitListState extends State<GambitListWidget> {

  @override
  void initState() {
    super.initState();
    // 创建Controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // 开始刷新

        },
        child: ListView.builder(
          itemCount: 10,
          itemExtent: 50,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.build),
              title: Text('测试话题'),
              trailing:  Icon(Icons.keyboard_arrow_right),
            );
          }
      ),
      )
    );
  }
}
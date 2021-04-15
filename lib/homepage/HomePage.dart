import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('首页'),
      ),
      body: new Center(
        child:  PageView(
          children: [
            Center(
              child: Text('测试1'),
            ),
            Center(
              child: Text('测试2'),
            ),
            Center(
              child: Text('测试3'),
            )
          ],
        )
      ),
    );
  }
}


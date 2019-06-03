import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

var headers = {"Origin": "https://720yun.com","Referer": "https://720yun.com"};

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('我的'),
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
                placeholder: (context,url) => new CircularProgressIndicator(),
                httpHeaders: headers,
                imageUrl: "https://ssl-offical2.720static.com/channel/upload/o_1cnqen2tf1219ni21p1pkls1f3t7.jpg"
            ),
            Image.network('https://ssl-offical2.720static.com/channel/upload/o_1cnqen2tf1219ni21p1pkls1f3t7.jpg',
              headers: headers,)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ReleaseTopicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReleaseTopicState();
  }
}

class ReleaseTopicState extends State<ReleaseTopicPage> {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('发布送养信息'),
      ),
      body: Text('发布'),
    );

  }
}